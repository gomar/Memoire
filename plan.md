# Flow around contra-rotating open rotors: general information
    * Background
    * Aerodynamic of an isolated propeller
    * Aerodynamic of a contra-rotating open rotor
        - review of the numerical simulations
    * A few words on aeroelasticity
        - experimental aeroelasticity
        - numerical aeroelasticity: contexte industriel:
            aeroelasticity = plan de mélange pour du rotor/stator
        - matrice de calcul 2 modes * 8 dephasages: impossible à 
        faire en DTS 360

# Harmonic balance methods
    * state of the art
        - Numeca
        - Duke
        - He
    * mono-frequential
        - theory
        - advantages
        - applications that can be treated
    * multi-frequential (advantages and questions that it raises)
        - theory
        - advantages
        - applications that can be treated

[JALON] FIN SEPTEMBRE
[BREAK] on doit comprendre en quoi les méthodes spectrales sont intéressantes
pour l'aéro-élasticité des CROR

mettre en perpective le fait que je fait des tests sur un modèle réduit mais
que je ne perds pas de vue que certains effets s'ajouterons lorsque je mets tout
en même temps
# Validation
    * Presentation of the toy problem: convection equation
    * Advantages
        - capturing a periodic flow
    * Limitations
        - condition of matrix A issue
            - highlighting the problem
            - solution: non evenly spaced timelevels
        - convergence
            - highlighting the problem
            - convergence of spectral methods: analyzing the spectrum of the wake
            - partial conclusion: we may go to industrial applications

[JALON] FIN OCTOBRE: STCF11 et les deux partie du dessus 

# application to the aeroelasticity of contra-rotating open rotors
    * elsA 
        - schemes
        - ALE/aero-elasticity
    * validation of the proposed approach (STCF 11) + NON EQUI et CONVERGENCE
    * aeroelasticity of an isolated contra-rotating open rotor + NON EQUI et CONVERGENCE
    * Rotating block configuration: toward installed configurations
    * [NOT SURE] aeroelasticity of an installed contra-rotating open rotor

[JALON] FIN NOVEMBRE: draft final

Rapporteurs:
- Van der weide
- Chassaing Paris VI
- quelqu'un de Cambridge pour faire de la pub à Dyson