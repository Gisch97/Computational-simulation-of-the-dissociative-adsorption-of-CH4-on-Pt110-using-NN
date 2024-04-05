import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

data = pd.read_csv('gsrd_inputs/systemdata.in', skiprows=17,header=None,delim_whitespace=True)
data.drop(columns=[3,4,5,6], inplace=True)
data.rename({0:'x', 
             1:'y',
             2:'z',
             7:'capa'},
             axis=1, 
             inplace=True)
data.capa = data.capa.fillna(0)
data.capa = data.capa.astype('int')
SYSTEMDATA = data
SURFACE_XY = SYSTEMDATA.query('capa < 5 & capa != 0')

X_periodic = 8.04
Y_periodic = 8.5277077811

def plot_surface_3D(datos,ax):
    for x in [-1,0,1]:
        for y in [-1,0,1]:
            ax.scatter(
                datos['x'] + x * X_periodic, 
                datos['y'] + y * Y_periodic, 
                datos['z'], 
                c=datos['capa'], 
                cmap='viridis', 
                s=100,
                alpha=0.8)
    return ax


def plot_surface(datos,axis1,axis2,ax,leg = False):
    if axis1 == 'x':
        periodic = X_periodic
    elif axis1 == 'y':
        periodic = Y_periodic
    else:
         return ax
    if axis2=='y':
        periodic2 = Y_periodic
    else:
        periodic2 = 0
    for x in [0]: # lista con cantidad de celdas
        for y in [0]:
            if (x == 1) & (y == 1)& (leg == True):
                Legend=True
            else:
                Legend=False
            sns.scatterplot(
                x=datos[axis1] + x*periodic, 
                y=datos[axis2]+ y*periodic2, 
                hue=datos['capa'], 
                s=2000, 
                palette=sns.color_palette("deep", n_colors=4), 
                ax = ax,
                alpha=0.7,
                legend=Legend)
    return ax

def make_surface_grid(datos,ax):
    ax = plot_surface(datos,'x','y',ax, leg=True)
    ax.axhline(y=Y_periodic, xmin=0.375, xmax=0.705,linestyle='--', c='r')
    ax.axhline(y=0, xmin=0.375, xmax=0.705, linestyle='--', c='r')
    ax.axvline(x=X_periodic, ymin=0.365, ymax=0.69, linestyle='--', c='r')
    ax.axvline(x=0,ymin=0.365, ymax=0.69, linestyle='--', c='r')
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    return ax

def auto_surface(ax):
    return make_surface_grid(SYSTEMDATA.query('capa < 5 & capa != 0'),ax)


def plot_surface_unit(
        datos, 
        axis1, 
        axis2,
        ax
):
    sns.scatterplot(
        x=datos[axis1], 
        y=datos[axis2], 
        hue=datos['capa'], 
        s=450, 
        palette=sns.color_palette("deep", n_colors=4), 
        ax = ax,
        alpha=0.7,
        legend=True)
    return ax
