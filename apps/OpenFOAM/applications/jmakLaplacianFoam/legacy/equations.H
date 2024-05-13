// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

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

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

fvScalarMatrix TEqn
(
    fvm::ddt(rho * cp, T)
 == 
    fvm::laplacian(kr, T, "laplacian(k,T)") + qdot
);

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

fvScalarMatrix beta1Eqn
(
    fvm::ddt(beta1) == dbeta1
);

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

fvScalarMatrix beta2Eqn
(
    fvm::ddt(beta2) == dbeta2
);

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

fvScalarMatrix beta3Eqn
(
    fvm::ddt(beta3) == dbeta3
);

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

TEqn.relax();
beta1Eqn.relax();
beta2Eqn.relax();
beta3Eqn.relax();

fvOptions.constrain(TEqn);
fvOptions.constrain(beta1Eqn);
fvOptions.constrain(beta2Eqn);
fvOptions.constrain(beta3Eqn);

TEqn.solve();
beta1Eqn.solve();
beta2Eqn.solve();
beta3Eqn.solve();

fvOptions.correct(T);
fvOptions.correct(beta1);
fvOptions.correct(beta2);
fvOptions.correct(beta3);

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
