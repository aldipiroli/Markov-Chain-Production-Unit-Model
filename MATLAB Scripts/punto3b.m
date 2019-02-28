clear all
clc
%%
load('data/singole_sim/aldi/matrix_N1e2.mat')
M2Aldi = matrix_N1e2
load('data/singole_sim/giovanni/matrix_N1e2.mat')
M2Giovans = matrix_N1e2
load('data/singole_sim/miche/matrix_N1e2.mat')
M2Miche = matrix_N1e2
load('data/singole_sim/mihai/matrix_N1e2.mat')
M2Mihai = matrix_N1e2

M2 = [M2Aldi;M2Giovans;M2Miche;M2Mihai]

load('data/singole_sim/aldi/matrix_N1e3.mat')
M3Aldi = matrix_N1e3
load('data/singole_sim/giovanni/matrix_N1e3.mat')
M3Giovans = matrix_N1e3
load('data/singole_sim/miche/matrix_N1e3.mat')
M3Miche = matrix_N1e3
load('data/singole_sim/mihai/matrix_N1e3.mat')
M3Mihai = matrix_N1e3

M3 = [M3Aldi;M3Giovans;M3Miche;M3Mihai]

load('data/singole_sim/aldi/matrix_N1e4.mat')
M4Aldi = matrix_N1e4
load('data/singole_sim/giovanni/matrix_N1e4.mat')
M4Giovans = matrix_N1e4
load('data/singole_sim/miche/matrix_N1e4.mat')
M4Miche = matrix_N1e4
load('data/singole_sim/mihai/matrix_N1e4.mat')
M4Mihai = matrix_N1e4

M4 = [M4Aldi;M4Giovans;M4Miche;M4Mihai]

load('data/singole_sim/aldi/matrix_N1e5.mat')
M5Aldi = simulation_matrix
load('data/singole_sim/giovanni/matrix_N1e5.mat')
M5Giovans = matrix_N1e5
load('data/singole_sim/miche/matrix_N1e5.mat')
M5Miche = matrix_N1e5
load('data/singole_sim/mihai/matrix_N1e5.mat')
M5Mihai = matrix_N1e5

M5 = [M5Aldi;M5Giovans;M5Miche;M5Mihai]

save('data/matrix_N1e2.mat', 'M2');
save('data/matrix_N1e3.mat', 'M3');
save('data/matrix_N1e4.mat', 'M4');
save('data/matrix_N1e5.mat', 'M5');
