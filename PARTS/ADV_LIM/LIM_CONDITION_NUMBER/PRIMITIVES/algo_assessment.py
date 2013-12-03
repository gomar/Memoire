from antares import *
import numpy as np
from antares.hb.HbAlgoOPT import HbAlgoOPT
from antares.hb.HbAlgoEQUI import HbAlgoEQUI
from antares.hb.HbAlgoAPFT import HbAlgoAPFT

nb_pts = 100
algo = 'opt'

def conditionning(f1, f2):
    """
    Compute the Almost-Periodic IDFT matrix
    """

    # reshaping the timelevels vector so that a matrix
    # product can be done with the frequencies
    timelevels = eval('algo_%s(f1, f2).reshape((5, 1))' % algo)
    # building the symmetric vector of frequencies

    frequencies = np.sort([-f1, -f2, 0, f1, f2]).reshape((1, 5))
    return np.linalg.cond(np.exp(2 * 1j * np.pi * np.dot(timelevels, frequencies)))

def algo_opt(f1, f2):
    """
    Optimization of the timelevels using gradient-based algorithm.
    See HbAlgoOPT for more infos.
    """
    return HbAlgoOPT(frequencies=[f1, f2]).optimize_timelevels()

def algo_equi(f1, f2):
    """
    Optimization of the timelevels using gradient-based algorithm.
    See HbAlgoOPT for more infos.
    """
    return HbAlgoEQUI(frequencies=[f1, f2]).optimize_timelevels()

def algo_apft(f1, f2):
    """
    Optimization of the timelevels using gradient-based algorithm.
    See HbAlgoOPT for more infos.
    """
    return HbAlgoAPFT(frequencies=[f1, f2]).optimize_timelevels()

vfunc = np.vectorize(conditionning)

base = Base()
base.init()
base[0][0]['f1'], base[0][0]['f2'] = np.meshgrid(np.linspace(1, 10000, num=nb_pts), 
	                                             np.linspace(1, 10000, num=nb_pts))
base[0][0]['kappa'] = np.ma.array(vfunc(base[0][0]['f1'], base[0][0]['f2']), 
                                  mask=np.identity(base[0][0].shape[0]).astype(bool))

w = Writer()
w['filename'] = 'algo_%s_assessment.dat' % algo
w['file_format'] = 'gnuplot_2d'
w['base'] = base
w.dump()

stats = base.stats

for var in ['mean', 'min', 'max', 'std']:
    print var, stats[var][0]['kappa']