/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Copyright (C) 2011-2023 OpenFOAM Foundation
     \\/     M anipulation  |
-------------------------------------------------------------------------------
License
    This file is part of OpenFOAM.

    OpenFOAM is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License
    along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.

Application
    jmakLaplacianFoam

Description
    Solves a simple Laplace equation for thermal diffusion in a solid coupled
    to a JMAK generalized states kinetics. This is a simple adaptation of old
    laplacianFoam solver, care must be taken when using it.

\*---------------------------------------------------------------------------*/

#include "argList.H"
#include "fvModels.H"
#include "fvConstraints.H"
#include "pimpleControl.H"

#include "fvmLaplacian.H"

using namespace Foam;

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

int main(int argc, char *argv[])
{
    argList::addNote
    (
        "Temperature equation solver for a JMAK kinetics in solids."
    );

    #include "setRootCase.H"

    #include "createTime.H"
    #include "createMesh.H"

    pimpleControl pimple(mesh);

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

    Info<< "Reading field T\n" << endl;
    volScalarField T
    (
        IOobject
        (
            "T",
            runTime.timeName(),
            mesh,
            IOobject::MUST_READ,
            IOobject::AUTO_WRITE
        ),
        mesh
    );

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

    Info << "Reading field beta1\n" << endl;
    volScalarField beta1
    (
        IOobject
        (
            "beta1",
            runTime.timeName(),
            mesh,
            IOobject::MUST_READ,
            IOobject::AUTO_WRITE
        ),
        mesh
    );

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

    Info << "Reading field beta2\n" << endl;
    volScalarField beta2
    (
        IOobject
        (
            "beta2",
            runTime.timeName(),
            mesh,
            IOobject::MUST_READ,
            IOobject::AUTO_WRITE
        ),
        mesh
    );

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

    Info << "Reading field beta3\n" << endl;
    volScalarField beta3
    (
        IOobject
        (
            "beta3",
            runTime.timeName(),
            mesh,
            IOobject::MUST_READ,
            IOobject::AUTO_WRITE
        ),
        mesh
    );

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

    Info<< "Reading physicalProperties\n" << endl;
    IOdictionary physicalProperties
    (
        IOobject
        (
            "physicalProperties",
            runTime.constant(),
            mesh,
            IOobject::MUST_READ_IF_MODIFIED,
            IOobject::NO_WRITE
        )
    );

    const dimensionSet dimR   = dimensionSet( 1,  2, -2, -1, -1,  0,  0);
    const dimensionSet dimRho = dimensionSet( 1, -3,  0,  0,  0,  0,  0);
    const dimensionSet dimCp  = dimensionSet( 0,  2, -2, -1,  0,  0,  0);
    const dimensionSet dimKr  = dimensionSet( 1,  1, -3, -1,  0,  0,  0);
    const dimensionSet dimHm  = dimensionSet( 1, -1, -2,  0,  0,  0,  0);
    const dimensionSet dimNm  = dimensionSet( 0,  0,  0,  0,  0,  0,  0);
    const dimensionSet dimKm  = dimensionSet( 0,  0, -1,  0,  0,  0,  0);
    const dimensionSet dimEm  = dimensionSet( 1,  2, -2,  0, -1,  0,  0);

    const dimensionedScalar R   ("R",   dimR,   physicalProperties);
    const dimensionedScalar rho ("rho", dimRho, physicalProperties);
    const dimensionedScalar cp  ("cp",  dimCp,  physicalProperties);
    const dimensionedScalar kr  ("kr",  dimKr,  physicalProperties);

    const dimensionedScalar H1  ("H1",  dimHm,  physicalProperties);
    const dimensionedScalar n1  ("n1",  dimNm,  physicalProperties);
    const dimensionedScalar k1  ("k1",  dimKm,  physicalProperties);
    const dimensionedScalar E1  ("E1",  dimEm,  physicalProperties);

    const dimensionedScalar H2  ("H2",  dimHm,  physicalProperties);
    const dimensionedScalar n2  ("n2",  dimNm,  physicalProperties);
    const dimensionedScalar k2  ("k2",  dimKm,  physicalProperties);
    const dimensionedScalar E2  ("E2",  dimEm,  physicalProperties);

    const dimensionedScalar H3  ("H3",  dimHm,  physicalProperties);
    const dimensionedScalar n3  ("n3",  dimNm,  physicalProperties);
    const dimensionedScalar k3  ("k3",  dimKm,  physicalProperties);
    const dimensionedScalar E3  ("E3",  dimEm,  physicalProperties);

    #include "createFvModels.H"
    #include "createFvConstraints.H"

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

    Info << "\nEvolving transport equations\n" << endl;

    while (runTime.run())
    {
        ++runTime;

        Info<< "Time = " << runTime.timeName() << nl << endl;

        fvModels.correct();

        while (pimple.correctNonOrthogonal())
        {
            volScalarField dbeta1 = k1 * Foam::exp(-E1 / (R * T));
            volScalarField dbeta2 = k2 * Foam::exp(-E2 / (R * T));
            volScalarField dbeta3 = k3 * Foam::exp(-E3 / (R * T));

            volScalarField q1 = dbeta1 * H1 * n1 * Foam::pow(beta1, n1-1);
            volScalarField q2 = dbeta2 * H2 * n2 * Foam::pow(beta2, n2-1);
            volScalarField q3 = dbeta3 * H3 * n3 * Foam::pow(beta3, n3-1);

            q1 *= Foam::exp(-Foam::pow(beta1, n1));
            q2 *= Foam::exp(-Foam::pow(beta2, n2));
            q3 *= Foam::exp(-Foam::pow(beta3, n3));

            volScalarField qdot = q1 + q2 + q3;

            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

            fvScalarMatrix TEqn
            (
                fvm::ddt(rho * cp, T)
            == 
                fvm::laplacian(kr, T, "laplacian(k,T)") + qdot
            );

            fvScalarMatrix beta1Eqn
            (
                fvm::ddt(beta1) == dbeta1
            );

            fvScalarMatrix beta2Eqn
            (
                fvm::ddt(beta2) == dbeta2
            );

            fvScalarMatrix beta3Eqn
            (
                fvm::ddt(beta3) == dbeta3
            );

            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

            TEqn.relax();
            beta1Eqn.relax();
            beta2Eqn.relax();
            beta3Eqn.relax();

            fvConstraints.constrain(TEqn);
            fvConstraints.constrain(beta1Eqn);
            fvConstraints.constrain(beta2Eqn);
            fvConstraints.constrain(beta3Eqn);

            TEqn.solve();
            beta1Eqn.solve();
            beta2Eqn.solve();
            beta3Eqn.solve();
        }

        runTime.write();

        Info << "ExecutionTime = " << runTime.elapsedCpuTime() << " s"
             << "  ClockTime = " << runTime.elapsedClockTime() << " s"
             << nl << endl;
    }

    Info << "End\n" << endl;

    return 0;
}

// ************************************************************************* //
