# Decoding the Data: Multivariable Logistic Regression

John Paul Bisciotti, M.S., Lead Data Scientist at the Department of Defense, explains multivariable logistic regression, from the straight-line formula y = mx + b to log-odds and odds ratios. He then uses these ideas to read a table from a recent *Journal of Clinical Microbiology* study.

## Video Notes

Logistic regression models the chance of a yes-or-no outcome, such as whether a patient died. This video on multivariable logistic regression explains: 

- Odds
- Log-odds
- Odds ratio
- Adjustment 

The video builds the model in four steps:

1. **An exact straight line.** Celsius and Fahrenheit, where every point falls on the line y = mx + b.
2. **Uncertainty.** Height and weight, where the points don't fall on a line and scatter around it, so the slope must be estimated from the data.
3. **A yes-or-no outcome with one predictor.** An ordinary straight line fitted to a yes-or-no outcome can predict unrealistic probabilities above 100% or below 0%. Logistic regression avoids this by using odds and log-odds.
4. **Several predictors.** A multivariable model has more than one predictor and adjusts each one for the others. 

The video applies these ideas to Table 5 of Pulsipher et al. (2026), "*Legionella* 5S rRNA PCR melting temperature analysis discriminates high-risk species associated with disease severity" (<https://doi.org/10.1128/jcm.00356-26>). The table reports unadjusted and adjusted odds ratios for several predictors of mortality and ICU admission, each with a confidence interval and p-value.

## Key Takeaways

- A 95% confidence interval that includes 1 means the data are consistent with no association. It does not prove the association is absent.
- Adjustment can shrink, erase, strengthen, or even reverse an association. When an association in pooled data reverses within groups, that is called Simpson's paradox.
- A change in an odds ratio after adjustment does not by itself prove confounding. In logistic regression, odds ratios can change after adjustment even without confounding.
- A statistically significant odds ratio is evidence of an association. It does not show causation, and it does not mean the model can predict individual outcomes well.

## Author Information

John Paul Bisciotti, M.S., Lead Data Scientist, Department of Defense.

*The views and opinions expressed in this document are those of the author(s) and do not represent the official position, policy, or endorsement of the Department of Defense (also known as the Department of War), the United States Government, or any of their agencies or components, unless another official document expressly designates them as such.*
