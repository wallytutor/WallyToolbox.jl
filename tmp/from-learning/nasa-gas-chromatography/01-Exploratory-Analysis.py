# -*- coding: utf-8 -*-
from functools import wraps
from pathlib import Path
from zipfile import ZipFile
from scipy.integrate import cumtrapz
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


DIR_DATA = Path("data")
DIR_ORIG = DIR_DATA / "orig"
DIR_PROC = DIR_DATA / "proc"

N_COMP = 9
""" Number of (known) classes of compounds.  """

M_PREC = 2
""" Number of digits in mass spectra. """


def holdpoint(func=None):
    """ Capture user input and do nothing. """
    match func:
        case None:
            input("\nPress anything to continue...")
            return
        case _:
            @wraps(func)
            def wrapped(*args, **kwargs):
                val = func(*args, **kwargs)
                holdpoint(func=None)
                return val
            return wrapped


@holdpoint
def load_all_data():
    """ Concentrate all data loading here. """
    print("\nLoading all datasets...")
    submission = pd.read_csv(DIR_ORIG / "submission_format.csv")
    train_labels = pd.read_csv(DIR_ORIG / "phase1/train_labels.csv")
    train_zipped = ZipFile(DIR_ORIG / "phase1/train_features.zip")
    print("\nAll data was loaded!")
    return submission, train_labels, train_zipped


@holdpoint
def check_heads(submission, train_labels):
    """ Confirm label ordering in submission and training sets. """
    print("\nSubmission\n")
    print(submission.head().T.to_markdown())

    print("\nTraining  \n")
    print(train_labels.head().T.to_markdown())

    cols1 = train_labels.columns[1:]
    cols2 = submission.columns[1:]
    order_match = all(cols1 == cols2)

    print(f"Submission/labels are ordered in the same way: {order_match}")


@holdpoint
def get_counted_compound_samples(train_labels):
    """ Get samples with a single compound for mapping. """
    train_labels["n_comp"] = train_labels.iloc[:, 1:].sum(axis=1)
    labels_hist = train_labels.n_comp.value_counts()

    print("\nHistogram of compounds per sample\n")
    print(labels_hist.sort_index().to_markdown())

    def get_ids(k):
        selection = train_labels.n_comp == k
        return train_labels.loc[selection].sample_id.to_list()

    no_sub_samples = {k: get_ids(k) for k in range(N_COMP)}
    del train_labels["n_comp"]

    return no_sub_samples


@holdpoint
def get_samples_per_counted_compounds(
    no_sub_samples, train_labels, train_zipped):
    """ Filter sets per number of compounds present. """
    gcms_data = {}

    for count, sample_ids in no_sub_samples.items():
        if not sample_ids:
            print(f"No samples with {count} compounds")
            continue

        print(f"Getting data for {count} compounds")
        gcms_data[count] = {}

        for sid in sample_ids:
            selected = (train_labels.sample_id == sid)
            labels = train_labels.loc[selected].iloc[0, 1:].to_list()

            fname = f"train_features/{sid}.csv"
            with train_zipped.open(fname) as fp:
                gcms_data[count][sid] = {
                    "data": pd.read_csv(fp),
                    "labels": labels
                }
            
    return gcms_data





def workflow():
    """ TODO: wrap-up here once ready. """
    pass


if __name__ == "__main__":
    submission, train_labels, train_zipped = load_all_data()

    check_heads(submission, train_labels)

    no_sub_samples = get_counted_compound_samples(train_labels)

    gcms_data = get_samples_per_counted_compounds(
        no_sub_samples, train_labels, train_zipped)








# def make_features(df):
#     """ """
#     # Multiplier to get integer masses later.
#     mass_scale = pow(10, M_PREC)

#     # Let's not mess with the original frame.
#     dd = df.copy()

#     # Reduce number of masses assuming detector tolerance.
#     dd["mass"] = (dd.mass.round(M_PREC) * mass_scale).astype("int64")

#     # Ensure max intensity is unity.
#     dd.intensity /= dd.intensity.max()
#     dd.intensity = np.clip(dd.intensity, 0.0, 1.0)

#     grouped = dd.groupby("time").agg(["mean", "std"])
#     grouped.columns = grouped.columns.map('|'.join).str.strip('|')

#     return grouped


# for key, entry in gcms_data[1].items():
#     df = entry["data"]
#     label = "".join(f"{v}" for v in entry["labels"])

#     plt.close("all")
#     plt.style.use("seaborn-white")
#     plt.plot(df["intensity"])
#     plt.grid(linestyle=":")
#     plt.tight_layout()
#     plt.savefig(DIR_PROC / f"phase1/pic_{label}_{key}", dpi=200)




# # Get mass spectra signature of data.
# mass_sign_dfs = [[get_mass_signature(df) for df in group]
#                  for group in reduced_mass_dfs]


# # Maximum number of spectra to plot (avoid overflow).
# max_lines = 10

# # Check signature of pure compounds.
# for cid_group, cid_list in enumerate(mass_sign_dfs):
#     print(f"Processing cid_group = {cid_group}")
#     if not len(cid_list):
#         print(f"cid_group {cid_group} is empty")
#         continue

#     plt.close("all")
#     plt.style.use("seaborn-white")

#     fig, ax = plt.subplots()

#     for k, df in enumerate(cid_list):
#         if k > max_lines:
#             break

#         x = df.index.to_numpy()
#         y = df.intensity.to_numpy()
#         ax.plot(x, y + 0.5 * k)

#     ax.grid(linestyle=":")
#     fig.tight_layout()

#     plt.savefig(DIR_PROC / f"phase1/pic{cid_group}", dpi=200)
