%% CLEAR:
clear all
close all
clc
%% CALCOLO ANALITICO:
% Caricamento dati:
load('data/PI.mat') 
load('data/treg.mat') 
load('data/a.mat')
load('data/m1.mat')
load('data/m2.mat')
load('data/p.mat')

% Calcolo dei tassi della superficie:
lambda_sigma_analitico = m1*p*( PI(2) + PI(6) + PI(9) ) + m2*( PI(5) + PI(8)) + m1*(1-p)*( PI(9) );
EX_sigma_analitico = 0*( PI(1) + PI(2) ) + 1*( PI(3) + PI(4) + PI(5) + PI(6) + PI(7) + PI(8) + PI(9));
ES_sigma_analitico = EX_sigma_analitico / lambda_sigma_analitico;

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

sart_id = 0;
t_size = size(T);
t_size = t_size(1,2);

for i = 1:t_size
    if (T(i)>= Tini && X(i)==1)
        sart_id = i;
        break
    end
end

if sart_id == 0
    disp('ERRORE: indice inizio simulazione non trovato.')
    pause();
end


%% Calcolo del numero medio di parti entranti in M2:
parti_entrate = 0;
x_size = size(X);
x_size = x_size(1,2);

for i = sart_id:x_size-1
    if( (X(i)==2 && X(i+1) == 3) || (X(i)==6 && X(i+1) == 4) || (X(i)==9 && X(i+1) == 7) || (X(i)==9 && X(i+1) == 4) || (X(i)==5 && X(i+1) == 4) || (X(i)==8 && X(i+1) == 7) )
        parti_entrate = parti_entrate + 1;
    end
end

lambda_sigma_simulazione = parti_entrate / (Tend - Tini);

%% Calcolo tempo medio di soggiorno delle parti in M2:
T_entrata = 0;
T_uscita = 0;
T_tot = 0;
conta_int = 0;
conta_out = 0;

controlla = 0;

x_size = size(X);
x_size = x_size(1,2);

i = sart_id;
while i < x_size-1
    if( (X(i)==2 && X(i+1) == 3) || (X(i)==6 && X(i+1) == 4) || (X(i)==9 && X(i+1) == 7) || (X(i)==9 && X(i+1) == 4) || (X(i)==5 && X(i+1) == 4) || (X(i)==8 && X(i+1) == 7) )
        T_entrata = T(i+1);
        conta_int = conta_int + 1;
        
        for j = i+1:x_size-1
            if( (X(j) == 3 && E(j) == 3) || (X(j) == 5 && E(j) == 3) || (X(j) == 8 && E(j) == 3) || (X(j) == 6 && E(j) == 2) || (X(j) == 9 && E(j) == 2))
                T_uscita = T(j+1);
                conta_out = conta_out + 1 ;
                i = j;
                T_tot = T_tot + (T_uscita - T_entrata);
                break
            end
        end
    else
        i = i+1;
    end
end
ES_sigma_simulazione = T_tot / conta_out; 

%% RISULTATI:
fprintf('\nRISULTATI:')
fprintf('\nLambda sigma:')
fprintf('\nAnalitico: %d, Simulazione: %d',lambda_sigma_analitico, lambda_sigma_simulazione)

fprintf('\nES sigma:')
fprintf('\nAnalitico: %d, Simulazione: %d',ES_sigma_analitico, ES_sigma_simulazione)
fprintf('\nEX sigma:')
fprintf('\nAnalitico: %d',EX_sigma_analitico)

%% Calcolo valore atteso del numero di parti all’interno della superficie:
clear all

% DEFINIZIONE DEL MODELLO:
load('data/model.mat')
load('data/PI.mat') 
load('data/treg.mat')  

F{1} = 'exprnd(30,1,L)';        % Evento a: distrib. di Poisson con tempo medio di 30min
F{2} = 'exprnd(35,1,L)';        % Evento d1: distrib. di Esponenziale con valore atteso di 35min
F{3} = 'exprnd(18,1,L)';        % Evento d2: distrib. di Esponenziale con valore atteso di 18min

% PARAMETRI SIMULAZIONE:
kmax = 350;
t = treg;
N = 7*1e5;    % numero delle simulazioni

% SIMULAZIONE:
resoults_matrix = zeros(N,1);
for i = 1:N
    
    L = kmax; % length of the clock sequences
    eval([ 'V(1,:) = ' F{1} ';' ]);
    eval([ 'V(2,:) = ' F{2} ';' ]);
    eval([ 'V(3,:) = ' F{3} ';' ]);
    [E,X,T] = simprobdes(model,V);
    t_size = size(T);
    t_size = t_size(1,2);
    for j = 1:t_size-1
        if((t>T(j)) && (t<T(j+1)))
            resoults_matrix(i,:) = X(j);
            break
        end
    end
end

count = 0;
for i = 1:N
    if ( (resoults_matrix(i) ~= 1 ) && ( resoults_matrix(i) ~= 2) )
        count = count + 1; 
    end
end
EX_sigma_simulazione = count / N;
fprintf(', Simulazione: %d',EX_sigma_simulazione) 