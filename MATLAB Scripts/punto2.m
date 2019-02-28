%% SCRIPT PROGETTO
clear 
clc
format short

%% Definizione della matrice dei tassi di transizione
a  = 1/30; % a sta per rate lambda (arrivi)
m1 = 1/35; % m1 sta per rate mu_1 della macchina M1
m2 = 1/18; % m2 sta per rate mu_2 della macchina M2

p = 0.1;


Q =[
    -a,         a,          0,          0,          0,          0,          0,          0,          0;
    m1*(1-p),   -m1,        m1*p,       0,          0,          0,          0,          0,          0;
    0,          m2,       -a-m2,        a,          0,          0,          0,          0,          0;
    0,          0,    m1*(1-p),       -m1-m2,    m1*p,          m2,         0,          0,          0;
    0,          0,          0,          m2,      -a-m2,         0,          a,          0,          0;
    0,    m1*(1-p),         0,        m1*p,         0,         -m1,          0,          0,         0;
    0,          0,          0,          0,    m1*(1-p),         0,       -m1-m2,        m1*p,       m2;
    0,          0,          0,          0,          0,          0,          m2,         -m2,        0;
    0,          0,          0,    m1*(1-p),          0,         0,        m1*p,          0,       -m1;]
    
    
%% PUNTO 2: Calcolo analitico delle probabilità stazionarie degli stati per la CTHM (soluzione del sistema)
Q_ = double(Q);
Q_(:,end+1) = ones(size(Q_,1),1)

sol_sys = zeros(size(Q_,1),1);
sol_sys(end+1) = 1

PI = sol_sys'*pinv(Q_)

%% Controllo con il limite 
tinf = 1e10
PI_zero = zeros(1,size(Q,2))
PI_zero(1) = 1

PI_lim = PI_zero*expm(Q*tinf)
% Controllo correttezza PI
for i=1:numel(PI)
    if PI(i) - PI_lim(i) > 1e-5
        fprintf('Errore nel calcolo di PI\n');
        break;
    end
end

%% Calcolo del tempo a cui il sistema va a regime
treg= tempo_a_regime(Q,PI, [1 0 0 0 0 0 0 0 0], 1e-7);


%% Salvataggio DATI:
save('data/PI.mat', 'PI')
save('data/treg.mat', 'treg')
save('data/a.mat', 'a')
save('data/m1.mat', 'm1')
save('data/m2.mat', 'm2')
save('data/p.mat', 'p')