required_packages <- c("car", "knitr", "lmtest", "rmarkdown", "tseries")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0L) {
  stop(
    "Install the missing packages before rendering: ",
    paste(missing_packages, collapse = ", "),
    call. = FALSE
  )
}

source_file <- "time-series-intervention-analysis.Rmd"
if (!file.exists(source_file)) {
  stop("Run this script from the repository root.", call. = FALSE)
}

rmarkdown::render(
  input = source_file,
  output_format = "pdf_document",
  clean = TRUE,
  quiet = FALSE
)
