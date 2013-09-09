1. Flow around contra-rotating open rotors: general information
    1.1 Background
    1.2 Aerodynamic of an isolated propeller
    1.3 Aerodynamic of a contra-rotating open rotor (avec review des simulations numériques déjà réalisées)
    1.4 A few words on aeroelasticity
- experimental aeroelasticity
- numerical aeroelasticity: (contexte industriel aujourd’hui: plan de mélange pour du rotor/stator
et on veut faire une matrice de calcul Mode / Dephasage => 360 pas possible)

2. Spectral methods
    2.1 state of the art (Numeca / Duke / Stanford / Oxford /  Wyoming / Tenesse / ECL Thouverez)
    2.2 mono-frequential
        - theory
        - advantages
        - applications that can be treated
    2.3 multi-frequential (advantages and questions that it raises)
        - theory
        - advantages
        - applications that can be treated

3. Advantages and limitations of spectral methods
    3.1 Presentation of the toy problem: convection equation
    3.2 Advantages
        - capturing a periodic flow
    3.3 Limitations
        - condition of matrix A issue
            - highlighting the problem
            - solution: non evenly spaced timelevels & preconditionning ?
        - convergence
            - highlighting the problem
            - convergence of spectral methods: analyzing the spectrum of the wake
            - partial conclusion: we may go to industrial applications

4. application to the aeroelasticity of contra-rotating open rotors
    4.1 Presentation of elsA
        - schemes used
        - ALE/ aero-elasticity
    4.2 validation of the proposed approach (STCF 11)
    4.3 aeroelasticity of an isolated contra-rotating open rotor
    4.4 Rotating block configuration: toward installed configurations
    4.5 [NOT SURE] aeroelasticity of an installed contra-rotating open rotor