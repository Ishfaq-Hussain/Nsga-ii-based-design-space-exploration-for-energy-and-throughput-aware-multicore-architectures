function f = initialize_variables(N, M, V, min_range, max_range,coff,coffTP,cofEP)

%% function f = initialize_variables(N, M, V, min_tange, max_range) 
% This function initializes the chromosomes. Each chromosome has the
% following at this stage
%       * set of decision variables
%       * objective function values
% 
% where,
% N - Population size
% M - Number of objective functions
% V - Number of decision variables
% min_range - A vector of decimal values which indicate the minimum value
% for each decision variable.
% max_range - Vector of maximum possible values for decision variables.

%  

min = min_range;
max = max_range;

% K is the total number of array elements. For ease of computation decision
% variables and objective functions are concatenated to form a single
% array. For crossover and mutation only the decision variables are used
% while for selection, only the objective variable are utilized.

K = M + V;

%% Initialize each chromosome
% For each chromosome perform the following (N is the population size)
for i = 1 : N
    % Initialize the decision variables based on the minimum and maximum
    % possible values. V is the number of decision variable. A random
    % number is picked between the minimum and maximum possible values for
    % the each decision variable. 
%     for j = 1 : V
%         f(i,j) = min(j) + (max(j) - min(j))*rand(1);
%     end
   f      =  [14   206    74
                8    69    75
               14   183    71
                3     4    78               
                8    64    75
                13   206    74
                4   134    80                
                8   122    78
                4   135    79
                5   151    76
                12   230    61
                4   135    79
                8   124    78
                3     9    78
                14   216    73
                3     6    77
                15   194    72                
                8   123    76                
                14   216    73
                15   195    72
                8   123    76
                15   195    72
                5   142    71
                14   216    73
                8   123    76
                4   171    74
                3     8    78
                8   124    76
                5   143    71
                14   216    73
                3    17    77
                8   122    76
                15   195    72
                5   153    71
                3    10    77
                2    38    65
                2    78    66
                8    12    63
                1    26    28
                5   168    74
                11    77    63
                5   168    74
                5   171    74
                15   216    71
                2    38    65
                10    77    63
                2    78    68
                2    38    64
                2    18    11
                3   220    59
                1   111    34
                3   132    70
                12    58    58
                8   158    71
                12    89    69
                13    88    69
                14    85    69
                1   111    34
                2    36    65
                2    51    62
                12    88    69
                2    50    62
                13    90    69
                7    82    59
                6    31    52
                12    88    69
                6   107    60
                2    74    40
                2    50    62                
                5   107    60
                6   109    60
                1   111    32
                6    25    46
                4    59    47
                10    32    46
                4   149    52
                3   211    55
                2   110    34
                1   227    46
                7   158    70
                10    35    46
                2    74    41
                12    92    67
                7   159    70
                6    34    46
                1   221    46
                1   226    46
                1   137    12
                7   158    70
                11    97    50
                1   230    46
                2    75    41
                14    54    53];
   
    % For ease of computation and handling data the chromosome also has the
    % vlaue of the objective function concatenated at the end. The elements
    % V + 1 to K has the objective function valued. 
    % The function evaluate_objective takes one chromosome at a time,
    % infact only the decision variables are passed to the function along
    % with information about the number of objective functions which are
    % processed and returns the value for the objective functions. These
    % values are now stored at the end of the chromosome itself.
    f(i,V + 1: K) = evaluate_objective(f(i,:), M, V,coff,coffTP,cofEP);
end
