%% CLEAR:
clear all
close all
clc

%% CALCOLO TRAMITE SIMULAZIONI:

% DEFINIZIONE DEL MODELLO:
load('data/model.mat')

F{1} = 'unifrnd(22,38,1,L)';  % Evento a: distrib. uniforme
F{2} = '35*ones(1,L)';        % Evento d1: deterministico
F{3} = '18*ones(1,L)';        % Evento d2: deterministico

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
Tini = 500;     %1e5
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
fprintf('\nLambda Efficace simulato nel caso di eventi che seguono\ndistribuzioni uniformi e deterministiche: %d',lambdaEff_simulazione)

fprintf('\nMu Efficace simulato nel caso di eventi che seguono\ndistribuzioni uniformi e deterministiche: %d\n\n',muEff_simulazione)