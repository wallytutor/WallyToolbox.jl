# -*- coding: utf-8 -*-
from math import ceil
from math import floor
from base64 import b64encode
import pandas as pd
import plotly.graph_objects as go
import streamlit as st


def load_data():
    """ Manage data loading. """
    print('* Loading database...')
    data = pd.read_csv('data.csv')

    data['Al'] *= 100
    data['Mg'] *= 100
    data['Si'] *= 100
    data['liquidus'] -= 273.15

    data['Mg'] = data['Mg'].astype(int)
    data['Si'] = data['Si'].astype(int)

    uniques = {
        'Mg': data['Mg'].unique(),
        'Si': data['Si'].unique()
    }

    name = 'liquidus'
    rng_tr = [50.0 * floor(float(data[name].min()) / 50), 
              50.0 * ceil(float(data[name].max()) / 50)]
    rng_al = [float(data['Al'].min()), float(data['Al'].max())]
    rng_mg = [float(data['Mg'].min()), float(data['Mg'].max())]
    rng_si = [float(data['Si'].min()), float(data['Si'].max())]

    return data, uniques, rng_tr, rng_al, rng_mg, rng_si


def should_continue(name, val, mg, si):
    """ Keep values within selected range for species. """
    if name == 'Mg' and (val < mg[0] or val > mg[1]):
        return True
    if name == 'Si' and (val < si[0] or val > si[1]):
        return True
    return False


def select_other(df, other, val):
    """ Slice dataframe for secondary species. """
    sel = df.loc[df[other] == val]
    line = go.Scatter(x=sel['Al'], 
                      y=sel['liquidus'], 
                      mode='lines', 
                      name=F'{other} at {val:.1f}%wt')
    return line


def plot(data, uniques, fixed, other, tr, al, mg, si):
    """ Generate plots according to filters. """
    csv = data.to_csv(index=False)
    b64 = b64encode(csv.encode()).decode()
    href = f'<a href="data:file/csv;base64,{b64}">Download CSV</a>'
    st.markdown(href, unsafe_allow_html=True)

    for valf in uniques[fixed]:
        if should_continue(fixed, valf, mg, si):
            continue

        fig = go.Figure()
        dff = data.loc[data[fixed] == round(valf)]

        for valo in uniques[other]:
            if should_continue(other, valo, mg, si):
                continue

            fig.add_trace(select_other(dff, other, round(valo)))

        name = F'{fixed} at {valf:.1f}%wt'
        fig.update_layout(title=F'Liquidus - COST507: {name}',
                        xaxis_title='Al Content [%wt]',
                        yaxis_title='Temperature [°C]')
        fig.update_xaxes(range=(al[0], al[1]))
        fig.update_yaxes(range=(tr[0], tr[1]))
        st.plotly_chart(fig)


def main():
    """ Main application. """
    st.set_page_config(page_title='Quaternary alloys')
    st.title('Quaternary alloys liquidus exploration')
    loader = st.cache(load_data)

    data, uniques, rng_tr, rng_al, rng_mg, rng_si = loader()

    st.markdown("""
    * Use the menu at left to bound axes limits and plot type.
    * You can download figures for report conception.
    """)

    st.sidebar.markdown('## Configure plot')

    tr = st.sidebar.slider('Temperature [°C]', min_value=rng_tr[0],
                           max_value=rng_tr[1], value=rng_tr,
                           step=1.0, format='%.0f')
    al = st.sidebar.slider('Al content [%wt]', min_value=rng_al[0],
                           max_value=rng_al[1], value=rng_al,
                           step=1.0, format='%.0f')
    mg = st.sidebar.slider('Mg content [%wt]', min_value=rng_mg[0],
                           max_value=rng_mg[1], value=rng_mg,
                           step=1.0, format='%.1f')
    si = st.sidebar.slider('Si content [%wt]', min_value=rng_si[0],
                           max_value=rng_si[1], value=rng_si,
                           step=1.0, format='%.1f')
    fixed = st.sidebar.selectbox('Fixed element', ['Mg', 'Si'])

    other = 'Mg' if fixed == 'Si' else 'Si'
    plot(data, uniques, fixed, other, tr, al, mg, si)


if __name__ == '__main__':
    main()
