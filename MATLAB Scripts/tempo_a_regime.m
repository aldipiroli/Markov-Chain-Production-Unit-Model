function [ temp, error ] = tempo_a_regime(Q,pi, pi_zero, max_error)
% funzione che restituisce il tempo
% Q;            è la matrice iniziale del sistema
% pi;           è il vettore delle probabilità calcolato analiticamente
% max_error;    è l'errore massimo che si può commettere nel trovare il vettore
%               pi


if ~isrow(pi_zero)
   pi_zero = pi_zero';
end
if ~isrow(pi)
    pi = pi';
end
                    
same_pi = 0;                    

for temp=1:1e10
    pi_aux(temp,:) = pi_zero*expm(Q*temp); 
    if prod((pi_aux(temp,:)-pi) <=  max_error*ones(1,length(pi)))
        if prod((pi_aux(temp-1,:)-pi) >  max_error*ones(1,length(pi))) 
            same_pi = 0; 
        else 
            same_pi = same_pi+1;
        end
    end
    if same_pi == 100  %dopo 100 volte che ottengo lo stesso vettore pi esco dalla funzione tornando il tempo
        break;
    end
end
if(same_pi < 100 )
    fprintf('Attenzione non si è raggiunto il tempo di regime.\n')
    error = 1;
else
    fprintf('Tempo di regime raggiunto.\n');
    error = 0;
end