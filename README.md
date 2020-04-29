# IntermittentBaroreflex
This repository contains code for the model-based data analysis described in the manuscript “Intermittent functioning of baroreflex contributes to the etiology of hypertension in spontaneously hypertensive rats” by Feng et al.. The code is as follows: 

Drivers: 
createdatafile.m - This code reads in the .txt data files in the following folders. This takes in 12 5-minute time series, one at each hour of the 12-hour dark cycle for each rat and generates a data.mat file containing matrices of the pulse, systolic, and diastolic pressures, heart rate, and RR intervals. 
optpars.m - This code reads in the data.mat file created from createdatafile.m and optimizes the parameters tau and alpha in the model via the function model_sol.m. The output is optimal.mat.
calculateONfraction.m - This code reads in the optimal.mat file generated from optpars.m and post-processes the results. It calculates the on fraction and determines convergence. It also calls many plotting functions. The output are the on fraction and .txt files determining the on and off states. 

Functions: 
model_sol.m - This code solves the model and computes the cost functional J that is optimized to produce parameters tau and alpha. 

Plotters: 
plot_BP_HR_RR.m - This function plots the blood pressure, heart rate, and RR intervals from the data similar to Figure 2 panels a and b in the manuscript. 
plot_hyperbolas.m - This function plots Figure 2 panel c in the manuscript.
plot_preOF.m - This function plots the optimized model results with the on fraction before applying the 10 second smoothing window. 
plot_OF.m - This function plots the optimized model results with the on fraction after applying the 10 second smoothing window. 
plot_drift.m - This function plots the regions where the baroreflex is on and normalizes each region as in Figure 2 panel e. 

