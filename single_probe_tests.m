
 S = diag(ones(100,1));    % Diagonal structure
 S(:,100) = 1; S(100,:) = 1;

load can_96.mat
sparsemat = full(Problem.A);
S = abs(sign(sparsemat));
%n_itr2 = zeros(1,5);
n_itr2 = 0;
for l = 1:5
    S_prime = S;
    [m_s, n_s] = size(S);     % Size of the sparse matrix
  
    if(l ==1)
        P = ones(m_s, n_s)/n_s;
    elseif (l==2)
        P = diag(sum(S,2)/n_s)*ones(m_s, n_s);
    elseif (l==3)
        P = rand(n_s)*(1 - (2/n_s)) + (1/n_s);
    elseif (l==4)
        mnzi = rand(m_s, n_s)*(2*log(n_s) -1) + 1;nnzj = rand(m_s, n_s)*(2*log(n_s) -1) + 1;
        P = min(mnzi,nnzj)/n_s;
    elseif (l==5)
        a = random('beta', (1/n_s), (2-1/n_s), m_s, n_s, 1000);
        b = random('beta', (1+1/n_s), (1-1/n_s), m_s, n_s, 1000);
        P = (mean(a, 3)+mean(b,3))/2;
    end
    P_prime2 = zeros(m_s, n_s);
    while( sum(sum(and(0 < P, P <1))) ~= sum(sum(and(0<S_prime, S_prime<1))))
        
        P_prime = P;
        [m_p, n_p] = size(P);
        probe_mat = zeros(n_p, 1);r_mat = zeros(m_p, 1);
        indices = NaN(1,n_p);ind = 1:n_p;
        
        
        
        tau = single_probe4(P_prime,m_p,n_p);
        probe_mat(tau(1:size(tau,2)),:) = 1;
        
        
        % The corresponding result matrix
        r_mat(find(S_prime * probe_mat)) = 1;
        
        P = update_probability(probe_mat, P, r_mat);
        
        
        for i = 1:n_p
            for j = 1:n_s
                if(sum(abs(P(:,i)-S(:,j))< 0.0000000000001) == m_p)
                    indices(i) = i;
                    P_prime2(:,j) = P(:,i);
                end
            end
        end
        % round(P_prime2(80:96,80:96))
        
        % Remove the fully identified columns from the probability matrix
        % before the next iteration
        col_indices = (1:n_p).*(isnan(indices));
        P = P(:,col_indices(col_indices>0));
        % Remove the corresponding columns from the sparsity matrix
        S_prime = S_prime(:,col_indices(col_indices>0));
        
        %n_itr2(l)= n_itr2(l)+1;
        n_itr2 = n_itr2+1
        
    end
    n_itr2(l)
end

n_itr2 = zeros(1,3);
for l = 1:3
        % Size of the sparse matrix
  
    if(l ==1)
        n_itr = 0;
        for i = 1:100
            P = rand(n_s)*(1 - (2/n_s)) + (1/n_s);
            n_itr = n_itr + find_probe(P,S);
        end
        n_itr2(l) = n_itr/100;
        elseif (l==2)
            n_itr = 0;
            for i = 1:100
                mnzi = rand(m_s, n_s)*(2*log(n_s) -1) + 1;nnzj = rand(m_s, n_s)*(2*log(n_s) -1) + 1;
                P = min(mnzi,nnzj)/n_s;
                n_itr = n_itr + find_probe(P,S);
            end
            n_itr2(l) = n_itr/100;
            elseif (l==3)
                n_itr =0;
                for i = 1:100
                    a = random('beta', (1/n_s), (2-1/n_s), m_s, n_s, 1000);
                    b = random('beta', (1+1/n_s), (1-1/n_s), m_s, n_s, 1000);
                    P = (mean(a, 3)+mean(b,3))/2;
                    n_itr = n_itr + find_probe(P,S);
            end
            n_itr2(l) = n_itr/100;
    end
end

    P_prime2 = zeros(m_s, n_s);
    while( sum(sum(and(0 < P, P <1))) ~= sum(sum(and(0<S_prime, S_prime<1))))
        
        P_prime = P;
        [m_p, n_p] = size(P);
        probe_mat = zeros(n_p, 1);r_mat = zeros(m_p, 1);
        indices = NaN(1,n_p);ind = 1:n_p;
        
        
        
        tau = single_probe4(P_prime,m_p,n_p);
        probe_mat(tau(1:size(tau,2)),:) = 1;
        
        
        % The corresponding result matrix
        r_mat(find(S_prime * probe_mat)) = 1;
        
        P = update_probability(probe_mat, P, r_mat);
        
        
        for i = 1:n_p
            for j = 1:n_s
                if(sum(abs(P(:,i)-S(:,j))< 0.0000000000001) == m_p)
                    indices(i) = i;
                    P_prime2(:,j) = P(:,i);
                end
            end
        end
        % round(P_prime2(80:96,80:96))
        
        % Remove the fully identified columns from the probability matrix
        % before the next iteration
        col_indices = (1:n_p).*(isnan(indices));
        P = P(:,col_indices(col_indices>0));
        % Remove the corresponding columns from the sparsity matrix
        S_prime = S_prime(:,col_indices(col_indices>0));
        
        %n_itr2(l)= n_itr2(l)+1;
        n_itr2 = n_itr2+1
        
    end
    n_itr2(l)
end
