# -*- coding: utf-8 -*-
""" Provides a Streamlit application for FuMEs simulation. """
from pathlib import Path
from casadi import heaviside
import sys
import json
import logging
import logging.config
import clr
import numpy as np
import pandas as pd
import plotly.express as px
import streamlit as st

# Path to directory containing this file.
HERE = Path(__file__).resolve().parent

# Put DLLs in system path.
sys.path.insert(0, str(HERE))

# Configure model to display title and wide format.
st.set_page_config(page_title="FuMEs", page_icon="random", layout="wide",
                   initial_sidebar_state="collapsed", menu_items=None)


def main():
    """ Main FuMEs Streamlit web application body. """
    logging.config.fileConfig(HERE / "app.conf")
    logger = logging.getLogger("root")
    logger.info("Starting model main function")

    conf = load_app_config()

    st.header("FuMEs - Furnace Modeling of Exchanges")

    st.sidebar.subheader("General Configuration")
    st.sidebar.slider(**conf["chamberFreeVolume"])
    st.sidebar.slider(**conf["boilerHeatingTime"])
    st.sidebar.slider(**conf["boilerResponseTime"])
    st.sidebar.slider(**conf["boilerCapacity"])

    st.sidebar.subheader("Optimizer Configuration")
    st.sidebar.slider(**conf["timeStep"])
    st.sidebar.slider(**conf["penaltyCompensateFlowChange"])
    st.sidebar.slider(**conf["penaltyTotalFlowChange"])
    st.sidebar.slider(**conf["penaltyBoilerCommandChange"])

    st.sidebar.subheader("Advanced Configuration")
    st.sidebar.slider(**conf["butterWorthExponent"])

    with st.expander("Chamber state", expanded=True):
        col = st.columns(3)
        col[0].slider(**conf["chamberTemperature"])
        col[1].slider(**conf["chamberPressure"])
        col[2].slider(**conf["boilerInitialState"])

        col = st.columns(3)
        col[0].slider(**conf["chamberHydrogenContent"])
        col[1].slider(**conf["chamberCarbonMonoxideContent"])
        col[2].slider(**conf["chamberDewPoint"])

    with st.expander("Gas source 1", expanded=True):
        col = st.columns(3)
        col[0].slider(**conf["hydrogenContentSrcOne"])
        col[1].slider(**conf["carbonMonoxideContentSrcOne"])
        col[2].slider(**conf["dewPointSrcOne"])

        col = st.columns(3)
        col[0].slider(**conf["flowRateSrcOne"])
        col[1].slider(**conf["flowRateMinSrcOne"])
        col[2].slider(**conf["flowRateMaxSrcOne"])

    with st.expander("Gas source 2", expanded=True):
        col = st.columns(3)
        col[0].slider(**conf["hydrogenContentSrcTwo"])
        col[1].slider(**conf["carbonMonoxideContentSrcTwo"])
        col[2].slider(**conf["dewPointSrcTwo"])

        col = st.columns(3)
        col[0].slider(**conf["flowRateSrcTwo"])
        col[1].slider(**conf["flowRateMinSrcTwo"])
        col[2].slider(**conf["flowRateMaxSrcTwo"])

    with st.expander("Coil list", expanded=True):
        col = st.columns(3)
        col[0].markdown("### Coil 0")
        col[0].slider(**conf["targetDewPointCoilSt"])
        col[0].slider(**conf["constantOfReductionCoilSt"])
        col[0].slider(**conf["constantOfOxidationCoilSt"])
        col[0].slider(**conf["constantOfDecarburizationCoilSt"])
        col[0].slider(**conf["productionDurationCoilSt"])

        col[1].markdown("### Coil 1")
        col[1].slider(**conf["targetDewPointCoilNd"])
        col[1].slider(**conf["constantOfReductionCoilNd"])
        col[1].slider(**conf["constantOfOxidationCoilNd"])
        col[1].slider(**conf["constantOfDecarburizationCoilNd"])
        col[1].slider(**conf["productionDurationCoilNd"])

        col[2].markdown("### Coil 2")
        col[2].slider(**conf["targetDewPointCoilRd"])
        col[2].slider(**conf["constantOfReductionCoilRd"])
        col[2].slider(**conf["constantOfOxidationCoilRd"])
        col[2].slider(**conf["constantOfDecarburizationCoilRd"])
        col[2].slider(**conf["productionDurationCoilRd"])

    with st.expander("Optimization", expanded=True):
        col = st.columns(2)
        col[0].checkbox(**conf["integrateOnly"])
        col[0].checkbox(**conf["optimizeTotalFlowRate"])
        col[0].checkbox(**conf["compensateFlowComposition"])
        col[0].checkbox(**conf["constrainHydrogenContent"])
        col[0].checkbox(**conf["constrainCarbonMonoxideContent"])
        col[1].slider(**conf["chamberCarbonMonoxideContentMax"])
        col[1].slider(**conf["chamberHydrogenContentMin"])
        col[1].slider(**conf["chamberHydrogenContentMax"])
        col[1].slider(**conf["totalFlowRateMin"])
        col[1].slider(**conf["totalFlowRateMax"])

    outputs = None

    with st.form("Main"):
        if st.form_submit_button("Run simulation"):
            outputs = run_backend(st.session_state)

    if outputs is not None:
        df = tabulate_outputs(st.session_state, outputs)
        plot_results(df)


@st.cache
def load_app_config():
    """ Load YAML file with app configuration. """
    with open(HERE / "app.json", encoding="utf-8") as fp:
        conf = json.load(fp)
    return conf


def run_backend(state):
    """ Access FuMEs backend implementation from C#. """
    clr.AddReference("fumes-wrapper")
    from FuMEsWrapper import FuMEsInputs
    from FuMEsWrapper import FuMEsModel

    inputs = FuMEsInputs()
    prepare_inputs(state, inputs)

    model = FuMEsModel(inputs)
    return model.Outputs


def prepare_inputs(state, inputs):
    """ Prepare inputs for backend model from dictionary. """
    inputs.boilerInitialState = state["boilerInitialState"]
    inputs.chamberFreeVolume = state["chamberFreeVolume"]
    inputs.boilerHeatingTime = state["boilerHeatingTime"]
    inputs.boilerResponseTime = state["boilerResponseTime"]
    inputs.boilerCapacity = state["boilerCapacity"]
    inputs.butterWorthExponent = state["butterWorthExponent"]
    inputs.chamberTemperature = state["chamberTemperature"]
    inputs.chamberPressure = state["chamberPressure"]
    inputs.chamberHydrogenContent = state["chamberHydrogenContent"]
    inputs.chamberCarbonMonoxideContent = state["chamberCarbonMonoxideContent"]
    inputs.chamberDewPoint = state["chamberDewPoint"]
    inputs.hydrogenContentSrcOne = state["hydrogenContentSrcOne"]
    inputs.carbonMonoxideContentSrcOne = state["carbonMonoxideContentSrcOne"]
    inputs.dewPointSrcOne = state["dewPointSrcOne"]
    inputs.flowRateSrcOne = state["flowRateSrcOne"]
    inputs.flowRateMinSrcOne = state["flowRateMinSrcOne"]
    inputs.flowRateMaxSrcOne = state["flowRateMaxSrcOne"]
    inputs.hydrogenContentSrcTwo = state["hydrogenContentSrcTwo"]
    inputs.carbonMonoxideContentSrcTwo = state["carbonMonoxideContentSrcTwo"]
    inputs.dewPointSrcTwo = state["dewPointSrcTwo"]
    inputs.flowRateSrcTwo = state["flowRateSrcTwo"]
    inputs.flowRateMinSrcTwo = state["flowRateMinSrcTwo"]
    inputs.flowRateMaxSrcTwo = state["flowRateMaxSrcTwo"]
    inputs.chamberHydrogenContentMin = state["chamberHydrogenContentMin"]
    inputs.chamberHydrogenContentMax = state["chamberHydrogenContentMax"]
    inputs.chamberCarbonMonoxideContentMax = state["chamberCarbonMonoxideContentMax"]
    inputs.totalFlowRateMin = state["totalFlowRateMin"]
    inputs.totalFlowRateMax = state["totalFlowRateMax"]
    inputs.timeStep = state["timeStep"]
    inputs.penaltyCompensateFlowChange = state["penaltyCompensateFlowChange"]
    inputs.penaltyTotalFlowChange = state["penaltyTotalFlowChange"]
    inputs.penaltyBoilerCommandChange = state["penaltyBoilerCommandChange"]
    inputs.targetDewPointCoilSt = state["targetDewPointCoilSt"]
    inputs.constantOfReductionCoilSt = state["constantOfReductionCoilSt"]
    inputs.constantOfOxidationCoilSt = state["constantOfOxidationCoilSt"]
    inputs.constantOfDecarburizationCoilSt = state["constantOfDecarburizationCoilSt"]
    inputs.productionDurationCoilSt = state["productionDurationCoilSt"]
    inputs.targetDewPointCoilNd = state["targetDewPointCoilNd"]
    inputs.constantOfReductionCoilNd = state["constantOfReductionCoilNd"]
    inputs.constantOfOxidationCoilNd = state["constantOfOxidationCoilNd"]
    inputs.constantOfDecarburizationCoilNd = state["constantOfDecarburizationCoilNd"]
    inputs.productionDurationCoilNd = state["productionDurationCoilNd"]
    inputs.targetDewPointCoilRd = state["targetDewPointCoilRd"]
    inputs.constantOfReductionCoilRd = state["constantOfReductionCoilRd"]
    inputs.constantOfOxidationCoilRd = state["constantOfOxidationCoilRd"]
    inputs.constantOfDecarburizationCoilRd = state["constantOfDecarburizationCoilRd"]
    inputs.productionDurationCoilRd = state["productionDurationCoilRd"]
    inputs.integrateOnly = state["integrateOnly"]
    inputs.optimizeTotalFlowRate = state["optimizeTotalFlowRate"]
    inputs.compensateFlowComposition = state["compensateFlowComposition"]
    inputs.constrainHydrogenContent = state["constrainHydrogenContent"]
    inputs.constrainCarbonMonoxideContent = state["constrainCarbonMonoxideContent"]


def plot_results(df):
    """ Display simulation/optimization results graphically. """
    line0 = px.line(df, x="Time [min]", y="Water content PV [°C]")
    line0.add_scatter(x=df["Time [min]"], y=df["Water content SP [°C]"],
                      mode='lines', name="Water content SP [°C]")
    line0.update(layout_showlegend=False)

    line1 = px.line(df, x="Time [min]", y="Hydrogen content PV [%]")
    line2 = px.line(df, x="Time [min]", y="Carbon monoxide content PV [ppm]")

    line3 = px.line(df, x="Time [min]", y="Steam flow PV [kg/h]")
    line3.add_scatter(x=df["Time [min]"], y=df["Steam flow SP [kg/h]"],
                      mode='lines', name="Steam flow SP [kg/h]",
                      line_shape="vh")
    line3.update(layout_showlegend=False)

    line4 = px.line(df, x="Time [min]", y="Renewal flow rate [Nm³/h]")
    line4.add_scatter(x=df["Time [min]"], y=df["Flow rate 1 [Nm³/h]"],
                      mode='lines', name="Flow rate 1 [Nm³/h]")
    line4.add_scatter(x=df["Time [min]"], y=df["Flow rate 2 [Nm³/h]"],
                      mode='lines', name="Flow rate 2 [Nm³/h]")
    line4.update(layout_showlegend=False)

    line5 = px.line(df, x="Time [min]", y="Source 1 flow fraction [-]")

    col = st.columns(2)
    col[0].plotly_chart(line0)
    col[0].plotly_chart(line1)
    col[0].plotly_chart(line2)
    col[1].plotly_chart(line3)
    col[1].plotly_chart(line4)
    col[1].plotly_chart(line5)


def tabulate_outputs(state, outputs):
    """ Transform model outputs into a pandas data-frame. """
    # Get time for computing DP SP.
    tk = np.array(list(outputs.tk)) / 60

    # Compute flows from each source.
    qk = mol_s_to_nm3h(np.array(list(outputs.qk)))
    rk = np.array(list(outputs.rk))
    q1 = (0 + rk) * qk
    q2 = (1 - rk) * qk

    # Compute dew-point SP.
    tc0 = 0
    tc1 = tc0 + state["productionDurationCoilSt"]
    tc2 = tc1 + state["productionDurationCoilNd"]
    sp0 = water_content(state["targetDewPointCoilSt"])
    sp1 = water_content(state["targetDewPointCoilNd"])
    sp2 = water_content(state["targetDewPointCoilRd"])

    dp_sp = sp0 + \
        (sp1 - sp0) * heaviside(tk - tc1) + \
        (sp2 - sp1) * heaviside(tk - tc2)
    dp_sp = dew_point(dp_sp.full().ravel())
    dp_pv = dew_point(np.array(list(outputs.x0)))

    x1 = np.array(list(outputs.x1)) * 100
    x2 = np.array(list(outputs.x2)) * 1000000

    uk = steam_mol_s_to_kgh(np.array(list(outputs.uk)))
    vk = steam_mol_s_to_kgh(np.array(list(outputs.vk)))

    df = pd.DataFrame({
        "Time [min]": tk,
        "Water content PV [°C]": dp_pv,
        "Water content SP [°C]": dp_sp,
        "Hydrogen content PV [%]": x1,
        "Carbon monoxide content PV [ppm]": x2,
        "Steam flow PV [kg/h]": uk,
        "Steam flow SP [kg/h]": vk,
        "Renewal flow rate [Nm³/h]": qk,
        "Flow rate 1 [Nm³/h]": q1,
        "Flow rate 2 [Nm³/h]": q2,
        "Source 1 flow fraction [-]": rk
    })

    return df


def water_content(dp):
    """ Compute water fraction from dew point.

    Parameters
    ----------
    dp : NumericT
        Dew point measured in Celsius degrees.

    Returns
    -------
    NumericT
        Partial pressure of water in atmosphere at PREF.
    """
    condlist = [(dp <= 0.0) & (dp > -272.0), (dp > 0.0)]
    funclist = [lambda dp: 10 ** (-2.22 + 9.72 * dp / (272 + dp)),
                lambda dp: 10 ** (-2.22 + 7.58 * dp / (240 + dp))]
    return np.clip(np.piecewise(dp, condlist, funclist), 0.0, 1.0)


def dew_point(X):
    """ Compute dew point from water fraction.

    Parameters
    ----------
    X : NumericT
        Water molar fraction.

    Returns
    -------
    NumericT
        Partial pressure of water in atmosphere at PREF.
    """
    X_crit = water_content(0.0)
    k = -np.log10(X_crit)

    def fun_l(X):
        log10x = np.log10(X)
        return 272.0 * (k + log10x) / (9.72 - k - log10x)

    def fun_h(X):
        log10x = np.log10(X)
        return 240.0 * (k + log10x) / (7.58 - k - log10x)

    condlist = [(X < X_crit) & (X > 0.0), (X >= X_crit)]
    funclist = [fun_l, fun_h]
    return np.clip(np.piecewise(X, condlist, funclist), -273, 100)


def steam_mol_s_to_kgh(flow):
    """ Steam PV flow computed from actual flow. """
    return flow * 3600 * MWST


def mol_s_to_nm3h(q):
    """ Convert [mole/s] to [Nm³/h]. """
    return q * 3600 / NORMAL_CONC


PREF: float = 101325.0
# """ Reference normal pressure [Pa]. """

TREF: float = 298.15
# """ Reference normal temperature [K]. """

RGAS: float = 8.31446261815324
# """ Universal gas constant [J/(mol.K)]. """

NORMAL_CONC: float = PREF / (RGAS * TREF)
# """ Normal state concentration [mol/m³]. """

MWST: float = 0.018
# """ Water molar weight [kg/mol]. """


if __name__ == "__main__":
    main()
