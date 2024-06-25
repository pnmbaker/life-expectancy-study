# Load necessary libraries

library(boot) # For bootstrapping functions 
library(lmtest) # For linear model diagnostics 
library(car) # For linear model diagnostics 
library(caret) # For machine learning model training 
library(MASS) # For box-cox transformation

# Fit the original full model using lm()

ogfullmodel <- lm(STAT512Project$'LifeExpDiff' ~ STAT512Project$'CurrExp' + STAT512Project$'DrConsult' + factor(STAT512Project$'HighPhysDen') + factor(STAT512Project$'MedPhysDen') +
factor(STAT512Project$'Y2016') + factor(STAT512Project$'Y2017') + factor(STAT512Project$'Y2018') + factor(STAT512Project$'Y2019'))

# Scatter plot of Health Expenditure per Capita vs. Gender Differences in Life Expectancy 

plot(STAT512Project$CurrExp, STAT512Project$`LifeExpDiff`, xlab = "Current Expenditure on Health, Per Capita, US$ Purchasing Power Parities (Current Prices, Current PPPs)", ylab = "Difference in Life Expectancy between Females and Males", main = "Scatter Plot: Health Expenditure per Capita vs. Gender Differences in Life Expectancy")
abline(ogfullmodel) # Add regression line to the plot
 
 # Scatter plot of Number of Doctor Consultations per Capita vs. Gender Differences in Life Expectancy

plot(STAT512Project$DrConsult, STAT512Project$`LifeExpDiff`, xlab = "Doctors Consultations, Number Per Capita", ylab = "Difference in Life Expectancy between Females and Males", main = "Scatter Plot: Number of Doctor Consultations per Capita vs. Gender Differences in Life Expectancy")
abline(ogfullmodel) # Add regression line to the plot
 
# Perform diagnostic tests on the original full model

residuals <- residuals(ogfullmodel) # Extract residuals 
bptest(ogfullmodel) # Breusch-Pagan test for heteroscedasticity
shapiro.test(residuals) # Shapiro-Wilk test for normality of residuals
vif(ogfullmodel) # Variance inflation factors
influencePlot(ogfullmodel) # Influence plot
  
# Perform backward stepwise variable selection using cross-validation

set.seed(123)
train.control <- trainControl(method = "cv", number = 10)
step.ogfullmodel <- train(LifeExpDiff ~ CurrExp + DrConsult + factor(HighPhysDen) + factor(MedPhysDen) + factor(`Y2016`) + factor(`Y2017`) + factor(`Y2018`) + factor(`Y2019`), data = STAT512Project, method = "leapBackward", trControl = train.control)
step.ogfullmodel$results # Display results of variable selection

# Perform Box-Cox transformation to improve model fit

bcSTAT512Project <- boxcox(ogfullmodel, lambda = seq(-3, 3, .1)) # Determine optimal lambda
lambda <- bcSTAT512Project$x[which.max(bcSTAT512Project$y)] # Extract optimal lambda
bcLifeExpDiff <- (STAT512Project$LifeExpDiff)^lambda # Apply Box-Cox transformation
bcFullModel <- lm(bcLifeExpDiff ~ STAT512Project$'CurrExp' + STAT512Project$'DrConsult' + factor(STAT512Project$'HighPhysDen') + factor(STAT512Project$'MedPhysDen') +
factor(STAT512Project$'Y2016') + factor(STAT512Project$'Y2017') + factor(STAT512Project$'Y2018') + factor(STAT512Project$'Y2019'))

# Scatter plot of Health Expenditure per Capita vs. Box-Cox Transformed Gender Differences in Life Expectancy
plot(STAT512Project$CurrExp, bcLifeExpDiff, xlab = "Current Expenditure on Health, Per Capita, US$ Purchasing Power Parities (Current Prices, Current PPPs)", ylab = "Box Cox: Difference in Life Expectancy between Females and Males", main = "Scatter Plot: Health Expenditure per Capita vs. Box Cox: Gender Differences in Life Expectancy")
abline(bcFullModel) # Add regression line to the plot

# Scatter plot of Number of Doctor Consultations per Capita vs. Box-Cox Transformed Gender Differences in Life Expectancy

plot(STAT512Project$DrConsult, bcLifeExpDiff, xlab = "Doctors Consultations, Number Per Capita", ylab = "Box Cox: Difference in Life Expectancy between Females and Males", main = "Scatter Plot: Number of Doctor Consultations per Capita vs. Box Cox: Gender Differences in Life Expectancy")
abline(bcFullModel) # Add regression line to the plot
 
# Perform diagnostic tests on the Box-Cox transformed model
bcResiduals <- residuals(bcFullModel) # Extract residuals
bptest(bcFullModel) # Breusch-Pagan test for heteroscedasticity
shapiro.test(bcResiduals) # Shapiro-Wilk test for normality of residuals
vif(bcFullModel) # Variance inflation factors
influencePlot(bcFullModel) # Influence plot
  
# Update dataset with Box-Cox transformed values 

STAT512Project$bcLifeExpDiff <- bcLifeExpDiff

# Perform backward stepwise variable selection on the Box-Cox transformed model 

set.seed(123)
train.control <- trainControl(method = "cv", number = 10)
step.bcFullModel <- train(bcLifeExpDiff ~ CurrExp + DrConsult + factor(HighPhysDen) + factor(MedPhysDen) + factor(`Y2016`) + factor(`Y2017`) + factor(`Y2018`) + factor(`Y2019`), data = STAT512Project, method = "leapBackward", trControl = train.control) 
step.bcFullModel$results # Display results of variable selection

# Fit weighted least squares (WLS) model using the original full model

lm_model <- lm(abs(residuals) ~ STAT512Project$'CurrExp' + STAT512Project$'DrConsult' + factor(STAT512Project$'HighPhysDen') + factor(STAT512Project$'MedPhysDen') + factor(STAT512Project$'Y2016') + factor(STAT512Project$'Y2017') + factor(STAT512Project$'Y2018') + factor(STAT512Project$'Y2019'))
wts1 <- 1/fitted(lm_model)^2
wlsFullModel <- lm(STAT512Project$'LifeExpDiff' ~ STAT512Project$'CurrExp' + STAT512Project$'DrConsult' + factor(STAT512Project$'HighPhysDen') + factor(STAT512Project$'MedPhysDen') + factor(STAT512Project$'Y2016') + factor(STAT512Project$'Y2017') + factor(STAT512Project$'Y2018') + factor(STAT512Project$'Y2019'), weight = wts1)

# Perform diagnostic tests on the WLS model

wlsResiduals <- residuals(wlsFullModel) # Extract residuals 
bptest(wlsFullModel) # Breusch-Pagan test for heteroscedasticity
shapiro.test(wlsResiduals) # Shapiro-Wilk test for normality of residuals
vif(wlsFullModel) # Variance inflation factors
influencePlot(wlsFullModel) # Influence plot

# Perform backward stepwise variable selection on the WLS model

set.seed(123)
train.control <- trainControl(method = "cv", number = 10)
step.wlsFullModel <- train(LifeExpDiff ~ CurrExp + DrConsult + factor(HighPhysDen) + factor(MedPhysDen) + factor(`Y2016`) + factor(`Y2017`) + factor(`Y2018`) + factor(`Y2019`), data = STAT512Project, method = "leapBackward", weights = wts1, trControl = train.control) 
step.wlsFullModel$results # Display results of variable selection

# Fit reduced model using only year factors

bcReducedModel <- lm(bcLifeExpDiff ~ factor(STAT512Project$'Y2016') + factor(STAT512Project$'Y2017') + factor(STAT512Project$'Y2018') + factor(STAT512Project$'Y2019'))

# Display summary of the Box-Cox transformed full model 

summary(bcFullModel)
  
# Perform bootstrapping to estimate confidence intervals for coefficients 

boot.huber <- function(STAT512Project, indices, maxit = 100) { 
data <- STAT512Project[indices,]
bcFullModel <- lm(bcLifeExpDiff ~ CurrExp + DrConsult + factor(HighPhysDen) + factor(MedPhysDen) + factor(Y2016) + factor(Y2017) + factor(Y2018) + factor(Y2019), data = data, maxit = maxit)
coefficients(bcFullModel) 
}
bootResults <- boot(data = STAT512Project, statistic = boot.huber, R = 100, maxit = 100)

# Compute percentile bootstrap confidence intervals for coefficients 

boot.ci(bootResults, index=1, type="perc")
boot.ci(bootResults, index=2, type="perc")
boot.ci(bootResults, index=3, type="perc")
boot.ci(bootResults, index=4, type="perc") 
boot.ci(bootResults, index=5, type="perc") 
boot.ci(bootResults, index=6, type="perc")
boot.ci(bootResults, index=7, type="perc") 
boot.ci(bootResults, index=8, type="perc") 
boot.ci(bootResults, index=9, type="perc")

# Perform ANOVA to compare reduced and full models 

anova(bcReducedModel, bcFullModel)
