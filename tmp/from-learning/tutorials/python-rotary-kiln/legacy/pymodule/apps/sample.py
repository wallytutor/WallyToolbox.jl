# -*- coding: utf-8 -*-
from importlib import import_module
from pathlib import Path
from time import perf_counter
from rotary_kiln.stream_easy import StreamEasy
import streamlit as st
import plotly.graph_objects as go
import yaml


class Sample(StreamEasy):
    """ Sample rotary kiln model application. """
    def __init__(self) -> None:
        super().__init__()

        config = Path(__file__).resolve().parent / "sample.yaml"

        with open(config, encoding="utf-8") as fp:
            self.conf = yaml.safe_load(fp)

    def _find_by_name(self, name, key, selector=None):
        if selector is None:
            selector = self.conf[key]
        return list(filter(lambda s: s["name"] == name, selector))[0]

    def _make_sidebar(self, pars):
        """ Create application sidebar for combustion setup. """
        for value in pars["fields"].values():
            self.add(st.sidebar, value)

    def _make_body(self, pars, general):
        """ Create application sidebar for discretization setup. """
        user_defined = (self._state["reactor_discretization_type"] == "User")

        if user_defined:
            st.subheader("Reactor description file")
            self.add(st, pars["fields"]["kiln_file"])
        else:
            st.subheader("Reactor discretization scheme")
            cols = st.columns(3)
            geom = pars["geometry"]
            self.add(cols[0], geom["reactor_slices"])
            self.add(cols[1], geom["reactor_length"])
            self.add(cols[2], geom["reactor_inner_diameter"])

            st.subheader("Wall description")
            cols = st.columns(2)
            geom = pars["layers"]
            self.add(cols[0], geom["brick_layer_thickness"])
            self.add(cols[1], geom["brick_layer_thermal_conductivity"])
            self.add(cols[0], geom["steel_layer_thickness"])
            self.add(cols[1], geom["steel_layer_thermal_conductivity"])

        st.subheader("Reactor load")
        cols = st.columns(3)
        geom = general["bed"]
        self.add(cols[0], geom["kiln_load_level"])

        st.subheader("Model options")
        cols = st.columns(3)
        geom = general["models"]
        self.add(cols[0], geom["reactor_solver_mode"])

        if self.get("reactor_solver_mode") and not user_defined:
            self.add(cols[1], geom["external_wall_temperature_entry"])
            self.add(cols[2], geom["external_wall_temperature_exit"])
        elif not self.get("reactor_solver_mode"):
            self.add(cols[1], geom["environment_temperature"])
            self.add(cols[2], geom["environment_convective_htc"])

    def _make_temperature_plot(self, table):
        """ Generate temperature plot along reactor. """
        fig = go.Figure()
        fig.add_trace(go.Scatter(x=table.x, y=table.T_int,
                            mode="lines+markers",
                            name="Internal"))
        fig.add_trace(go.Scatter(x=table.x, y=table.T_ext,
                            mode="lines+markers",
                            name="External"))
        fig.update_layout(
            title="Temperature profile",
            xaxis_title="Coordinate [m]",
            yaxis_title="Temperature [°C]",
            height=800)
        return fig

    def run(self):
        """ Main application model manager/runner. """
        st.set_page_config(page_title="Rotary Kiln", layout="wide")
        st.title(self.conf["title"])

        self.add_selectbox(st.sidebar, self.conf["reactor_discretization_type"])
        self.add_selectbox(st.sidebar, self.conf["combustion_models_names"])

        reactor_discretization_name = self.get("reactor_discretization_type")
        combustion_model_name = self.get("combustion_models_names")

        if (combustion_model_name is None or
            reactor_discretization_name is None):
            st.markdown("Please, select models on side bar.")
            return

        if reactor_discretization_name != "User":
            reactor_discretization_name = "Automatic"

        pars = self._find_by_name(combustion_model_name,
                                  "combustion_models_configs")
        self._make_sidebar(pars)

        module = "rotary_kiln.combustion_models.{}".format(pars["module"])
        module = import_module(module)

        st.markdown(pars["description"], unsafe_allow_html=True)
        
        general = self.conf["reactor_model_general"]
        pars = self._find_by_name(reactor_discretization_name,
                                  "reactor_discretization_configs")
        self._make_body(pars, general)

        def run_app():
            """ Callback for run button. """
            nonlocal table

            if (reactor_discretization_name == "User" and
                self._state["kiln_file"] is None):
                st.error("First select a kiln description file!")
                st.snow()
                return
            
            table = module.make_combustion_solution(self._state)
            return table

        with st.form("Results"):
            if st.form_submit_button("Run model"):
                if (table := run_app()) is None:
                    return

                fig = self._make_temperature_plot(table)
                st.plotly_chart(fig, use_container_width=True)
                st.table(table)

                st.success("Computation finished, now check the results!")
                st.balloons()


if __name__ == "__main__":
    app = Sample()
    app.run()
