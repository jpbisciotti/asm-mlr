# Decoding the Data: Multivariable Logistic Regression

John Paul Bisciotti, M.S., Lead Data Scientist at the Department of Defense, explains multivariable logistic regression, from the straight-line formula y = mx + b to odds ratios, using a table from a recent *Journal of Clinical Microbiology* study.

## Video Notes

Logistic regression models a yes-or-no outcome, such as whether a patient died. The video builds up to it in steps:

1. Celsius to Fahrenheit shows an exact straight line.
2. Height and weight add uncertainty: points scatter around the line, so the slope is an estimate.
3. A yes-or-no outcome breaks an ordinary straight line, which predicts probabilities above 100% and below 0%.
4. Logistic regression fixes this with odds and log-odds.

The **odds** of an event are how often it happens divided by how often it doesn't. With 8 deaths and 2 survivals, the odds of death are 4. Odds are lopsided: the odds of death (4) and of survival (0.25) describe the same result, yet sit at different distances from 1. The logarithm makes them symmetric: +1.39 and −1.39 around 0.

Logistic regression fits a straight line on the **log-odds** scale. On the probability scale, the same model is an S-shaped curve that stays between 0% and 100%.

Exponentiating a coefficient gives an **odds ratio**, which compares two odds. Above 1 means higher odds of the outcome, 1 means no difference, and below 1 means lower odds.

A multivariable model has several predictors. Each coefficient then describes its own predictor's association with the outcome, holding the others constant; this is **adjustment**.

The video applies these ideas to Table 5 of Pulsipher et al. (2026), "*Legionella* 5S rRNA PCR melting temperature analysis discriminates high-risk species associated with disease severity." The table reports unadjusted and adjusted odds ratios for five predictors of 90-day mortality and ICU admission, each with a confidence interval and p-value.

## Key Takeaways

- An odds ratio whose confidence interval includes 1 is consistent with no association but does not prove its absence.
- Adjustment can shrink, erase, or strengthen an association, or even reverse it (Simpson's paradox).
- A shift in an odds ratio after adjustment does not by itself prove confounding, because odds ratios can shift even without it.
- A statistically significant odds ratio shows an association, not causation or the ability to predict individual outcomes.

## Author Information

John Paul Bisciotti, M.S., Lead Data Scientist, Department of Defense.

*The views and opinions expressed in this document are those of the author(s) and do not represent the official position, policy, or endorsement of the Department of Defense (also known as the Department of War), the United States Government, or any of their agencies or components, unless another official document expressly designates them as such.*
