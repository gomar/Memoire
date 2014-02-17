import sys
sys.path.append('../../PRIMITIVES')
from convection_code import Convection
from antares import *
import numpy as np

# convection = Convection()
# convection.sim = 'HB'
# convection.cfl = 1.
# convection.n_mesh = 2000
# def inj_back_p(t):
#     "Sinusoidal function with only one frequency"
#     omega_t = 2. * np.pi * convection.c / convection.Lx
#     return (1. + np.sin(1. * omega_t * t) + np.sin(22. * omega_t * t))
# convection.inj_func = [inj_back_p, np.zeros]

# hb_comp = HbComputation()
# hb_comp['frequencies'] = [1., 22.]
# hb_comp = hb_comp.optimize_timelevels()
# convection.frequencies = hb_comp['frequencies']
# convection.timelevels = hb_comp['timelevels']
# print 'condition number', hb_comp.conditionning()
# convection.result_dir = 'multifreq'
# print convection.compute()


for harm in range(25):
	convection = Convection()
	convection.sim = 'TSM'
	convection.cfl = 1.
	convection.n_mesh = 2000
	def inj_back_p(t):
	    "Sinusoidal function with only one frequency"
	    omega_t = 2. * np.pi * convection.c / convection.Lx
	    return (1. + np.sin(1. * omega_t * t) + np.sin(22. * omega_t * t))
	convection.inj_func = [inj_back_p, np.zeros]

	hb_comp = HbComputation()
	hb_comp['frequencies'] = [(i + 1) for i in range(harm + 1)]
	convection.frequencies = hb_comp['frequencies']
	print hb_comp['frequencies']
	convection.result_dir = 'multifreq'
	print convection.compute()