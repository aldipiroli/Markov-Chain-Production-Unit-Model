%% CLEAR:
clear all
close all
clc
format long

%% CREAZIONE ISTOGRAMMA MEDIE:
load('data/matrix_N1e2.mat')
load('data/matrix_N1e3.mat')
load('data/matrix_N1e4.mat')
load('data/matrix_N1e5.mat')
load('data/PI.mat')

v_avarageM2 = mean(M2)
v_avarageM3 = mean(M3)
v_avarageM4 = mean(M4)
v_avarageM5 = mean(M5)
m_avarage = [PI; v_avarageM5; v_avarageM4; v_avarageM3; v_avarageM2];

figure(1)
bar(m_avarage')
legend('PI Analitico','10^5', '10^4', '10^3', '10^2')
ylabel('\Pi_x')
xlabel('stati ')
axis([0 9.5 0 0.55]);

%% CREAZIONE ISTOGRAMMI VARIANZE:
v_varM2 = var(M2);
v_varM3 = var(M3);
v_varM4 = var(M4);
v_varM5 = var(M5);

% Varianza Stato 1
figure(2)    
subplot(4,1,1), hist(M2(:,1),1000), title ('varianza con N=10^2');
axis([0.2 0.7 0 100])
subplot(4,1,2), hist(M3(:,1),1000), title ('varianza con N=10^3');
axis([0.2 0.7 0 40])
subplot(4,1,3), hist(M4(:,1),1000), title ('varianza con N=10^4');
axis([0.2 0.7 0 20])
subplot(4,1,4), hist(M5(:,1),1000), title ('varianza con N=10^5');
axis([0.2 0.7 0 20])


% Varianza Stato 2
figure(3)    
subplot(4,1,1), hist(M2(:,2),1000), title ('varianza con N=10^2');
axis([0.3 0.8 0 100])
subplot(4,1,2), hist(M3(:,2),1000), title ('varianza con N=10^3');
axis([0.3 0.8 0 40])
subplot(4,1,3), hist(M4(:,2),1000), title ('varianza con N=10^4');
axis([0.3 0.8 0 20])
subplot(4,1,4), hist(M5(:,2),1000), title ('varianza con N=10^5');
axis([0.3 0.8 0 20])

