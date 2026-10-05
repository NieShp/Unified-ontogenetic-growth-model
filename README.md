# Code for the stoichiometric growth model

This repository contains the MATLAB code used to generate the main results
and figures presented in the manuscript.

## Files

- body_mass_increase.m
  Core function implementing the ontogenetic growth model described by
  Equations (1)–(10) in the main text.

- main_Figure_2_plot.m
  Generates Figure 2.

- main_Figure_3_run.m
  Simulates consumer final body mass and stoichiometry across combinations
  of food ingestion rate and food nutrient-to-carbon ratio.

- main_Figure_3_plot.m
  Generates Figure 3 from the simulation outputs.

- main_Figure_4_run_plot/
  Contains the simulation and plotting scripts used to generate Figure 4.

## Software

The analyses were conducted in MATLAB.

## Usage

Run the corresponding `main_Figure_*_run.m` scripts to generate simulation
outputs, followed by the associated plotting scripts to reproduce the figures.
