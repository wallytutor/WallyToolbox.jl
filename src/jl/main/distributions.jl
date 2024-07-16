# -*- coding: utf-8 -*-

struct WeibullDistribution
    sigma::Float64
    shape::Float64
end

function cdf(x, pars::WeibullDistribution)
    return 1.0 - exp(-(x / pars.sigma)^pars.shape)
end

##############################################################################
# EOF
##############################################################################