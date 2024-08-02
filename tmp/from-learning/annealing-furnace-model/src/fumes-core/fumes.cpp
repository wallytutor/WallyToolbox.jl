#include "fumes.hpp"
#include <algorithm>
#include <cmath>
#include <numeric>
#include <tuple>
#include "symbsol/symbsol.hpp"

using casadi::SX;
using casadi::MX;
using casadi::DM;
using casadi::SXVector;
using casadi::MXVector;
using casadi::DMVector;
using casadi::Dict;
using casadi::SXDict;
using casadi::MXDict;
using casadi::DMDict;
using casadi::Function;
using symbsol::CasADiIpoptResults;

/////////////////////////////////////////////////////////////////////////////
// Static functions and variables
/////////////////////////////////////////////////////////////////////////////

static constexpr double RGAS = 8.31446261815324;
static constexpr double PREF = 101325.0;
static constexpr double TREF = 288.15;

static double DewPointToWaterContent(double dp)
{
    if (dp <= -272.0) { return 0.0; }
    auto f = [dp](double a, double b) { return a * dp / (b + dp); };
    double n = (dp <= 0.0) ? f(9.72, 272.0) : f(7.58, 240.0);
    return std::clamp(std::pow(10, n - 2.22), 0.0, 1.0);
}

static void ConvertUnitsEntering(FuMEsInputs& inputs)
{
    // kg/h -> mol/s
    inputs.boilerInitialState /= (0.018 * 3600.0);

    // kg/h -> mol/s
    inputs.boilerCapacity /= (0.018 * 3600.0);

    // °C -> K
    inputs.chamberTemperature += 273.15;

    // mbar -> Pa
    inputs.chamberPressure *= 100.0;
    inputs.chamberPressure += 101325.0;

    // % -> [-]
    inputs.chamberHydrogenContent /= 100.0;

    // ppm -> [-]
    inputs.chamberCarbonMonoxideContent /= 1000000.0;

    // °C -> [-]
    inputs.chamberDewPoint = DewPointToWaterContent(inputs.chamberDewPoint);

    // % -> [-]
    inputs.hydrogenContentSrcOne /= 100.0;

    // ppm -> [-]
    inputs.carbonMonoxideContentSrcOne /= 1000000.0;

    // °C -> [-]
    inputs.dewPointSrcOne = DewPointToWaterContent(inputs.dewPointSrcOne);

    // Nm³/h -> mol/s
    inputs.flowRateSrcOne *= PREF / (RGAS * TREF * 3600);

    // Nm³/h -> mol/s
    inputs.flowRateMinSrcOne *= PREF / (RGAS * TREF * 3600);

    // Nm³/h -> mol/s
    inputs.flowRateMaxSrcOne *= PREF / (RGAS * TREF * 3600);

    // % -> [-]
    inputs.hydrogenContentSrcTwo /= 100.0;

    // ppm -> [-]
    inputs.carbonMonoxideContentSrcTwo /= 1000000.0;

    // °C -> [-]
    inputs.dewPointSrcTwo = DewPointToWaterContent(inputs.dewPointSrcTwo);

    // Nm³/h -> mol/s
    inputs.flowRateSrcTwo *= PREF / (RGAS * TREF * 3600);

    // Nm³/h -> mol/s
    inputs.flowRateMinSrcTwo *= PREF / (RGAS * TREF * 3600);

    // Nm³/h -> mol/s
    inputs.flowRateMaxSrcTwo *= PREF / (RGAS * TREF * 3600);

    // % -> [-]
    inputs.chamberHydrogenContentMin /= 100.0;

    // % -> [-]
    inputs.chamberHydrogenContentMax /= 100.0;

    // ppm -> [-]
    inputs.chamberCarbonMonoxideContentMax /= 1000000.0;

    // Nm³/h -> mol/s
    inputs.totalFlowRateMin *= PREF / (RGAS * TREF * 3600);

    // Nm³/h -> mol/s
    inputs.totalFlowRateMax *= PREF / (RGAS * TREF * 3600);

    // °C -> [-]
    inputs.targetDewPointCoilSt = DewPointToWaterContent(inputs.targetDewPointCoilSt);

    // min -> s
    inputs.productionDurationCoilSt *= 60.0;

    // °C -> [-]
    inputs.targetDewPointCoilNd = DewPointToWaterContent(inputs.targetDewPointCoilNd);

    // min -> s
    inputs.productionDurationCoilNd *= 60.0;

    // °C -> [-]
    inputs.targetDewPointCoilRd = DewPointToWaterContent(inputs.targetDewPointCoilRd);

    // min -> s
    inputs.productionDurationCoilRd *= 60.0;
}

static double MolesInSystem(const FuMEsInputs& inputs)
{
    return (inputs.chamberPressure * inputs.chamberFreeVolume) /
        (RGAS * inputs.chamberTemperature);
}

static std::vector<double> InitialState(const FuMEsInputs& inputs)
{
    return { inputs.chamberDewPoint,
             inputs.chamberHydrogenContent,
             inputs.chamberCarbonMonoxideContent,
             inputs.boilerInitialState };
}

static std::vector<double> SourceOneComposition(const FuMEsInputs& inputs)
{
    return { inputs.dewPointSrcOne, inputs.hydrogenContentSrcOne,
             inputs.carbonMonoxideContentSrcOne };
}

static std::vector<double> SourceTwoComposition(const FuMEsInputs& inputs)
{
    return { inputs.dewPointSrcTwo, inputs.hydrogenContentSrcTwo,
             inputs.carbonMonoxideContentSrcTwo };
}

static std::vector<double> MinimumComposition(const FuMEsInputs& inputs)
{
    return { 0.0, inputs.chamberHydrogenContentMin, 0.0};
}

static std::vector<double> MaximumComposition(const FuMEsInputs& inputs)
{
    return { DewPointToWaterContent(15), 
             inputs.chamberHydrogenContentMax,
             inputs.chamberCarbonMonoxideContentMax };
}

static void AllocateResult(int len, double** data, const std::vector<double>& results)
{
    size_t size = len * sizeof(double);
    *data = static_cast<double*>(malloc(size));
    memcpy(*data, results.data(), size);
}

/////////////////////////////////////////////////////////////////////////////
// FuMEs internal data (use mathematical names instead of good variables!)
/////////////////////////////////////////////////////////////////////////////

struct FuMEsResults
{
    static constexpr size_t n_vars = 7;

    double cost;
    std::vector<double> tk;
    std::vector<double> x0;
    std::vector<double> x1;
    std::vector<double> x2;
    std::vector<double> uk;
    std::vector<double> vk;
    std::vector<double> rk;
    std::vector<double> qk;
    // TODO add steel constants.

    FuMEsResults() {}

    FuMEsResults(CasADiIpoptResults& sol, double dt, bool verbose = false)
    {
        tk.push_back(0.0);
        x0.push_back(sol.x[0]);
        x1.push_back(sol.x[1]);
        x2.push_back(sol.x[2]);
        uk.push_back(sol.x[3]);
        vk.push_back(sol.x[4]);
        rk.push_back(sol.x[5]);
        qk.push_back(sol.x[6]);

        cost = sol.f;

        size_t step_count = 0;

        // This is the index of the last valid entry.
        size_t max_k = sol.nx - 2 * n_vars + (size_t)(4);

        for (size_t k = n_vars; k < max_k; k += n_vars)
        {
            tk.push_back(dt * (++step_count));
            x0.push_back(sol.x[k + 0]);
            x1.push_back(sol.x[k + 1]);
            x2.push_back(sol.x[k + 2]);
            uk.push_back(sol.x[k + 3]);
            vk.push_back(sol.x[k + 4]);
            rk.push_back(sol.x[k + 5]);
            qk.push_back(sol.x[k + 6]);
        }

        if (verbose) { PrintTable(); }
    }

    void PrintRow(size_t k)
    {
        std::cout
            << std::right << std::fixed
            << std::setprecision(0)
            << std::setw(10) << tk[k]
            << std::setprecision(6)
            << std::setw(10) << x0[k]
            << std::setw(10) << x1[k]
            << std::setw(10) << x2[k]
            << std::setw(10) << uk[k]
            << std::setw(10) << vk[k]
            << std::setw(10) << rk[k]
            << std::setw(10) << qk[k]
            << std::endl;
    }

    void PrintTable()
    {
        for (size_t k = 0; k != tk.size(); k++)
        {
            PrintRow(k);
        }

        std::cout << "Final cost = " << cost << std::endl;
    }
};

class FuMEsInnerData
{
public:
    FuMEsInnerData(const FuMEsInputs& inputs) :
        bw { (unsigned int)(inputs.butterWorthExponent) },
        td { inputs.boilerHeatingTime },
        tc { inputs.boilerResponseTime },
        nt { MolesInSystem(inputs) },
        dt { inputs.timeStep },
        qs1_init { inputs.flowRateSrcOne },
        qs2_init { inputs.flowRateSrcTwo },
        x_init { InitialState(inputs) },
        x1_fix{ SourceOneComposition(inputs) },
        x2_fix{ SourceTwoComposition(inputs) },
        integrate_only { inputs.integrateOnly },
        compensate_flow { inputs.compensateFlowComposition },
        optimize_flow{ inputs.optimizeTotalFlowRate },
        constrain_x1 { inputs.constrainHydrogenContent },
        constrain_x2 { inputs.constrainCarbonMonoxideContent },
        boiler_capacity{ inputs.boilerCapacity },
        qt_min { inputs.totalFlowRateMin },
        qt_max { inputs.totalFlowRateMax },
        penalty_vk { inputs.penaltyBoilerCommandChange },
        penalty_rk { inputs.penaltyCompensateFlowChange },
        penalty_qk { inputs.penaltyTotalFlowChange },
        xk_min{ MinimumComposition(inputs) },
        xk_max{ MaximumComposition(inputs) }
    {
        // If boiler initial state is above zero > already started.
        // Most use cases do not really require this.
        if (x_init[3] > 0.0)
        {
            td = 0.0;
        }

        double tend = ComposeTimeDependentSymbols(inputs);

        std::tuple<SX, SX> problem = CreateProblemOdeSystem();

        Function F = CreateRk4SteppingFunction(problem);

        DMDict sol = MultipleShootingIntegration(F, (unsigned int)(tend / dt));

        // TODO check Ipopt status here: how?

        CasADiIpoptResults ipopt_results(sol);
        processed_ipopt = FuMEsResults(ipopt_results, dt);
    }

    FuMEsResults RestoreSimulation() const
    {
        return processed_ipopt;
    }

    void PrintStepwiseFunctions() const
    {
        std::cout << "k_red " << k_red << std::endl;
        std::cout << "k_oxi " << k_oxi << std::endl;
        std::cout << "k_dec " << k_dec << std::endl;
        std::cout << "x_aim " << x_aim << std::endl;
    }
private:
    // --- Problem constants.
    const unsigned int bw;            // Butterworth Heaviside exponent.
    const double dt;                  // Integration time-step.
    const double nt;                  // System size in moles.
    const double tc;                  // Boiler response time.
    double td;                        // Boiler starting time.

    // --- Initial conditions         //
    const double qs1_init;            // Initial source 1 flow.
    const double qs2_init;            // Initial source 2 flow.
    const std::vector<double> x_init; // Initial state.
    const std::vector<double> x1_fix; // Source 1 composition.
    const std::vector<double> x2_fix; // Source 2 composition.

    // --- Problem constraints        //
    bool integrate_only;              // Do not optimize boiler.
    bool compensate_flow;             // Change ratios of sources 1/2.
    bool optimize_flow;               // Optimize total flow.
    bool constrain_x1;                // Apply bounds to H2.
    bool constrain_x2;                // Apply bounds to CO.
    const double boiler_capacity;     // Boiler capacity.
    const double qt_min;              // Minimum total flow.
    const double qt_max;              // Maximum total flow.
    const double penalty_vk;          // Scale for steam penalization.
    const double penalty_rk;          // Scale for mixing penalization.
    const double penalty_qk;          // Scale for flow change penalization.
    const std::vector<double> xk_min; // Minimum compositions.
    const std::vector<double> xk_max; // Maximum compositions.
    // TODO individual flow constraints.
    //const double qs1_min;
    //const double qs1_max;
    //const double qs2_min;
    //const double qs2_max;

    // --- Results output
    FuMEsResults processed_ipopt;

    // Symbolic variables.
    const SX t = SX::sym("t");
    const SX x = SX::sym("x", 3);
    const SX u = SX::sym("u");
    const SX v = SX::sym("v");
    const SX r = SX::sym("r");
    const SX q = SX::sym("q");

    // Symbolic parameters.
    const SX xs0 = SX::sym("xs0", 3);
    const SX xs1 = SX::sym("xs1", 3);
    const SX xs2 = SX::sym("xs2", 3);

    // Step-wise functions.
    SX k_red;
    SX k_oxi;
    SX k_dec;
    SX x_aim;

    DMDict MultipleShootingIntegration(Function F, unsigned int n_steps)
    {
        using symbsol::vector_extend;

        // Total flow, flow 1 contribution.
        double qt = qs1_init + qs2_init;
        double r0 = qs1_init / qt;

        // Objective function.
        MX f = 0.0;

        // Initial conditions symbols.
        MX yk = MX::sym("y0", 4);

        // Arrays for storing step dependent constraints.
        MXVector t = { 0.0 };  // Time points.
        MXVector w = { yk };   // States.
        MXVector g = {};       // Constraints.

        // Boundaries of states.
        std::vector<double> lbw;
        std::vector<double> ubw;

        // First steps should be identical to initial state.
        vector_extend(lbw, x_init);
        vector_extend(ubw, x_init);

        // TODO add initial guess here.
        // TODO once all controls are added, use a single instance of
        // vector_extend to all of them, that's why the code is already
        // implemented like that.

        // Penalize strong changes.
        MX vk_prev, rk_prev, qk_prev;

        // Add one extra steps to have controls the same size as outputs.
        size_t last_step = (size_t)(n_steps) + (size_t)(1);

        for (size_t k = 0; k != last_step; k++)
        {
            // Current step controls symbols.
            MX vk = MX::sym("v" + std::to_string(k));
            MX rk = MX::sym("r" + std::to_string(k));
            MX qk = MX::sym("q" + std::to_string(k));

            // TODO in vk_min consider adding real minimum boiler capacity.
            // For Hygromatik that is about 20% of full range depending on model.
            double vk_min = (integrate_only) ? x_init[4] : 0.0;
            double vk_max = (integrate_only) ? x_init[4] : boiler_capacity;
            double rk_min = (compensate_flow) ? 0.0 : r0;
            double rk_max = (compensate_flow) ? 1.0 : r0;
            double qk_min = (optimize_flow) ? qt_min : qt;
            double qk_max = (optimize_flow) ? qt_max : qt;

            vector_extend(w, { vk, rk, qk });
            vector_extend(lbw, { vk_min, rk_min, qk_min });
            vector_extend(ubw, { vk_max, rk_max, qk_max });
            // TODO initial guess here.

            // Prepare call to integrator.
            MXDict current_args {
                {"t",   k  * dt},
                {"y",   yk},
                {"v",   vk},
                {"r",   rk},
                {"q",   qk},
                {"xs0", MX({ 1.0, 0.00, 0 })},
                {"xs1", MX(x1_fix)},
                {"xs2", MX(x2_fix)}
            };

            // Integrate step.
            MXDict Ik = F(current_args);

            // Problem current time.
            t.push_back((k + 1) * dt);

            // Increment objective function.
            f += Ik["quad"];

            // Add controllers change penalties.
            if (k > 0)
            {
                if (!integrate_only)
                {
                    f += penalty_vk * pow(vk - vk_prev, 2);
                }
                if (compensate_flow)
                {
                    f += penalty_rk * pow(rk - rk_prev, 2);
                }
                if (optimize_flow)
                {
                    f += penalty_qk * pow(qk - qk_prev, 2);
                }
            }

            // For later penalties.
            vk_prev = vk;
            rk_prev = rk;
            qk_prev = qk;

            // Lift the variable.
            MX y_prev = Ik["ynew"];
            
            // Create *expected solution*.
            yk = MX::sym("y" + std::to_string(k + 1), 4);
            w.push_back(yk);

            // Get solution ranges.
            double x1_min = (constrain_x1) ? xk_min[1] : 0.0;
            double x1_max = (constrain_x1) ? xk_max[1] : 1.0;
            double x2_min = (constrain_x2) ? xk_min[2] : 0.0;
            double x2_max = (constrain_x2) ? xk_max[2] : 1.0;

            // Bound *expected solution*.
            vector_extend(lbw, { xk_min[0], x1_min, x2_min, 0.0 });
            vector_extend(ubw, { xk_max[0], x1_max, x2_max, boiler_capacity });

            // Constrain *expected solution*.
            g.push_back(y_prev - yk);
        }

        Dict opts = { {"verbose", false} };
        MXDict nlp = { {"x", vertcat(w)}, {"f", f}, {"g", vertcat(g)} };
        Function solver = nlpsol("solver", "ipopt", nlp, opts);

        // Create inputs to solver with following interface:
        // I(x0[n],p[],lbx[n],ubx[n],lbg[2],ubg[2],lam_x0[n],lam_g0[2])
         DMDict arg;
         arg["x0"]     = {};
         arg["p"]      = {};
         arg["lbx"]    = DM(lbw);
         arg["ubx"]    = DM(ubw);
         arg["lbg"]    = 0;
         arg["ubg"]    = 0;
         arg["lam_x0"] = {};
         arg["lam_g0"] = {};

         // Solve problem and return solution, if any.
         return solver(arg);
    }

    Function CreateRk4SteppingFunction(std::tuple<SX, SX> problem)
    {
		using symbsol::MakeRungeKutta4Stepper;
		typedef std::vector<std::string> StrVector;

		// TODO think about concatenating the xs's.
		// Names for better function usage.
		const StrVector name_inputs = { "t", "y", "v", "r", "q", "xs0", "xs1", "xs2" };

        // Unpack symbolic problem.
        SX y, ydot;
        std::tie(y, ydot) = problem;

		// Arguments for f and stepper creation.
		SXVector args = { t, y, v, r, q, xs0, xs1, xs2 };

        // Wrap derivative in a function.
        Function f = Function("f", args, { ydot });

		// Use RK4 method to step function.
		SX ynew = MakeRungeKutta4Stepper(f, t, y, args, dt, 4);

        // Compute target water content.
        SX x_aim_new = (Function("x_aim", { t }, { x_aim })(t + dt)).at(0);

        // Compute square of error to compose cost.
        SX quad = pow(x_aim_new - ynew(0), 2);

        // Wrap solution and quadrature in a function.
        return Function("F", { t, y, v, r, q, xs0, xs1, xs2 },
                       { ynew, quad }, name_inputs, { "ynew", "quad" });
    }

    std::tuple<SX, SX> CreateProblemOdeSystem()
    {
        // Compute reaction rates.
        SX w = SX::sym("w", 3);
        w(2) = k_dec * x(0);
        w(0) = k_red * x(1) - k_oxi * x(0) - w(2);
        w(1) = -w(0);

        // Forced injections.
        SX q_in = u * xs0 + q * (r * xs1 + (1 - r) * xs2);

        // Sum of all injected flows (P, T = cte).
        // SX q_out = u + q + w(2) considering CO contribution.
        SX q_out = u + q;

        // Balance equation.
        SX xdot = (q_in - q_out * x + w) / nt;

        // Boiler pseudo-equation.
        // TODO make physical boiler option.
        SX udot = heaviside(t - td) * (v - u) / tc;

        // Assembly problem
        SX y = vertcat(x, u);
        SX ydot = vertcat(xdot, udot);

        // TODO after multiple-shooting pack them all together.
        // SX p    = vertcat(v, qs1, qs2)

        return std::make_tuple(y, ydot);
    }

    double ComposeTimeDependentSymbols(const FuMEsInputs& inputs)
    {
        using symbsol::MakeStepWiseFunction;

        std::vector<double> durations = {
            inputs.productionDurationCoilSt,
            inputs.productionDurationCoilNd,
            inputs.productionDurationCoilRd };
        std::vector<double> k_red_data = {
            inputs.constantOfReductionCoilSt,
            inputs.constantOfReductionCoilNd,
            inputs.constantOfReductionCoilRd };
        std::vector<double> k_oxi_data = {
            inputs.constantOfOxidationCoilSt,
            inputs.constantOfOxidationCoilNd,
            inputs.constantOfOxidationCoilRd };
        std::vector<double> k_dec_data = {
            inputs.constantOfDecarburizationCoilSt,
            inputs.constantOfDecarburizationCoilNd,
            inputs.constantOfDecarburizationCoilRd };
        std::vector<double> x_aim_data = {
            inputs.targetDewPointCoilSt,
            inputs.targetDewPointCoilNd,
            inputs.targetDewPointCoilRd };

        k_red = MakeStepWiseFunction(t, durations, k_red_data, bw);
        k_oxi = MakeStepWiseFunction(t, durations, k_oxi_data, bw);
        k_dec = MakeStepWiseFunction(t, durations, k_dec_data, bw);
        x_aim = MakeStepWiseFunction(t, durations, x_aim_data, bw);

        return std::accumulate(durations.begin(), durations.end(),
                               decltype(durations)::value_type(0));
    }
};

/////////////////////////////////////////////////////////////////////////////
// API
/////////////////////////////////////////////////////////////////////////////

FuMEsResults RunCore(FuMEsInputs& inputs)
{
    FuMEsResults results;

    try
    {
        std::cout << "Starting FuMEs simulation..." << std::endl;

        ConvertUnitsEntering(inputs);

        FuMEsInnerData model = FuMEsInnerData(inputs);
        results = model.RestoreSimulation();
    }
    catch (casadi::CasadiException& err)
    {
        std::cerr << "CasADi: " << err.what() << std::endl;
    }
    catch (std::exception& err)
    {
        std::cerr << "Other: " << err.what() << std::endl;
    }

    return results;
}

void FuMEsRunExplicit(FuMEsInputs& inputs, int* len, double** tk, double** x0,
    double** x1, double** x2, double** uk, double** vk, double** rk, double** qk)
{
    try
    {
        FuMEsResults results = RunCore(inputs);

        *len = (int)(results.tk.size());

        AllocateResult(*len, tk, results.tk);
        AllocateResult(*len, x0, results.x0);
        AllocateResult(*len, x1, results.x1);
        AllocateResult(*len, x2, results.x2);
        AllocateResult(*len, uk, results.uk);
        AllocateResult(*len, vk, results.vk);
        AllocateResult(*len, rk, results.rk);
        AllocateResult(*len, qk, results.qk);

        // TODO convert back results for display!    
    }
    catch (std::exception& err)
    {
        std::cerr << "Other: " << err.what() << std::endl;
    }
}

void FuMEsRun(FuMEsInputs& inputs, FuMEsOutputs& outputs)
{
    try
    {
        FuMEsResults results = RunCore(inputs);

        outputs.size = (int)(results.tk.size());
        outputs.tk = new double[outputs.size];
        outputs.x0 = new double[outputs.size];
        outputs.x1 = new double[outputs.size];
        outputs.x2 = new double[outputs.size];
        outputs.uk = new double[outputs.size];
        outputs.vk = new double[outputs.size];
        outputs.rk = new double[outputs.size];
        outputs.qk = new double[outputs.size];

        for (size_t k = 0; k != results.tk.size(); k++)
        {
            outputs.tk[k] = results.tk[k];
            outputs.x0[k] = results.x0[k];
            outputs.x1[k] = results.x1[k];
            outputs.x2[k] = results.x2[k];
            outputs.uk[k] = results.uk[k];
            outputs.vk[k] = results.vk[k];
            outputs.rk[k] = results.rk[k];
            outputs.qk[k] = results.qk[k];
        }

        // TODO convert back results for display!    
    }
    catch (std::exception & err)
    {
        std::cerr << "Other: " << err.what() << std::endl;
    }
}
