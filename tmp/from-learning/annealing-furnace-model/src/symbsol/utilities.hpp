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
#ifndef __SYMBSOL_UTILITIES__
#define __SYMBSOL_UTILITIES__

#include "definitions.hpp"

namespace symbsol
{
    /**
     * Extend a vector with elements, without destroying source one.
     *
     * This function is specially useful for multiple-shooting symbolic
     * integration since it allows to keep track of state vector properly
     * and also extend multiple-element constraints.
     */
    template<typename T>
    void vector_extend(Vector<T>& vec, const Vector<T>& ext)
    {
        vec.reserve(vec.size() + ext.size());
        vec.insert(std::end(vec), std::begin(ext), std::end(ext));
    }

    /**
     * Extend a vector with elements with move semantics.
     *
     * This function is specially useful for multiple-shooting symbolic
     * integration since it allows to keep track of state vector properly
     * and also extend multiple-element constraints.
     */
    template<typename T>
    void vector_extend(Vector<T> & vec, Vector<T> && ext)
    {
        if (vec.empty())
        {
            vec = std::move(ext);
        }
        else
        {
            vec.reserve(vec.size() + ext.size());
            std::move(std::begin(ext), std::end(ext), std::back_inserter(vec));
            ext.clear();
        }
    }
}

#endif // (__SYMBSOL_UTILITIES__)