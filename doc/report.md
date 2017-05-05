---
institute: Université Pierre et Marie Curie
title: "Synchronous Retrogames in HTML5"
subtitle: Rapport de projet
author:
- Alexandre Doussot
- Encadrant - Pierre-Évariste Dagand
teacher: Pierre-Évariste Dagand
course: 3I013 -- Projet de Recherche
place: Paris
date: \today
header-includes:
  - \usepackage{tikz}
  - \usepackage{listings}
  - \usepackage{color}
  - \usepackage{courier}
  - \usepackage{syntax}
  - \usepackage{fancyvrb}
  - \usepackage{booktabs}
---

\newpage

\include tex_templates/code.tex

\include skeleton/intro.md

\newpage

\include sdf/sdf.md

\newpage

\include compiler/compiler.md

\include parsing/parsing.md

\newpage

\include nsap/nsap.md

\include compiler/scheduler.md

\include sol/sol.md

\include codegen/solgen.md

\newpage

\include sol/sol_translation.md

\include js/engine.md

\newpage

\include skeleton/future.md 

\include skeleton/conclusion.md

\newpage

\include skeleton/references.md

\newpage

\include skeleton/annex.md