function f = non_domination_sort_mod(x, M, V)
% disp('    non_domination_sort_mod')
% disp(x)
%% function f = non_domination_sort_mod(x, M, V)
% This function sort the current popultion based on non-domination. All the
% individuals in the first front are given a rank of 1, the second front
% individuals are assigned rank 2 and so on. After assigning the rank the
% crowding in each front is calculated.

[N, m] = size(x);
clear m

% Initialize the front number to 1.
front = 1;

% There is nothing to this assignment, used only to manipulate easily in
% MATLAB.
F(front).f = [];
individual = [];

%% Non-Dominated sort. 
% The initialized population is sorted based on non-domination. The fast
% sort algorithm [1] is described as below for each

% � for each individual p in main population P do the following
%   � Initialize Sp = []. This set would contain all the individuals that is
%     being dominated by p.
%   � Initialize np = 0. This would be the number of individuals that domi-
%     nate p.
%   � for each individual q in P
%       * if p dominated q then
%           � add q to the set Sp i.e. Sp = Sp ? {q}
%       * else if q dominates p then
%           � increment the domination counter for p i.e. np = np + 1
%   � if np = 0 i.e. no individuals dominate p then p belongs to the first
%     front; Set rank of individual p to one i.e prank = 1. Update the first
%     front set by adding p to front one i.e F1 = F1 ? {p}
% � This is carried out for all the individuals in main population P.
% � Initialize the front counter to one. i = 1
% � following is carried out while the ith front is nonempty i.e. Fi != []
%   � Q = []. The set for storing the individuals for (i + 1)th front.
%   � for each individual p in front Fi
%       * for each individual q in Sp (Sp is the set of individuals
%         dominated by p)
%           � nq = nq?1, decrement the domination count for individual q.
%           � if nq = 0 then none of the individuals in the subsequent
%             fronts would dominate q. Hence set qrank = i + 1. Update
%             the set Q with individual q i.e. Q = Q ? q.
%   � Increment the front counter by one.
%   � Now the set Q is the next front and hence Fi = Q.
%
for i = 1 : N
    % Number of individuals that dominate this individual
    individual(i).n = 0;
    % Individuals which this individual dominate
    individual(i).p = [];
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M
            if (x(i,V + k) < x(j,V + k))
                dom_less = dom_less + 1;
            elseif (x(i,V + k) == x(j,V + k))
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 && dom_equal ~= M
            individual(i).n = individual(i).n + 1;
        elseif dom_more == 0 && dom_equal ~= M
            individual(i).p = [individual(i).p j];
        end
    end   
    if individual(i).n == 0
        x(i,M + V + 1) = 1;
        F(front).f = [F(front).f i];
    end
end
% Find the subsequent fronts
while ~isempty(F(front).f)
   Q = [];
   for i = 1 : length(F(front).f)
       if ~isempty(individual(F(front).f(i)).p)
        	for j = 1 : length(individual(F(front).f(i)).p)
            	individual(individual(F(front).f(i)).p(j)).n = ...
                	individual(individual(F(front).f(i)).p(j)).n - 1;
        	   	if individual(individual(F(front).f(i)).p(j)).n == 0
               		x(individual(F(front).f(i)).p(j),M + V + 1) = ...
                        front + 1;
                    Q = [Q individual(F(front).f(i)).p(j)];
                end
            end
       end
   end
   front =  front + 1;
   F(front).f = Q;
end

[temp,index_of_fronts] = sort(x(:,M + V + 1));
for i = 1 : length(index_of_fronts)
    sorted_based_on_front(i,:) = x(index_of_fronts(i),:);
end
current_index = 0;

%% Crowding distance
%The crowing distance is calculated as below
% � For each front Fi, n is the number of individuals.
%   � initialize the distance to be zero for all the individuals i.e. Fi(dj ) = 0,
%     where j corresponds to the jth individual in front Fi.
%   � for each objective function m
%       * Sort the individuals in front Fi based on objective m i.e. I =
%         sort(Fi,m).
%       * Assign infinite distance to boundary values for each individual
%         in Fi i.e. I(d1) = ? and I(dn) = ?
%       * for k = 2 to (n ? 1)
%           � I(dk) = I(dk) + (I(k + 1).m ? I(k ? 1).m)/fmax(m) - fmin(m)
%           � I(k).m is the value of the mth objective function of the kth
%             individual in I

% Find the crowding distance for each individual in each front
for front = 1 : (length(F) - 1)
%    objective = [];
    distance = 0;
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)
        y(i,:) = sorted_based_on_front(current_index + i,:);
    end
    current_index = current_index + i;
    % Sort each individual based on the objective
    sorted_based_on_objective = [];
    for i = 1 : M
        [sorted_based_on_objective, index_of_objectives] = ...
            sort(y(:,V + i));
        sorted_based_on_objective = [];
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
        end
        f_max = ...
            sorted_based_on_objective(length(index_of_objectives), V + i);
        f_min = sorted_based_on_objective(1, V + i);
        y(index_of_objectives(length(index_of_objectives)),M + V + 1 + i)...
            = Inf;
        y(index_of_objectives(1),M + V + 1 + i) = Inf;
         for j = 2 : length(index_of_objectives) - 1
            next_obj  = sorted_based_on_objective(j + 1,V + i);
            previous_obj  = sorted_based_on_objective(j - 1,V + i);
            if (f_max - f_min == 0)
                y(index_of_objectives(j),M + V + 1 + i) = Inf;
            else
                y(index_of_objectives(j),M + V + 1 + i) = ...
                     (next_obj - previous_obj)/(f_max - f_min);
            end
         end
    end
    distance = [];
    distance(:,1) = zeros(length(F(front).f),1);
    for i = 1 : M
        distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);
%         disp(distance);
    end
    y(:,M + V + 2) = distance;
    y = y(:,1 : M + V + 2);
    z(previous_index:current_index,:) = y;
%     save solution2.txt z -ASCII
end
f = z();
