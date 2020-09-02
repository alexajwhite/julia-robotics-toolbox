# The arm_main file loads all the arm robotics models allowing for them to be
# created through the robot(model) function.

 function robot(model::String)

 end


function Puma560()

    deg = pi/180

    L0 = RevoluteDH(
        d=0,          # link length (Dennavit-Hartenberg notation)
        a=0,          # link offset (Dennavit-Hartenberg notation)
        alpha=pi/2,   # link twist (Dennavit-Hartenberg notation)
        I=[0, 0.35, 0, 0, 0, 0],  # inertia tensor of link with respect to
                                  # center of mass I = [L_xx, L_yy, L_zz,
                                  # L_xy, L_yz, L_xz]
        r=[0, 0, 0],  # distance of ith origin to center of mass [x,y,z]
                      # in link reference frame
        m=0,          # mass of link
        Jm=200e-6,    # actuator inertia
        G=-62.6111,   # gear ratio
        B=1.48e-3,    # actuator viscous friction coefficient (measuredt
                      # at the motor)
        Tc=[0.395, -0.435],  # actuator Coulomb friction coefficient for
                             # direction [-,+] (measured at the motor)
        qlim=[-160*deg, 160*deg],    # minimum and maximum joint angle
        mesh='UNIMATE/puma560/link1.stl')

    L1 = RevoluteDH(
        d=0, a=0.4318, alpha=0,
        I=[0.13, 0.524, 0.539, 0, 0, 0],
        r=[-0.3638, 0.006, 0.2275],
        m=17.4, Jm=200e-6, G=107.815,
        B=.817e-3, Tc=[0.126, -0.071],
        qlim=[-45*deg, 225*deg],
        mesh='UNIMATE/puma560/link2.stl')

    L2 = RevoluteDH(
        d=0.15005, a=0.0203, alpha=-pi/2,
        I=[0.066, 0.086, 0.0125, 0, 0, 0],
        r=[-0.0203, -0.0141, 0.070],
        m=4.8, Jm=200e-6, G=-53.7063,
        B=1.38e-3, Tc=[0.132, -0.105],
        qlim=[-225*deg, 45*deg],
        mesh='UNIMATE/puma560/link3.stl')

    L3 = RevoluteDH(
        d=0.4318, a=0, alpha=pi/2,
        I=[1.8e-3, 1.3e-3, 1.8e-3, 0, 0, 0],
        r=[0, 0.019, 0],
        m=0.82, Jm=33e-6, G=76.0364,
        B=71.2e-6, Tc=[11.2e-3, -16.9e-3],
        qlim=[-110*deg, 170*deg],
        mesh='UNIMATE/puma560/link4.stl')

    L4 = RevoluteDH(
        d=0, a=0, alpha=-pi/2,
        I=[0.3e-3, 0.4e-3, 0.3e-3, 0, 0, 0],
        r=[0, 0, 0], m=0.34,
        Jm=33e-6, G=71.923, B=82.6e-6,
        Tc=[9.26e-3, -14.5e-3],
        qlim=[-100*deg, 100*deg],
        mesh='UNIMATE/puma560/link5.stl')

    L5 = RevoluteDH(
        d=0, a=0, alpha=0,
        I=[0.15e-3, 0.15e-3, 0.04e-3, 0, 0, 0],
        r=[0, 0, 0.032], m=0.09, Jm=33e-6,
        G=76.686, B=36.7e-6, Tc=[3.96e-3, -10.5e-3],
        qlim=[-266*deg, 266*deg],
        mesh='UNIMATE/puma560/link6.stl')

    L = [L0, L1, L2, L3, L4, L5]

    # zero angles, L shaped pose
    qz = [0, 0, 0, 0, 0, 0]

    # ready pose, arm up
    qr = [0, pi/2, -pi/2, 0, 0, 0]

    # straight and horizontal
    qs = [0, 0, -pi/2, 0, 0, 0]

    # nominal table top picking pose
    qn = [0, pi/4, pi, 0, pi/4, 0]

end
