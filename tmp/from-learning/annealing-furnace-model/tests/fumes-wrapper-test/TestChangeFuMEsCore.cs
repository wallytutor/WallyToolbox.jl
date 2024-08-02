using System;
using Xunit;
using FuMEsWrapper;

namespace FuMEsWrapperTest
{
    public class TestChangeFuMEsCore
    {
        private void AssertMinusOne(double val)
        {
            Assert.True(Math.Abs(val + 1.0) < 1.0e-10);
        }

        [Fact]
        public void TestChangeValueStandard()
        {
            var inputs = FuMEsInputsSample.New();

            SafeNativeMethods.TestChangeMinusOne_boilerInitialState(ref inputs);
            AssertMinusOne(inputs.boilerInitialState);

            // ---

            SafeNativeMethods.TestChangeMinusOne_chamberFreeVolume(ref inputs);
            AssertMinusOne(inputs.chamberFreeVolume);

            SafeNativeMethods.TestChangeMinusOne_boilerHeatingTime(ref inputs);
            AssertMinusOne(inputs.boilerHeatingTime);

            SafeNativeMethods.TestChangeMinusOne_boilerResponseTime(ref inputs);
            AssertMinusOne(inputs.boilerResponseTime);

            SafeNativeMethods.TestChangeMinusOne_boilerCapacity(ref inputs);
            AssertMinusOne(inputs.boilerCapacity);

            SafeNativeMethods.TestChangeMinusOne_butterWorthExponent(ref inputs);
            AssertMinusOne(inputs.butterWorthExponent);

            // ---

            SafeNativeMethods.TestChangeMinusOne_chamberTemperature(ref inputs);
            AssertMinusOne(inputs.chamberTemperature);

            SafeNativeMethods.TestChangeMinusOne_chamberPressure(ref inputs);
            AssertMinusOne(inputs.chamberPressure);

            SafeNativeMethods.TestChangeMinusOne_chamberHydrogenContent(ref inputs);
            AssertMinusOne(inputs.chamberHydrogenContent);

            SafeNativeMethods.TestChangeMinusOne_chamberCarbonMonoxideContent(ref inputs);
            AssertMinusOne(inputs.chamberCarbonMonoxideContent);

            SafeNativeMethods.TestChangeMinusOne_chamberDewPoint(ref inputs);
            AssertMinusOne(inputs.chamberDewPoint);

            // ---

            SafeNativeMethods.TestChangeMinusOne_hydrogenContentSrcOne(ref inputs);
            AssertMinusOne(inputs.hydrogenContentSrcOne);

            SafeNativeMethods.TestChangeMinusOne_carbonMonoxideContentSrcOne(ref inputs);
            AssertMinusOne(inputs.carbonMonoxideContentSrcOne);

            SafeNativeMethods.TestChangeMinusOne_dewPointSrcOne(ref inputs);
            AssertMinusOne(inputs.dewPointSrcOne);

            SafeNativeMethods.TestChangeMinusOne_flowRateSrcOne(ref inputs);
            AssertMinusOne(inputs.flowRateSrcOne);

            SafeNativeMethods.TestChangeMinusOne_flowRateMinSrcOne(ref inputs);
            AssertMinusOne(inputs.flowRateMinSrcOne);

            SafeNativeMethods.TestChangeMinusOne_flowRateMaxSrcOne(ref inputs);
            AssertMinusOne(inputs.flowRateMaxSrcOne);

            // ---

            SafeNativeMethods.TestChangeMinusOne_hydrogenContentSrcTwo(ref inputs);
            AssertMinusOne(inputs.hydrogenContentSrcTwo);

            SafeNativeMethods.TestChangeMinusOne_carbonMonoxideContentSrcTwo(ref inputs);
            AssertMinusOne(inputs.carbonMonoxideContentSrcTwo);

            SafeNativeMethods.TestChangeMinusOne_dewPointSrcTwo(ref inputs);
            AssertMinusOne(inputs.dewPointSrcTwo);

            SafeNativeMethods.TestChangeMinusOne_flowRateSrcTwo(ref inputs);
            AssertMinusOne(inputs.flowRateSrcTwo);

            SafeNativeMethods.TestChangeMinusOne_flowRateMinSrcTwo(ref inputs);
            AssertMinusOne(inputs.flowRateMinSrcTwo);

            SafeNativeMethods.TestChangeMinusOne_flowRateMaxSrcTwo(ref inputs);
            AssertMinusOne(inputs.flowRateMaxSrcTwo);

            // ---

            SafeNativeMethods.TestChangeMinusOne_chamberHydrogenContentMin(ref inputs);
            AssertMinusOne(inputs.chamberHydrogenContentMin);

            SafeNativeMethods.TestChangeMinusOne_chamberHydrogenContentMax(ref inputs);
            AssertMinusOne(inputs.chamberHydrogenContentMax);

            SafeNativeMethods.TestChangeMinusOne_chamberCarbonMonoxideContentMax(ref inputs);
            AssertMinusOne(inputs.chamberCarbonMonoxideContentMax);

            SafeNativeMethods.TestChangeMinusOne_totalFlowRateMin(ref inputs);
            AssertMinusOne(inputs.totalFlowRateMin);

            SafeNativeMethods.TestChangeMinusOne_totalFlowRateMax(ref inputs);
            AssertMinusOne(inputs.totalFlowRateMax);

            // ---

            SafeNativeMethods.TestChangeMinusOne_timeStep(ref inputs);
            AssertMinusOne(inputs.timeStep);

            SafeNativeMethods.TestChangeMinusOne_penaltyCompensateFlowChange(ref inputs);
            AssertMinusOne(inputs.penaltyCompensateFlowChange);

            SafeNativeMethods.TestChangeMinusOne_penaltyTotalFlowChange(ref inputs);
            AssertMinusOne(inputs.penaltyTotalFlowChange);

            SafeNativeMethods.TestChangeMinusOne_penaltyBoilerCommandChange(ref inputs);
            AssertMinusOne(inputs.penaltyBoilerCommandChange);

            // ---

            SafeNativeMethods.TestChangeMinusOne_targetDewPointCoilSt(ref inputs);
            AssertMinusOne(inputs.targetDewPointCoilSt);

            SafeNativeMethods.TestChangeMinusOne_constantOfReductionCoilSt(ref inputs);
            AssertMinusOne(inputs.constantOfReductionCoilSt);

            SafeNativeMethods.TestChangeMinusOne_constantOfOxidationCoilSt(ref inputs);
            AssertMinusOne(inputs.constantOfOxidationCoilSt);

            SafeNativeMethods.TestChangeMinusOne_constantOfDecarburizationCoilSt(ref inputs);
            AssertMinusOne(inputs.constantOfDecarburizationCoilSt);

            SafeNativeMethods.TestChangeMinusOne_productionDurationCoilSt(ref inputs);
            AssertMinusOne(inputs.productionDurationCoilSt);

            // ---

            SafeNativeMethods.TestChangeMinusOne_targetDewPointCoilNd(ref inputs);
            AssertMinusOne(inputs.targetDewPointCoilNd);

            SafeNativeMethods.TestChangeMinusOne_constantOfReductionCoilNd(ref inputs);
            AssertMinusOne(inputs.constantOfReductionCoilNd);

            SafeNativeMethods.TestChangeMinusOne_constantOfOxidationCoilNd(ref inputs);
            AssertMinusOne(inputs.constantOfOxidationCoilNd);

            SafeNativeMethods.TestChangeMinusOne_constantOfDecarburizationCoilNd(ref inputs);
            AssertMinusOne(inputs.constantOfDecarburizationCoilNd);

            SafeNativeMethods.TestChangeMinusOne_productionDurationCoilNd(ref inputs);
            AssertMinusOne(inputs.productionDurationCoilNd);

            // ---

            SafeNativeMethods.TestChangeMinusOne_targetDewPointCoilRd(ref inputs);
            AssertMinusOne(inputs.targetDewPointCoilRd);

            SafeNativeMethods.TestChangeMinusOne_constantOfReductionCoilRd(ref inputs);
            AssertMinusOne(inputs.constantOfReductionCoilRd);

            SafeNativeMethods.TestChangeMinusOne_constantOfOxidationCoilRd(ref inputs);
            AssertMinusOne(inputs.constantOfOxidationCoilRd);

            SafeNativeMethods.TestChangeMinusOne_constantOfDecarburizationCoilRd(ref inputs);
            AssertMinusOne(inputs.constantOfDecarburizationCoilRd);

            SafeNativeMethods.TestChangeMinusOne_productionDurationCoilRd(ref inputs);
            AssertMinusOne(inputs.productionDurationCoilRd);

            // --- 

            SafeNativeMethods.TestChangeTrue_integrateOnly(ref inputs);
            Assert.True(inputs.integrateOnly);

            SafeNativeMethods.TestChangeTrue_optimizeTotalFlowRate(ref inputs);
            Assert.True(inputs.optimizeTotalFlowRate);

            SafeNativeMethods.TestChangeTrue_compensateFlowComposition(ref inputs);
            Assert.True(inputs.compensateFlowComposition);

            SafeNativeMethods.TestChangeTrue_constrainHydrogenContent(ref inputs);
            Assert.True(inputs.constrainHydrogenContent);

            SafeNativeMethods.TestChangeTrue_constrainCarbonMonoxideContent(ref inputs);
            Assert.True(inputs.constrainCarbonMonoxideContent);
        }
    }
}
