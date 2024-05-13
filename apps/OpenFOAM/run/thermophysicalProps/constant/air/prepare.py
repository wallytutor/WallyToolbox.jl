# -*- coding: utf-8 -*-
""" Used for preparing thermophysicalProperties-2. """
from sklearn.preprocessing import MinMaxScaler
import cantera as ct
import matplotlib.pyplot as plt
import numpy as np

FORMAT = """\
    (
        {0:+.12e}
        {1:+.12e}
        {2:+.12e}
        {3:+.12e}
        {4:+.12e}
        {5:+.12e}
        {6:+.12e}
        {7:+.12e}
    );
"""

T = np.linspace(100, 3000, 1000)
air = ct.Solution("air.yaml")
sol = ct.SolutionArray(air, shape=T.shape)
sol.TP = T, None

cp = sol.cp_mass
mu = sol.viscosity
kt = sol.thermal_conductivity

cp_poly = np.polyfit(T, cp, deg=7)
mu_poly = np.polyfit(T, mu, deg=7)
kt_poly = np.polyfit(T, kt, deg=7)

print(FORMAT.format(*cp_poly[::-1]))
print(FORMAT.format(*mu_poly[::-1]))
print(FORMAT.format(*kt_poly[::-1]))


def addplot(axk, n, u, p, name, loc=2):
    t = T[T >= 300]
    u = u[T >= 300]
    v = np.polyval(p, t)
    e = 100 * (u - v) / u

    scaler = MinMaxScaler()
    scaler.fit(u.reshape(-1, 1))
    u = scaler.transform(u.reshape(-1, 1))
    v = scaler.transform(v.reshape(-1, 1))

    axk[0].plot(t, u, "k:", label="Cantera")
    axk[0].scatter(t[::n], v[::n], c="r", label="Polynomial")
    axk[0].grid(linestyle=":")
    axk[0].legend(loc=loc)
    axk[0].set_ylabel(f"Property {name}")

    axk[1].plot(t, e, "k:")
    axk[1].grid(linestyle=":")
    axk[1].set_ylabel("Relative Error [%]")


plt.close("all")
plt.style.use("seaborn-white")
fig, ax = plt.subplots(3, 2, sharex=True)
addplot(ax[0], n=25, u=cp, p=cp_poly, name="cp")
addplot(ax[1], n=25, u=mu, p=mu_poly, name="mu")
addplot(ax[2], n=25, u=kt, p=kt_poly, name="kt")
plt.tight_layout()
plt.show()
