namespace FuMEsWrapper
{
    public static class FuMEsInputsSample
    {
        public static FuMEsInputs New()
        {
            return new FuMEsInputs
            {
                boilerInitialState = 0.0,

                //configuration = new Configuration
                chamberFreeVolume = 300.0,
                boilerHeatingTime = 300.0,
                boilerResponseTime = 100.0,
                boilerCapacity = 17.0,
                butterWorthExponent = 50,

                //chamberState = new ChamberState
                chamberTemperature = 800.0,
                chamberPressure = 1.0,
                chamberHydrogenContent = 5.0,
                chamberCarbonMonoxideContent = 100.0,
                chamberDewPoint = -20.0,

                // injectionPrimary = new InjectionSource
                hydrogenContentSrcOne = 5.0,
                carbonMonoxideContentSrcOne = 0.0,
                dewPointSrcOne = -50.0,
                flowRateSrcOne = 300.0,
                flowRateMinSrcOne = 0.0,
                flowRateMaxSrcOne = 600.0,

                // injectionSecondary = new InjectionSource
                hydrogenContentSrcTwo = 0.5,
                carbonMonoxideContentSrcTwo = 0.0,
                dewPointSrcTwo = -50.0,
                flowRateSrcTwo = 0.0,
                flowRateMinSrcTwo = 0.0,
                flowRateMaxSrcTwo = 600.0,

                // constraints = new Constraints
                chamberHydrogenContentMin = 4.5,
                chamberHydrogenContentMax = 6.5,
                chamberCarbonMonoxideContentMax = 10000.0,
                totalFlowRateMin = 100.0,
                totalFlowRateMax = 500.0,

                // optimizationControls = new OptimizationControls
                timeStep = 15.0,
                penaltyCompensateFlowChange = 0.00001,
                penaltyTotalFlowChange = 0.0005,
                penaltyBoilerCommandChange = 0.1,

                // new SteelCoil
                targetDewPointCoilSt = -20.0,
                constantOfReductionCoilSt = 0.01,
                constantOfOxidationCoilSt = 0.01,
                constantOfDecarburizationCoilSt = 0.01,
                productionDurationCoilSt = 10.0,

                // new SteelCoil
                targetDewPointCoilNd = 0.0,
                constantOfReductionCoilNd = 0.01,
                constantOfOxidationCoilNd = 5.0,
                constantOfDecarburizationCoilNd = 10.0,
                productionDurationCoilNd = 10.0,

                // new SteelCoil
                targetDewPointCoilRd = -10.0,
                constantOfReductionCoilRd = 0.01,
                constantOfOxidationCoilRd = 5.0,
                constantOfDecarburizationCoilRd = 10.0,
                productionDurationCoilRd = 10.0,

                // solutionFlags = new SolutionFlags
                integrateOnly = false,
                optimizeTotalFlowRate = true,
                compensateFlowComposition = true,
                constrainHydrogenContent = true,
                constrainCarbonMonoxideContent = true
            };
        }
    }
}
