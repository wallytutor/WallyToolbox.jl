/*********************************************************************
 *    This file is part of SymbSol.
 *
 *    SymbSol -- Helper utilities to solve problems with CasADi.
 *    Copyright (C) 2021 Walter Dal'Maz Silva. All rights reserved.
 *
 *    SymbSol is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU Lesser General Public License as
 *    published by the Free Software Foundation; either version 3 of
 *    the License, or (at your option) any later version.
 *
 *    SymbSol is distributed in the hope that it will be useful, but
 *    WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with SymbSol; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 *    MA  02110-1301  USA
 *
 *********************************************************************/
#ifndef __SYMBSOL_MODELS__
#define __SYMBSOL_MODELS__

#include "definitions.hpp"
#include <numeric>

namespace symbsol
{
    /**
     * Provide a convenient retrieval of NLP solutions into vectors.
     *
     * Outputs from nonlinear problems solutions in CasADi have an
     * interface that is not optimized for further processing with
     * standard C++. This simple structure recovers the results in
     * vectors so that they can be used, for example, for tabulation.
     * 
     * Parameters
     * ----------
     * sol : DMDict or DMVector
     *     Depending on how you called the solver created by `nlpsol`
     *     the results can be in a map `DMDict` or a vector `DMVector`.
     *     In both cases the solution is structured in a similar manner
     *     as `DM` sets that can be converted to plain C++ vectors. As
     *     a recall, the solution is expected to contain the elements
     *     `O(x[nx],f,g[ng],lam_x[nx],lam_g[ng],lam_p[np])`
     */
    struct CasADiIpoptResults
    {
        const unsigned int nx;
        const unsigned int ng;
        const unsigned int np;
        const double f;
        const VectorReal x;      // [nx]
        const VectorReal g;      // [ng]
        const VectorReal lam_x;  // [nx]
        const VectorReal lam_g;  // [ng]
        const VectorReal lam_p;  // [np]

        CasADiIpoptResults(DMDict& sol) :
            nx{ (unsigned int)(sol["x"].nnz()) },
            ng{ (unsigned int)(sol["g"].nnz()) },
            np{ (unsigned int)(sol["lam_p"].nnz()) },
            x{ sol["x"].get_elements() },
            f{ sol["f"].get_elements()[0] },
            g{ sol["g"].get_elements() },
            lam_x{ sol["lam_x"].get_elements() },
            lam_g{ sol["lam_g"].get_elements() },
            lam_p{ sol["lam_p"].get_elements() }
        {}

        CasADiIpoptResults(DMVector& sol) :
            nx{ (unsigned int)(sol[0].nnz()) },
            ng{ (unsigned int)(sol[2].nnz()) },
            np{ (unsigned int)(sol[5].nnz()) },
            x{ sol[0].get_elements() },
            f{ sol[1].get_elements()[0] },
            g{ sol[2].get_elements() },
            lam_x{ sol[3].get_elements() },
            lam_g{ sol[4].get_elements() },
            lam_p{ sol[5].get_elements() }
        {}
    };
        
    /**
     * Provides a continuous differentiable Heaviside function approximation.
     *
     * This approximation makes use of some form of Butterworth filter of
     * degree `b/2` to produce a step function. It is useful for the setup of
     * smooth set-points for optimization problems due to its natural smearing
     * of inputs. Notice that if transition time absolute value is too close
     * to machine epsilon (10 times its value) the function will adopt internal
     * CasADi's definition of Heaviside function.
     *
     * Parameters
     * ----------
     * t : SX
     *     Independent variable to evaluate function at (generally time).
     * tc : T
     *     Value of independent variable where step is centered at.
     * b : unsigned int
     *     Order of approximation, the higher the sharper is the step.
     */
    template <class T>
    SX Heaviside(SX t, T tc, unsigned int b)
    {
        if (abs(tc) <= 10 * std::numeric_limits<T>::epsilon())
        {
            return heaviside(t - tc);
        }

        return 1.0 - 1.0 / (1.0 + pow(t / tc, b));
    }

    /**
     * Construct a multi-step constant function.
     *
     * Parameters
     * ----------
     * t : SX
     *     Independent variable to evaluate function at (generally time).
     * tcs : Vector<T>
     *     Values of independent variable where steps are centered at.
     *     The first value represents the position where the first element
     *     of `k` transitions to the second value in `k`.
     * k : Vector<T>
     *     Values of constant step levels.
     * b : unsigned int
     *     Order of approximation, the higher the sharper is the step.
     */
    template <class T>
    SX MakeStepWiseFunction(SX t, const Vector<T>& tcs, const Vector<T>& k, unsigned int b)
    {
        if (tcs.size() != k.size())
        {
            throw std::runtime_error("Arrays of change times and properties must "
                                     "have same length for using this function.");
        }
        if (k.size() == 0)
        {
            throw std::runtime_error("At least one element must be provided in "
                                     "property to step over.");
        }

        T tc = 0.0;
        SX val = k[0];

        for (size_t i = 1; i != k.size(); i++)
        {
            tc += tcs[i - 1];
            val += Heaviside<T>(t, tc, b) * (k[i] - k[i - 1]);
        }

        return val;
    }

    /**
     * Create function that itegrate problem over provided time-step.
     *
     * Parameters
     * ----------
     * f : const Function
     *     Right-hand side of system of ODE's to integrate.
     * t : const SX
     *     Symbol of independent variables at current step.
     * y : const SX
     *     Symbol of dependent variables at current step.
     * args : SXDict
     *     Dictionary of arguments to be supplied to function.
     * dt : const T
     *     Integration step to perform.
     * ns : const int
     *     Number of internal steps to perform.
     * name_t : const std::string
     *     Name of independent variable in `args`.
     * name_y : const std::string
     *     Name of dependent variable in `args`.
     * name_o : const std::string
     *     Name of right-hand side in `f` outputs.
     */
    template <class T>
    SX MakeRungeKutta4Stepper(const Function f, const SX t, const SX y,
        SXDict args, const T dt, const int ns = 10, const String name_t = "t",
        const String name_y = "y", const String name_o = "o0")
    {
        SX z = y;
        T st = dt / ns;

        for (int k = 0; k != ns; k++)
        {
            const T mt = st / 2;

            args[name_t] = t;
            args[name_y] = z;
            SX k1 = f(args).at(name_o);

            args[name_t] = t + mt;
            args[name_y] = z + mt * k1;
            SX k2 = f(args).at(name_o);

            args[name_t] = t + mt;
            args[name_y] = z + mt * k2;
            SX k3 = f(args).at(name_o);

            args[name_t] = t + st;
            args[name_y] = z + st * k3;
            SX k4 = f(args).at(name_o);

            z += (st / 6) * (k1 + 2 * k2 + 2 * k3 + k4);
        }

        return z;
    }

    /**
     * Create function that itegrate problem over provided time-step.
     *
     * Parameters
     * ----------
     * f : const Function
     *     Right-hand side of system of ODE's to integrate.
     * t : const SX
     *     Symbol of independent variables at current step.
     * y : const SX
     *     Symbol of dependent variables at current step.
     * args : SXVector
     *     Vector of arguments to be supplied to function.
     * dt : const T
     *     Integration step to perform.
     * ns : const int
     *     Number of internal steps to perform.
     * index_t : const int
     *     Index of independent variable in `args`.
     * index_y : const int
     *     Index of dependent variable in `args`.
     * index_o : const int
     *     Index of right-hand side in `f` outputs.
     */
    template <class T>
    SX MakeRungeKutta4Stepper(const Function f, const SX t, const SX y,
        SXVector args, const T dt, const int ns = 10, const int index_t = 0,
        const int index_y = 1, const int index_o = 0)
    {
        SX z = y;
        T st = dt / ns;

        for (int k = 0; k != ns; k++)
        {
            const T mt = st / 2;

            args.at(index_t) = t;
            args.at(index_y) = z;
            SX k1 = f(args).at(index_o);

            args.at(index_t) = t + mt;
            args.at(index_y) = z + mt * k1;
            SX k2 = f(args).at(index_o);

            args.at(index_t) = t + mt;
            args.at(index_y) = z + mt * k2;
            SX k3 = f(args).at(index_o);

            args.at(index_t) = t + st;
            args.at(index_y) = z + st * k3;
            SX k4 = f(args).at(index_o);

            z += (st / 6) * (k1 + 2 * k2 + 2 * k3 + k4);
        }

        return z;
    }
}

#endif // (__SYMBSOL_MODELS__)