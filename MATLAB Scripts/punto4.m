%% CLEAR:
clear all
close all
clc

%% CALCOLO ANALITICO:
load('data/PI.mat') 
load('data/treg.mat')
load('data/a.mat')
load('data/m1.mat')
load('data/m2.mat')
load('data/p.mat')

lambdaEff_analitico = a*(PI(1)+PI(3)+PI(5));
muEff_analitico = m1*(1-p)*(PI(2)+PI(4)+PI(6)+PI(7)+PI(9));

%% CALCOLO TRAMITE SIMULAZIONI:

% DEFINIZIONE DEL MODELLO:
load('data/model.mat')

F{1} = 'exprnd(30,1,L)';        % Evento a: distrib. di Poisson con tempo medio di 30min
F{2} = 'exprnd(35,1,L)';        % Evento d1: distrib. di Esponenziale con valore atteso di 35min
F{3} = 'exprnd(18,1,L)';        % Evento d2: distrib. di Esponenziale con valore atteso di 18min

% PARAMETRI SIMULAZIONE:
kmax = 1e7;

% SIMULAZIONE:
disp('Inizio Simulazione:')

L = kmax; % length of the clock sequences
eval([ 'V(1,:) = ' F{1} ';' ]);
eval([ 'V(2,:) = ' F{2} ';' ]);
eval([ 'V(3,:) = ' F{3} ';' ]);

[E,X,T] = simprobdes(model,V);
disp('Simulazione completata!')

% CALCOLO muEff - lambdaEff:

% Parametri Conteggio:
Tini = treg;     
Tend = T(end);

% Calcolo indice inizio simulazione: 
indice_trovato = 0;
for i = 1:kmax-1
    if (T(i)>= Tini && X(i)==1)
        sart_id = i;
        indice_trovato = 1;
        break
    end
end

if indice_trovato == 0
    disp('ERRORE: indice inizio simulazione non trovato.')
    pause();
end

% Calcolo pezzi entrati, pezzi usciti:
parti_entrate = 0;
parti_uscite = 0;
for i = sart_id:kmax-1
    if( (X(i)==1 && X(i+1) == 2) || (X(i)==3 && X(i+1) == 4) || (X(i)==5 && X(i+1) == 7) )
        parti_entrate = parti_entrate + 1;
    end
    
    if( (X(i)==2 && X(i+1) == 1) || (X(i)==4 && X(i+1) == 3) || (X(i)==6 && X(i+1) == 2) || (X(i)==7 && X(i+1) == 5) ||  (X(i)==9 && X(i+1) == 4) )
        parti_uscite = parti_uscite + 1;
    end
end

% Calcolo dei tassi:
lambdaEff_simulazione = parti_entrate /(Tend - Tini);
muEff_simulazione = parti_uscite/(Tend - Tini);


%% RISULTATI:

fprintf('\nRISULTATI:')
fprintf('\nLambda Efficace:\n')
fprintf('Analitico: %d, Simulazione: %d',lambdaEff_analitico,lambdaEff_simulazione)

fprintf('\nMu Efficace:\n')
fprintf('Analitico: %d, Simulazione: %d',muEff_analitico,muEff_simulazione)
save('data/muEff_analitico.mat','muEff_analitico');