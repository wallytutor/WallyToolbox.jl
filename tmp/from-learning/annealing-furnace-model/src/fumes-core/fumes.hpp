#ifndef __FUMES_CORE__
#define __FUMES_CORE__

#include "fumes_config.hpp"
#include <casadi/casadi.hpp>

struct FuMEsInputs
{
    double boilerInitialState;

    // Configuration configuration;
    double chamberFreeVolume;
    double boilerHeatingTime;
    double boilerResponseTime;
    double boilerCapacity;
    double butterWorthExponent;
    
    // ChamberState chamberState;
    double chamberTemperature;
    double chamberPressure;
    double chamberHydrogenContent;
    double chamberCarbonMonoxideContent;
    double chamberDewPoint;

    // InjectionSource injectionPrimary;
    double hydrogenContentSrcOne;
    double carbonMonoxideContentSrcOne;
    double dewPointSrcOne;
    double flowRateSrcOne;
    double flowRateMinSrcOne;
    double flowRateMaxSrcOne;

    // InjectionSource injectionSecondary;
    double hydrogenContentSrcTwo;
    double carbonMonoxideContentSrcTwo;
    double dewPointSrcTwo;
    double flowRateSrcTwo;
    double flowRateMinSrcTwo;
    double flowRateMaxSrcTwo;

    // Constraints constraints;
    double chamberHydrogenContentMin;
    double chamberHydrogenContentMax;
    double chamberCarbonMonoxideContentMax;
    double totalFlowRateMin;
    double totalFlowRateMax;

    // OptimizationControls optimizationControls;
    double timeStep;
    double penaltyCompensateFlowChange;
    double penaltyTotalFlowChange;
    double penaltyBoilerCommandChange;

    //List<SteelCoil> coilQueue;
    double targetDewPointCoilSt;
    double constantOfReductionCoilSt;
    double constantOfOxidationCoilSt;
    double constantOfDecarburizationCoilSt;
    double productionDurationCoilSt;

    //List<SteelCoil> coilQueue;
    double targetDewPointCoilNd;
    double constantOfReductionCoilNd;
    double constantOfOxidationCoilNd;
    double constantOfDecarburizationCoilNd;
    double productionDurationCoilNd;

    //List<SteelCoil> coilQueue;
    double targetDewPointCoilRd;
    double constantOfReductionCoilRd;
    double constantOfOxidationCoilRd;
    double constantOfDecarburizationCoilRd;
    double productionDurationCoilRd;

    // SolutionFlags solutionFlags;
    bool integrateOnly;
    bool optimizeTotalFlowRate;
    bool compensateFlowComposition;
    bool constrainHydrogenContent;
    bool constrainCarbonMonoxideContent;
};

struct FuMEsOutputs
{
    int size;
    double* tk;
    double* x0;
    double* x1;
    double* x2;
    double* uk;
    double* vk;
    double* rk;
    double* qk;
    // TODO add steel constants.
};

FUMESCORE_API
void FuMEsRunExplicit(FuMEsInputs& inputs, int* len,
    double** tk, double** x0, double** x1, double** x2,
    double** uk, double** vk, double** rk, double** qk);

FUMESCORE_API
void FuMEsRun(FuMEsInputs& inputs, FuMEsOutputs& outputs);

#endif // (__FUMES_CORE_)
