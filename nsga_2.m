function nsga_2(pop,gen)

%%
%     

%% Simple error checking
% Number of Arguments
% Check for the number of arguments. The two input arguments are necessary
% to run this function.
if nargin < 2
    error('NSGA-II: Please enter the population size and number of generations as input arguments.');
end
% Both the input arguments need to of integer data type
if isnumeric(pop) == 0 || isnumeric(gen) == 0
    error('Both input arguments pop and gen should be integer datatype');
end
% Minimum population size has to be 20 individuals
if pop < 2
    error('Minimum population for running this function is 20');
end
if gen < 2
    error('Minimum number of generations is 5');
end
% Make sure pop and gen are integers
pop = round(pop);
gen = round(gen);
%% Objective Function

[M, V, min_range, max_range] = objective_description_function();

  x1 = [4 8 16 32 64 128 256]; % cache size in Khz

  y1 = [1.37e-01 2.07e-01 3.29e-01 3.65e-01 4.48e-01 5.48e-01 6.87e-01]; % energy jouls

  z1 = [2.39 2.38 2.38 2.42 2.46 2.36 2.34]; %cache throughput with 33mHz frequency
    
 
  coff = polyfit(x1,y1,4);
  coffTP = polyfit(x1,z1,5);
  
  xfreq = [10E+6 20E+6 30E+6 40E+6 50E+6 60E+6 70E+6 80E+6]; 
  EP = [0.085E-07 1.54E-08 2.15E-08 2.68E-08 3.2E-08 3.75E-08 4.3E-08 4.8E-08];
  
  cofEP = polyfit(xfreq,EP,4);

%% Initialize the population
chromosome = initialize_variables(pop, M, V, min_range, max_range,coff,coffTP,cofEP);
% chromosome = initialize_variables(pop, M, V, min_range, max_range);
% matrix1=chromosome


%% Sort the initialized population

chromosome = non_domination_sort_mod(chromosome, M, V);

%% Start the evolution process


for i = 1 : gen
    % Select the parents
    % Parents are selected for reproduction to generate offspring. The
    % original NSGA-II uses a binary tournament selection based on the
    % crowded-comparision operator. The arguments are 
    % pool - size of the mating pool. It is common to have this to be half the
    %        population size.
    % tour - Tournament size. Original NSGA-II uses a binary tournament
    %        selection, but to see the effect of tournament size this is kept
    %        arbitary, to be choosen by the user.
    pool = round(pop/2);
    tour = 2;
    % Selection process
    % A binary tournament selection is employed in NSGA-II. In a binary
    % tournament selection process two individuals are selected at random
    % and their fitness is compared. The individual with better fitness is
    % selcted as a parent. Tournament selection is carried out until the
    % pool size is filled. Basically a pool size is the number of parents
    % to be selected. The input arguments to the function
    % tournament_selection are chromosome, pool, tour. The function uses
    % only the information from last two elements in the chromosome vector.
    % The last element has the crowding distance information while the
    % penultimate element has the rank information. Selection is based on
    % rank and if individuals with same rank are encountered, crowding
    % distance is compared. A lower rank and higher crowding distance is
    % the selection criteria.
    parent_chromosome = tournament_selection(chromosome, pool, tour);
    % Perfrom crossover and Mutation operator
    % The original NSGA-II algorithm uses Simulated Binary Crossover (SBX) and
    % Polynomial  mutation. Crossover probability pc = 0.9 and mutation
    % probability is pm = 1/n, where n is the number of decision variables.
    % Both real-coded GA and binary-coded GA are implemented in the original
    % algorithm, while in this program only the real-coded GA is considered.
    % The distribution indeices for crossover and mutation operators as mu = 20
    % and mum = 20 respectively.
    mu = 20;
    mum = 20;
    offspring_chromosome = ...
        genetic_operator(parent_chromosome, ...
        M, V, mu, mum, min_range, max_range,coff,coffTP,cofEP);
    % Intermediate population
    % Intermediate population is the combined population of parents and
    % offsprings of the current generation. The population size is two
    % times the initial population.
    
    [main_pop,temp] = size(chromosome);
    [offspring_pop,temp] = size(offspring_chromosome);
    % temp is a dummy variable.
    clear temp
    % intermediate_chromosome is a concatenation of current population and
    % the offspring population.
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = ...
        offspring_chromosome;
   
       a = intermediate_chromosome;
%         b=[];
%         for i=1:size(a,2)
%           if(a(i)>0)
%             b=[b a(i)];
%           end
%         end
%        intermediate_chromosome = b
    % Non-domination-sort of intermediate population
    % The intermediate population is sorted again based on non-domination sort
    % before the replacement operator is performed on the intermediate
    % population.
    intermediate_chromosome = ...
        non_domination_sort_mod(intermediate_chromosome, M, V);
    % Perform Selection
    % Once the intermediate population is sorted only the best solution is
    % selected based on it rank and crowding distance. Each front is filled in
    % ascending order until the addition of population size is reached. The
    % last front is included in the population based on the individuals with
    % least crowding distance
%     disp('Generation')
%     disp(i)
    chromosomes = replace_chromosome(intermediate_chromosome, M, V, pop);
    chromosome = round(chromosomes);
    if ~mod(i,100)
        clc
        fprintf('%d generations completed\n',i);
    end
end
% chromosome = round(chromosomes);
  chromosome = chromosomes

       x=0;
       [r,c]=size(chromosome);
%        disp(chromosomes)
          for i=1:r
              if(chromosome(i,4)==0 || chromosome(i,5)==0)
              x=x+1;
          else
        intermediate1(i-x,:)=chromosome(i,:);
              end
          end
        final=intermediate1(1:end-x,:)
        newfinal = round(final)
%   
%% Result
% Save the result in ASCII text format.
save GWR.txt newfinal -ASCII
save Gpaper.txt final -ASCII

%% Visualize
% The following is used to visualize the result if objective space
% dimension is visualizable.
if M == 2
    plot(chromosome(:,V + 1),chromosome(:,V + 2),'*');
    xlabel('Eenergy (Joules)'); ylabel('Throughput'); 
elseif M ==3
    plot3(chromosome(:,V + 1),chromosome(:,V + 2),chromosome(:,V + 3),'*');
end
    
