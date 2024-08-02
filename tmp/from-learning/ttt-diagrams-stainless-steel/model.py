# -*- coding: utf-8 -*-
from sklearn.metrics import r2_score
from sklearn.metrics import mean_squared_error as mse
from sklearn.model_selection import train_test_split
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


class StandardScaler:
    """ A simple standard scaler. """
    def __init__(self, X):
        self._mean = X.mean(axis=0)
        self._std = X.std(axis=0)
        
    def get_parameters(self):
        """ Return dictionary with mean and standard deviation. """
        return {'mean': self._mean, 'std': self._std}

    def apply_to(self, X):
        """ Apply standard scaling to data. """
        return (X - self._mean) / self._std

    
def split_transform_data(X, y, test_size=0.2, random_state=42,
                         use_scaler=False):
    """ Train-test split and apply standard scaler. """
    rets = train_test_split(X, y, test_size=test_size,
                            random_state=random_state,
                            shuffle=True)
    X_train, X_tests, y_train, y_tests = rets

    if not use_scaler:
        scaler = None
    else:
        scaler = StandardScaler(X_train)
        X_train = scaler.apply_to(X_train)
        X_tests = scaler.apply_to(X_tests)

    return X_train, X_tests, y_train, y_tests, scaler


def correlation_matrix(df):
    """ Plot a standardized correlation matrix for data-frame. """
    # Compute correlation matrix.
    corr = df.corr()

    # Generate a mask for the upper triangle
    mask = np.triu(np.ones_like(corr, dtype=bool))

    # Set up the matplotlib figure
    fig, ax = plt.subplots(figsize=(11, 9))

    # Generate a custom diverging colormap
    cmap = sns.diverging_palette(230, 20, as_cmap=True)

    # Draw the heatmap with the mask and correct aspect ratio
    sns.heatmap(corr, mask=mask, cmap=cmap, vmin=-1, vmax=+1, center=0,
                square=True, linewidths=0.5, cbar_kws={"shrink": 0.9})
    
    fig.tight_layout()
    return fig


def regression_plot(model, X_train, X_tests, y_train, y_tests,
                    lims_corr=(250, 800), x_lim_hist=(-20, +30)):
    """ Confront predictions to expected values in datasets. """
    train_data = True
    if any(x is None for x in [X_train, y_train]):
        train_data = False
    
    tmp1 = pd.DataFrame({'Expected': y_tests,
                        'Predicted': model.predict(X_tests)})
    error_tests = y_tests - tmp1['Predicted']
    score11 = r2_score(y_tests, tmp1['Predicted'].to_numpy())
    score12 = mse(y_tests, tmp1['Predicted'].to_numpy())**0.5
    title = F'Tests R²={score11:.4f} | RMSE={score12:.4f}'
    
    if train_data:
        tmp2 = pd.DataFrame({'Expected': y_train,
                            'Predicted': model.predict(X_train)})
        error_train = y_train - tmp2['Predicted']
        score21 = r2_score(y_train, tmp2['Predicted'].to_numpy())
        score22 = mse(y_train, tmp2['Predicted'].to_numpy())**0.5
        title += F'\nTrain R²={score21:.4f} | RMSE={score22:.4f}'
    
    plt.style.use('seaborn-white')
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))
    fig.suptitle(title, fontsize=16)

    xy = [y_tests.min(), y_tests.max()]
    
    if train_data:
        sns.regplot(x='Expected', y='Predicted', data=tmp2,
                    ax=ax1, label='Train', scatter_kws={'alpha': 0.6})
    sns.regplot(x='Expected', y='Predicted', data=tmp1,
                ax=ax1, label='Tests', scatter_kws={'alpha': 0.6})
    ax1.plot(xy, xy, 'k:', label='_none_')
    ax1.set_xlim(*lims_corr)
    ax1.set_ylim(*lims_corr)
    ax1.grid(linestyle=':')
    ax1.legend(loc='upper left')
    
    if train_data:
        ax2.hist(error_train, bins=50, density=True,
                 alpha=0.6, label='Train')
    ax2.hist(error_tests, bins=50, density=True,
             alpha=0.6, label='Tests')
    ax2.set_xlabel('Prediction error')
    ax2.set_ylabel('Probability density')
    ax2.set_xlim(*x_lim_hist)
    ax2.grid(linestyle=':')
    ax2.legend(loc=2)
    
    fig.tight_layout()
    return fig, score12


def plot_benchmark(bm):
    """ Plot RMSE against reference paper values. """
    g = sns.catplot(data=bm, kind='bar',
                    x='Dataset', y='RMSE', hue='Group',
                    ci=None, palette='RdBu', height=6)
    g.legend.set_title('')
