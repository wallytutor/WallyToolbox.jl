#ifndef __FUMES_TESTS__
#define __FUMES_TESTS__

#include "fumes_config.hpp"
#include "fumes.hpp"

//
FUMES_TEST TestChangeMinusOne_boilerInitialState(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_chamberFreeVolume(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_boilerHeatingTime(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_boilerResponseTime(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_boilerCapacity(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_butterWorthExponent(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_chamberTemperature(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_chamberPressure(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_chamberHydrogenContent(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_chamberCarbonMonoxideContent(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_chamberDewPoint(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_hydrogenContentSrcOne(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_carbonMonoxideContentSrcOne(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_dewPointSrcOne(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_flowRateSrcOne(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_flowRateMinSrcOne(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_flowRateMaxSrcOne(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_hydrogenContentSrcTwo(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_carbonMonoxideContentSrcTwo(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_dewPointSrcTwo(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_flowRateSrcTwo(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_flowRateMinSrcTwo(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_flowRateMaxSrcTwo(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_chamberHydrogenContentMin(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_chamberHydrogenContentMax(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_chamberCarbonMonoxideContentMax(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_totalFlowRateMin(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_totalFlowRateMax(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_timeStep(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_penaltyCompensateFlowChange(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_penaltyTotalFlowChange(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_penaltyBoilerOutputChange(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_penaltyBoilerCommandChange(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_targetDewPointCoilSt(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfReductionCoilSt(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfOxidationCoilSt(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfDecarburizationCoilSt(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_productionDurationCoilSt(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_targetDewPointCoilNd(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfReductionCoilNd(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfOxidationCoilNd(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfDecarburizationCoilNd(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_productionDurationCoilNd(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeMinusOne_targetDewPointCoilRd(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfReductionCoilRd(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfOxidationCoilRd(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_constantOfDecarburizationCoilRd(FuMEsInputs& inputs);
FUMES_TEST TestChangeMinusOne_productionDurationCoilRd(FuMEsInputs& inputs);
//
FUMES_TEST TestChangeTrue_integrateOnly(FuMEsInputs& inputs);
FUMES_TEST TestChangeTrue_optimizeTotalFlowRate(FuMEsInputs& inputs);
FUMES_TEST TestChangeTrue_compensateFlowComposition(FuMEsInputs& inputs);
FUMES_TEST TestChangeTrue_constrainHydrogenContent(FuMEsInputs& inputs);
FUMES_TEST TestChangeTrue_constrainCarbonMonoxideContent(FuMEsInputs& inputs);

#endif // (__FUMES_TESTS__)
