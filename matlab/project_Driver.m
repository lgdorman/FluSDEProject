
close all
clear all

run('..\add_to_path.m');

%%
csvFile = '..\influenza-surveillance-data\public-health-laboratory-influenza-respiratory-virus-surveillance-data-by-region-and-influenza-season.csv';

loadFluData(csvFile);