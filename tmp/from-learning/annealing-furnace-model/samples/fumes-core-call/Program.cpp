#include "fumes.hpp"

FuMEsInputs FuMEsInputsSample()
{
    return FuMEsInputs {
        /*boilerInitialState =*/ 0.0,

        /*chamberFreeVolume =*/ 300.0,
        /*boilerHeatingTime =*/ 300.0,
        /*boilerResponseTime =*/ 100.0,
        /*boilerCapacity =*/ 17.0,
        /*butterWorthExponent =*/ 50,

        /*chamberTemperature =*/ 800.0,
        /*chamberPressure =*/ 1.0,
        /*chamberHydrogenContent =*/ 5.0,
        /*chamberCarbonMonoxideContent =*/ 100.0,
        /*chamberDewPoint =*/ -20.0,

        /*hydrogenContentSrcOne =*/ 5.0,
        /*carbonMonoxideContentSrcOne =*/ 0.0,
        /*dewPointSrcOne =*/ -50.0,
        /*flowRateSrcOne =*/ 300.0,
        /*flowRateMinSrcOne =*/ 0.0,
        /*flowRateMaxSrcOne =*/ 600.0,

        /*hydrogenContentSrcTwo =*/ 0.5,
        /*carbonMonoxideContentSrcTwo =*/ 0.0,
        /*dewPointSrcTwo =*/ -50.0,
        /*flowRateSrcTwo =*/ 0.0,
        /*flowRateMinSrcTwo =*/ 0.0,
        /*flowRateMaxSrcTwo =*/ 600.0,

        /*chamberHydrogenContentMin =*/ 4.5,
        /*chamberHydrogenContentMax =*/ 6.5,
        /*chamberCarbonMonoxideContentMax =*/ 10000.0,
        /*totalFlowRateMin =*/ 100.0,
        /*totalFlowRateMax =*/ 500.0,

        /*timeStep =*/ 15.0,
        /*penaltyCompensateFlowChange =*/ 0.00001,
        /*penaltyTotalFlowChange =*/ 0.0005,
        /*penaltyBoilerCommandChange =*/ 0.1,

        /*targetDewPointCoilSt =*/ -20.0,
        /*constantOfReductionCoilSt =*/ 0.01,
        /*constantOfOxidationCoilSt =*/ 0.01,
        /*constantOfDecarburizationCoilSt =*/ 0.01,
        /*productionDurationCoilSt =*/ 10.0,

        /*targetDewPointCoilNd =*/ 0.0,
        /*constantOfReductionCoilNd =*/ 0.01,
        /*constantOfOxidationCoilNd =*/ 5.0,
        /*constantOfDecarburizationCoilNd =*/ 10.0,
        /*productionDurationCoilNd =*/ 10.0,

        /*targetDewPointCoilRd =*/ -10.0,
        /*constantOfReductionCoilRd =*/ 0.01,
        /*constantOfOxidationCoilRd =*/ 5.0,
        /*constantOfDecarburizationCoilRd =*/ 10.0,
        /*productionDurationCoilRd =*/ 10.0,

        /*integrateOnly =*/ false,
        /*optimizeTotalFlowRate =*/ true,
        /*compensateFlowComposition =*/ true,
        /*constrainHydrogenContent =*/ true,
        /*constrainCarbonMonoxideContent =*/ true
    };
}

void PrintTable(const FuMEsOutputs& outputs)
{
    for (size_t k = 0; k != outputs.size; k++)
    {
        std::cout
            << std::right << std::fixed
            << std::setprecision(0)
            << std::setw(10) << outputs.tk[k]
            << std::setprecision(6)
            << std::setw(10) << outputs.x0[k]
            << std::setw(10) << outputs.x1[k]
            << std::setw(10) << outputs.x2[k]
            << std::setw(10) << outputs.uk[k]
            << std::setw(10) << outputs.vk[k]
            << std::setw(10) << outputs.rk[k]
            << std::setw(10) << outputs.qk[k]
            << std::endl;
    }

    std::cout << "THE END" << std::endl;
}

int main()
{
    FuMEsInputs inputs = FuMEsInputsSample();
    FuMEsOutputs outputs;

    FuMEsRun(inputs, outputs);
    PrintTable(outputs);

    return 0;
}
