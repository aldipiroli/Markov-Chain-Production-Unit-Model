%% Clear:
clear all
close all 
clc  
%% Caricamento dei dati:
load('data/model.mat')

%% Parametri di Simulazione:
kmax = 150;             % I k passi minimi per raggiungere il t di rigeime.
N = 7*1e5;              % Numero delle simulazioni da effettuare

t = 500;                % Tempo necessario per andare a regime 
M = 250;                % Numero di gruppi di N simulazioni
K = 1;                  % Numero di volte in cui risimuliamo il sistema cambiando N

t_camp = [0:1:t+400];   % Si fa un campionamento su un intervallo più grande rispetto a quello del t di regime così siamo sicuri che ci siamo

%% Definizione Stochastic Clock Structure:
F{1} = 'unifrnd(22,38,1,L)';  % Evento a: distrib. uniforme
F{2} = '35*ones(1,L)';        % Evento d1: deterministico
F{3} = '18*ones(1,L)';        % Evento d2: deterministico
L=kmax;

%% Simulazione:
n = 9;      %stati del sistema

fprintf('Inizio Simulazioni:\n')
for z = 1:K
    matrix_p_blks=zeros(n,M);          
    sum_matrix_state=zeros(n,length(t_camp));
    for j = 1:M  
        disp([' Simulation del ' num2str(j) ' blocco.'])
        matrix_states=zeros(n,length(t_camp));   
        for i = 1:N      
            % Definizione della Clock Sequence
            V = [];
            eval([ 'V(1,:) = ' F{1} ';' ]);
            eval([ 'V(2,:) = ' F{2} ';' ]);
            eval([ 'V(3,:) = ' F{3} ';' ]);

            % Simulazione
            [step,E,X,T] = simprobdes_unif(model,V,length(t_camp));
            matrix_steps = zeros(n,length(t_camp));

            for k = 1 :step-1  
                 if(T(k+1) <= length(t_camp))
                    matrix_steps(X(k),round(T(k)+1):round(T(k+1))) = 1; 
                 else  
                    matrix_steps(X(k),round(T(k)+1):length(t_camp)) = 1; 
                 end
            end
            matrix_states = matrix_states+matrix_steps;
        
       end 
    sum_matrix_state=sum_matrix_state+matrix_states;
    end
end
%% Grafico andamento sistema
m_prob_t=sum_matrix_state/(N*M); %media nel tempo
 
figure(1);
hold on
for sts=1:model.n
    plot(t_camp ,m_prob_t(sts,:));
end 
grid on
title('Probabilità stati');
xlabel('Tempo');
ylabel('Probabilità');
legend('P(X(t)=1)', 'P(X(t)=2)', 'P(X(t)=3)', 'P(X(t)=4)', 'P(X(t)=5)', 'P(X(t)=6)', 'P(X(t)=7)', 'P(X(t)=8)', 'P(X(t)=9)');