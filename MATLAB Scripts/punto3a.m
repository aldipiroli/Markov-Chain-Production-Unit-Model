%% Clear:
clear all 
close all 
clc 
load('data/treg.mat') 

%% Parametri di Simulazione:
kmax = 350;        % Indice del numero di passi/eventi da effettuare per ogni singola simulazione
N = 1e2;           % Numero delle simulazioni da effettuare
t = treg;          % Istante al quale il sistema e' gia' abbondantemente a regime
M = 250;           % Numero di gruppi di N simulazioni
K = 4;             % Numero di volte in cui risimuliamo il sistema cambiando N

tempoEsecuzione = 0;
tempoTotale = 0;

%% Definizione del modello
m = 3; % numero degli eventi
n = 9; % numero degli stati
p = 0.1; 

model.m = m;
model.n = n;
model.p = zeros(n,n,m); 
model.p0 = zeros(n,1);        
model.p0 = [ 1 ; 0 ; 0; 0 ; 0 ; 0 ; 0 ; 0 ; 0];


model.p(:,1,1) = [ 0; 1; 0; 0; 0; 0; 0; 0; 0]; 
model.p(:,1,2) = NaN*ones(1,9); 
model.p(:,1,3) = NaN*ones(1,9);  
 
model.p(:,2,1) = [ 0; 1; 0; 0; 0; 0 ; 0 ; 0 ; 0];
model.p(:,2,2) = [ 1-p; 0; p; 0 ; 0 ; 0 ; 0 ; 0 ; 0]; 
model.p(:,2,3) = NaN*ones(1,9);
 
model.p(:,3,1) = [ 0; 0; 0; 1; 0; 0; 0; 0; 0];
model.p(:,3,2) = NaN*ones(1,9);
model.p(:,3,3) = [ 0; 1; 0; 0; 0; 0 ; 0 ; 0 ; 0];
 
model.p(:,4,1) = [ 0; 0; 0; 1; 0; 0; 0; 0; 0];
model.p(:,4,2) = [ 0; 0; 1-p; 0; p; 0; 0; 0; 0];
model.p(:,4,3) = [ 0; 0; 0; 0; 0; 1; 0; 0; 0];
 
model.p(:,5,1) = [ 0; 0; 0; 0; 0; 0; 1; 0; 0];
model.p(:,5,2) = NaN*ones(1,9);
model.p(:,5,3) = [ 0; 0; 0; 1; 0; 0; 0; 0; 0];
 
model.p(:,6,1) = [ 0; 0; 0; 0; 0; 1; 0; 0; 0];
model.p(:,6,2) = [ 0; 1-p; 0; p; 0; 0; 0; 0; 0];
model.p(:,6,3) = NaN*ones(1,9);
 
model.p(:,7,1) = [ 0; 0; 0; 0; 0; 0; 1; 0; 0];
model.p(:,7,2) = [ 0; 0; 0; 0; 1-p; 0; 0; p; 0];
model.p(:,7,3) = [ 0; 0; 0; 0; 0; 0; 0; 0; 1];
 
model.p(:,8,1) = [ 0; 0; 0; 0; 0; 0; 0; 1; 0];
model.p(:,8,2) = NaN*ones(1,9);
model.p(:,8,3) = [ 0; 0; 0; 0; 0; 0; 1; 0; 0];
 
model.p(:,9,1) = [ 0; 0; 0; 0; 0; 0; 0; 0; 1];
model.p(:,9,2) = [ 0; 0; 0; 1-p; 0; 0; p; 0; 0];
model.p(:,9,3) = NaN*ones(1,9);

save('data/model.mat','model')

% Definizione Stochastic Clock Structure:
F{1} = 'exprnd(30,1,L)';        % Evento a: distrib. di Poisson con tempo medio di 30min
F{2} = 'exprnd(35,1,L)';        % Evento d1: distrib. di Esponenziale con valore atteso di 35min
F{3} = 'exprnd(18,1,L)';        % Evento d2: distrib. di Esponenziale con valore atteso di 18min
L=kmax;

%% Simulazione:
fprintf('Inizio Simulazioni:\n')
for k = 1:K
    fprintf('\nSimulazione numero %d con N = %d', k,N)
    simulation_matrix = zeros(M, model.n); 
    tempoTotale = 0;
    rng('shuffle'); 
    for j = 1:M  
       px_est = []; % Inserisco lo stato al tempo t per ogni N-esima simulazione 
       tStart = tic;
       for i = 1:N      
        % Definizione della Clock Sequence
        V = [];
       
        eval([ 'V(1,:) = ' F{1} ';' ]);
        eval([ 'V(2,:) = ' F{2} ';' ]);
        eval([ 'V(3,:) = ' F{3} ';' ]);

        % Simulazione
        [E,X,T] = simprobdes(model,V);

        % Valutazione dello stato al tempo t
        if T(end) < t
            display('Il sistema non è andato a regime per il t scelto!')
            k = 4;
            break
        end

        for h = 1:length(T)-1
           if (t>=T(h))&&(t<T(h+1))
               px_est(end+1) = X(h);
               break;
           end
        end

       end
        % Conto le occorrenze dei vari stati al tempo t nell'N-esima simulazione e ne calcolo le probabilita'
        px_aux = zeros(1,model.n);
        for i = 1:(model.n)
            px_aux(i) = sum(px_est == i) / length(px_est);
        end
        simulation_matrix(j,:) = px_aux;
        tEnd = toc(tStart);
        tempoTotale = tempoTotale + tEnd;
        tempoEsecuzione = tempoEsecuzione + tempoTotale;
        fprintf('\nN = %d, ciclo: %d, tempo ciclo: %4.f sec',N, j, tEnd)
    end
    save_m = strcat('data/singole_sim/CREACARTELLACONNOMEMEMEBRO/matrix_N1e', num2str(k+1),'.mat') 
    save(save_m, 'simulation_matrix');
    N = N*10;
    fprintf('\nProgramma in esecuzione da: %.f sec \n', tempoEsecuzione)
end

fprintf('\n--- FINE DELLA SIMULAZIONE ---\n')