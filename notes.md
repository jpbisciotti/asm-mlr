```{=html}
<!-- Speaker notes for slides.qmd -------------------------------------------
Each note is introduced by a heading whose text is a single token, e.g.

    # slide-01

Everything from that heading up to the next such heading is that slide's note.
Reference a note from slides.qmd with speaker_note("slide-01").

Edit the prose freely below --- em-dashes, quotes, apostrophes, and multiple
paragraphs are all fine. Just avoid starting a line of prose with "# word",
since that looks like a new note heading to the parser.
--------------------------------------------------------------------------- -->
```

# slide-01

Hello. I am John Paul Bisciotti, Lead Data Scientist at the Department of Defense. In this video, we learn about multivariable logistic regression from the straight line formula — y equals m x plus b — to log odds and odds ratio. [/]

# slide-disclaimer

# slide-02

This talk has two sections. In Section One, we learn about the logistic regression model, in four steps: [/] we start with an exact linear relationship; [/] then we introduce uncertainty; [/] then we transition to a yes-or-no outcome with one predictor (the logit part); [/] and finally we introduce several predictors (the multivariable part). [/] In Section Two, we interpret a table. First, an example to meet every listener where they are.

# slide-03

Consider three glasses of water. Each glass's temperature sits on a scale. [/] At the bottom, water freezes. [/] At the top, it boils. We can read the scale in two ways: in Celsius or Fahrenheit. Two names for one temperature.

# slide-04

We display that relationship as a plot. [/] Celsius is the predictor, on the x-axis. [/] Fahrenheit is the outcome, on the y-axis. The formula is Fahrenheit equals 9/5 Celsius plus 32. You know this structure from grade school — y equals m x plus b — with a slope (m) of 9/5 and an intercept (b) of 32. [/] Every point falls exactly on the line. One Celsius value returns one Fahrenheit value, always, with absolute certainty. Based on the available data, there is sufficient evidence of a significant association between Celsius and Fahrenheit — not just on average, but for every point!

# slide-05

Next, we analyze data that isn't as predictable. Consider height and weight. [/] Put a child on a balance scale, and about fifty pounds brings it level. [/] Put an adult on, and it takes about 150. Taller people tend to weigh more — [/] but that's a tendency, not a rule. Two people of the same height can weigh very different amounts.

# slide-06

Here, [/] height is the predictor, [/] weight is the outcome, [/] and each point is a person. [/] The points scatter around the line instead of falling on it. The line describes only the general trend, [/] and the vertical gaps between the points and the line are the residuals. No formula hands us the true slope — we estimate it from the data. Because the points scatter, the estimate is uncertain. That uncertainty is what confidence intervals and p-values describe. More on this in Section 2.

# slide-07

So far, the outcome has been continuous — temperature and weight. Now suppose the outcome is yes or no: whether a person died. [/] Age is the predictor on the x-axis. We code the outcome [/] zero for survived [/] and one for died, so the points sit in two rows — below and above. [/] Fit an ordinary straight line, as we did before, and it keeps rising. That line is the probability of death at each age. It rises until it predicts impossible values — [/] above one on the top-right, [/] below zero on the bottom-left. A probability must stay between zero and one; there is no such thing as a 130% chance of death. We need a model that keeps probability predictions inside that range.

# slide-08

To understand the model, we must understand two words: odds and log-odds.

The first word is odds. Picture ten people. Five die and five survive. The odds of death are "deaths against survivals" — five over five is odds of one. In this sample, death is exactly as likely as survival. Likewise, the odds of survival are "survivals against deaths" — five over five is odds of one. Odds of one means equal likelihood. Odds of one is our anchor.

[/] Next, suppose eight die and two survive. The odds of death are eight deaths to two survivals — eight over two is odds of four. More deaths than survivals pushes the odds above one, the anchor.

[/] Now keep the same ten people but flip the target. The odds of survival are two survivals to eight deaths — two over eight is odds of 0.25, the reciprocal of four. Fewer survivals than deaths pulls the odds below one, the anchor.

# slide-09

Put those three odds on a number line. The anchor — no effect — sits at one. [/] The odds of death sit at four. [/] The odds of survival sit at 0.25. [/] Odds run from zero upward with no ceiling.

What's wrong with this scale? Death and survival are mirror-image results — reciprocals describing the same result — and mirror images should sit at equal distances from the anchor. But they don't. [/] Four sits three whole units above the anchor. [/] 0.25 sits only three quarters of a unit below it. The same result, told two ways, lands at two very different distances. [/] The odds scale is lopsided.

Recall we said: "To understand the model, we must understand two words: odds and log-odds." [/] The second word — the log — fixes the lopsidedness. [/] The log of 4 is positive 1.39. The log of 0.25 is negative 1.39. The log of one — the anchor — is zero.

On the log-odds scale, mirror-image results sit at equal distances from the anchor. Log odds runs from negative infinity to positive infinity.

# slide-10

This is why we model binary events with logistic regression. [/] On the left is the model on the log-odds scale. Death on the log-odds scale is a straight line in age, with an intercept and a slope. Logistic regression fits a straight line on the log-odds scale, running from negative infinity to positive infinity.

When we want an intuitive answer, we walk back in two steps: from log-odds to odds, and from odds to probability. [/] On the right is the same model on the probability scale: an S-shaped curve that stays between zero and one. These are not two models — they are one model seen two ways. We use the straight line to interpret coefficients, and the curve to read a predicted probability.

# slide-11

So how do we interpret the model's coefficient, beta? Bottom line: we will focus on the sign of the coefficient. In logistic regression, a positive coefficient means a higher odds of the outcome; a negative coefficient means a lower odds of the outcome; and a zero coefficient is the anchor, no difference in odds of the outcome.

# slide-12

Because the coefficient on the log-odds scale is not intuitive, we walk back to the plain odds scale. When we exponentiate the coefficient, we undo the log. Adding the coefficient on the log-odds scale is the same as multiplying the plain odds by a fixed factor. That fixed factor, e to the beta, is the odds ratio. An odds ratio compares two odds.

-   Take two sets of ten people. In the first set, six die and four survive — odds of 1.5. [/] In the second set, nine die and one survives — odds of nine. Compare the second set to the first: nine over 1.5 is an odds ratio of six. [/]

-   Now a third set, where six die and four survive — odds of 1.5. Compare it to the first set: 1.5 over 1.5 is an odds ratio of one. [/]

-   Now a fourth set, where five die and five survive — odds of one. Compare it to the first set: one over 1.5 is an odds ratio of about 0.67.

So an odds ratio above one means increased odds. An odds ratio of one means no change — the anchor. An odds ratio below one means decreased odds.

# slide-13

So far we have used one predictor. Multivariable means several. Suppose the model has two predictors: age [/] and treatment. Patients fall into two groups: [/] treated or [/] untreated.

On the left, the plot shows one line per group. [/] The two lines are parallel: same slope, different height. Equal slope means the same association between age and death for treated and untreated. [/] Between the two lines, the gap is the effect of the treatment, which reduces the odds of death. The left plot with parallel lines is an additive model: the treatment adds across all ages, equally. [/] So, when a second predictor in the model, each coefficient now describes its own predictor's association with the outcome, holding the other predictors constant.

[/] On the right, the plot shows why adjustment can matter. [/] The dashed red line shows the best fit line with *positive* slope when all points are pooled together. [/] The solid teal line shows the best fit line with *negative* slope within each of the three groups. Adjustment can shrink, erase, grow, or, in this case, [/] reverse the slope. This is known as Simpson's Paradox. Both slope describe the same data. The choice to adjust depends on your goal. For predictive analysis, any variable that improves generalization earns its place — even one with no causal link to the outcome. You stop adding variables when held-out error does not improve enough. For explanatory analysis, you think about causal structure and adjust to remove confounding bias.

# slide-14

To understand Section One, pause the video, and read this summary at your own pace. Next is Section Two.

# slide-15

Let's apply what we have learned about logistic regression to a figure from a study recently published in the Journal of Clinical Microbiology "Legionella 5S rRNA PCR melting temperature analysis discriminates high-risk species associated with disease severity".

Here's the setup. [/] Legionella causes pneumonia, which can be detected by a real-time PCR assay. The study investigates if the melting temperature from the Legionella real-time PCR assay can determine which species is making a patient sick — and how sick they'll get.

[/] That temperature splits the species into two apparent groups. Above 66 degrees sit the high-risk species, L. new-MAH-fah-lah (pneumophila) and L. longbeachae. Below 66 the rest.

[/] The researchers gathered adults with confirmed Legionella across several hospitals — 189 of them with a melting temperature on record. For each one they knew the Tm group, a few other traits, and two outcomes: whether the patient reached intensive care, and whether they died within ninety days.

Now the table tells how 5 explanatory variables are associated with 2 outcome variables.

# slide-16

This table covers two outcomes, [/] 90-day mortality on top [/] and ICU admission below, [/] with the same five predictors under each: age, body mass index, hypertension, immunocompromise, and PCR melting temperature of at least 66°C. Each predictor gets two odds ratios — [/] univariate (alone) and [/] multivariable (adjusted for the other four) — [/] each with a confidence interval and a p-value.

[/] Here we have the table as a plot. We'll look at three things: which associations are significant, which hold up across both outcomes, and which shift after adjustment.

For mortality, only age is significant: its interval excludes 1. Body mass index, hypertension, immunocompromise, and melting temperature all have intervals that include 1.

Recall from section one: an odds ratio of 1 is our anchor, no association. When the interval includes 1, as it does for those four, we fail to reject the null. The data are consistent with no association.

Age is different. Its interval excludes 1, just barely — the rounded lower bound sits at 1.00. So we reject the null: age is significantly associated with mortality.

Now the bottom half: ICU admission. Two predictors are significant, hypertension and melting temperature. Hypertension more than doubles the odds of ICU admission; melting temperature roughly triples it. Both intervals exclude 1, univariate and multivariable alike. Age, body mass index, and immunocompromise are not significant; their intervals all include 1.

Of the five predictors, only two, body mass index and immunocompromise, tell the same story for both outcomes: neither is associated with either outcome, adjusted or not. The other three (age, hypertension, and melting temperature) depend on which outcome you're asking about.

Now, adjustment. Within each outcome, every predictor keeps the same significance status before and after adjustment. Age stays significantly associated with mortality; hypertension and melting temperature stay significantly associated with ICU admission. Nothing flips.

For ICU admission, adjustment shrinks both associations: hypertension drops from 2.36 to 2.10, melting temperature from 3.16 to 2.85. That shrinkage is worth a closer look. It could reflect confounding among the five mutually adjusted predictors, or it could simply reflect how odds ratios behave under adjustment even without confounding. Telling the two apart takes subject-matter judgment.

# slide-17

This concludes the video. Thank you.
