# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt
import pandas as pd

font = "Times New Roman"

df = pd.read_csv("shrinkage.csv", skipinitialspace=True)

x = df["SH"].to_numpy()
yval = df["Vol-Change [%]"].to_numpy()
yerr = df["Error [%]"].to_numpy()

plt.close("all")
plt.style.use("seaborn-white")
fig, ax = plt.subplots(figsize=(6, 5))
ax.scatter(x, yval, c="k")
ax.errorbar(x, yval, yerr=yerr, color="k", capsize=6, ls="none")
ax.grid(linestyle=":")
ax.set_xlabel("Space Holder [%vol.]", fontname=font, fontsize=16)
ax.set_ylabel("Shrinkage [%vol.]", fontname=font, fontsize=16)

for tick in ax.get_xticklabels():
    tick.set_fontname(font)
    tick.set_fontsize(14)

for tick in ax.get_yticklabels():
    tick.set_fontname(font)
    tick.set_fontsize(14)

fig.tight_layout()
fig.savefig("shrinkage.png", dpi=300)
