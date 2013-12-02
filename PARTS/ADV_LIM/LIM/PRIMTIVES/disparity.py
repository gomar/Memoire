from antares import *
import numpy as np

nb_pts = 100

def conditionning(f1, f2):
    """
    Compute the Almost-Periodic IDFT matrix
    """

    # reshaping the timelevels vector so that a matrix
    # product can be done with the frequencies
    timelevels = (np.arange(0., 5.) / (min(f1, f2) * 5.)).reshape((5, 1))
    # building the symmetric vector of frequencies

    frequencies = np.sort([-f1, -f2, 0, f1, f2]).reshape((1, 5))
    return np.linalg.cond(np.exp(2 * 1j * np.pi * np.dot(timelevels, frequencies)))

vfunc = np.vectorize(conditionning)

base = Base()
base.init()
base[0][0]['f1'], base[0][0]['f2'] = np.meshgrid(np.linspace(1, 10000, num=nb_pts), 
	                                             np.linspace(1, 10000, num=nb_pts))
base[0][0]['kappa'] = vfunc(base[0][0]['f1'], base[0][0]['f2'])

w = Writer()
w['filename'] = 'disparity.dat'
w['file_format'] = 'gnuplot_2d'
w['base'] = base
w.dump()

stats = base.stats

for var in ['mean', 'min', 'max', 'std']:
    print var, stats[var][0]['kappa']