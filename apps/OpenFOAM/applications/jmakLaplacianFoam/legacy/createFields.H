// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

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

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

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

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

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

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

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

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

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

#include "createFvOptions.H"

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
