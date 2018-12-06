# If we assume both populations of total summer crimes in Seattle from 2002 to 2017, 
# and total winter crimes in Seattle from from 2002 to 2017, are approximately Normal:

# (note: a fair assumption, seeing as the data set contains well over 30 points)

summer_normal_dist <- rnorm(97689)

winter_normal_dist <- rnorm(89726)

# Perform Welch's t-test for two populations with unknown variances
t.test(summer_normal_dist, winter_normal_dist)

# --- RESULTS ---
# Welch Two Sample t-test
# 
# data:  summer_normal_dist and winter_normal_dist
# t = 1.8005, df = 185930, p-value = 0.07178
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -0.0007372345  0.0173894983    <-- THIS is our 95% confidence interval!
# sample estimates:
#   mean of x    mean of y 
# 0.006720223 -0.001605909 

# Since the 95% confidence interval includes zero, we cannot definitively
# conclude that there is a difference in population means of total crime
# between winter and summer in Seattle. However, the confidence interval
# is skewed - a 92% confidence interval of the same test type produces
# (0.0002, 0.01642). We think that the link between weather and crime,
# although not conclusive, warrants further investigation, especially after
# researching about its previous studies in academia.

