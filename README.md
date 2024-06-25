# Study on Life Expectancy and Possible Contributing Factors

## Introduction
Life expectancy is an essential indicator of population health, providing insights into country trends and opportunities for improvement. Numerous studies have explored the factors influencing life expectancy and health outcomes. Past research has examined the cost implications of healthcare, such as the RAND Corporation's studies, and how different countries have successfully improved life expectancies. In this study, we aim to delve deeper into the various factors influencing life expectancy and identify areas where improvements can enhance global health outcomes.

## Data Description
The dataset used for this analysis is derived from the Organization for Economic Cooperation and Development (OECD) Health Statistics 2022. It includes comprehensive information on life expectancy, GDP, health expenditure, education levels, and other relevant factors across OECD countries and beyond.

# Study on Gender Differences in Life Expectancy: Impact of Health Expenditure, Doctor Consultations, and Physician Density

## Introduction
My Research Question: Do health expenditure per capita, the number of doctor consultations per capita, and total number of physicians per capita impact gender differences in life expectancy across countries over 5 years?

My research question aims to understand the dynamics influencing the differences in life expectancy between females and males across various countries over a span of five years. The question focuses on discerning how certain factors might contribute to these discrepancies. These factors include health expenditure per capita, which reflects the amount of money a country invests in healthcare for each individual. Additionally, the number of doctor consultations per capita is examined, which sheds light on the frequency with which people seek medical attention on average. Furthermore, the research question considers physician density, a categorical representation indicating whether a country possesses a low, medium, or high density of doctors per capita. This variable plays an important role in understanding the availability of healthcare professionals within a given population. Alongside these variables, the analysis includes time as a categorical variable, dividing the data into five years from 2015 to 2019. With a sample size of 165, the research question aims to investigate the impact of health expenditure, doctor consultations, physician density, and the passage of time on gender disparities in life expectancy.

## Data Description
The dataset used for this analysis is derived from the Organization for Economic Cooperation and Development (OECD) Health Statistics 2022. It includes comprehensive information on life expectancy, GDP, health expenditure, education levels, and other relevant factors across OECD countries and beyond.

## Analysis Steps
1. **Model Diagnostics Phase**:
   - The scatterplot for health expenditure showed a weak negative relationship, suggesting a potential nonlinear association.
   - The scatterplot for doctor consultations revealed almost no identifiable relationship.
   - The Breusch-Pagan test for homoscedasticity of residuals yielded a p-value of 0.9296, indicating constant variance.
   - The Shapiro-Wilk test for normality of residuals produced a p-value of 1.547e-08, suggesting evidence against normality.
   - Multicollinearity among predictor variables was examined using Variance Inflation Factor (VIF) analysis, with all VIF values less than 10.
   - Assessment of influential data points revealed no Y scale outliers, but points 33 and 66 exhibited high leverage.
   - 10-fold cross-validation resulted in a root mean squared error (RMSE) of 1.490277.

2. **Model Remedy Phase**:
   - Due to non-normality of error terms, the Box Cox transformation was applied to the dependent variable, resulting in a lambda value of -0.5151515.
   - The transformed model addressed non-linearity in health expenditure but showed minimal impact on doctor consultations.
   - The Breusch-Pagan test for the transformed model showed a p-value of 0.2503 for homoscedasticity.
   - The Shapiro-Wilk test for normality of residuals yielded a p-value of 0.006764.
   - Multicollinearity remained insignificant.
   - 10-fold cross-validation of the transformed model resulted in a RMSE of 0.05204775.

3. **Model Validation Phase**:
   - Comparison of untransformed, Box Cox transformed, and Weighted Least Squares (WLS) models showed the Box Cox transformation had the best predictive power with a RMSE of 0.05204775.
   - The Box Cox transformation most effectively addressed non-normality among the models.
   - Variables health expenditure (X5) and number of doctor consultations (X8) were found to be statistically significant.
   - Variables high physician density (X13) and low physician density (X14) were not statistically significant and may be excluded from the model.
   - Fixed effects across years (X16, X17, X18, X19) were included to control for time-series aspects.
   - The final Box Cox model was expressed as E(Y-0.5151515) = 3.712e-01 + 1.705e-05X5 - 2.721e-03X8 + 1.584e-02X13 + 1.987e-02X14 - 2.077e-03X16 + 2.588e-04X17 - 2.039e-03X18 - 3.052e-03X19 + ε.
   - Bootstrapping was used for parameter estimation due to non-normality.
   - A partial F-test indicated a significant difference in life expectancy between females and males, considering health expenditure, doctor consultations, and physician density (p-value = 3.432e-13).

## Conclusion
The study demonstrates that health expenditure per capita, number of doctor consultations per capita, and physician density per capita have a statistically significant impact on gender differences in life expectancy. These findings underscore the critical role of healthcare access and resources in shaping disparities in life expectancy between genders. The study highlights the importance of equitable healthcare access and investment in improving overall population health.

## Repository Structure
- `data/`: Contains cleaned OECD Health Statistics 2022 dataset used for analysis.
- `code/`: Includes R scripts for model diagnostics, model remedy, model validation.
- `results/`: Contains visualizations and outputs generated from the analysis.
