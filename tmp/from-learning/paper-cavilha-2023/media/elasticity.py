# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt
import pandas as pd

font = "Times New Roman"

df = pd.read_csv("elasticity.csv", skipinitialspace=True)

x = df["SH"].to_numpy()
yval = df["E (GPa)"].to_numpy()
yerr = yval * df["Erro"].to_numpy()
mval = df["GibAsh (GPa)"].to_numpy()

plt.close("all")
plt.style.use("seaborn-white")
fig, ax = plt.subplots(figsize=(6, 5))
ax.scatter(x, yval, c="k", marker="s", label="Measurement")
ax.scatter(x, mval, c="r", marker="D", label="Gibson-Ashby Model")
ax.errorbar(x, yval, yerr=yerr, color="k", capsize=6, ls="none")
ax.grid(linestyle=":")
ax.set_xlabel("Space Holder [%vol.]", fontname=font, fontsize=16)
ax.set_ylabel("Elastic Modulus [GPa]", fontname=font, fontsize=16)
legend = ax.legend(loc=1, frameon=True)

plt.setp(legend.texts, fontname=font, fontsize=14)

for tick in ax.get_xticklabels():
    tick.set_fontname(font)
    tick.set_fontsize(14)

for tick in ax.get_yticklabels():
    tick.set_fontname(font)
    tick.set_fontsize(14)

fig.tight_layout()
fig.savefig("elasticity.png", dpi=300)
