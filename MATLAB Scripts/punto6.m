%% SCRIPT PROGETTO
clear 
clc

%% 
lambda = 1/(30);   % A sta per rate lambda (arrivals)
m1 = 1/35;           % m1 sta per rate mu_1 della macchina M1
m2 = 1/18;           % m2 sta per rate mu_2 della macchina M2

p = 0.1;


Q = [-lambda	,	lambda	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	;
m1*(1-p)	,	-(m1*(1-p) + lambda + m1*(p))	,	lambda	,	m1*(p)	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	;
0	,	m1*(1-p)	,	-(m1*(1-p) + m1*(p))	,	0	,	m1*(p)	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	;
0	,	m2	,	0	,	- (lambda+m2)	,	lambda	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	;
0	,	0	,	m2	,	m1*(1-p)	,	-(m2+m1*(1-p)+lambda+m1*(p))	,	lambda	,	m1*(p)	,	0	,	0	,	0	,	0	,	0	,	0	,	0	;
0	,	0	,	0	,	0	,	m1*(1-p)	,	-(m1*(1-p)+m1*(p)+m2)	,	0	,	m1*(p)	,	m2	,	0	,	0	,	0	,	0	,	0	;
0	,	0	,	0	,	0	,	m2	,	0	,	-(m2 + lambda)	,	lambda	,	0	,	0	,	0	,	0	,	0	,	0	;
0	,	0	,	0	,	0	,	0	,	m2	,	m1*(1-p)	,	-(m2+m1+lambda)	,	0	,	lambda	,	m1*(p)	,	0	,	0	,	0	;
0	,	0	,	m1*(1-p)	,	0	,	0	,	m1*(p)	,	0	,	0	,	-m1	,	0	,	0	,	0	,	0	,	0	;
0	,	0	,	0	,	0	,	0	,	0	,	0	,	m1*(1-p)	,	0	,	-m1-m2	,	0	,	0	,	m2	,	m1*(p)	;
0	,	0	,	0	,	0	,	0	,	0	,	0	,	m2	,	0	,	0	,	-m2-lambda	,	0	,	0	,	lambda	;
0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	-m2	,	0	,	m2	;
0	,	0	,	0	,	0	,	0	,	m1*(1-p)	,	0	,	0	,	0	,	m1*(p)	,	0	,	0	,	-m1	,	0	;
0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	0	,	m2	,	m1*(1-p)	,	m1*(p)	,	0	,	-m2-m1];

Q_ = double(Q);
Q_(:,end+1) = ones(size(Q_,1),1);

sol_sys = zeros(size(Q_,1),1);
sol_sys(end+1) = 1;

PI = sol_sys'*pinv(Q_);

treg_6 = tempo_a_regime(Q,PI, [1 0 0 0 0 0 0 0 0 0 0 0 0 0], 1e-7);

%% Definizione del modello
m = 3; % numero degli eventi
n = 14; % numero degli stati
p = 0.1; 

model_pt_6.m = m;
model_pt_6.n = n;
model_pt_6.p = zeros(n,n,m); % transition probabilities
model_pt_6.p0 = zeros(n,1); % initial state probabilities
model_pt_6.p0 = [ 1 ; 0 ; 0; 0 ; 0 ; 0 ; 0 ; 0 ; 0; 0; 0; 0; 0; 0];


model_pt_6.p(:,1,1) = [ 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,1,2) = NaN*ones(1,14); 
model_pt_6.p(:,1,3) = NaN*ones(1,14);  
 
model_pt_6.p(:,2,1) = [ 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,2,2) = [ 1-p; 0; 0; p; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,2,3) = NaN*ones(1,14);
 
model_pt_6.p(:,3,1) = [ 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,3,2) = [ 0; 1-p; 0; 0; p; 0; 0; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,3,3) = NaN*ones(1,14);
 
model_pt_6.p(:,4,1) = [ 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,4,2) = NaN*ones(1,14);
model_pt_6.p(:,4,3) = [ 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]; 
 
model_pt_6.p(:,5,1) = [ 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,5,2) = [ 0; 0; 0; 1-p; 0; 0; p; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,5,3) = [ 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
 
model_pt_6.p(:,6,1) = [ 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,6,2) = [ 0; 0; 0; 0; 1-p; 0; 0; p; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,6,3) = [ 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0]; 
 
model_pt_6.p(:,7,1) = [ 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,7,2) = NaN*ones(1,14);
model_pt_6.p(:,7,3) = [ 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0]; 
 
model_pt_6.p(:,8,1) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0]; 
model_pt_6.p(:,8,2) = [ 0; 0; 0; 0; 0; 0; 1-p; 0; 0; 0; p; 0; 0; 0]; 
model_pt_6.p(:,8,3) = [ 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0]; 
 
model_pt_6.p(:,9,1) = [ 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,9,2) = [ 0; 0; 1-p; 0; 0; p; 0; 0; 0; 0; 0; 0; 0; 0]; 
model_pt_6.p(:,9,3) = NaN*ones(1,14);

model_pt_6.p(:,10,1) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0]; 
model_pt_6.p(:,10,2) = [ 0; 0; 0; 0; 0; 0; 0; 1-p; 0; 0; 0; 0; 0; p]; 
model_pt_6.p(:,10,3) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0];

model_pt_6.p(:,11,1) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1]; 
model_pt_6.p(:,11,2) = NaN*ones(1,14); 
model_pt_6.p(:,11,3) = [ 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0];

model_pt_6.p(:,12,1) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0]; 
model_pt_6.p(:,12,2) = NaN*ones(1,14);
model_pt_6.p(:,12,3) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1]; 

model_pt_6.p(:,13,1) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0]; 
model_pt_6.p(:,13,2) = [ 0; 0; 0; 0; 0; 1-p; 0; 0; 0; p; 0; 0; 0; 0]; 
model_pt_6.p(:,13,3) = NaN*ones(1,14);

model_pt_6.p(:,14,1) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1]; 
model_pt_6.p(:,14,2) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1-p; p; 0; 0]; 
model_pt_6.p(:,14,3) = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0]; 

%% CALCOLO ANALITICO
muEff_analitico = m1*(1-p)*(PI(2)+PI(3)+PI(5)+PI(6)+PI(8)+PI(9)+PI(10)+PI(13)+PI(14));

%% CALCOLO TRAMITE SIMULAZIONI:

F{1} = 'exprnd(30,1,L)';    % Evento a: distrib. di Poisson con tempo medio di 30min
F{2} = 'exprnd(35,1,L)';        % Evento d1: distrib. di Esponenziale con valore atteso di 35min
F{3} = 'exprnd(18,1,L)';        % Evento d2: distrib. di Esponenziale con valore atteso di 18min

% PARAMETRI SIMULAZIONE:
kmax = 5*1e7;

% SIMULAZIONE:
disp('Inizio Simulazione:')

L = kmax; % length of the clock sequences
eval([ 'V(1,:) = ' F{1} ';' ]);
eval([ 'V(2,:) = ' F{2} ';' ]);
eval([ 'V(3,:) = ' F{3} ';' ]);

[E,X,T] = simprobdes(model_pt_6,V);
disp('Simulazione completata!')

%% CALCOLO muEff - lambdaEff:
% Parametri Conteggio:
Tini = treg_6;      
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
parti_uscite = 0;
for i = sart_id:kmax-1
    if( (X(i)==2 && X(i+1) == 1) || (X(i)==3 && X(i+1) == 2) || (X(i)==5 && X(i+1) == 4) || (X(i)==6 && X(i+1) == 5) || (X(i)==8 && X(i+1) == 7) || (X(i)==9 && X(i+1) == 3) || (X(i)==10 && X(i+1) == 8) || (X(i)==13 && X(i+1) == 6) || (X(i)==14 && X(i+1) == 11) )
        parti_uscite = parti_uscite + 1;
    end
end

% Calcolo dei tassi:
muEff_simulazione = parti_uscite/(Tend - Tini);


%% RISULTATI:
fprintf('\nRISULTATI:')
fprintf('\nAnalitico: %d, Simulazione: %d\n',muEff_analitico,muEff_simulazione)