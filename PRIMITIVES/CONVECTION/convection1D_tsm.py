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


def main(harm_computed, cfl, n_mesh, c, case, sim):
    # ===============================
    # = Computing some stuff needed =
    # ===============================
    Lx = 1.  # total size of the mesh in meters
    # pulsation of the temporal phenomenon
    omega_t = 2. * pi * c / Lx
    n_mesh += 1
    # temporal frequency of the injection
    base_freq = omega_t / (2. * pi)
    # intializing antares hb_comp from user data
    hb_comp = at.HbComputation()
    hb_comp['frequencies'] = np.array(harm_computed)  * base_freq
    # hb_comp = hb_comp.optimize_timelevels()
    Lt = Lx / c
    dx = Lx / float(n_mesh)
    # dt stability for TSM computations (see Sicot's thesis)
    dt = cfl * dx / (c + max(harm_computed) * omega_t * dx)
    n_iter = int(Lt / dt)
    n_iter *= 2
    # building mesh coordinates
    mesh = np.arange(n_mesh) * dx
    # initializing u
    u = np.ones((n_mesh, len(hb_comp['timelevels'])))

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
        dv = 0.12
        width = 0.3
        # the similarity law (velocity is normalized)
        return (1. - dv * np.exp(-0.693 * (2 * t / (Lt * width)) ** 2.))

    def inj_sin(t, f_1, f_2):
        "Sinusoidal function"
        return np.sin(f_1 * omega_t * t) + np.sin(f_2 * omega_t * t)

    def inj_multiple_sin(t):
        "Sinusoidal function"
        return (np.sin(omega_t * t) +
                np.cos(2 * omega_t * t) +
                np.sin(omega_t * 17. * t))

    def inj_step(t):
        "Step function"
        return 0.5 * (np.sign(t) + 1)

    if case == 'SIN_1':
        injection = lambda t: inj_sin(periodicity_operator(t), 
                                      f_1=1., f_2=1.)
    elif case == 'SIN_2':
        injection = lambda t: inj_sin(periodicity_operator(t), 
                                      f_1=1., f_2=2.)
    elif case == 'SIN_3':
        injection = lambda t: inj_sin(periodicity_operator(t), 
                                      f_1=1., f_2=10.)

    source_term_op = hb_comp.ap_source_term()
    v_injection = np.vectorize(injection)
    # ghost cells boundary condition
    bnd_injection = v_injection(hb_comp['timelevels'])
    bnd_injection_gc_m = v_injection(hb_comp['timelevels'] + 1. * dx * cfl / c)
    bnd_injection_gc_m2 = v_injection(hb_comp['timelevels'] + 2. * dx * cfl / c)


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
            up2 = u_gc[4:]
            up = u_gc[3:-1]
            um = u_gc[1:-3]
            um2 = u_gc[:-4]
            dy = np.concatenate((((-up2 + 8. * up - 8. * um + um2) / (12. * dx)),
                                 [(3. * u[-2] - 4. * u[-3] + u[-4]) / (2. * dx)],
                                 [(u[-1] - u[-2]) / dx]))
            return dy

        u_prime = fourth_order_centered(u=y, dx=dx, t=t)

        return -c * u_prime


    def post_norm(u, base=None):
        if base is None:
            base = at.Base()
            base.init(instants=['t%02d' % i for i in range(len(hb_comp['timelevels']))])
            base[0].shared['x'] = mesh
            for inst in range(len(hb_comp['timelevels'])):
                base[0]['t%02d' % inst] = at.Instant()
        for inst, inst_name in enumerate(base[0].keys()):
            base[0][inst_name]['u'] = u[:, inst]
        t = 0.
        # temporal interpolation for comparison with analytical solution
        treatment = at.Treatment('hbinterp')
        treatment['base'] = base
        treatment['time'] = t
        treatment['hb_computation'] = hb_comp
        result = treatment.execute()

        result[0]['analytic'] = at.Instant()
        result[0]['analytic']['u'] = v_injection(mesh / c + t)
        plot['base'] = result
        plot.execute()

        u = result[0][0]['u']
        analytic = result[0]['analytic']['u']

        delta_u = u[2:-3] - analytic[2:-3]
        norm = [np.average(np.abs(delta_u)),
                ((np.average((delta_u) ** 2.)) ** 0.5),
                np.max(delta_u)]
        print 'L1 norm', norm[0]
        print 'L2 norm', norm[1]
        print 'Linf norm', norm[2]
        return norm

    def post_plot(u, base=None):
        if base is None:
            base = at.Base()
            base.init(instants=['t%02d' % i for i in range(len(hb_comp['timelevels']))])
            base[0].shared['x'] = mesh
            for inst in range(len(hb_comp['timelevels'])):
                base[0]['t%02d' % inst] = at.Instant()
        for inst, inst_name in enumerate(base[0].keys()):
            base[0][inst_name]['u'] = u[:, inst]
        plot['base'] = base
        plot.execute()

    def post_save(u, base=None):
        if base is None:
            base = at.Base()
            base.init(instants=['t%02d' % i for i in range(len(hb_comp['timelevels']))])
            base[0].shared['x'] = mesh
            for inst in range(len(hb_comp['timelevels'])):
                base[0]['t%02d' % inst] = at.Instant()
        for inst, inst_name in enumerate(base[0].keys()):
            base[0][inst_name]['u'] = u[:, inst]
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
            base['analytic'][inst]['u'] = v_injection(mesh / c + time_vect[inst])
        # raw names for all files
        path = os.path.join('RESULTS', case)
        if not os.path.isdir(path):
            os.makedirs(path)
        f_name = os.path.join(path,
                              '%s_N%d' % (sim, len(hb_comp['frequencies'])))
        
        writer = at.Writer()
        writer['filename'] = f_name + '_<zone>_<instant>.dat'
        writer['file_format'] = 'column'
        writer['base'] = base
        writer.dump()

    # =============
    # = TIME LOOP =
    # =============
    j = 0
    base = None
    while j < n_iter:
        u = rk4(u=u, t=j * dt, dt=dt, dx=dx)
        if j % 100 == 0:
            base = post_plot(u=u, base=base)
        j += 1

    post_save(u=u, base=base)
    # =====================
    # = generating figure =
    # =====================
    os.chdir('FIGS')
    dict_tag2rep = {'nharm':len(harm_computed), 
                    'case':case, 'sim':sim}
    new_gp = replace_in_file('CONVECTION.gp', dict_tag2rep)
    # write macro
    f = open('tmp.gp', 'w')
    f.write(new_gp)
    f.close()
    # launch tecplot
    launch_command(['gnuplot', os.path.join(os.path.abspath('.'), 'tmp.gp')])
    launch_command(['/Users/gomar/Documents/Development/SHELL_tools/epslatex2eps.sh',
                    'CONVECTION_{case}_{sim}_N{nharm}.tex'.format(**dict_tag2rep)])
    os.remove('tmp.gp')
    os.remove('CONVECTION_{case}_{sim}_N{nharm}.eps'.format(**dict_tag2rep))
    return post_norm(u=u, base=base)


main(harm_computed=(np.arange(8) + 1), cfl=1., n_mesh=2000, c=1., case='SIN_3', sim='TSM')

