required_packages <- c("car", "knitr", "lmtest", "rmarkdown", "tseries")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages) > 0L) {
  stop(
    "Install the missing packages before verification: ",
    paste(missing_packages, collapse = ", "),
    call. = FALSE
  )
}

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(script_arg) == 1L) {
  script_path <- normalizePath(sub("^--file=", "", script_arg), mustWork = TRUE)
  project_root <- dirname(script_path)
} else {
  project_root <- normalizePath(getwd(), mustWork = TRUE)
}

required_files <- c(
  "README.md",
  "cereal-sales-data.csv",
  "time-series-intervention-analysis.Rmd",
  "time-series-intervention-analysis.pdf"
)
required_paths <- file.path(project_root, required_files)
stopifnot(
  all(file.exists(required_paths)),
  all(file.info(required_paths)$size > 0L)
)

verification_directory <- tempfile("cereal-verification-")
dir.create(verification_directory)
on.exit(unlink(verification_directory, recursive = TRUE), add = TRUE)

invisible(file.copy(
  file.path(project_root, c(
    "cereal-sales-data.csv",
    "time-series-intervention-analysis.Rmd"
  )),
  verification_directory
))

old_working_directory <- setwd(verification_directory)
on.exit(setwd(old_working_directory), add = TRUE)

invisible(knitr::purl(
  "time-series-intervention-analysis.Rmd",
  output = "analysis.R",
  documentation = 0L,
  quiet = TRUE
))
analysis <- new.env(parent = globalenv())
sys.source("analysis.R", envir = analysis)

matches_reported_value <- function(actual, expected, digits = 3L) {
  length(actual) == 1L &&
    is.finite(actual) &&
    identical(round(as.numeric(actual), digits), as.numeric(expected))
}

expected_effects <- c(1153, -8118, -3257, -2104)
stopifnot(
  nrow(analysis$cereal) == 104L,
  identical(analysis$cereal$week, 1:104),
  analysis$break_week == 88L,
  identical(round(unname(analysis$ols_effects)), expected_effects),
  matches_reported_value(
    analysis$ols_effects[["Pre-entry weekly trend"]] +
      analysis$ols_effects[["Change in weekly trend"]],
    -2104,
    digits = 0L
  ),
  analysis$dw_result$p.value < 0.01,
  analysis$reset_result$p.value > 0.05,
  analysis$ncv_result$p > 0.05,
  analysis$shapiro_result$p.value > 0.05,
  analysis$kpss_result$p.value >= 0.1
)

comparison_rows <- setNames(
  seq_len(nrow(analysis$model_comparison)),
  analysis$model_comparison$Model
)
stopifnot(
  identical(
    analysis$model_comparison$Model,
    c("AR(1)", "MA(1)", "ARMA(1,1)")
  ),
  analysis$model_comparison$Model[[which.min(analysis$model_comparison$AIC)]] ==
    "ARMA(1,1)",
  analysis$model_comparison$Model[[which.min(analysis$model_comparison$BIC)]] ==
    "AR(1)",
  matches_reported_value(
    analysis$model_comparison$AIC[comparison_rows[["ARMA(1,1)"]]],
    2187.6,
    digits = 1L
  ),
  matches_reported_value(
    analysis$model_comparison$BIC[comparison_rows[["AR(1)"]]],
    2193.3,
    digits = 1L
  ),
  analysis$model_comparison$AIC[comparison_rows[["AR(1)"]]] -
    analysis$model_comparison$AIC[comparison_rows[["ARMA(1,1)"]]] < 1,
  matches_reported_value(
    analysis$selected_error_coefficients[["ar1"]],
    0.673
  ),
  matches_reported_value(
    analysis$selected_error_coefficients[["ma1"]],
    -0.451
  ),
  analysis$ar_root_modulus > 1,
  analysis$ma_root_modulus > 1,
  analysis$selected_ljung_box_result$p.value > 0.05,
  analysis$selected_shapiro_result$p.value > 0.05,
  analysis$arch_p_value > 0.05
)

stopifnot(
  identical(analysis$evaluation_weeks, 95:104),
  nrow(analysis$rolling_results) == 10L,
  matches_reported_value(analysis$ar1_rmse, 13004, digits = 0L),
  matches_reported_value(analysis$arma_rmse, 12903, digits = 0L),
  matches_reported_value(analysis$naive_rmse, 15107, digits = 0L),
  analysis$arma_rmse < analysis$ar1_rmse,
  analysis$ar1_rmse < analysis$naive_rmse,
  analysis$ar1_interval_hits == 8L,
  analysis$arma_interval_hits == 8L,
  nrow(analysis$forecast_table) == 10L,
  identical(analysis$forecast_table$Week, 105:114),
  all(analysis$forecast_table$Lower95 < analysis$forecast_table$Forecast),
  all(analysis$forecast_table$Forecast < analysis$forecast_table$Upper95)
)

readme <- paste(
  readLines(file.path(project_root, "README.md"), warn = FALSE),
  collapse = "\n"
)
expected_readme_text <- c(
  "104 weekly sales observations",
  "week 88",
  "+1,153 units per week",
  "-8,118 units",
  "-3,257 units per week",
  "-2,104 units per week",
  "approximately 0.673 and -0.451",
  "RMSE of 12,903 units versus 13,004 for two-step AR(1) and 15,107 for a naive forecast",
  "cannot establish that competitor entry caused the change"
)
stopifnot(all(vapply(
  expected_readme_text,
  grepl,
  logical(1),
  x = readme,
  fixed = TRUE
)))

pdftotext <- Sys.which("pdftotext")
if (!nzchar(pdftotext)) {
  stop("pdftotext is required to verify the rendered report.", call. = FALSE)
}

report_path <- file.path(project_root, "time-series-intervention-analysis.pdf")
report_text_path <- file.path(verification_directory, "report.txt")
extraction_status <- system2(
  pdftotext,
  c(shQuote(report_path), shQuote(report_text_path)),
  stdout = FALSE,
  stderr = FALSE
)
if (extraction_status != 0L) {
  stop("Could not extract text from the rendered report.", call. = FALSE)
}

report_text <- paste(readLines(report_text_path, warn = FALSE), collapse = "\n")
expected_report_text <- c(
  "Structural Break and Time Series Modeling of Weekly Cereal Sales",
  "Segmented Regression",
  "Residual Time Series Modeling",
  "Forecasting",
  "12,903",
  "15,107",
  "Data Source"
)
stopifnot(all(vapply(
  expected_report_text,
  grepl,
  logical(1),
  x = report_text,
  fixed = TRUE
)))

message("Project verification passed.")
