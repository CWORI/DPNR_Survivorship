library(tidyverse)
library(sf)
library(leaflet)
library(htmltools)
library(janitor)

# Purpose: Build the interactive Coki A-H polygon map and popup summaries.
# Inputs: reviewed GPS marker CSV plus outputs from 03_outplant_interval_workflow.R.
# Outputs: a Leaflet widget object, a GeoJSON polygon file, and a popup-summary CSV.
# Assumptions: M1-M4 are ordered around each Coki boundary as shown in the field layout.

# Settings --------------------------------------------------------------------
map_plot_area_m2 <- 480
map_polygon_opacity <- 0.34
map_polygon_weight <- 3

# File paths ------------------------------------------------------------------
map_coordinate_path <- file.path("data_raw", "metadata", "Plot_Map_GPS_Points.csv")
map_monthly_path <- file.path("data_processed", "outplant_monthly_observations.csv")
map_section_monthly_path <- file.path("data_processed", "outplant_section_monthly_observations.csv")
map_survival_path <- file.path("outputs", "Tables", "outplant_cumulative_survival_summary.csv")
map_config_dir <- file.path("config", "outplant_interval_files")
map_polygon_output_path <- file.path("data_processed", "coki_plot_polygons.geojson")
map_summary_output_path <- file.path("outputs", "Tables", "coki_interactive_map_summary.csv")

# 1. Read and validate corner coordinates -------------------------------------
map_coordinates <- read_csv(map_coordinate_path, show_col_types = FALSE) |>
  clean_names() |>
  filter(!is.na(id_new), !is.na(marker), !is.na(lat), !is.na(lon)) |>
  mutate(
    marker_order = readr::parse_number(marker),
    plot = str_replace(id_new, "^Plot([A-H])$", "Plot \\1"),
    display_name = str_replace(plot, "^Plot ", "Coki ")
  )

coki_corners <- map_coordinates |>
  filter(str_detect(id_new, "^Plot[A-H]$")) |>
  arrange(plot, marker_order)

corner_counts <- coki_corners |>
  count(plot, name = "n_markers")

if (nrow(corner_counts) != 8 || any(corner_counts$n_markers != 4)) {
  stop("Each Coki A-H must have exactly four reviewed GPS markers.", call. = FALSE)
}

polygon_geometries <- coki_corners |>
  group_split(plot) |>
  map(function(corner_rows) {
    xy <- as.matrix(corner_rows |> select(lon, lat))
    st_polygon(list(rbind(xy, xy[1, , drop = FALSE])))
  }) |>
  st_sfc(crs = 4326)

coki_polygons <- coki_corners |>
  distinct(plot, display_name) |>
  arrange(plot) |>
  st_sf(geometry = polygon_geometries)

# 2. Build latest monitoring summaries ---------------------------------------
monthly_observations <- read_csv(map_monthly_path, show_col_types = FALSE) |>
  mutate(survey_date = as.Date(survey_date))

latest_dates <- monthly_observations |>
  filter(present) |>
  group_by(plot) |>
  summarise(latest_survey_date = max(survey_date), .groups = "drop")

latest_observations <- monthly_observations |>
  inner_join(latest_dates, by = "plot") |>
  filter(survey_date == latest_survey_date, present)

latest_totals <- latest_observations |>
  group_by(plot, latest_survey_date) |>
  summarise(
    n_outplants = n_distinct(genet),
    observed_outplant_area_m2 = sum(area_m2, na.rm = TRUE),
    outplant_cover_percent = 100 * observed_outplant_area_m2 / map_plot_area_m2,
    .groups = "drop"
  )

latest_species <- latest_observations |>
  group_by(plot, species) |>
  summarise(n_outplants = n_distinct(genet), .groups = "drop") |>
  arrange(plot, desc(n_outplants), species) |>
  group_by(plot) |>
  summarise(
    species_breakdown = str_c(species, ": ", n_outplants, collapse = "; "),
    species_breakdown_html = str_c(
      "<li><em>", htmlEscape(species), "</em>: ", n_outplants, "</li>",
      collapse = ""
    ),
    .groups = "drop"
  )

config <- list.files(map_config_dir, pattern = "^Plot_[A-H]\\.csv$", full.names = TRUE) |>
  map_dfr(~ read_csv(.x, col_types = cols(.default = col_character()), show_col_types = FALSE))

expected_sections <- config |>
  distinct(plot, plot_section) |>
  count(plot, name = "expected_sections")

latest_section_coverage <- read_csv(map_section_monthly_path, show_col_types = FALSE) |>
  mutate(survey_date = as.Date(survey_date)) |>
  distinct(plot, plot_section, survey_date) |>
  inner_join(latest_dates, by = "plot") |>
  filter(survey_date == latest_survey_date) |>
  count(plot, name = "observed_sections") |>
  left_join(expected_sections, by = "plot") |>
  mutate(
    coverage_status = if_else(
      observed_sections == expected_sections,
      "All configured sections",
      str_c("Partial coverage: ", observed_sections, " of ", expected_sections, " sections")
    )
  )

latest_survival <- read_csv(map_survival_path, show_col_types = FALSE) |>
  mutate(survey_date = as.Date(survey_date)) |>
  group_by(plot) |>
  slice_max(survey_date, n = 1, with_ties = FALSE) |>
  ungroup() |>
  transmute(
    plot,
    survival_survey_date = survey_date,
    baseline_outplants = n_baseline,
    surviving_outplants = n_surviving_from_baseline,
    cumulative_survivorship_percent = percent_cumulative_survival
  )

coki_map_summary <- coki_polygons |>
  st_drop_geometry() |>
  left_join(latest_totals, by = "plot") |>
  left_join(latest_species, by = "plot") |>
  left_join(latest_section_coverage, by = "plot") |>
  left_join(latest_survival, by = "plot") |>
  arrange(plot)

# 3. Create popup text and attach it to polygons ------------------------------
coki_map_summary <- coki_map_summary |>
  mutate(
    popup_html = if_else(
      is.na(latest_survey_date),
      str_c(
        "<div class='coki-map-popup'><h3>", display_name, "</h3>",
        "<p><strong>No outplant monitoring files are currently configured.</strong></p></div>"
      ),
      str_c(
        "<div class='coki-map-popup'><h3>", display_name, "</h3>",
        "<p><strong>Latest outplant snapshot:</strong> ", format(latest_survey_date, "%d %b %Y"), "<br>",
        "<strong>Survey coverage:</strong> ", coverage_status, "</p>",
        "<p><strong>Outplants present:</strong> ", scales::comma(n_outplants), "<br>",
        "<strong>Observed outplant area:</strong> ", sprintf("%.4f m²", observed_outplant_area_m2), "<br>",
        "<strong>Outplant cover:</strong> ", sprintf("%.4f%% of the 480 m² Coki", outplant_cover_percent), "</p>",
        "<p><strong>Species counts</strong></p><ul>", species_breakdown_html, "</ul>",
        "<p><strong>Cumulative survivorship:</strong> ", sprintf("%.1f%%", cumulative_survivorship_percent),
        " (", surviving_outplants, " of ", baseline_outplants, ")<br>",
        "<small>Latest complete-section survivorship survey: ", format(survival_survey_date, "%d %b %Y"), "</small></p>",
        "</div>"
      )
    )
  )

coki_polygons <- coki_polygons |>
  left_join(coki_map_summary |> select(plot, popup_html), by = "plot")

# 4. Build interactive Leaflet map -------------------------------------------
coki_colors <- c(
  "Coki A" = "#E69F00", "Coki B" = "#56B4E9", "Coki C" = "#F0E442",
  "Coki D" = "#CC79A7", "Coki E" = "#D55E00", "Coki F" = "#0072B2",
  "Coki G" = "#A6D854", "Coki H" = "#8A6FDF"
)

map_bounds <- st_bbox(coki_polygons)

coki_interactive_map <- leaflet(
  options = leafletOptions(minZoom = 15, maxZoom = 22, zoomControl = TRUE)
) |>
  addProviderTiles(
    providers$Esri.WorldImagery,
    group = "Satellite imagery",
    options = tileOptions(maxZoom = 22, maxNativeZoom = 19)
  ) |>
  addProviderTiles(
    providers$OpenStreetMap.Mapnik,
    group = "Street map",
    options = tileOptions(maxZoom = 22, maxNativeZoom = 19)
  ) |>
  addPolygons(
    data = coki_polygons,
    group = "Coki boundaries",
    color = ~ unname(coki_colors[display_name]),
    fillColor = ~ unname(coki_colors[display_name]),
    fillOpacity = map_polygon_opacity,
    weight = map_polygon_weight,
    opacity = 1,
    popup = ~ popup_html,
    label = ~ display_name,
    highlightOptions = highlightOptions(weight = 5, fillOpacity = 0.55, bringToFront = TRUE),
    labelOptions = labelOptions(
      noHide = TRUE,
      direction = "center",
      textOnly = TRUE,
      style = list("font-weight" = "700", "font-size" = "13px", "color" = "#ffffff", "text-shadow" = "0 1px 3px #000")
    )
  ) |>
  addCircleMarkers(
    data = st_as_sf(coki_corners, coords = c("lon", "lat"), crs = 4326, remove = FALSE),
    group = "Corner markers",
    radius = 3,
    stroke = TRUE,
    weight = 1,
    color = "#ffffff",
    fillColor = "#222222",
    fillOpacity = 0.9,
    popup = ~ str_c(
      "<strong>", display_name, " ", marker, "</strong><br>",
      sprintf("Latitude: %.7f<br>Longitude: %.7f<br>Depth: %.1f ft (%.2f m)", lat, lon, depth_ft, depth_m)
    )
  ) |>
  addLayersControl(
    baseGroups = c("Satellite imagery", "Street map"),
    overlayGroups = c("Coki boundaries", "Corner markers"),
    options = layersControlOptions(collapsed = FALSE)
  ) |>
  addScaleBar(position = "bottomleft", options = scaleBarOptions(metric = TRUE, imperial = TRUE)) |>
  fitBounds(map_bounds[["xmin"]], map_bounds[["ymin"]], map_bounds[["xmax"]], map_bounds[["ymax"]])

# 5. Write reusable map data ---------------------------------------------------
if (file.exists(map_polygon_output_path)) {
  file.remove(map_polygon_output_path)
}

st_write(coki_polygons |> select(plot, display_name), map_polygon_output_path, quiet = TRUE)

coki_map_summary |>
  select(-species_breakdown_html, -popup_html) |>
  write_csv(map_summary_output_path)
