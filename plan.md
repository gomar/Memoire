# Écoulement dans les hélices contra-rotatives: données générales
    * contexte
    * aérodynamique d'une hélice
    * aérodynamique des hélices contra-rotatives
    * quelques mots sur l'aéro-élasticité (méthodes utilisées pour l'AEL)
        - expé
        - numérique (TSM et lorsque plusieurs fréquences: HBT car temps de calcul DTS trop élevé)

# Généralités
    * équation que je résous / schémas utilisés
    * elsA
    * présentation AEL / ALE

# Méthode d'équilibrage harmonique multi-fréquentielle
    * état de l'art
    * TSM
    * HBT, difficultés qui apparaissent
    * canal où ça marche (avantages)
        - sinusoide
        - clocking / sillage ?
    * canal où ça ne marche pas
        - instants équi-répartis
        - signal que je veux capturer (sinusoïdes, step, gaussienne)

# Amélioration de l'approche
    * algorithme de choix des instants (OPT JCP)
    * convergence en nbre d'harmoniques: juste outils d'analyse à appliquer au cas canal
    * conclusion partielle: on peut aller vers des applis industrielles

# Application à l'aéro-élasticité des hélices contra-rotatives
    * validation de l'approche retenue (STCF 11)
        - les configurations standards de Fransson et al.
        - cas subsonique
        - cas transsonique
    * aéro-élasticité d'un doublet isolé
    * aéro-élasticité d'un doublet avec pylône
