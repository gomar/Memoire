from convection1D_tsm import Convection
import os

convection = Convection()
convection.sim = 'HB'
convection.frequencies = [1.]
convection.cfl = 1.
convection.n_mesh = 1000
def inj_back_p(t):
    "Sinusoidal function"
    return (np.sin(1 * omega_t * t))

convection.inj_func = inj_back_p

main(harm_computed=[1], cfl=1., n_mesh=1000, c=1., case='back_p', result_dir=os.path.join(''))
