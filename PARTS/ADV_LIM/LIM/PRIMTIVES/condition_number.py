import sys
sys.path.append('../../PRIMITIVES')
from convection_code import Convection
from antares import *
import numpy as np


def iround(x):
    """iround(number) -> integer
    Round a number to the nearest integer."""
    return int(round(x) - .5) + (x > 0)

nb_amp = 10
nb_cond = 11

base = Base()
base.init()
for var in ['amp', 'cond', 'error']:
	base[0][0][var] = np.zeros((nb_amp, nb_cond))


for cond_idx in range(nb_cond):
	for amp_idx in range(nb_amp):
		amp_val = 1 - 0.1 * amp_idx
		cond_val = 1 + 0.01 * cond_idx

		convection = Convection()
		convection.sim = 'HB'
		convection.cfl = 1.
		convection.n_mesh = 500
		def inj_back_p(t):
		    "Sinusoidal function with only one frequency"
		    omega_t = 2. * np.pi * convection.c / convection.Lx
		    return (1. + amp_val * np.sin(1. * omega_t * t))
		convection.inj_func = [inj_back_p, np.ones]

		hb_comp = HbComputation()
		hb_comp['frequencies'] = [1.]
		hb_comp = hb_comp.optimize_timelevels(target=cond_val)
		convection.frequencies = hb_comp['frequencies']
		convection.timelevels = hb_comp['timelevels']
		print 'condition number', hb_comp.conditionning()
		convection.result_dir = 'condition_number/AMP%d/K%d' % (amp_idx, iround(hb_comp.conditionning() * 100.))
		base[0][0]['amp'][amp_idx, cond_idx] = amp_val
		base[0][0]['cond'][amp_idx, cond_idx] = cond_val
		base[0][0]['error'][amp_idx, cond_idx] = convection.compute()

w = Writer()
w['filename'] = 'condition_number/2d_error_map'
w['file_format'] = 'gnuplot_2d'
w['base'] = base
w.dump()
