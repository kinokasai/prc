# Introduction

Retrogames were played in the dark arcade rooms of the past millenium. Such games were written
in assemby so as to squeeze every bit of performance from hardware that weren't clocked at more than a few Megahertz.
Nowadays, a mere smartphone harnesses several Megabytes of RAM and multiple
processor cores clocked at several Gigahertz each.
Such power allows us to revisit game programming: ease of development takes the
lead while performance is sidelined.

Web browsers are ubiquitous - and are quickly becoming the defacto platform to
run multiplatform apps.
Furthermore, the new web standard HTML5 [1] greatly simplifies the deployment of
dynamic application through the Javascript language. Notably, the `canvas` [2]
interface allows to draw objects, animate them, and intercept inputs from mouse
or keyboards in a Web page.

The canvas API imposes a reactive programming paradigm: in order to update the
canvas, one should register a callback function through `requestAnimationFrame()` [3].
 One has to do the same to process input.

The reactive limitations imposed by the canvas API is similar to what is used in
control-command systems. Several languages, based on the synchronous dataflow
paradigm, have been created in order to ease development of such systems.
A program written in such a language processes a flow of events -
player inputs - and produces a flow of actions corresponding to instructions that will
be transmitted to the actuators.

In this internship, we aimed at applying this programming model to gameplay code
implementation. As such, we devised our own programming language `SAP`, as well of
our own compiler - `SMUDGE` - closely
based on the one described in [\ref{Pouzet}]. We also conceived a Javascript runtime
library. Finally, we used the `SAP` language to produce a game - the well-known Snake.

The report is structured as follow. We first explain features and operation
of the synchronous data flow paradigm as well as introduce our language.

We then explain in depth the several passes of our compiler: `Parsing`, `Normalization`,
`Scheduling`, `Intermediate Code Generation` and `Javascript Code Generation`.

Finally, we touch on how the generated code can be used by game developers.