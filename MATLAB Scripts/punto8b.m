%% CLEAR:
clear all
close all
clc
%% 
% DEFINIZIONE DEL MODELLO:
load('data/model.mat')

F{1} = 'unifrnd(22,38,1,L)';  % Evento a: distrib. uniforme
F{2} = '35*ones(1,L)';        % Evento d1: deterministico
F{3} = '18*ones(1,L)';        % Evento d2: deterministico

% PARAMETRI SIMULAZIONE:
kmax = 1e7;

% SIMULAZIONE:
disp('Inizio Simulazione:')
L = kmax; 
eval([ 'V(1,:) = ' F{1} ';' ]);
eval([ 'V(2,:) = ' F{2} ';' ]);
eval([ 'V(3,:) = ' F{3} ';' ]);

[E,X,T] = simprobdes(model,V); 
disp('Simulazione completata!')

% Parametri Conteggio:
Tini = 500;      
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
fprintf('\nLambda sigma simulazione: %d',lambda_sigma_simulazione)
fprintf('\nES sigma simulazione: %d',ES_sigma_simulazione)
 

%% Calcolo valore atteso del numero di parti all'interno della superficie:
 
% PARAMETRI SIMULAZIONE:
kmax = 150;
t = 600;
N = 7*1e5;    % numero delle simulazioni
L = kmax; % length of the clock sequences
    
% SIMULAZIONE:
resoults_matrix = zeros(N,1);
for i = 1:N 
    V=[];
    eval([ 'V(1,:) = ' F{1} ';' ]);
    eval([ 'V(2,:) = ' F{2} ';' ]);
    eval([ 'V(3,:) = ' F{3} ';' ]);
    [E,X,T] = simprobdes(model,V);
    t_size = size(T);
    t_size = t_size(1,2);
    for j = 1:t_size-1
        if((t>T(j)) && (t<T(j+1)))
            resoults_matrix(i,:) = X(j); 
        end
    end
end

count = 0;
for i = 1:N
    if ( (resoults_matrix(i) ~= 1 ) && ( resoults_matrix(i) ~= 2) )
        count = count + 1; 
    end
end
%% RISULTATI 
EX_sigma_simulazione = count / N;
fprintf('\nEX sigma simulazione: %d\n',EX_sigma_simulazione) 
fprintf('\nPer verificare la legge di Little si deve avere ES_sigma simulato uguale al rapporto tra EX_sigma e Lambda_sigma simulati.\n');

fprintf('\nES_sigma = %d  Rapporto EX_sigma / Lambda_sigma = %d\n',ES_sigma_simulazione,EX_sigma_simulazione/lambda_sigma_simulazione); 
