# Purpose: export all current Coki E report figures as high-definition vector PDFs.
# Inputs: report chunks, existing Matches workflow tables, stages 06 and 07.
# Output: Coki_E_High_Def_PDFs/ (one PDF per report figure plus README).
# Run from the project root. Existing PDFs should be archived before replacement.

# Settings ----
pdf_width_inches <- 15
pdf_selected_labels <- commandArgs(trailingOnly = TRUE)

# File paths ----
project_root <- normalizePath(getwd(), mustWork = TRUE)
stopifnot(file.exists(file.path(project_root, "coral_survivorship_report.qmd")))
output_dir <- file.path(project_root, "Coki_E_High_Def_PDFs")
workflow_path <- file.path(project_root, "R", "03_outplant_interval_workflow.R")

# 1. Load function definitions without rebuilding the shared pipeline ----
library(tidyverse)
library(janitor)
workflow <- readLines(workflow_path)
main_line <- grep("^# Main pipeline", workflow)[1]
eval(parse(text = workflow[seq_len(main_line - 1)]))
for (folder in c("data_processed", "outputs/Tables")) {
  for (path in list.files(folder, pattern = "^outplant.*\\.csv$", full.names = TRUE)) {
    assign(tools::file_path_sans_ext(basename(path)), read_csv(path, show_col_types = FALSE))
  }
}
outplant_config <- outplant_read_config(outplant_config_path)

# 2. Evaluate the existing E setup and figure expressions ----
report <- readLines("coral_survivorship_report.qmd")
start <- grep("^## Plot E$", report)[1]
end <- grep("^## Plot F$", report)[1]
section <- report[start:(end - 1)]
chunk_starts <- grep("^```\\{r\\}", section)
dir.create(output_dir, showWarnings = FALSE)
exported <- character()
for (i in chunk_starts) {
  j <- i + which(section[(i + 1):length(section)] == "```")[1]
  chunk <- section[(i + 1):(j - 1)]
  label <- sub("#\\| label: ", "", chunk[grep("^#\\| label:", chunk)])
  if (identical(label, "plot-e-cohort-setup")) {
    for (expr in parse(text = chunk)) {
      if (is.call(expr) && identical(expr[[1]], as.name("write_csv"))) next
      eval(expr)
    }
  } else if (any(grepl("^#\\| fig-width:", chunk)) &&
             (length(pdf_selected_labels) == 0L || label %in% pdf_selected_labels)) {
    plot_result <- eval(parse(text = chunk))
    stopifnot(inherits(plot_result, "ggplot"), is.null(plot_result$labels$subtitle))
    fig_width <- as.numeric(sub(".*: ", "", chunk[grepl("fig-width:", chunk)]))
    fig_height <- as.numeric(sub(".*: ", "", chunk[grepl("fig-height:", chunk)]))
    if (identical(label, "plot-e-interval-survival-plot")) {
      plot_result <- plot_result + theme(plot.margin = margin(10, 20, 15, 90))
    }
    filename <- paste0(gsub("-", "_", sub("^plot-e-", "Coki_E_", label)), ".pdf")
    ggsave(file.path(output_dir, filename), plot_result,
           device = grDevices::pdf, useDingbats = FALSE,
           width = pdf_width_inches, height = pdf_width_inches * fig_height / fig_width,
           units = "in", bg = "white", limitsize = FALSE)
    exported <- c(exported, filename)
  }
}
stopifnot(length(exported) == if (length(pdf_selected_labels) == 0L) 10L else length(pdf_selected_labels),
          all(file.exists(file.path(output_dir, exported))))

# 3. Record scope and provenance ----
writeLines(c(
  "# Current Coki E figure PDFs", "",
  "Ten vector PDFs exported from the Coki E section of coral_survivorship_report.qmd.",
  "Refreshed October 27, 2026 using corrected Matches exports. Surveys extend through September 1, 2026.",
  "Each page is 15 inches wide with the report figure aspect ratio.",
  "Cover figures use Matches, not the separate all-coral cover dataset.",
  "The three cohort cover/area figures show only the 2025 and April 2026 cohorts.",
  "Other measured ancestry remains in audit tables and is excluded from these figures.",
  "Current-object area is counted once even when multiple originals share a descendant.",
  "All Coki E subtitles are removed. Cohort survival follows original-object lineages.",
  "Earlier PDFs are preserved in archive/2026-10-21_coki_e_pdfs_before_refresh/.",
  "Rebuild from the project root with Rscript logs/2026-10-21_lineage_validation/export_coki_e_pdfs.R.",
  "", "## Files", paste0("- ", sort(list.files(output_dir, pattern = "^Coki_E_.*\\.pdf$")))
), file.path(output_dir, "README.md"))
cat(paste(exported, collapse = "\n"), "\n")
