using System.Runtime.InteropServices;

namespace FuMEsWrapper
{
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct FuMEsInputs
    {
        [MarshalAs(UnmanagedType.R8)]
        public double boilerInitialState;

        // public Configuration configuration;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberFreeVolume;
        [MarshalAs(UnmanagedType.R8)]
        public double boilerHeatingTime;
        [MarshalAs(UnmanagedType.R8)]
        public double boilerResponseTime;
        [MarshalAs(UnmanagedType.R8)]
        public double boilerCapacity;
        [MarshalAs(UnmanagedType.R8)]
        public double butterWorthExponent;

        // public ChamberState chamberState;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberTemperature;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberPressure;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberHydrogenContent;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberCarbonMonoxideContent;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberDewPoint;

        // public InjectionSource injectionPrimary;
        [MarshalAs(UnmanagedType.R8)]
        public double hydrogenContentSrcOne;
        [MarshalAs(UnmanagedType.R8)]
        public double carbonMonoxideContentSrcOne;
        [MarshalAs(UnmanagedType.R8)]
        public double dewPointSrcOne;
        [MarshalAs(UnmanagedType.R8)]
        public double flowRateSrcOne;
        [MarshalAs(UnmanagedType.R8)]
        public double flowRateMinSrcOne;
        [MarshalAs(UnmanagedType.R8)]
        public double flowRateMaxSrcOne;

        // public InjectionSource injectionSecondary;
        [MarshalAs(UnmanagedType.R8)]
        public double hydrogenContentSrcTwo;
        [MarshalAs(UnmanagedType.R8)]
        public double carbonMonoxideContentSrcTwo;
        [MarshalAs(UnmanagedType.R8)]
        public double dewPointSrcTwo;
        [MarshalAs(UnmanagedType.R8)]
        public double flowRateSrcTwo;
        [MarshalAs(UnmanagedType.R8)]
        public double flowRateMinSrcTwo;
        [MarshalAs(UnmanagedType.R8)]
        public double flowRateMaxSrcTwo;

        // public Constraints constraints;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberHydrogenContentMin;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberHydrogenContentMax;
        [MarshalAs(UnmanagedType.R8)]
        public double chamberCarbonMonoxideContentMax;
        [MarshalAs(UnmanagedType.R8)]
        public double totalFlowRateMin;
        [MarshalAs(UnmanagedType.R8)]
        public double totalFlowRateMax;

        // public OptimizationControls optimizationControls;
        [MarshalAs(UnmanagedType.R8)]
        public double timeStep;
        [MarshalAs(UnmanagedType.R8)]
        public double penaltyCompensateFlowChange;
        [MarshalAs(UnmanagedType.R8)]
        public double penaltyTotalFlowChange;
        [MarshalAs(UnmanagedType.R8)]
        public double penaltyBoilerCommandChange;

        //public List<SteelCoil> coilQueue;
        [MarshalAs(UnmanagedType.R8)]
        public double targetDewPointCoilSt;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfReductionCoilSt;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfOxidationCoilSt;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfDecarburizationCoilSt;
        [MarshalAs(UnmanagedType.R8)]
        public double productionDurationCoilSt;

        //public List<SteelCoil> coilQueue;
        [MarshalAs(UnmanagedType.R8)]
        public double targetDewPointCoilNd;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfReductionCoilNd;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfOxidationCoilNd;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfDecarburizationCoilNd;
        [MarshalAs(UnmanagedType.R8)]
        public double productionDurationCoilNd;

        //public List<SteelCoil> coilQueue;
        [MarshalAs(UnmanagedType.R8)]
        public double targetDewPointCoilRd;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfReductionCoilRd;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfOxidationCoilRd;
        [MarshalAs(UnmanagedType.R8)]
        public double constantOfDecarburizationCoilRd;
        [MarshalAs(UnmanagedType.R8)]
        public double productionDurationCoilRd;

        // public SolutionFlags solutionFlags;
        [MarshalAs(UnmanagedType.I1)]
        public bool integrateOnly;
        [MarshalAs(UnmanagedType.I1)]
        public bool optimizeTotalFlowRate;
        [MarshalAs(UnmanagedType.I1)]
        public bool compensateFlowComposition;
        [MarshalAs(UnmanagedType.I1)]
        public bool constrainHydrogenContent;
        [MarshalAs(UnmanagedType.I1)]
        public bool constrainCarbonMonoxideContent;
    }
}
