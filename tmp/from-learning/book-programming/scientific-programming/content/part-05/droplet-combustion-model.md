# Multicomponent liquid droplet combustion

In what follows we provide an implementation of the model developed by [Ren *et al.*](https://dx.doi.org/10.1021/acs.energyfuels.0c03669)

## Required tools

```julia
using Plots;
```

## Physical constants

```julia
RGAS = 8.31446261815324;
```

## Helper functions

```julia
struct ThermoData
    name::String;
    mw::Float64;
    lo::Array{Float64};
    hi::Array{Float64};
    Tc::Float64;
end
```

```julia
struct Solution
    mw::Array{Float64};
end
```

```julia
SPECIES = [
    ThermoData(
        "C8H10", 0.10616,
        [ 1.41688302E+00,  4.24899260E-02,  2.90259016E-05,
         -5.79774769E-08,  2.22785462E-11, -5.38782056E+02,
          2.16289435E+01],
        [ 1.09952650E+01,  3.94471414E-02, -1.60141065E-05,
          3.02159851E-09, -2.15018598E-13, -4.33350070E+03,
         -3.36830297E+01],
        1000.0
    ),
    ThermoData(
        "C8H16O2", 0.144214,
        [-6.91263883E-01,  1.03659150E-01, -6.99110558E-05,
          2.45512669E-08, -3.65222106E-12, -7.12346831E+04,
          3.86102343E+01],
        [ 1.55349351E+01,  5.99912854E-02, -2.58415306E-05,
          4.78465321E-09, -3.27482927E-13, -7.60581758E+04,
         -4.61023856E+01],
         1000.0
    ),
    ThermoData(
        "CO2", 0.044,
        [ 2.35677352E+00,  8.98459677E-03, -7.12356269E-06,
          2.45919022E-09, -1.43699548E-13, -4.83719697E+04,
          9.90105222E+00],
        [ 3.85746029E+00,  4.41437026E-03, -2.21481404E-06,
          5.23490188E-10, -4.72084164E-14, -4.87591660E+04,
          2.27163806E+00],
        1000.0
    ),
    ThermoData(
        "O2", 0.032,
        [ 3.78245636E+00, -2.99673416E-03,  9.84730201E-06,
         -9.68129509E-09,  3.24372837E-12, -1.06394356E+03,
          3.65767573E+00],
        [ 3.28253784E+00,  1.48308754E-03, -7.57966669E-07,
          2.09470555E-10, -2.16717794E-14, -1.08845772E+03,
          5.45323129E+00],
        1000.0
    ),
    ThermoData(
        "N2", 0.02801,
        [ 0.03298677E+02,  0.14082404E-02, -0.03963222E-04,
          0.05641515E-07, -0.02444854E-10, -0.10208999E+04,
          0.03950372E+02],
        [ 0.02926640E+02,  0.14879768E-02, -0.05684760E-05,
          0.10097038E-09, -0.06753351E-13, -0.09227977E+04,
          0.05980528E+02],
        1000.0
    ),
    ThermoData(
        "H2O", 0.018,
        [ 4.19864056E+00, -2.03643410E-03,  6.52040211E-06,
         -5.48797062E-09,  1.77197817E-12, -3.02937267E+04,
         -8.49032208E-01],
        [ 3.03399249E+00,  2.17691804E-03, -1.64072518E-07,
         -9.70419870E-11,  1.68200992E-14, -3.00042971E+04, 
          4.96677010E+00],
        1000.0
    )
];

MIXTURE = Solution(
    [s.mw for s in SPECIES]
);
```

```julia
function linspace(a, b, num)
    return Vector{Float64}(a : (b - a) / (num - 1) : b);
end

function weighted_average(w, A, B)
    return w .* A .+ (1 .- w) .* B;
end

function cp_poly(T, a)
    p = a[5];
    p = T * p + a[4];
    p = T * p + a[3];
    p = T * p + a[2];
    p = T * p + a[1];
    return RGAS * p;
end

function specific_heat_mole(obj, T)
    return (T > obj.Tc) ? cp_poly(T, obj.hi) : cp_poly(T, obj.lo);
end

function specific_heat_mass(obj, T)
    return specific_heat_mole(obj, T) / obj.mw;
end

function mean_molecular_mass(Y, species)
     return 1.0 ./ sum(yk ./ s.mw for (yk, s) in zip(Y, species))
end

function mass_to_mole_fraction(Y, mw)
    num = Y ./ mw';
    return num ./ sum(num, dims=2);
end
```

```julia
rows = 9;

Y = zeros(rows, length(species));
Y[:, 1] = linspace(0.0, 1.0, rows);
Y[:, 5] = 1.0 .- Y[:, 1];
Y
```

```julia
mass_to_mole_fraction(Y, MIXTURE.mw)
```

```julia

```

```julia
function gas_products(epsilon, ST11, ST12, ST21, ST22)
    CO2_Numper = weighted_average(epsilon, ST11 / MW_F1, ST21 / MW_F2);
    H2O_Numper = weighted_average(epsilon, ST12 / MW_F1, ST22 / MW_F2);

    den1 = CO2_Numper * MW_CO2 + H2O_Numper * MW_H2O;
    den2 = CO2_Numper + H2O_Numper;
    
    return [
        CO2_Numper * MW_CO2 / den1, 
        H2O_Numper * MW_H2O / den1,
        CO2_Numper / den2,
        H2O_Numper / den2
    ];
end
```

```julia
# function lambda = lamb(Y,X,T)
# global Patm Rg kb Na
# N = 6;
# % C8H10 C8H16O2 CO2 O2 N2 H2O

# MW = [106;144;44;32;28;18]/1e3;
# sigma_k = [6.51;7.55;3.76;3.46;3.62;2.60].*1e-10;
# C_v =[specheat('C8H10',T);specheat('C8H16O2',T);specheat('CO2',T);specheat('O2',T);specheat('N2',T);specheat('H2O',T)]- Rg;% refer to specific heat; C_v = C_p - R
# Z_rot_0 = [0.00;0.00;2.10;3.80;4.00;4.00];
# epsilon = [4003.83;4586.38;2028.74;892.98;810.91;4759.22]/Na;
# myu_k = [0.00;0.00;0.00;0.00;0.00;1.84]; % A s m

# T_s = kb*T./epsilon;
# Omega_D = 1.06036./T_s.^0.15610 + 0.19300./exp(0.47635*T_s) + 1.03587./exp(1.52996*T_s) + 1.76474./exp(3.89411*T_s);
# rho = Patm*MW/Rg/T;
# D_kk = 3/8*sqrt(pi*kb^3*T^3./MW*Na)/Patm/pi./sigma_k.^2./Omega_D;
    
# delta_k = 1/2*myu_k.^2/epsilon./sigma_k.^3;
# Omega_22 = 1.16145./T_s.^0.14874 + 0.52487./exp(0.7732*T_s) + 2.16178./exp(2.43787*T_s)-6.435e-4*T_s.^0.14874.*sin(18.0323*T_s.^(-0.7683)-7.27371);
        
# eta_k = 5/16*sqrt(pi*MW/Na*kb*T)/pi./sigma_k.^2./Omega_22;

# C_v_trans = 1.5*Rg;
# C_v_rot = [1.5, 1.5, 1, 1, 1, 1.5]'*Rg;
# C_v_vib = C_v - [3, 3, 2.5, 2.5, 2.5, 3]'*Rg;
# Z_rot = Z_rot_0.*F(298,epsilon)./F(T,epsilon);
    
# A = 5/2 - rho.*D_kk./eta_k;
# B = Z_rot + 2/pi*(5/3*C_v_rot/Rg + rho.*D_kk./eta_k);
    
# f_trans = 5/2*(1 - 2/pi*C_v_rot./C_v_trans.*A./B);
# f_rot = rho.*D_kk./eta_k.*(1 + 2/pi*A./B);
# f_vib = rho.*D_kk./eta_k;
    
# lambda_k = eta_k./MW.*(f_trans.*C_v_trans + f_rot.*C_v_rot + f_vib.*C_v_vib);
# lambda = 1/2*(sum(X'.*lambda_k) + 1./sum(X'./lambda_k));
# end

# function F = F(T,epsilon)
# global kb
# F = 1 + pi^(3/2)/2*(epsilon/kb/T).^(1/2) + (pi^2/4 + 2)*(epsilon/kb/T) + pi^(3/2)*(epsilon/kb/T).^(3/2);
# end
```

```julia
function gas_mixture_products(epsilon, ST11, ST12, ST21, ST22, YF, YO, YP, YN, T, rfp)
    rets = gas_products(epsilon, ST11, ST12, ST21, ST22);
    (MF_CO2, MF_H2O, XF_CO2, XF_H2O) = rets;
    
    YF1  = YF * epsilon;
    YF2  = YF * (1.0 - epsilon);
    YCO2 = YP * MF_CO2;
    YH2O = YP * MF_H2O;
    
    #     F1   F2   CO2  O2  N2   H2O
    Y = [YF1, YF2, YCO2, YO, YN, YH2O];
    X = mass_to_mole_fraction(Y, MIXTURE.mw)
    (XF1, XF2, XCO2, XO, XN, XH2O) = X;

    XP   = XCO2 + XH2O;
    MW_P = (XCO2[1] * MW_CO2 + XH2O[1] * MW_H2O) / XP[1];
    
#     % characteristic temperature and componient
#     ratio1 = 1/6; ratio2 = 2/3; ratio3 = 1/6;
#     Tch   = ratio1*T(1)   + ratio2*T(rfp)  + ratio3*T(end);
#     YF1ch = ratio1*YF1(1) + ratio2*YF1(rfp)+ ratio3*YF1(end);
#     YF2ch = ratio1*YF2(1) + ratio2*YF2(rfp)+ ratio3*YF2(end);
#     YOch  = ratio1*YO(1)  + ratio2*YO(rfp) + ratio3*YO(end);
#     YPch  = ratio1*YP(1)  + ratio2*YP(rfp) + ratio3*YP(end);
#     YNch  = ratio1*YN(1)  + ratio2*YN(rfp) + ratio3*YN(end);
#     YCO2ch = YPch*MF_CO2;
#     YH2Och = YPch*MF_H2O;
    
#     XF1ch = ratio1*XF1(1) + ratio2*XF1(rfp)+ ratio3*XF1(end);
#     XF2ch = ratio1*XF2(1) + ratio2*XF2(rfp)+ ratio3*XF2(end);
#     XOch  = ratio1*XO(1)  + ratio2*XO(rfp) + ratio3*XO(end);
#     XPch  = ratio1*XP(1)  + ratio2*XP(rfp) + ratio3*XP(end);
#     XNch  = ratio1*XN(1)  + ratio2*XN(rfp) + ratio3*XN(end);
#     XCO2ch = XPch*XF_CO2;
#     XH2Och = XPch*XF_H2O;
    
# %% Expression of thermal conductivity for specific heat and kinetic viscouty of gas species
#     %% thermal conductivity
#     Ych = [YF1ch,YF2ch,YCO2ch,YOch,YNch,YH2Och];
#     Xch = [XF1ch,XF2ch,XCO2ch,XOch,XNch,XH2Och];
#     lambda_g = lamb(Ych,Xch,Tch);
#     Ybd = [YF1(1),YF2(1),YCO2(1),YO(1),YN(1),YH2O(1)];
#     Xbd = [XF1(1),XF2(1),XCO2(1),XO(1),XN(1),XH2O(1)];
#     lambda_bd = lamb(Ybd,Xbd,T(1));

#     %% specific heat J/kg/K
#     cp_F1  = specheat('C8H10',Tch)/MW_F1;
#     cp_F2  = specheat('C8H16O2',Tch)/MW_F2;
#     cp_O2  = specheat('O2' ,Tch)/MW_O;
#     cp_CO2 = specheat('CO2',Tch)/MW_CO2;
#     cp_H2O = specheat('H2O',Tch)/MW_H2O;
#     cp_N2  = specheat('N2' ,Tch)/MW_N;
#     cp = YF1ch*cp_F1 + YF2ch*cp_F2 + YOch*cp_O2 + YNch*cp_N2 + YCO2ch*cp_CO2 + YH2Och*cp_H2O;
    
#     cp_F1  = specheat('C8H10',T(1))/MW_F1;
#     cp_F2  = specheat('C8H16O2',T(1))/MW_F2;
#     cp_O2  = specheat('O2' ,T(1))/MW_O;
#     cp_CO2 = specheat('CO2',T(1))/MW_CO2;
#     cp_H2O = specheat('H2O',T(1))/MW_H2O;
#     cp_N2  = specheat('N2' ,T(1))/MW_N;
#     cp_bd = YF1(1)*cp_F1 + YF2(1)*cp_F2 + YO(1)*cp_O2 + YN(1)*cp_N2 + YCO2(1)*cp_CO2 + YH2O(1)*cp_H2O;

#     return [lambda_g, lambda_bd, cp, cp_bd, MW_P]
end
```

## Parameters setting

### Constants

```julia
kb = 1.3806505e-23;
Patm = 101325.0;
Na = 6.02e+23;
```

### Gas phase

```julia
# Infinity position for air.
Y_O_inf = 1.0; 
Y_N_inf = 1.0 - Y_O_inf;
```

```julia
thermo = Dict([(v.name, v) for v in SPECIES]);
```

```julia
# kg/mol N2
MW_N = thermo["N2"].mw;

# kg/mol O2
MW_O = thermo["O2"].mw;

# kg/mol CO2
MW_CO2 = thermo["CO2"].mw;

# kg/mol H2O
MW_H2O = thermo["H2O"].mw;

# kg/mol m-Xylene 
MW_F1 = thermo["C8H10"].mw; 

# kg/mol 2-EHA
MW_F2 = thermo["C8H16O2"].mw;
```

```julia
# K boiling point of m-Xylene.
T_boil_F1 = 139 + 273.15;

# K boiling point of 2-EHA   
T_boil_F2 = 228 + 273.15;
```

```julia
# J/kg/K gas heat capacity, initial guess.
cp = (2*844+3*1930+3*4.76*1040)/9.76*5;

# W/m/K heat conductivity of air gases, initial gas.
lambda_g = 0.2;
```

```julia
# C H O fuel.
fuel1 = [8, 10, 0];
fuel2 = [8, 16, 2];

# Solvent 1 Solvent + ()O2 -> ST11 CO2 + ST12 H2O;
ST11 = fuel1[1];
ST12 = fuel1[2] / 2;

#  Solute 1 Solute + () O2 -> ST21 CO2 + ST22 H2O;
ST21 = fuel2[1];
ST22 = fuel2[2] / 2;

# Latent heat for H2O, 25oC, J/mol
HvH2O = 40650.0;
```

```julia
# Latent energy for m-Xylene evaporation J/kg.
Qv1 = 42.65e3 / MW_F1;

# Latent energy for 2-EHA evaporation J/kg.
Qv2 = 75.60e3 / MW_F2;

# Standard combustion enthaphy for m-Xylene J/kg.
Qc1 = 4.3745e6 / MW_F1 + 1 / MW_F1*ST12*HvH2O;

# Standard combustion enthaphy for C8H16O2 J/kg; meanless for Ni(OH)2.
Qc2 = 4.5233e6 / MW_F2 + 1 / MW_F2*ST22*HvH2O;

# Multiplier for computing nu.
factor = MW_O ./ [1, 4, 2]

#  For species 1, m-Xylene.
nu1 = sum(fuel1 .* factor) / MW_F1;

# For species 2, 2-EHA.
nu2 = sum(fuel2 .* factor) / MW_F2;
```

### Liquid phase

```julia
# heat conductivity of m-Xylene, W/m/K
lambda_l1 = 0.1032;

# heat conductivity of 2EHA, W/m/K
lambda_l2 = 200.7e-3;

# liquid capacity of m-Xylene, J/kg/K
cp_l1 = 184.5 / MW_F1;

# liquid capacity of 2-EHA, J/kg/K
cp_l2 = 309.75 / MW_F2 * 2;

# liquid density of m-xylene, kg/m3
rho_l1 = 860.0;

# liquid density of 2-EHA, kg/m3
rho_l2 = 903.0;

# Molar mass of fuel 1 m-xylene 
MW1 = MW_F1;

# Molar mass of fuel 2 2-EHA
MW2 = MW_F2;

# Lewis numbers.
Le = 10.0;
Le_g = 1.0;
```

## Grid discretization

```julia
# Number of points in droplet grid.
N = 500;

# The number of grid of the gas-phase flame.
rNum = 200;

# The farthest position of the gas phase (non-dimensional).
rmax = 50.0;

# Grid size in the droplet (non-dimensional).
dx = 1.0 / N;

# Grid size of the gas phase(non-dimensional)
dr = (rmax - 1) / (rNum - 1);

# Central point in the droplet grid (non-dimensional).
xc = linspace(0.5/N, 1.0-0.5/N, N);

# Node point in the droplet grid (non-dimensional).
xn = linspace(0.0, 1.0, N+1);

# Grid of the gas phase (non-dimensional).
r = linspace(1.0, rmax, rNum);

# Grid of time (unit: s)
tspan = linspace(0.0, 0.025, 10001);
```

## Initial conditions

```julia
# K temperature at the infinity.
T_inf = 300.0;

# K surface temperature.
Ts = 300.0;

# droplet size (m)
rs0 = 50.0e-06;

# setting of temporal droplet size.
rs = rs0;

# initial droplet density is equal to the major fuel component.
rho_d = rho_l1;

# molar mass for product species is equal to the inert species.
MW_P = MW_N;

# initial estimation temperature for gas phase (K)
T = 300.0 .* ones(rNum);

# mole fraction of inert species is initially set as 1
XNs = 1;

# mole fraction of product species is initially set as 0
XPs = 0;
```

## Numerical simulation setup

```julia
# initial temperature
T0 = Ts .* ones(N+1, 1);

# initial mass fractions of components in droplets
Y0 = zeros(2*(N+1), 1);

# less-volatile component, 2-EHA
Y0[N+2:2*N+2] = 0.023792 .* ones(N+1,1);

# major fuel, m-xylene
Y0[1:N+1] = 1.0 .- Y0[N+2:2*N+2];

# Initial states.
Tinit = T0;
Yinit = Y0;
```

```julia
# parameters for storage
Time_history = [];
Tresult_history = [];
Tgresult_history = [];
Y1result_history = [];
Y2result_history = [];
YFresult_history = [];
rs_history = [];
rf_history = [];
drs2dt_history = [];
B_history = [];
```

```julia
YF = similar(r);
YO = similar(r);
YP = similar(r);
YN = similar(r);
```

```julia
j0 = 5;

for i = 1:1:length(tspan)-1
    for j = 1:j0
        ######################################################################
        # liquid T and c for the gas-phase boundary condition
        ######################################################################
        
        # droplet surface temperature
        Ts  = Tinit[end, end];
        
        # droplet volatile species, mass fraction
        Y1s = Yinit[1*N+1, end];

        # droplet non-volatile species, mass fraction
        Y2s = Yinit[2*N+2, end];

        # Mean molar mass-like expression.
        mean_mw_Y = 1.0 / (Y1s / MW1 + Y2s / MW2);
        
        # droplet volatile species, mole fraction.
        X1s = mean_mw_Y * Y1s / MW1;
        
        # droplet non-volatile species, mole fraction.
        X2s = mean_mw_Y * Y2s / MW2; 
        
        # mole fraction of species 1 at the droplet surface in the gas phase
        XF1s = X1s * exp(Qv1 * MW_F1 / RGAS * (1 / T_boil_F1 - 1 / Ts));
        
        # mole fraction of species 2 at the droplet surface in the gas phase
        XF2s = X2s * exp(Qv2 * MW_F2 / RGAS * (1 / T_boil_F2 - 1 / Ts));
        
        # Mean molar mass in terms of mole fractions.
        mean_mw_X = XF1s * MW_F1 + XF2s * MW_F2 + XNs * MW_N + XPs * MW_P;
        
        # mass fraction of species 1 at the droplet surface in the gas phase
        YF1s = XF1s * MW_F1 / mean_mw_X;
        
        # mass fraction of species 2 at the droplet surface in the gas phase
        YF2s = XF2s * MW_F2 / mean_mw_X;
        
        # mass fraction of the total fuel species at the droplet surface in the gas phase.
        YFs = YF1s + YF2s;
        
        # fractional mass vaporization rate of species 1
        epsilon = YF1s / YFs;

        # Terms recurring in the following equations.
        eps1 = epsilon / MW_F1;
        eps2 = (1 - epsilon) / MW_F2;
        
        # molar mass of product species based on the evaporated fuel species (kg/mol)
        num = (eps1 * ST11 + eps2 * ST21) * MW_CO2 +
              (eps1 * ST12 + eps2 * ST22) * MW_H2O;
        MW_P = num / (eps1 * (ST11 + ST12) + eps2 * (ST21 + ST22));
        
        # molar fraction of fuel species (kg/mol)
        MW_F = 1.0 / (eps1 + eps2);
        
        ######################################################################
        # gas phase temperature and species profile
        ######################################################################
        
        # averaged stoichiometric oxygen-to-fuel mass ratio 
        nu = weighted_average(epsilon, nu1, nu2);
        
        # combustion heat (J/kg)
        Qc = weighted_average(epsilon, Qc1, Qc2);
        
        # vaporization heat (J/kg)
        Qv = weighted_average(epsilon, Qv1, Qv2);
        
        # Spalding transfer number 
        Bm = (Y_O_inf / nu + YFs) / (1 - YFs);
 
        # Critical combustion limit, here we assume the flame exists
        # throughout the droplet lifetime
        CombCri = 100 * rs^2 / rs0^2;
        CombCri0 = 0.0;

        if (CombCri < CombCri0)
            rf = 1.0;
        else
            # Recurring terms in expressions.
            YOnu = Y_O_inf / nu;
            Bm1 = Bm + 1;
            lBm1 = log(Bm1);
            expLogBm1 = (exp.(-1.0 .* lBm1 ./ r) .- 1.0) ./ (1.0 / Bm1 - 1.0);
            nuFactor = (1.0 .+ nu) ./ nu;
            
            # flame front position, non-dimensional
            rf = lBm1 ./ log(1 .+ YOnu);
            
            # *before flame front*.
            loc = r .< rf;
            
            # distribution of species inside the flame front
            YF[loc] = -YOnu .+ (YFs .+ YOnu) .* expLogBm1[loc];
            YO[loc] .= 0.0;
            YP[loc] = nuFactor .* (Y_O_inf .- (Bm / Bm1) .* Y_O_inf .* expLogBm1[loc]);
            
            # *after flame front*.
            loc = r .>= rf;
            
            # distribution of species outside the flame front
            YF[loc] .= 0.0;
            YO[loc] = Y_O_inf .- (YFs .* nu .+ Y_O_inf) .* expLogBm1[loc];
            YP[loc] = ((nu .+ 1) .* YFs .+ nuFactor ./ Bm1 .* Y_O_inf) .* expLogBm1[loc];
            
            # distribution of the inert species
            YN[1:end] = Y_N_inf .- (Bm ./ Bm1) .* Y_N_inf .* expLogBm1;
        end
        
        # fuel mass fraction at the droplet surface
        YFs = YF[1];
        
        # oxidizer mass fraction at the droplet surface
        YOs = YO[1];
        
        # product species mass fraction at the droplet surface
        YPs = YP[1];
        
        # inert species mass fraction at the droplet surface
        YNs = YN[1];
        
        # Update mean molar mass from mass fractions.
        mean_mw_Y = 1.0 ./ (YFs/MW_F + YOs/MW_O + YPs/MW_P + YNs/MW_N);
        
        # mole fraction of product species at the droplet surface,
        XPs = mean_mw_Y .* YPs ./ MW_P;
        
        # mole fraction of inert species at the droplet surface,
        XNs = mean_mw_Y .* YNs ./ MW_N;
        
        ######################################################################
        # Physical parameter estimation
        ######################################################################
        
        # find flame position in grid
        rfp = ceil((rf - 1) / dr) + 1;
        
        # Estimate the gas-phase thermal conductivity (J/m/K), heat capacity
        # (J/kg/K), molar mass of product ('g' for average value, 'bd' for
        # surface value)
        props = gas_mixture_products(epsilon, ST11, ST12, ST21, ST22, YF, YO, YP, YN, T, rfp);
#         (lambda_g, lambda_bd, cp, cp_bd, MW_P) = props;
        
        # distribution of temperature inside the flame front
#         T(find(r< rf)) = T_inf + Y_O_inf*Qc/nu/cp + (Ts - T_inf - Y_O_inf*Qc/nu/cp)*(exp(-1./r(find(r< rf))*log(1+Bm))-1)/(1/(1+Bm)-1);
        
        #distribution of temperature outside the flame front
#         T(find(r>=rf)) = T_inf + (Ts - T_inf + YFs*Qc/cp)*(exp(-1./r(find(r>=rf))*log(1+Bm))-1)/(1/(1+Bm)-1);

        # Parameter
#         drs2dt = -2*lambda_g/cp/rho_d(end)*log(1+Bm); % dr^2/dt (m2/s)

        ######################################################################
        # mass and heat diffusion coefficient in liquids
        ######################################################################

#         converge = 1;
#         Tresult_temp = Tinit;
#         Yresult_temp = Yinit;
#         while(converge == 1) % this iteration for the variation of thermoproperties of liquid species
#             [rho_d, cp_d, lambda_d] = Liquidmixpro(Yresult_temp,Tresult_temp,cp_l1,cp_l2,lambda_l1,lambda_l2); %estimate the density (kg/m3), heat capacity (J/kg/K), thermal conductivity(J/m/K)
#             alpha_d = lambda_d./cp_d./rho_d; % thermal diffusivity (m2/s)
#             D = alpha_d./Le; % mass diffusivity (m2/s)
#             D = [D,D];
#             Tresult = heattransfer(linspace(tspan(i)*(j0+1-j)/j0 + tspan(i+1)*(j-1)/j0,tspan(i+1),3),Tinit,rs,alpha_d,lambda_d); %solve the temperature distribution in the droplet
#             Yresult = masstransfer(linspace(tspan(i)*(j0+1-j)/j0 + tspan(i+1)*(j-1)/j0,tspan(i+1),3),Yinit,rho_d,rs,D);%solve the species mass fraction in the droplet
#             Y1result  = Yresult(1:N+1); % mass fraction for species 1
#             Y2result  = 1 - Y1result; % mass fraction for species 2
#             errorT = sum(abs(Tresult - Tresult_temp))/sum(abs(Tresult_temp));
#             errorY = sum(abs(Yresult - Yresult_temp))/sum(abs(Yresult_temp));
#             fprintf('rs=%f,%e,%e\n',rs,errorT,errorY);
#             if(errorT < 1e-7 && errorY < 1e-7)
#                 converge = 0;
#                 Y1result  = Yresult(1:N+1);
#                 Y2result  = Yresult(N+2:2*N+2);
#             else
#                 Tresult_temp = Tresult;
#                 Yresult_temp = Yresult;
#             end
#         end
#         Tinit = Tresult;
#         Yinit = Yresult;
#         if j ~= j0 % the relaxation coefficient is added here to avoid the fluctuations caused by the iteration between gas and liquid phase.
#             jj = (j0-j)/(j0+1-j);
#             Tinit = jj.*Tresult + (1 - jj).*Tinit;
#             Yinit = jj.*[Y1result;Y2result] + (1 - jj).*Yinit;
#         else
#             Tinit = Tresult;
#             Yinit = [Y1result;Y2result];         
#         end
    end
end
```

```julia
# %% save the result to history
#     YFresult_history=[YFresult_history;[YF1s,YF2s,YF1s+YF2s]];
#     rf_history = [rf_history;rf];
#     Tgresult_history = [Tgresult_history;T];
#     Tresult_history   = [Tresult_history;Tresult'];
#     Y1result_history  = [Y1result_history;Y1result'];
#     Y2result_history  = [Y2result_history;Y2result'];
#     drs2dt_history = [drs2dt_history;drs2dt];
#     B_history = [B_history;Ts];	
# Time_history=[Time_history;tspan(i+1)];

#     %% solve droplet shrink
#     dmdt = 4*pi*rs*lambda_g/cp*log(1+Bm)/Le_g; % changing mass flow rate, kg/s
#     rs2 = (rs^2+drs2dt*(tspan(i+1)-tspan(i)));%/alpha_droplet^(2/3);
#     if (rs2 > 0)
#         rs = sqrt(rs2);
#         rs_history = [rs_history;rs];
#     else
#         break
#     end
#     if(rs2/rs0^2 < 0.01) % when the droplet is too small, stop simulation to avoid the error when the droplet radius is 0.
#         break
#     end  
    
#     %% temporal output 
#     if(mod(i,1)==0)
#         fprintf('step = %d, r^2 = %g, Bm = %e \n',i,rs^2/rs0^2*100,Bm);
#         figure(1);set(gcf, 'position', [500,-300,1000,1000]);
#         subplot(2,2,1);
#         yyaxis left; plot(r,T,'b-');           xlabel('Dimensionless radial position r/r_s');ylabel('Temperature T(K)');
#         yyaxis right;plot(r,YO,'r-',r,YF,'r--');xlabel('Dimensionless radial position r/r_s');ylabel('Species mass fraction Y_i');
#         set(gca, 'XScale', 'log','FontSize',14);title(['t =',num2str(tspan(i+1)),'s']);
        
#         subplot(2,2,2);
#         plot(r,YN,'b-',r,YP,'r-');xlabel('Dimensionless radial position r/r_s');ylabel('Species mass fraction');
#         set(gca, 'XScale', 'log','FontSize',14);
        
#         subplot(2,2,3);
#         yyaxis left; plot(xn,Tresult_history(end,:),'b-');xlabel('Dimensionless radial position r/r_s');ylabel('Temperature T(K)');
#         yyaxis right;plot(xn,Y1result_history(end,:),'m-',xn,Y2result_history(end,:),'g-');xlabel('Dimensionless radial position r/r_s');ylabel('Species mass fraction');
#         set(gca, 'FontSize',14);

#         subplot(2,2,4);
#         yyaxis left;plot(Time_history/rs0^2/1e6/4,rs_history.^2/rs0^2)
#         yyaxis right;plot(Time_history/rs0^2/1e6/4,B_history)
#         set(gca,'FontSize',14);
#     end
# end
```

```julia

```

```julia

```
