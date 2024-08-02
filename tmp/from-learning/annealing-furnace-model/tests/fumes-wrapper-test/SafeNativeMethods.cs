using System.Runtime.InteropServices;
using FuMEsWrapper;

namespace FuMEsWrapperTest
{
    internal class SafeNativeMethods
    {
        const string libraryName = "fumes-core.dll";
        const CallingConvention convention = CallingConvention.Cdecl;

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_boilerInitialState(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberFreeVolume(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_boilerHeatingTime(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_boilerResponseTime(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_boilerCapacity(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_butterWorthExponent(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberTemperature(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberPressure(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberHydrogenContent(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberCarbonMonoxideContent(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberDewPoint(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_hydrogenContentSrcOne(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_carbonMonoxideContentSrcOne(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_dewPointSrcOne(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_flowRateSrcOne(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_flowRateMinSrcOne(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_flowRateMaxSrcOne(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_hydrogenContentSrcTwo(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_carbonMonoxideContentSrcTwo(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_dewPointSrcTwo(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_flowRateSrcTwo(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_flowRateMinSrcTwo(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_flowRateMaxSrcTwo(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberHydrogenContentMin(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberHydrogenContentMax(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_chamberCarbonMonoxideContentMax(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_totalFlowRateMin(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_totalFlowRateMax(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_timeStep(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_penaltyCompensateFlowChange(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_penaltyTotalFlowChange(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_penaltyBoilerCommandChange(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_targetDewPointCoilSt(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfReductionCoilSt(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfOxidationCoilSt(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfDecarburizationCoilSt(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_productionDurationCoilSt(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_targetDewPointCoilNd(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfReductionCoilNd(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfOxidationCoilNd(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfDecarburizationCoilNd(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_productionDurationCoilNd(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_targetDewPointCoilRd(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfReductionCoilRd(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfOxidationCoilRd(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_constantOfDecarburizationCoilRd(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeMinusOne_productionDurationCoilRd(ref FuMEsInputs inputs);

        // ---

        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeTrue_integrateOnly(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeTrue_optimizeTotalFlowRate(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeTrue_compensateFlowComposition(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeTrue_constrainHydrogenContent(ref FuMEsInputs inputs);
        [DllImport(libraryName, CallingConvention = convention)]
        public static extern void TestChangeTrue_constrainCarbonMonoxideContent(ref FuMEsInputs inputs);
    }
}
