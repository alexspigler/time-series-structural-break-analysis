# Structural Break and Time Series Modeling of Weekly Cereal Sales

An intervention analysis of a weekly cereal-sales example using segmented regression with jointly estimated ARMA errors.

**[Read the report](./time-series-intervention-analysis.pdf)** | **[View the R Markdown source](./time-series-intervention-analysis.Rmd)**

## Overview

The dataset contains 104 weekly sales observations. In its accompanying scenario, a competing product enters the market in week 88. The analysis estimates whether the sales level or weekly trend changed at that point while accounting for serial correlation.

Originally developed as coursework.

The data come from the weekly cereal-sales intervention example in Montgomery, Jennings, and Kulahci's *Introduction to Time Series Analysis and Forecasting*, Second Edition. Wiley provides the textbook's data through its [student companion site](https://bcs.wiley.com/he-bcs/Books?action=index&bcsId=10036&itemId=1118745116). The source does not identify the brands or establish whether the values are observed or simulated. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the data notice.

## Approach

1. Validate the dataset and encode a centered intervention at week 88.
2. Use ordinary least squares to inspect the segmented trend and diagnose serial correlation.
3. Jointly estimate the regression and ARMA errors by maximum likelihood.
4. Compare AR(1), MA(1), and ARMA(1,1) error specifications using AIC, BIC, and residual diagnostics.
5. Produce ten-week model projections and evaluate the specification over ten rolling one-step forecasts.

The centered model directly estimates the pre-entry trend, immediate level shift, change in trend, and post-entry trend. ARMA(1,1) is retained as the primary error specification because it has the lowest AIC, while AR(1) is reported as a more parsimonious sensitivity model favored by BIC.

## Results

Under the joint ARMA(1,1) specification:

- Pre-entry trend: approximately **+1,153 units per week**.
- Immediate level shift at week 88: approximately **-6,545 units** (95% CI: -18,464 to 5,375; p = 0.282).
- Change in trend: approximately **-3,390 units per week** (95% CI: -4,556 to -2,224; p < 0.001).
- Post-entry trend: approximately **-2,237 units per week** (95% CI: -3,387 to -1,088; p < 0.001).

A likelihood-ratio comparison with a trend-only ARMA(1,1) model supports including the level and slope changes (p < 0.001). The immediate level-shift interval includes zero, so the evidence is concentrated in the change in trend rather than a discrete jump at week 88. The AR(1) sensitivity fit gives the same substantive conclusion.

Residual diagnostics do not flag remaining short-lag autocorrelation. In a limited rolling check for weeks 95 through 104, the model's one-step RMSE is 13,013 units versus 15,107 for a naive forecast, with 8 of 10 observations inside the nominal 95% intervals.

## Interpretation and Limitations

This is an uncontrolled interrupted time series built from a published textbook example. It supports an estimated change associated with the stated week-88 event date, but it does not establish that competitor entry caused the decline or that market share changed.

Only 17 post-entry observations and two annual cycles are available. Annual seasonality cannot be assessed reliably, and the ten-week forecasts should be read as conditional model projections rather than validated long-range forecasts.

## Reproduce the Report

The analysis was verified with R 4.6.0 and these package versions:

- `car` 3.1-5
- `knitr` 1.51
- `lmtest` 0.9-40
- `rmarkdown` 2.31
- `tseries` 0.10-61

Install the required packages:

```r
install.packages(c("car", "knitr", "lmtest", "rmarkdown", "tseries"))
```

PDF rendering also requires Pandoc and a LaTeX distribution such as TinyTeX or MacTeX. From the repository root, run:

```sh
Rscript render-report.R
```

The report checks the expected columns, row count, week sequence, finite values, and intervention week before fitting any models.

## Files

- `time-series-intervention-analysis.Rmd`: complete narrative, code, and analysis
- `time-series-intervention-analysis.pdf`: rendered technical report
- `cereal-sales-data.csv`: published example data used by the analysis
- `render-report.R`: dependency check and report build command

## License

The code and original documentation are available under the [MIT License](LICENSE). The third-party dataset is not covered by that license; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## Author

**Alex Spigler** - Statistics & Computer Science, George Washington University

[LinkedIn](https://linkedin.com/in/alexspigler) | [alexspigler.dev](https://alexspigler.dev)
