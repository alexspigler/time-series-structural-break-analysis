# Structural Break and Time Series Modeling of Weekly Cereal Sales

A time series analysis investigating the effect of competitive market entry on weekly cereal sales using intervention regression and ARIMA error modeling.

**[View Full Report (PDF)](./time-series-intervention-analysis.pdf)**

## Project Overview

This project analyzes two years of weekly cereal sales data to detect and quantify a structural break caused by a competitor's product launch. The analysis demonstrates how to properly model time series data when both trend changes and autocorrelation are present.

**Key Finding:** The competitor's market entry at week 88 resulted in an immediate sales spike (+278,483 units) followed by a significant decline in growth rate (-3,257 units/week), suggesting initial category expansion followed by market share erosion.

## Methodology

The analysis employs a two-stage approach:

1. Intervention Regression Model - Captures level and trend changes at the intervention point
2. ARIMA(1,0,1) Error Structure - Accounts for autocorrelation in residuals

### Statistical Techniques Used
- Intervention analysis (structural break detection)
- Regression diagnostics (Durbin-Watson, Shapiro-Wilk, Breusch-Pagan tests)
- ACF/PACF analysis for model selection
- ARIMA modeling with exogenous variables
- Time series forecasting with prediction intervals

**Note:** Data values are synthetic.

## Key Results

### Model Performance
- R² = 0.90 - Excellent fit explaining 90% of sales variation
- All coefficients statistically significant (p < 0.001)
- Residuals pass white noise tests after ARIMA correction
- 10-week forecasts with 95% prediction intervals

### Analytical Insights
- Baseline trend: +1,153 units/week before competition
- Immediate impact: +278,483 unit spike at market entry
- Long-term effect: Net negative trend (-2,104 units/week) post-entry
- Suggests temporary category growth followed by sustained competitive pressure

## Technologies & Packages

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
