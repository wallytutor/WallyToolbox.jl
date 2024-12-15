##############################################################################
# MIXTURE
##############################################################################

import Symbolics
using Symbolics: scalarize

export meanmolecularmass
export mass2molefraction
export mole2massfraction

#############################################################################
# Type signatures
#############################################################################

const SymArray = Symbolics.Arr{Num, 1}

##############################################################################
# AVERAGED PROPERTIES
##############################################################################

function meanmolecularmass(Y, W)
    return 1.0 / sum(@. Y / W)
end

function meanmolecularmass(Y::SymArray, W::SymArray)
    return 1.0 / sum(scalarize(@. Y / W))
end

@doc "Mixture mean molecular mass [kg/mol]." meanmolecularmass

##############################################################################
# CONCENTRATIONS
##############################################################################

mass2molefraction(Y, W) = meanmolecularmass(Y, W) * @. Y / W
mole2massfraction(X, W) = (@. X * W) / sum(@. X * W)

@doc "Convert mass fractions to mole fractions." mass2molefraction
@doc "Convert mole fractions to mass fractions." mole2massfraction

##############################################################################
# EOF
##############################################################################