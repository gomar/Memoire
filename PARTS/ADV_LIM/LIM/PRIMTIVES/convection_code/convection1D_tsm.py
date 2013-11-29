import numpy as np
from math import pi
import antares as at
import os
import subprocess

def replace_in_file(filename, dict_tag2rep):
    f = open(filename)
    line = f.read()
    f.close()
    for tag in dict_tag2rep.keys():
        line = line.replace('<' + tag + '>', str(dict_tag2rep[tag]))
    return line


def raise_error(error):
    if error:
        print 'Something went wrong for conversion of file %s' % file
        print 'Error is:'
        print error


def launch_command(command):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    process.stdout.read()
    error = process.stderr.read()
    raise_error(error)


class Convection():

    def __init__(self):
        self.sim = 'TSM'
        self.frequencies = None
        self.timelevels = None


        self.cfl = None
        self.n_mesh = None

        self.inj_func = None
        self.result_dir = None

        self.c = 1.
        self.Lx = 1.


    def compute(self):
        # ===============================
        # = Computing some stuff needed =
        # ===============================
        # pulsation of the temporal phenomenon
        omega_t = 2. * pi * self.c / self.Lx
        n_mesh = self.n_mesh + 1
        # intializing antares hb_comp from user data
        hb_comp = at.HbComputation()
        hb_comp['frequencies'] = np.array(self.frequencies)  * omega_t / (2. * pi)
        if self.timelevels is not None:
            hb_comp['timelevels'] = self.timelevels
        Lt = self.Lx / self.c
        dx = self.Lx / float(self.n_mesh)
        # dt stability for TSM computations (see Sicot's thesis)
        dt = self.cfl * dx / (self.c + max(self.frequencies) * omega_t * dx)
        n_iter = int(Lt / dt)
        n_iter *= 2
        # building mesh coordinates
        mesh = np.arange(n_mesh) * dx
        # initializing u
        u = np.zeros((n_mesh, len(hb_comp['timelevels'])))
        # creating result directory
        if not os.path.isdir(self.result_dir):
            os.makedirs(self.result_dir)

        # ==========================
        # = Linking to Antares API =
        # ==========================
        at.verbose(0)
        plot = at.Treatment('plot')    

        def periodicity_operator(t):
            """
            custom periodization of functions
            """
            return (t - Lt / 2.) - Lt * int(t / Lt)

        def inj_wake(t):
            "Lakshminarayana and Davino wake"
            dv = 0.5
            width = 0.1
            # the similarity law (velocity is normalized)
            return (1. - dv * np.exp(-0.693 * (2 * t / (Lt * width)) ** 2.))

        def inj_sin(t):
            "Sinusoidal function"
            return (np.cos(1 * omega_t * t) +
                    np.sin(2 * omega_t * t) + 
                    np.cos(3 * omega_t * t) + 
                    np.sin(4 * omega_t * t) + 
                    np.cos(5 * omega_t * t))

        def inj_step(t):
            "Step function"
            return 0.5 * (np.sign(t) + 1)

        if self.inj_func == 'sin':
            injection = lambda t: inj_sin(periodicity_operator(t))
        elif self.inj_func == 'step':
            injection = lambda t: inj_step(periodicity_operator(t))
        elif self.inj_func == 'wake':
            injection = lambda t: inj_wake(periodicity_operator(t))
        else:
            if hasattr(self.inj_func, '__call__'):
                injection = self.inj_func

        source_term_op = hb_comp.ap_source_term()
        v_injection = np.vectorize(injection)
        # ghost cells boundary condition
        bnd_injection = v_injection(hb_comp['timelevels'])
        bnd_injection_gc_m = v_injection(hb_comp['timelevels'] + 1. * dx * self.cfl / self.c)
        bnd_injection_gc_m2 = v_injection(hb_comp['timelevels'] + 2. * dx * self.cfl / self.c)


        def rk4(u, t, dt, dx):
            # alpha = [0., 0.5, 0.5, 1.]  # classical Runge-Kutta coefficients
            alpha = [1. / 4., 1. / 3., 1. / 2., 1.]  # elsA Runge-Kutta coefficients

            u_i = u.copy()
            alpha_im1 = 0.
            for step in range(len(alpha)):
                u_i = u + alpha[step] * dt * (rhs(t=t + alpha_im1 * dt, 
                                                  y=u_i, dx=dx) + 
                                              np.imag(np.dot(u_i, source_term_op)))
                alpha_im1 = alpha[step]

            u_i[0] = bnd_injection
            return u_i


        def rhs(t, y, dx):

            def second_order_centered(u, dx, t):
                "Evaluation of u derivative, central difference, second order"
                u_gc = np.concatenate((np.empty((1, u.shape[1])), u))
                u_gc[0] = bnd_injection_gc_m
                u_gc[1] = bnd_injection
                up = u_gc[2:]
                um = u_gc[:-2]
                dy = np.concatenate(((up - um) / (2. * dx),
                                    [(u[-1] - u[-2]) / dx]))
                return dy

            def fourth_order_centered(u, dx, t):
                "Evaluation of u derivative, central difference, second order"
                u_gc = np.concatenate((np.empty((2, u.shape[1])), u))
                u_gc[0] = bnd_injection_gc_m2
                u_gc[1] = bnd_injection_gc_m
                u_gc[2] = bnd_injection
                eps4 = 0.16
                up2 = u_gc[4:]
                up = u_gc[3:-1]
                uc = u_gc[2:-2]
                um = u_gc[1:-3]
                um2 = u_gc[:-4]
                dy = np.concatenate((((-up2 + 8. * up - 8. * um + um2) / (12. * dx))
                                      + (self.c * eps4 * (up2 - 4. * up + 6. * uc - 4. * um + um2) / dx),
                                     [(3. * u[-2] - 4. * u[-3] + u[-4]) / (2. * dx)],
                                     [(u[-1] - u[-2]) / dx]))
                return dy

            u_prime = fourth_order_centered(u=y, dx=dx, t=t)

            return - self.c * u_prime

        def _init_base(u, base=None):
            if base is None:
                base = at.Base()
                base.init(instants=['t%02d' % i for i in range(len(hb_comp['timelevels']))])
                base[0].shared['x'] = mesh
                for inst in range(len(hb_comp['timelevels'])):
                    base[0]['t%02d' % inst] = at.Instant()
                for inst, inst_name in enumerate(base[0].keys()):
                    base[0][inst_name]['u'] = u[:, inst]
            return base

        def post_norm(u, base=None):
            base = _init_base(u=u, base=base)

            norm = 0.
            analytic_norm = 0.        
            for i_name, inst in enumerate(hb_comp['timelevels']):
                delta_u = base[0][i_name]['u'][2:-3] - v_injection(mesh / self.c + inst)[2:-3]
                norm += np.average((delta_u) ** 2.)
                analytic_norm += np.average((v_injection(mesh / self.c + inst)[2:-3]) ** 2.)
            norm /= analytic_norm
            norm = norm ** 0.5
            print 'L2 norm', norm
            return norm

        def post_plot(u, base=None):
            base = _init_base(u=u, base=base)

            plot['base'] = base
            plot.execute()

        def post_save(u, base=None):
            base = _init_base(u=u, base=base)

            time_vect = [0., Lt / 3., 2. * Lt / 3.]
            # temporal interpolation for comparison with analytical solution
            treatment = at.Treatment('hbinterp')
            treatment['base'] = base
            treatment['time'] = [0., Lt / 3., 2. * Lt / 3.]
            treatment['hb_computation'] = hb_comp
            base = treatment.execute()

            # stroing analytical result
            base['analytic'] = at.Zone()
            base['analytic'].shared['x'] = mesh
            for inst, inst_name in enumerate(base[0].keys()):
                base['analytic'][inst_name] = at.Instant()
                base['analytic'][inst]['u'] = v_injection(mesh / self.c + time_vect[inst])
            # raw names for all files
            f_name = os.path.join(self.result_dir,
                                  '%s_N%d' % (self.sim, len(hb_comp['frequencies'])))
            
            writer = at.Writer()
            writer['filename'] = f_name + '_<zone>_<instant>.dat'
            writer['file_format'] = 'column'
            writer['base'] = base
            writer.dump()

        def post_dft(u, base=None):
            base = _init_base(u=u, base=base)
            treatment = at.Treatment('hbdft')
            treatment['base'] = base
            treatment['hb_computation'] = hb_comp
            hb_dft = treatment.execute()

            tmp_dft_resu = []
            tmp_dft_resu.append(np.average(hb_dft[0]['mean']['u']))

            for inst in hb_dft[0].keys():
                if inst.endswith('_mod'):
                    tmp_dft_resu.append(np.average(hb_dft[0][inst]['u']))
            dft_resu = at.Base()
            dft_resu.init()
            dft_resu[0][0]['frequency'] = np.array([0] + [i + 1 for i in range(len(hb_comp['frequencies']))])
            dft_resu[0][0]['u_mod'] = tmp_dft_resu

            dft_analytic = at.Base()
            dft_analytic.init()
            dft_analytic[0][0]['time'] = np.linspace(0, Lt, num=10000, endpoint=False)
            dft_analytic[0][0]['u'] = v_injection(dft_analytic[0][0]['time'])
            
            t = at.Treatment('fft')
            t['base'] = dft_analytic
            tmp_dft_resu = t.execute()

            dft_analytic = at.Base()
            dft_analytic.init()
            dft_analytic[0][0]['frequency'] = tmp_dft_resu[0][0]['frequency'][:11]
            dft_analytic[0][0]['u'] = tmp_dft_resu[0][0]['u_mod'][:11]

            # raw names for all files
            f_name = os.path.join(self.result_dir, '%s' % (self.sim))
            
            writer = at.Writer()
            writer['filename'] = f_name + '_N%d' % len(hb_comp['frequencies']) + '_dft.dat'
            writer['file_format'] = 'column'
            writer['base'] = dft_resu
            writer.dump()

            writer = at.Writer()
            writer['filename'] = f_name + '_analytic' + '_dft.dat'
            writer['file_format'] = 'column'
            writer['base'] = dft_analytic
            writer.dump()

        # =============
        # = TIME LOOP =
        # =============
        j = 0
        base = None
        while j < n_iter:
            u = rk4(u=u, t=j * dt, dt=dt, dx=dx)
            # if j % 100 == 0:
            #     base = post_plot(u=u, base=base)
            j += 1

        post_save(u=u, base=base)
        post_dft(u=u, base=base)
        # =====================
        # = generating figure =
        # =====================
        return post_norm(u=u, base=base)
