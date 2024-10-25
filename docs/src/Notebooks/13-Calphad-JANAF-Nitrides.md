# Gibbs energy analysis of $Si_3N_4$ and $MnSiN_2$


Data was retrieved and manually prepared from extractions made from [NIST JANAF tables](https://janaf.nist.gov/).

```python
%matplotlib inline
%config InlineBackend.figure_formats = ["svg"]
```

```python
from pathlib import Path
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
```

```python
DATA_DIR = Path("../../../data/thermodynamics/janaf")
```

## Data treatment


Because of different conventions of reference state, it can be tricky to figure how to use JANAF data to check CALPHAD parameters. Below we make a try to find the required transformations. External data for $Si_3N_4$ comes from [Ma (2005)](https://doi.org/10.1016/j.calphad.2003.12.005).

```python
def get_hser(db, Tr=298.15):
    """ Get formation enthalpy at reference temperature. """
    return float(1000*db.loc[db["T(K)"] == Tr]["delta-f H"].iloc[0])


def load_fix_janaf_for_calphad(fname):
    """ Load file and make transformations. """
    db = pd.read_csv(fname, sep=",")

    # Some missing data on top of some files, fill with zero.
    db.fillna(0.0, inplace=True)

    # In JANAF the reference enthalpy is 298.15K, while for CALPHAD
    # we must use 0K to retrieve a non-zero enthalpy at 298.15K.
    # Below we perform this shift to ensure compliance.
    db["H"] = 1000*(db["H-H(Tr)"] - db["H-H(Tr)"].iloc[0])

    # To get GHSER as in CALPHAD we add a column as below. Notice
    # that because of JANAF definition of H(Tr) we need to add the
    # formation enthalpy to get the CALPHAD compatible value.
    db["GHSER"] = -1*db["-[G-H(Tr)]/T"]*db["T(K)"]
    db["GHSER"] += get_hser(db)

    # Get data in range 298-2000K only for what comes next.
    db = db.loc[(db["T(K)"] > 298) & (db["T(K)"] < 2000)]

    return pd.DataFrame(db)
```

Next we proceed with loading and inspecting the head of JANAF tables.

```python
tab_nn2si0 = load_fix_janaf_for_calphad(DATA_DIR / "n2.tab")
tab_nn2si0.head()
```

```python
tab_nn0si1 = load_fix_janaf_for_calphad(DATA_DIR / "si1.tab")
tab_nn0si1.head()
```

```python
tab_nn4si3 = load_fix_janaf_for_calphad(DATA_DIR / "si3n4.tab")
tab_nn4si3.head()
```

The value of $G-H(SER)$ has been fixed in JANAF data and must now be compatible with the polynomial by Ma (2003).

Because Ma (2003) reports Gibbs energy per mole of atoms and not per CEF unit formula, we divide the values by 7 (3 Si + 4 N).

```python
T = np.linspace(300, 1600, 1000)

T_1 = T
T_2 = tab_nn4si3["T(K)"]

GSI3N4_1 = -788513.009+733.225*T-121.79*T*np.log(T)\
    -0.02065*T**2+1666886.4*T**(-1)+6.9938E-7*T**3
GSI3N4_2 = tab_nn4si3["GHSER"]

GSI3N4_1 /= 7
GSI3N4_2 /= 7
```

Below we reproduce partially Fig. 6 from Ma (2003).

```python
plt.close("all")
plt.style.use("bmh")
plt.figure(figsize=(8, 6))
plt.plot(T_1, GSI3N4_1/1000, "-", label="G($Si_3N_4$) [Ma (2003)]")
plt.plot(T_2, GSI3N4_2/1000, "o", label="G($Si_3N_4$) [JANAF]")
plt.xlabel("Temperature [K]")
plt.ylabel("Gibbs Energy [kJ/mol]")
plt.xlim(200, 1700)
plt.grid(linestyle=":")
plt.legend(loc="best")
plt.tight_layout()
```

## Application to $MnSiN_2$


**WORK IN PROGRESS**

```python
GHSERMN = np.piecewise(T, [T < 1519.0, T >= 1519.0], [
    lambda T: -8.115280e+03+1.300590e+02*T-2.34582e+01*T*np.log(T)\
        -7.347680e-03*T**2+6.98271e+04*T**(-1),
    lambda T: -2.873341e+04+3.122648e+02*T-4.80000e+01*T*np.log(T)\
        +1.6568470+30*T**(-9)
])

GHSERNN = np.piecewise(T, [T < 950.00, (950.00 <= T) & (T < 3350.00), T >= 3350.00], [
    lambda T: -3.750675e+03-9.45425e+00*T-1.27819e+01*T*np.log(T)\
        -1.76686e-03*T**2+2.680735e-09*T**3-3.237400e+04*T**(-1),
    lambda T: -7.358850e+03+1.72003e+01*T-1.63699e+01*T*np.log(T)\
        -6.51070e-04*T**2+3.009700e-08*T**3+5.630700e+05*T**(-1),
    lambda T: -1.639280e+04+5.02600e+01*T-2.04695e+01*T*np.log(T)\
        +2.39754e-04*T**2-8.333100e-09*T**3+4.596375e+06*T**(-1)
])

GHSERSI = np.piecewise(T, [T < 1687.0, T >= 1687.0], [
    lambda T: -8.162609e+03+1.37236859e+02*T-2.28317533e+01*T*np.log(T)\
        -1.912904e-03*T**2-3.552E-9*T**3+1.76667e+05*T**(-1),
    lambda T: -9.457642e+03+1.67281367e+02*T-2.71960000e+01*T*np.log(T)\
        -4.203700e+30*T**(-9)
])

# HSERMN = 4.995696E+03
# HSERSI = 4.335000E+03
# HSERNN = 3.217000E+03
# (0.25*HSERMN+0.25*HSERSI+0.5*HSERNN)
hypothesis_scale = 10

G_sum_xk_Gk = 0.25*GHSERMN+0.25*GHSERSI+0.5*GHSERNN
G_form_MNSIN2_MC = -86500.0+43.0*T
G_form_MNSIN2_LI = np.piecewise(T, [T < 980.0, T >= 980.0], [
    lambda T: -994489.0 + 454.0*T,
    lambda T: -970238.0 + 429.0*T
]) / hypothesis_scale

G_MNSIN2_MC = G_sum_xk_Gk + G_form_MNSIN2_MC
G_MNSIN2_LI = G_sum_xk_Gk + G_form_MNSIN2_LI
```

```python
plt.close("all")
plt.style.use("bmh")
plt.figure(figsize=(8, 6))
plt.plot(T, G_MNSIN2_MC/1000, "-", label="G($MnSiN_2$) [Matcalc]")
plt.plot(T, G_MNSIN2_LI/1000, "-", label="G($MnSiN_2$) [Li (2022)]")
plt.xlabel("Temperature [K]")
plt.ylabel("Gibbs Energy [kJ/mol]")
plt.xlim(200, 1700)
plt.grid(linestyle=":")
plt.legend(loc="best")
plt.tight_layout()
```
