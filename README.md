# Structural Break and Time Series Modeling of Weekly Cereal Sales

A time series analysis investigating the effect of competitive market entry on weekly cereal sales using intervention regression and ARIMA error modeling.

**[View Full Report (PDF)](./time-series-intervention-analysis.pdf)**

## Project Overview

This project analyzes two years of weekly cereal sales data to quantify the impact of a structural break at a known intervention point (a competitor's product launch in week 88). The analysis demonstrates how to model time series data when both trend changes and autocorrelation are present. The sales series is **synthetic**, generated to exercise the full intervention-analysis workflow, so the focus is the method and diagnostics rather than the specific numbers.

**Key finding:** The competitor's launch in week 88 produced almost no immediate change in the level of sales; the series is essentially flat across the break. The effect was on the trend instead: sales had been rising by 1,153 units per week, and afterward declined by 2,104 units per week. This gradual reversal is consistent with sustained market-share erosion rather than a one-time shock.

## Methodology

1. **Intervention regression** captures the level and trend changes at the known break point (week 88).
2. **Diagnostics** on that fit flag autocorrelated residuals as the only violated assumption, which makes ordinary regression inference unreliable.
3. **ARIMA(1,0,1) errors** then model that autocorrelation; a Ljung-Box test confirms the residuals are white noise.

### Statistical Techniques Used
- Intervention analysis (structural break at a known intervention point)
- Regression diagnostics: Durbin-Watson (autocorrelation), non-constant variance score test / Cook-Weisberg (heteroscedasticity), Shapiro-Wilk (normality), KPSS (stationarity)
- ACF/PACF analysis for model selection
- ARIMA modeling with exogenous variables
- Time series forecasting with prediction intervals

## Key Results

### Model Performance
- Residuals pass white noise tests after ARIMA correction
- 10-week forecasts with 95% prediction intervals

### Analytical Insights
- Baseline trend: +1,153 units/week before competition
- Immediate impact: small level change at entry (≈ -8,100 units; the series is flat across the break)
- Long-term effect: trend reverses to -2,104 units/week post-entry (a -3,257 units/week change in slope)

## Packages

**Language:** R

**Key Packages:**
- `astsa` - Time series analysis and ARIMA modeling
- `lmtest` - Diagnostic tests (Durbin-Watson)
- `car` - Regression diagnostics (ncvTest)
- `tseries` - Stationarity tests (KPSS)

## How to Use

### Prerequisites
```r
install.packages(c("astsa", "lmtest", "car", "tseries"))
```

### Running the Analysis
1. Clone this repository
2. Open `time-series-intervention-analysis.Rmd` in RStudio
3. Ensure `cereal-sales-data.csv` is in the same directory
4. Knit to PDF or run chunks interactively

### Data Format
The dataset contains 104 weekly observations with columns:
- `week` - Week number (1-104)
- `sales` - Weekly sales in units

## Visualizations

The analysis includes:
- Time series plot showing the structural break
- Diagnostic plots (residuals, Q-Q, ACF/PACF)
- ARIMA diagnostic checks
- 10-week forecast with prediction intervals

## Report Sections

1. Introduction - Business context and objectives
2. Data & Exploratory Analysis - Initial visualization and observations
3. Methods - Intervention model specification and justification
4. Regression Diagnostics - Assumption validation and residual analysis
5. Model Refinement with ARIMA Errors - Model selection and specification
6. Forecasting - 10-week predictions with uncertainty quantification
7. Conclusion - Key findings and practical implications

---

## Author
**Alex Spigler** — Statistics & Computer Science, George Washington University  
[GitHub](https://github.com/alexspigler) · [LinkedIn](https://linkedin.com/in/alexspigler)

---

## License

MIT License - see [LICENSE](LICENSE) file for details.
