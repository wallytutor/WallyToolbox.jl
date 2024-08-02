# -*- coding: utf-8 -*-
from itertools import product
from pathlib import Path
from typing import Optional
from networkx import DiGraph
from networkx import draw
from scipy.spatial.distance import euclidean
from skimage.filters import gaussian
from skimage.filters import threshold_otsu
from skimage.io import imread
from skimage.measure import find_contours
from skimage.measure import label
from skimage.measure import regionprops
from skimage.measure import regionprops_table
import json
import re
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import scipy.stats as st

plt.rcParams["font.family"] = "Times New Roman"

ROOT_PATH = Path(__file__).resolve().parent
""" Path to this file's parent directory. """

PROPERTIES = (
    "area",
    "axis_major_length",
    "axis_minor_length",
    "eccentricity",
    "equivalent_diameter_area",
    "feret_diameter_max",
    "perimeter",
    "perimeter_crofton",
    "centroid",
    "orientation"
)
""" Selected properties for tabulation of zones. """

LEGEND = {
    "area": "Pore mean area [µm²]",
    "area_ratio": "Ratio of area to bounding box [-]",
    "area_rect": "Area of bounding box [µm²]",
    "axis_major_length": "Pore mean major axis [µm]",
    "axis_minor_length": "Pore mean minor axis [µm]",
    "eccentricity": "Pore mean eccentricity [-]",
    "equivalent_diameter_area": "Equivalent diameter [µm]",
    "feret_diameter_max": "Maximum Feret diameter [µm]",
    "perimeter": "Pore mean perimeter [µm]",
    "perimeter_crofton": "Pore mean Crofton perimeter [µm]",
}
""" Selected properties for tabulation of zones. """


class WorkflowPorosity:
    """ Manage quantification of porosity in samples. """
    def __init__(self, all_files, force=False):
        print("\n\nStarting `WorflowPorosity`")
        path_porosity = ROOT_PATH / "media/outputs/porosity"
        path_porosity.mkdir(exist_ok=True, parents=True)

        # To be filled in `__workflow`.
        self._bias = []
        self._porosity = []

        for k, (file_n, file_m, stem) in enumerate(all_files):
            results = [
                path_porosity / f"porosity-{stem}-01-compare.png",
                path_porosity / f"porosity-{stem}-02-publish.png",
                path_porosity / f"porosity-{stem}-03-check.png",
            ]

            if all(r.exists() for r in results) and not force:
                print(f"Already treated ({k:03d}) {stem}")
                continue
            
            print(f"Processing ({k:03d}) {stem}")
            figs = self.__workflow(file_n, file_m, sigma=15)
            figs[0].savefig(results[0], dpi=300)
            figs[1].savefig(results[1], dpi=300)
            figs[2].savefig(results[2], dpi=300)

        df = pd.DataFrame({
            "stem": [s[2] for s in all_files],
            "bias": self._bias,
            "porosity": self._porosity
        })
        df.to_csv(path_porosity / "results.csv", index=False)
        print(df.describe().T)

    def __workflow(self, file_n, file_m, sigma):
        """ Compare raw and patched images in terms of porosity level. """
        img_n, _, cont_n, porosity_n = _segment(file_n, sigma)
        img_m, _, cont_m, porosity_m = _segment(file_m, sigma)
        
        def add_subplot(ax, img, contours, porosity, name=None, lw=1):
            """ Create same format of display for each image. """
            if name is not None:
                ax.set_title(f"Porosity of {porosity:.1f}% ({name})")
            else:
                ax.set_title(f"Porosity of {porosity:.1f}%")

            ax.imshow(img, cmap="gray")
            
            for c in contours:
                ax.plot(c[:, 1], c[:, 0], color="r", linewidth=lw)
            
            ax.axis("off")
            
        self._bias.append(porosity_n - porosity_m)
        self._porosity.append(porosity_m)

        plt.close("all")
        fig1, (ax_n, ax_m) = plt.subplots(1, 2, figsize=(12, 5))
        add_subplot(ax_n, img_n, cont_n, porosity_n, name="normal")
        add_subplot(ax_m, img_m, cont_m, porosity_m, name="manual")
        fig1.tight_layout()

        plt.close("all")
        fig2, ax_n = plt.subplots(1, 1, figsize=(6, 5))
        add_subplot(ax_n, img_n, cont_m, porosity_n, lw=2)
        fig2.tight_layout()

        # Add a third plot to porosity analysis, using the same raw (normal)
        # image in both subplots, but on the right side display the contours
        # foundcwith manually edited images.
        plt.close("all")
        fig3, (ax_n, ax_m) = plt.subplots(1, 2, figsize=(12, 5))
        add_subplot(ax_n, img_n, cont_n, porosity_n, name="normal")
        add_subplot(ax_m, img_n, cont_m, porosity_m, name="manual")
        fig3.tight_layout()

        return fig1, fig2, fig3


class WorkflowRegions:
    """ Manage quantification of region properties in samples. """
    def __init__(self,
            all_files,
            sigma=10,
            cutoff=100,
            force=False
        ):
        print("\n\nStarting `WorflowRegions`")
        path_regions = ROOT_PATH / "media/outputs/regions"
        path_regions.mkdir(exist_ok=True, parents=True)

        # To be fed in `__workflow`.
        # self._norms = {}
        # self._walls = {}
        dists = {}

        for k, (file_n, file_m, stem) in enumerate(all_files):
            results = [
                path_regions / f"regions-{stem}-compare.png",
                path_regions / f"regions-{stem}-publish.png",
                path_regions / f"regions-{stem}-check.png",
                # path_regions / f"regions-{stem}-graph.png",
                # path_regions / f"regions-{stem}-dists.png",
                path_regions / f"regions-{stem}.csv"
            ]
 
            if all(r.exists() for r in results) and not force:
                print(f"Already treated ({k:03d}) {stem}")
                continue
            
            print(f"Processing ({k}) {stem}")
            rets = self.__workflow(file_n, file_m, stem, sigma, cutoff)
            figs, df, dists[stem] = rets

            figs[0].savefig(results[0], dpi=300)
            figs[1].savefig(results[1], dpi=300)
            figs[2].savefig(results[2], dpi=300)
            # figs[2].savefig(results[2], dpi=300)
            # figs[3].savefig(results[3], dpi=300)
            df.to_csv(results[3], index=False)

        with open(path_regions / "distances.json", "w") as fp:
            json.dump(dists, fp)

        # fig = self.__get_dists_publ_fig(self._norms, self._walls,
        #                                 calibration, unit="µm")

    def __exclude_borders(self, img, regions):
        """ Filter regions close to the borders of image. """
        new_regions = []
        h, w = img.shape
    
        for props in regions:
            minr, minc, maxr, maxc = props.bbox
            lower_bounds = minr > 0 and minc > 0
            upper_bounds = maxr < h and maxc < w
            
            if lower_bounds and upper_bounds:
                new_regions.append(props)

        return new_regions

    def __compute_row_wise_data(self, img, debug=False):
        """ Compute mean length of white regions over rows.
        
        Note: pores are expected to be zero-valued.

        Parameters
        ----------
        img : np.ndarray
            Mask image of detected regions.

        Returns
        -------
        List[float]
            Mean length of white pixel regions in each row.
        """
        def color_swap(d):
            """ Get black/white regions swap points and split array. """
            return np.split(d, 1 + np.where(abs(np.diff(d)) != 0.0)[0])

        def get_all_segments(d):
            """ Get length, start index, and values of segments. """
            segments = color_swap(d)
            data = []

            for k, s in enumerate(segments):
                index = (0 if len(data) == 0 else sum(data[k-1][:2]))
                data.append((index, len(s), s))

            return data

        def get_valid_white_segments(d):
            """ Get length of white segments over rows. """
            all_segments = get_all_segments(d)
            last = len(all_segments) - 1
            keep = []

            for k, s in enumerate(all_segments):
                # Not keeping black segments.
                if sum(s[2]) <= 0.0:
                    continue

                # Do not keep white on extremities because we are
                # unaware of the distance to the next black (same
                # logic used with bounding boxes extraction).
                if k in [0, last]:
                    continue

                keep.append(s[:2])

            return keep

        # Convert image into float for computations.
        tmp_data_s = img.astype("float")
        tmp_data_t = tmp_data_s.T

        # Get row-/col-wise data.
        row_data = [get_valid_white_segments(tmp_data_s[row])
                    for row in range(tmp_data_s.shape[0])]
        col_data = [get_valid_white_segments(tmp_data_t[row])
                    for row in range(tmp_data_t.shape[0])]
        
        if debug:
            validate = range(100, 1800+1, 100)
            vdata = [(k, row_data[k]) for k in validate]

            plt.close("all")
            plt.imshow(img, cmap="gray")

            for row, data in vdata:
                for (start, length) in data:
                    x = range(start, start + length)
                    y = np.zeros(length) + row
                    plt.plot(x, y, c="r")

            plt.tight_layout()
            plt.show()

        # Get only the lengths accross all rows/columns.
        all_data = row_data + col_data
        return [r[1] for data in all_data for r in data]
    
    def __draw_regions(self, regions, ax):
        """ Draw regions over image on given axis. """
        for props in regions:
            y0, x0 = props.centroid
            minr, minc, maxr, maxc = props.bbox
            orientation = props.orientation

            x1 = x0 + np.cos(orientation) * 0.5 * props.axis_minor_length
            y1 = y0 - np.sin(orientation) * 0.5 * props.axis_minor_length
            x2 = x0 - np.sin(orientation) * 0.5 * props.axis_major_length
            y2 = y0 - np.cos(orientation) * 0.5 * props.axis_major_length

            ax.plot((x0, x1), (y0, y1), "-r", linewidth=1)
            ax.plot((x0, x2), (y0, y2), "-r", linewidth=1)
            ax.plot(x0, y0, ".g", markersize=10)

            bx = (minc, maxc, maxc, minc, minc)
            by = (minr, minr, maxr, maxr, minr)
            ax.plot(bx, by, "-b", linewidth=1)
                
    def __workflow(self, file_n, file_m, stem, sigma, cutoff, pct=[10, 100]):
        """ Segment image and retrieve region properties. """
        img0 = imread(file_n, as_gray=True)

        img1, img2, contours, _ = _segment(file_m, sigma)
        label_img = label(1 - img2)
        regions = regionprops(label_img)

        # Ensure (if not already) regions are sorted by area.
        regions = sorted(regions, key=lambda r: r.area)

        # Get percentile confidence interval.
        sm, lg = np.percentile([r.area for r in regions], pct)

        def func_cutoff(r):
            """ Function to eliminate extreme regions. """
            return (sm < r.area < lg) and (r.area > cutoff)

        # Remove those regions outside the confidence interval.
        regions = list(filter(func_cutoff, regions))

        # Remove regions crossing borders of image.
        regions = self.__exclude_borders(img0, regions)

        # Accumulate data for computing pore wall statistics.
        dists = self.__compute_row_wise_data(img2)

        # Generate graph of connected regions.
        # G, pos, norms, walls = self.__create_distance_graph(regions)
        # self._norms[stem] = norms
        # self._walls[stem] = walls

        fig1 = self.__get_props_comp_fig(img1, contours, regions)
        fig2 = self.__get_props_publ_fig(img0, contours, regions)
        fig3 = self.__get_props_comp_fig(img0, contours, regions)
        # fig3 = self.__get_graph_publ_fig(img0, contours, G, pos)
        # fig4 = self.__get_dists_publ_fig(norms, walls, 1.0)
        # figs = (fig1, fig2, fig3, fig4)
        figs = (fig1, fig2, fig3)

        table = regionprops_table(label_img, properties=PROPERTIES)
        table = pd.DataFrame(table)

        return figs, table, dists

    def __get_axes(self, img):
        """ Retrieve properly dimensioned axes for figure plot. """
        w = 8
        h = w * (img.shape[0] / img.shape[1])
        
        fig = plt.figure(frameon=False)
        fig.set_size_inches(w, h)

        ax = plt.Axes(fig, [0.0, 0.0, 1.0, 1.0])
        ax.set_axis_off()

        fig.add_axes(ax)

        return fig, ax

    def __get_props_comp_fig(self, img, contours, regions):
        """ Get figure to compare quality of image properties assignment. """
        plt.close("all")
        fig, (ax_a, ax_b) = plt.subplots(1, 2, figsize=(12, 5))
        ax_a.imshow(img, cmap="gray")
        ax_b.imshow(img, cmap="gray")
        
        for c in contours:
            ax_a.plot(c[:, 1], c[:, 0], color="r", linewidth=1)
        
        ax_a.axis("off")

        self.__draw_regions(regions, ax_b)
        ax_b.axis("off")

        fig.tight_layout()
        return fig

    def __get_props_publ_fig(self, img, contours, regions, use_cont=False):
        """ Get figure to publish of image properties assignment. """
        plt.close("all")
        fig, ax = self.__get_axes(img)
        ax.imshow(img, cmap="gray")
        
        if use_cont:
            for c in contours:
                ax.plot(c[:, 1], c[:, 0], color="y", linewidth=1)
        
        self.__draw_regions(regions, ax)
        return fig
    
    ##########################################################################
    # Unused graph method still in development for future applications.
    ##########################################################################

    def __get_graph_publ_fig(self, img, contours, G, pos):
        """ Generate graph of nearest neightbors."""
        plt.close("all")
        fig, ax = self.__get_axes(img)
        ax.imshow(img, cmap="gray", aspect="auto")

        for c in contours:
            ax.plot(c[:, 1], c[:, 0], color="y", linewidth=1)

        draw(G, pos=pos, ax=ax, arrowstyle="-", node_size=20,
             node_color="r", edge_color="r", with_labels=True)
        return fig

    def __get_dists_publ_fig(self, norms, walls, calibration,
                             unit="pixels", bins=20):
        """ Plot distributions of distances and wall thicknesses. """
        def add_axes(ax, vec, xlabel):
            """ Add subplot to figure. """
            # TODO replace std by np.percentile(vec, [0.025, 0.975])
            vec = np.array(vec) * calibration
            mu = np.mean(vec)
            std = np.std(vec)

            ax.hist(vec, bins=bins, alpha=0.6, density=True,
                    label=f"Distances ({mu:.1f} ± {std:.1f})")
            ax.axvline(mu+0*std, color="k", linestyle=":")
            # ax.axvline(mu+1*std, color="k", linestyle=":")
            # ax.axvline(mu-1*std, color="k", linestyle=":")
            ax.grid(linestyle=':')

            ax.set_xlabel(xlabel)
            ax.set_ylabel("Probability density")
            ax.legend(loc=1)

        plt.close("all")
        plt.style.use("seaborn-white")
        fig, ax = plt.subplots(1, 2, figsize=(12, 5))
        add_axes(ax[0], norms, f"Pore distance [{unit}]")
        add_axes(ax[1], walls, f"Wall thickness [{unit}]")
        fig.tight_layout()
        return fig

    def __create_distance_graph(self, regions, d_max=500, no_max=4):
        """ Create directed graph of coordinate porosity in region. """
        # TODO: compute mean-free-path between N-pores, coordination 8.

        G = DiGraph()
        pos = {n.label: n.centroid[::-1] for n in regions}
        radius = {n.label: n.equivalent_diameter_area/2 for n in regions}

        for pa, pb in product(regions, regions):
            # Exclude self loops.
            if (la := pa.label) == (lb := pb.label):
                continue

            # Get (x, y) pairs instead of (y, x).
            ca = pa.centroid[::-1]
            cb = pb.centroid[::-1]

            # Compute distances and check agains d_max.
            if abs(ca[1] - cb[1]) > d_max or abs(ca[0] - cb[0]) > d_max:
                continue

            # Compute node properties.
            # Subtract equivalent radii to get wall thickness.
            ra = pa.equivalent_diameter_area / 2
            rb = pb.equivalent_diameter_area / 2
            norm = euclidean(ca, cb)
            wall = norm - (ra + rb)
            G.add_edge(la, lb, norm=norm, wall=wall)

        to_remove = []
        # https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
        # https://en.wikipedia.org/wiki/Area_of_a_triangle#Using_coordinates
        # na = 26
        # nb = 27
        # nc = 28

        # xa, ya = pos[na]
        # xb, yb = pos[nb]
        # xc, yc = pos[nc]

        # dx = xb - xa
        # dy = yb - ya

        # dab = euclidean([xa, ya], [xb, yb])
        # dac = euclidean([xa, ya], [xc, yc])
        # dbc = euclidean([xb, yb], [xc, yc])

        # drc = dx * (yc - ya) - dy * (xc - xa)
        # drc = dx * (yb - yc) - dy * (xb - xc)
        # drc = abs(drc) / dab
        frac = 0.5

        for na, nb in G.edges():
            xa, ya = pos[na]
            xb, yb = pos[nb]
            
            dx = xb - xa
            dy = yb - ya
            dab = euclidean([xa, ya], [xb, yb])

            for nc, (xc, yc) in pos.items():
                if nc == na or nc == nb:
                    continue

                if (na, nb) in to_remove:
                    continue

                dac = euclidean([xa, ya], [xc, yc])
                dbc = euclidean([xb, yb], [xc, yc])

                if (dac > dab) and (dbc > dac):
                    continue

                drc = dx * (yb - yc) - dy * (xb - xc)
                drc = abs(drc) / dab

                if drc < radius[nc]:
                    to_remove.append((na, nb))

        G.remove_edges_from(to_remove)
        # from IPython import embed; embed()

        def nearest_neighbors(node):
            """ Get `num` nearest neighbors of `node` in `G`. """
            # Access neighbor and "norm" property of edge.
            v = [(k, v["norm"]) for k, v in G[node].items()]

            # Keep only the `no_max` closest neighbors.
            return sorted(v, key=lambda p: p[1])[:no_max]

        # Nearest neighbors of all nodes (node: [other, norm]).
        distances = {n: nearest_neighbors(n) for n in G.nodes}

        # Remove edges not kept in distance dictionary.
        for node, dists in distances.items():
            others = [v[0] for v in dists]
            successors = list(G.successors(node))

            for neighbor in successors:
                if neighbor not in others:
                    G.remove_edge(node, neighbor)

        # Process distance for compat with histogram plotting.
        norms = []
        walls = []
    
        for na, nb in G.edges():
            edge = G[na][nb]
            norms.append(edge["norm"])

            if (wall := edge["wall"]) > 0:
                walls.append(wall)
    
        return G, pos, norms, walls


class WorkflowPostprocessing:
    """ Performs consolidation of results at different conditions.
    
    This class is responsible py the consolidation of experimental
    results from different amounts of placeholders. A single call
    to the constructor will manage the whole workflow, the created
    object has no internal state and need not to be stored.

    Parameters
    ----------
    post_files : dict[Number, str | Path]
        Dictionary with keys as the amount of placeholders used
        in sample synthesis and values as the path to results file
        with all measurements performed in images of this class.
    table_name : str | Path
        Path to file with wall distance summary data.
    cutoff : Optional[int] = 100
        Cut-off size for small pores to be eliminated.
    """
    def __init__(self, post_files, table_name, cutoff=10) -> None:
        print("\n\nStarting `WorflowPostprocessing`")

        # Create dictionary of tables to post-process.
        dfs = {s: self.__table_post(f, cutoff) for s, f in post_files.items()}

        # Plots are in terms of keys of dictionary as coordinates.
        x = list(dfs.keys())

        # Retrieve tables of summarized data.
        tables = [df.describe().T for df in dfs.values()]

        # Get names of numerical columns.
        columns = sorted(tables[0].index)
    
        # Make quantification and plot all columns.
        for n, c in enumerate(columns):
            print(f"Working on ({n}/{len(columns)}) {c}")

            pairs = [self.__get_pair(df, c) for df in tables]
            yval, yerr = np.array(pairs).T
            saveas = ROOT_PATH / f"media/outputs/{c}-effect.png"
            self.__plot(x, yval, yerr, LEGEND[c], saveas)

            saveas = ROOT_PATH / f"media/outputs/{c}-dist.png"
            self.__hist(dfs, c, LEGEND[c], saveas)

        # Read wall thicness summary for plotting.
        df = pd.read_csv(table_name)

        # Spaceholder content as x-axis again.
        x = df["SH"].to_numpy()

        mean = df["mean"].to_numpy()
        median = df["median"].to_numpy()
        mode = df["mode"].to_numpy()
        # merr = 1.96 * df["std"] / np.sqrt(df["size"])
        # merr = np.array(list(zip(df["p025"], df["p975"]))).T

        saveas = ROOT_PATH / "media/outputs/wall_thickness-effect.png"

        plt.close("all")
        plt.style.use("seaborn-white")
        fig = plt.figure(figsize=(6, 5))
        plt.plot(x, mean,   "k:", label="_none_")
        plt.plot(x, median, "k:", label="_none_")
        plt.plot(x, mode,   "k:", label="_none_")
        plt.scatter(x, mean,   c="k", marker="o", label="Mean")
        plt.scatter(x, median, c="k", marker="v", label="Median")
        plt.scatter(x, mode,   c="k", marker="s", label="Mode")
        plt.grid(linestyle=":")
        plt.xlabel("Space Holder [%vol.]")
        plt.ylabel("Wall thickness (estimator) [µm]")
        plt.legend(loc=1)
        fig.tight_layout()
        fig.savefig(saveas, dpi=300)

    def __get_pair(self, df, c):
        """ Compose pair for value and interval computation. """
        yval = df.at[c, "mean"]
        yerr = self.__stderr(df.at[c, "std"], df.at[c, "count"])
        return (yval, yerr)

    def __stderr(self, std, N, m=1.96):
        """ Standard error computation at given confidence interval. """
        return m * std / np.sqrt(N)

    def __hist(self, dfs, col, label, saveas, bins=20):
        """ Generate histograms of given variable. """
        plt.close("all")
        plt.style.use("seaborn-white")
        fig = plt.figure(figsize=(6, 5))

        for sh, df in dfs.items():
            x = df[col].to_numpy()
            plt.hist(x, bins=bins, alpha=1.0, cumulative=True,
                     density=True, histtype="step",
                     label=f"{sh:.0f}%vol.")

        plt.grid(linestyle=":")
        plt.legend(loc="best")

        plt.xlabel(label)
        plt.ylabel("Probability density")
        
        fig.tight_layout()
        fig.savefig(saveas, dpi=300)

    def __plot(self, x, yval, yerr, label, saveas):
        """ Create and save plot of provided region property. """
        font = "Times New Roman"

        plt.close("all")
        plt.style.use("seaborn-white")
        fig, ax = plt.subplots(figsize=(6, 5))

        ax.scatter(x, yval, c="k")
        ax.errorbar(x, yval, yerr=yerr,
                    color="k", 
                    capsize=6,
                    ls="none")
        ax.grid(linestyle=":")
        
        ax.set_xlabel("Space Holder [%vol.]", fontname=font, fontsize=16)
        ax.set_ylabel(label, fontname=font, fontsize=16)
        
        for tick in ax.get_xticklabels():
            tick.set_fontname(font)
            tick.set_fontsize(14)

        for tick in ax.get_yticklabels():
            tick.set_fontname(font)
            tick.set_fontsize(14)

        fig.tight_layout()
        fig.savefig(saveas, dpi=300)

    def __table_post(self, fname, cutoff):
        """ Provide standard results postprocessing. """
        df = pd.read_csv(fname)

        # Remove small spots not removed by cutoff.
        df = df[df.area > cutoff]

        # Remove *line-like* objects.
        df = df[df.eccentricity < 1]

        # Area of rectangle with sides equal to equivalent ellipse.
        df["area_rect"] = df.axis_major_length * df.axis_minor_length

        # Filling of rectangle with respect to bounding box.
        df["area_ratio"] = df.area / df.area_rect

        return df


class WorkflowStudy:
    """ Manage whole study with component classes. """
    def __init__(self,
            spaceholder_fraction: list[int],
            calibration: float,
            force: bool = False,
            sigma: Optional[float] = 10.0,
            cutoff: Optional[int] = 100
        ) -> None:
        all_files = self.__get_all_files()

        # WorkflowPorosity(all_files, force=force)
        # self.__porosity_stats()

        # WorkflowRegions(all_files, sigma=sigma, cutoff=cutoff, force=force)

        with open(ROOT_PATH / "media/outputs/regions/distances.json") as fp:
            all_dists = json.load(fp)

        dists = {}
        for sh in spaceholder_fraction:
            pattern = re.compile(rf"Ti_pure_(\d)-{sh}\.(\d)*")

            dists[sh] = []
            for key in filter(pattern.match, all_dists.keys()):
                dists[sh].extend(all_dists[key])

        table_name = ROOT_PATH / "media/outputs/wall_thickness.csv"
        fig, table = self.__get_hist_dist_publ_fig(dists, calibration)
        fig.savefig(ROOT_PATH / "media/outputs/wall_thickness.png", dpi=300)
        table.to_csv(table_name, index=False)

        post_files = {}
        post_name = "media/outputs/summary-regions-{0:0d}.csv"

        for sh in spaceholder_fraction:
            regex = f"*Ti_pure*{sh:0d}.*.csv"
            post_files[sh] = post_name.format(sh)
            self.__summary(regex, post_files[sh], calibration)

        WorkflowPostprocessing(post_files, table_name, cutoff=cutoff)

    def __get_all_files(self):
        """ Retrive file pairs to be treated. """
        path = ROOT_PATH
        files_normal = sorted((path / "media/inputs/normal").glob(r"*.jpg"))
        files_manual = sorted((path / "media/inputs/manual").glob(r"*.jpg"))
        
        stem_normal = [f.stem for f in files_normal]
        stem_manual = [f.stem for f in files_manual]
        
        if stem_normal != stem_manual:
            raise Exception("Check files in sub-folders, names do not match!")
        
        return list(zip(files_normal, files_manual, stem_normal))

    def __get_hist_dist_publ_fig(self, dists, calibration, xmax=600.0):
        """ Create histogram of wall intercepts lengthts. """
        plt.close("all")
        plt.style.use("seaborn-white")
        fig, ax = plt.subplots(1, 1, figsize=(6, 5))

        table = []
        bins = 200
        for sh, dist in dists.items():
            # bins = len(dist) // 2000

            vec = np.array(dist) * calibration
            p025, p975 = np.percentile(vec, [2.5, 97.5])
    
            table.append({
                "SH": sh, 
                "size": len(vec),
                "std": np.std(vec),
                "mean": np.mean(vec),
                "median": np.median(vec),
                "mode": st.mode(vec, keepdims=True).mode[0],
                "p025": p025,
                "p975": p975
            })

            ax.hist(vec, bins=bins, alpha=0.6, density=True,
                    label=f"{sh:0d}%")

        ax.grid(linestyle=':')
        ax.set_xlim(0.0, xmax)
        ax.set_ylim(0.0, 0.02)
        ax.set_xlabel("Wall thickness [µm]")
        ax.set_ylabel("Probability density")
        ax.legend(loc=1)
        fig.tight_layout()

        table = pd.DataFrame(table)

        return fig, table
    
    def __add_units(self, df, calibration):
        """ Make values dimensional through pixel calibration. """
        # Remove some unused columns.
        drops = ["centroid-0", "centroid-1", "orientation", "source"]
        df.drop(columns=drops, inplace=True)

        # Conversion factors for columns to plot.
        scale = {"[-]": 1.0,
                 "[µm]": calibration**1,
                 "[µm²]": calibration**2
                 }
        
        # Convert units based on standardized legends.
        for c in df.columns:
            df[c] *= scale[LEGEND[c].split(" ")[-1]]

        return df

    def __porosity_stats(self):
        """ Compute statistics from porosity quantification. """       
        df = pd.read_csv(ROOT_PATH / "media/outputs/porosity/results.csv")
        df["SH"] = df["stem"].str[10:12].astype(int)

        stats = df[["SH", "bias", "porosity"]].groupby("SH").agg({
            "SH": "count",
            "bias": ["mean", "std"],
            "porosity": ["mean", "std", st.sem]
        })

        n = stats["SH", "count"]
        loc = stats["porosity", "mean"]
        scale = stats["porosity", "sem"]
        res = st.t.interval(confidence=0.95, df=n, loc=loc, scale=scale)
        stats["porosity_min"] = res[0]
        stats["porosity_max"] = res[1]

        print(stats)

    def __summary(self, regex, saveas, calibration):
        """ Concatenate all data matching one sample. """
        all_tables = []
        regions = ROOT_PATH / "media/outputs/regions"

        for f in regions.glob(regex):
            df = pd.read_csv(f)

            df["source"] = f.stem
            all_tables.append(df)

        df = pd.concat(all_tables, ignore_index=True)
        df = self.__add_units(df, calibration)
        df.to_csv(saveas, index=False)


def _segment(fname, sigma):
    """ Perform image automated thresholding for segmentation. """
    img0 = imread(fname, as_gray=True)
    img1 = gaussian(img0, sigma=sigma)
    img2 = img1 > threshold_otsu(img1)
    
    porosity = 100 * (1 - img2.sum() / img2.size)
    contours = find_contours(img2, 0.99)

    return img0, img2, contours, porosity


if __name__ == "__main__":
    MICRON_PER_PIXEL = 500 / 515 
    WorkflowStudy(spaceholder_fraction=[50, 70, 80],
                  calibration=MICRON_PER_PIXEL,
                  force=True)
