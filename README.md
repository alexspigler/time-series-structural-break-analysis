# Structural Break and Time Series Modeling of Weekly Cereal Sales

An intervention analysis of a weekly cereal-sales example using segmented regression followed by ARMA modeling of the regression residuals.

**[Read the report](./time-series-intervention-analysis.pdf)** | **[View the R Markdown source](./time-series-intervention-analysis.Rmd)**

## Overview

The dataset contains 104 weekly sales observations. In its accompanying scenario, a competing product enters the market in week 88. The analysis estimates whether the sales level or weekly trend changed at that point while accounting for serial correlation.

The data come from the weekly cereal-sales intervention example in Montgomery, Jennings, and Kulahci's *Introduction to Time Series Analysis and Forecasting*, Second Edition. Wiley provides the textbook's data through its [student companion site](https://bcs.wiley.com/he-bcs/Books?action=index&bcsId=10036&itemId=1118745116). The source does not identify the brands or establish whether the values are observed or simulated. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the data notice.

## Approach

1. Validate the dataset and encode a centered intervention at week 88.
2. Estimate the level and trend changes with a segmented ordinary least-squares regression.
3. Diagnose serial correlation and compare AR(1), MA(1), and ARMA(1,1) models for the regression residuals.
4. Check whether the fitted ARMA residuals behave approximately as white noise.
5. Combine the regression projection with the residual forecast and evaluate the two-stage workflow over ten rolling one-step forecasts.

The centered regression directly estimates the pre-entry trend, immediate level shift, change in trend, and post-entry trend. ARMA(1,1) then models the serial dependence in the regression residuals. It is retained for the residual stage because it has the lowest AIC and both terms contribute, although BIC favors the simpler AR(1).

## Results

The segmented regression estimates:

- Pre-entry trend: approximately **+1,153 units per week**.
- Immediate level shift at week 88: approximately **-8,118 units**.
- Change in trend: approximately **-3,257 units per week**.
- Post-entry trend: approximately **-2,104 units per week**.

The primary modeled change is a reversal in trend rather than a one-time level shift.

The ARMA(1,1) residual model has fitted AR and MA coefficients of approximately 0.673 and -0.451. Its residuals show no evident remaining short-lag autocorrelation, strong nonnormality, or conditional heteroskedasticity. In a limited rolling check for weeks 95 through 104, two-step ARMA(1,1) has an RMSE of 12,903 units versus 13,004 for two-step AR(1) and 15,107 for a naive forecast. The small difference between the residual models does not establish a meaningful predictive advantage.

## Interpretation and Limitations

This is an uncontrolled interrupted time series built from a published textbook example. It estimates a change in the brand's weekly sales associated with the stated week-88 event date, but it cannot establish that competitor entry caused the change; market share is not observed.

Only 17 post-entry observations and two annual cycles are available. Annual seasonality cannot be assessed reliably, and the ten-week forecasts should be read as conditional model projections rather than validated long-range forecasts. Their intervals represent residual-process uncertainty only; they omit regression-coefficient, parameter-estimation, and model-selection uncertainty.

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
