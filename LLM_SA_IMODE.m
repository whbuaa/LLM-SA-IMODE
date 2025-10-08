classdef LLM_SA_IMODE < ALGORITHM
% <single> <real> <large/none> <constrained/none>
% Improved multi-operator differential evolution
% minN  ---   4 ---LLM_ Minimum population size
% aRate --- 2.6 --- Ratio of archive size to population size

%------------------------------- Reference --------------------------------
% K. M. Sallam, S. M. Elsayed, R. K. Chakrabortty, and M. J. Ryan, Improved
% multi-operator differential evolution algorithm for solving unconstrained
% problems, Proceedings of the IEEE Congress on Evolutionary Computation,
% 2020.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2021 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            %% Parameter setting
            [minN,aRate] = Algorithm.ParameterSet(4,5);
            
            %% Generate random population
            Population = Problem.Initialization();
            Archive    = [];
            MCR = zeros(20*Problem.D,1) + 0.2;
            MF  = zeros(20*Problem.D,1) + 0.2;
            k   = 1;
            MOP = ones(1,5)/5;
            cycle = 0;
            %% init dataset
            train_data             = [];
            Incre_learning         = [];
            incre_lable            = [];
            incre_Xtr              = []; 
             [~,init_rank]         = sort(FitnessSingle(Population));
             init_Population       = Population(init_rank(1:Problem.N));
            for i = 1:Problem.N
                train_data{1,i}    = init_Population(i);
            end
            %% Optimization
            while Algorithm.NotTerminated(Population)
                % Reduce the population size
                N          = ceil((minN-Problem.N)*Problem.FE/Problem.maxFE) + Problem.N;
                [~,rank]   = sort(FitnessSingle(Population));
                Population = Population(rank(1:N));
                Archive    = Archive(randperm(end,min(end,ceil(aRate*N))));
                
                 % Eigencoordinate System
                [~,I]  = sort(Population.objs,'ascend');
                num    = N;
                TopDec = Population(I(1:num)).decs;
                B      = orth(cov(TopDec));
                R1= deal(zeros(num-1));
                R1(logical(eye(num-1))) = rand(1,num-1);
                % construct train set
                train_set_uni        = [];
                train_set            = [];
                train_set_tem        = [];
                Y_lable              = [];
                Xtr                  = [];
                ind                  = [];
                train_rank           = [];
                for i = 1:N
                    train_set_tem   = [train_data{1,i},train_set_tem];
                end
                train_set_tem       = [Population,train_set_tem];
                [~,ind]             = unique(train_set_tem.objs);
                trainN              = size(ind,1);
                train_set_uni       = train_set_tem(ind(1:trainN));
                [~,train_rank]      = sort(FitnessSingle(train_set_uni));
                train_set           = train_set_uni(train_rank(1:trainN));
               % increment learning
                incre_lable         = ones(size(Incre_learning,1),1);
                incre_Xtr           = Incre_learning;
                % Generate Lable
                for i=1:trainN
                    for j =1:trainN-1
                        Y_lable((i-1)*(trainN-1)+j,1)=1;
                    end
                    if(i>1)
                        for kk=1:i-1
                            Y_lable((i-1)*(trainN-1)+kk,1)=2;
                        end
                    end
                end
               % tr data
                t=0;
                for n=1:trainN
                    for  m=1:trainN
                        if(n==m)
                        else
                            t=t+1;
                            Xtr(t,:) = [train_set(n).dec,train_set(m).dec];
                        end
                    end
                end  
                % Generate parents, CR, F, and operator for each offspring
                Xp1 = Population(ceil(rand(1,N).*max(1,0.25*N))).decs;
                Xp2 = Population(ceil(rand(1,N).*max(2,0.5*N))).decs;
                Xr1 = Population(randi(end,1,N)).decs;
                Xr3 = Population(randi(end,1,N)).decs;
                P   = [Population,Archive];
                Xr2 = P(randi(end,1,N)).decs;
                CR  = randn(N,1).*sqrt(0.1) + MCR(randi(end,N,1));
                CR  = sort(CR);
                CR  = repmat(max(0,min(1,CR)),1,Problem.D);
                F   = min(1,trnd(1,N,1).*sqrt(0.1) + MF(randi(end,N,1)));
                while any(F<=0)
                    F(F<=0) = min(1,trnd(1,sum(F<=0),1).*sqrt(0.1) + MF(randi(end,sum(F<=0),1)));
                end
                F  = repmat(F,1,Problem.D);
                OP = arrayfun(@(S)find(rand<=cumsum(MOP),1),1:N);
                OP = arrayfun(@(S)find(OP==S),1:length(MOP),'UniformOutput',false);
                % Generate offspring
                PopDec = Population.decs;
                OffDec = PopDec;
                OffDec(OP{1},:) = PopDec(OP{1},:) + F(OP{1},:).*(Xp1(OP{1},:)-PopDec(OP{1},:)+Xr1(OP{1},:)-Xr2(OP{1},:));
                OffDec(OP{2},:) = PopDec(OP{2},:) + F(OP{2},:).*(Xp1(OP{2},:)-PopDec(OP{2},:)+Xr1(OP{2},:)-Xr3(OP{2},:));
                OffDec(OP{3},:) = F(OP{3},:).*(Xr1(OP{3},:)+Xp2(OP{3},:)-Xr3(OP{3},:));
                if(size(B,2)== num-1)
                OffDec(OP{4},:) = PopDec(OP{4},:) + F(OP{4},:)*B*R1*B'.*(Xp1(OP{4},:)-PopDec(OP{4},:)+Xr1(OP{4},:)-Xr3(OP{4},:));
                OffDec(OP{5},:) = F(OP{5},:)*B*R1*B'.*(Xr1(OP{5},:)+Xp2(OP{5},:)-Xr3(OP{5},:));      
                else
                OffDec(OP{4},:) = PopDec(OP{4},:) + F(OP{4},:).*(Xp1(OP{4},:)-PopDec(OP{4},:)+Xr1(OP{4},:)-Xr2(OP{4},:));
                OffDec(OP{5},:) = F(OP{5},:).*(Xr1(OP{5},:)+Xp2(OP{5},:)-Xr3(OP{5},:));    
                end
                if rand < 0.4
                    Site = rand(size(CR)) > CR;
                    OffDec(Site) = PopDec(Site);
                else
                    p1 = randi(Problem.D,N,1);
                    p2 = arrayfun(@(S)find([rand(1,Problem.D),2]>CR(S,1),1),1:N);
                    for i = 1 : N
                        Site = [1:p1(i)-1,p1(i)+p2(i):Problem.D];
                        OffDec(i,Site) = PopDec(i,Site);
                    end
                end
                % Generate predict data
                RCES_Xte                       = [Population.decs,OffDec]; 
                % define model
                clf                            = py.sklearn.neighbors.KNeighborsClassifier(int16(3));
                clf.fit(py.numpy.array([Xtr;incre_Xtr]), py.numpy.array([Y_lable;incre_lable]));
                pre_lable                      = clf.predict(py.numpy.array(RCES_Xte));
                RCES_pred                      = double(pre_lable)';    
                RCES_replace                   =  RCES_pred-1;
                Offspring                      = Population;
                RCES_row                       = find(RCES_replace==1);
                for i = 1 : size(RCES_row,1)
                    Population_CES                = SOLUTION(OffDec(RCES_row(i),:));
                    if(FitnessSingle(Population(RCES_row(i)))>FitnessSingle(Population_CES))
                        Offspring(RCES_row(i))         = Population_CES  ;
                    else
                        Incre                     = [Population(RCES_row(i)).dec,Population_CES.dec];
                        Incre_learning            = [Incre_learning;Incre];
                    end
                end
                if( cycle>=10)
                    Offspring                      = SOLUTION(OffDec);
                end
                % Update the population and archive
                delta   = FitnessSingle(Population) - FitnessSingle(Offspring);
                replace = delta > 0;
                Archive = [Archive,Population(replace)];
                Archive = Archive(randperm(end,min(end,ceil(aRate*N))));
                Population(replace) = Offspring(replace);
              %% build and update train_data
                for i = 1:N
                    if(replace(i))
                        train_data{1,i}       = [Population(i),train_data{1,i}];
                        train_data{1,i}       = train_data{1,i}(1:min(end,2));
                    end
                end

                % Update CR, F, and probabilities of operators
                w   = delta(replace)./sum(delta(replace));
                if ~isempty(w)
                    cycle = 0;
                else
                    cycle = cycle + 1;
                end
                udiff  = OffDec(:,:) - PopDec(:,:);
                MCR(k) = LLM_MCR(w, udiff, CR);
                MF(k) = LLM_MF(w, udiff, CR);
                k      = mod(k,length(MCR)) + 1;

                udiff  = OffDec(:,:) - PopDec(:,:);
                numerator = sum((udiff).^2, 2);
                denominator = sum(PopDec.^2, 2);
                udiffNorm = numerator ./ (denominator + eps);
                delta = max(0,delta./abs(FitnessSingle(Population)));
                feRatio = Problem.FE/Problem.maxFE;
                MOP = LLM_OAM(delta, udiffNorm, feRatio, OP);

                clearvars RCES_Xte RCES_row replace TopDec B
                % refine the best solution
                parm.MF                             = MF;
                parm.MCR                            = MCR;
                if(Problem.FE<1*Problem.maxFE)
                    [~,rank]                        = sort(FitnessSingle(Population));
                    Population                      = Population(rank(1:N));
                    [best_off]                      =  refine_evo(Population,Archive,Problem.D,parm,Incre_learning);
                    if( FitnessSingle(Population(1)) - FitnessSingle(best_off)>0)
                        Population(N)               = best_off;
                        Archive                     = [Archive,best_off];
                        Archive                     = Archive(randperm(end,min(end,ceil(aRate*N))));
                    end
                end
            end
        end
    end
end

function MCR = LLM_MCR(w, udiff, CR)
    persistent MCR_prev quantum_state;
    if isempty(MCR_prev)
        MCR_prev = 0.5;
        quantum_state = 0.5;
    end

    if ~isempty(w)
        % Quantum superposition weighting
        replace = length(w);
        selected_CR = CR(1:replace, 1);

        % Relativistic momentum adaptation
        cr_diff = selected_CR - MCR_prev;
        gamma = 1./sqrt(1 - min(0.99, quantum_state^2 * mean(cr_diff.^2)));
        relativistic_weights = w .* exp(-gamma .* abs(cr_diff));

        % Topological persistence scaling
        persistence = max(selected_CR) - min(selected_CR);
        scaled_CR = selected_CR .* (1 + quantum_state * persistence);

        MCR = sum(relativistic_weights .* scaled_CR) / sum(relativistic_weights);

        % Update quantum state
        quantum_state = 0.9 * quantum_state + 0.1 * (1 - std(selected_CR)/max(selected_CR));
        MCR_prev = MCR;
    else
        % Topological diversity mapping
        if size(udiff,1) > 1
            % Compute persistent homology features
            dist_matrix = pdist2(udiff, udiff);
            max_dist = max(dist_matrix(:));
            quantum_state = 0.9 * quantum_state + 0.1 * (max_dist/(1 + max_dist));

            % Create topological weights
            median_udiff = median(udiff);
            diversity = 1./(1 + sum((udiff - median_udiff).^2, 2));
            diversity_weights = diversity ./ max(diversity);
        else
            diversity_weights = ones(size(CR,1),1);
        end

        % Quantum tunneling adjustment
        tunneling_prob = exp(-abs(CR(:,1) - MCR_prev)/(0.1 + 0.4*quantum_state));
        MCR = sum(diversity_weights .* tunneling_prob .* CR(:,1)) / ...
              sum(diversity_weights .* tunneling_prob);
    end

    % Quantum confinement
    MCR = 0.1 + 0.8 * (0.5 + 0.5 * sin(pi * (MCR - 0.5) * quantum_state));
end

function MF = LLM_MF(w, udiff, F)
    if ~isempty(w)
        % Success-based scenario with adaptive moment-constrained weighting
        replace = length(w);
        F_used = F(1:replace, 1);

        % Robust statistical estimation
        med_F = median(F_used);
        mad_F = mad(F_used, 1);

        % Dynamic weighting based on fitness and dispersion
        robust_w = w ./ (1 + (F_used - med_F).^2 / (2*mad_F^2));
        robust_w = robust_w / sum(robust_w);

        % Adaptive smoothing with momentum
        hist_factor = 0.2 * (med_F - 0.5);
        MF = sum(robust_w .* F_used) + hist_factor;
    else
        % Diversity-driven exploration
        pop_size = size(F, 1);

        % Normalized distance-based weights
        dist_w = 1./(1 + vecnorm(udiff, 2, 2).^0.5);
        dist_w = dist_w / sum(dist_w);

        % Variance-adaptive scaling
        var_F = var(F(:,1));
        adapt_factor = tanh(var_F * pop_size / 10);

        % Exploration-exploitation balance
        MF = adapt_factor * max(F(:,1)) + (1 - adapt_factor) * sum(dist_w .* F(:,1));
    end

    % Physically meaningful constraints
    MF = min(max(MF, 0.05), 1.0);
end

function MOP = LLM_OAM(delta, udiffNorm, feRatio, OP)
    numOps = 5;

    % Check for unused operators and apply fallback mechanism
    unusedOps = cellfun(@isempty, OP);
    numUnused = sum(unusedOps);

    if numUnused > 0
        MOP = ones(1, numOps) * 0.1;
        usedOps = ~unusedOps;
        if sum(usedOps) > 0
            remainingProb = 1 - 0.1 * numUnused;
            MOP(usedOps) = remainingProb / sum(usedOps);
        else
            MOP = ones(1, numOps) / numOps;
        end
        return;
    end

    % Compute operator effectiveness using weighted harmonic mean with linear weights
    opEffect = zeros(1, numOps);
    for i = 1:numOps
        idx = OP{i};
        deltaOp = mean(delta(idx), 'omitnan');
        udiffOp = mean(udiffNorm(idx), 'omitnan');

        % Apply linear weighting based on solving stage
        w1 = 1 - feRatio; % Improvement weight decreases linearly
        w2 = feRatio;     % Diversity weight increases linearly

        % Weighted harmonic mean with weights
        if deltaOp <= 0 || udiffOp <= 0
            opEffect(i) = 0;
        else
            opEffect(i) = (w1 + w2) / (w1 / deltaOp + w2 / udiffOp);
        end
    end

    % Handle edge cases
    opEffect(isnan(opEffect) | opEffect < 0) = 0;
    if all(opEffect == 0)
        opEffect = ones(1, numOps);
    end

    % Apply adaptive smoothing based on solving stage
    persistent prevMOP;
    if isempty(prevMOP)
        prevMOP = ones(1, numOps) / numOps;
    end
    smoothingFactor = 0.5 * (1 - feRatio); % Smoothing decreases linearly
    MOP = smoothingFactor * (opEffect / sum(opEffect)) + (1 - smoothingFactor) * prevMOP;
    prevMOP = MOP;

    % Normalize and clip probabilities
    MOP = MOP / sum(MOP);
    MOP = max(0.1, min(0.9, MOP));
    MOP = MOP / sum(MOP);
end