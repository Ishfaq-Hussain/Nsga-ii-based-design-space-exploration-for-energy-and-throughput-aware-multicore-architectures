function f = evaluate_objective(x)
% disp('     Core      cache      freq')
% disp(x)
%  disp(coff);
%  disp(coffTP);
f = [];
% Objective function one
%---------------------------------------------------------------------------
% x1 = [1 2 4 8 16 32 64 128 256];
% y1 = [1.36e-01 1.47e-01 2.01e-01 3.00e-01 4.80e-01 5.27e-01 6.64e-01 7.87e-01 9.98e-01];
% 
%   coff = polyfit(x1,y1,4);
%     
% xfreq = [1.60e+07 2.00e+07 2.50e+07 3.30e+07];
% yfreq = [3.57E+00 2.86E+00 2.29E+00 1.73E+00];
% 
% coffreq = polyfit(xfreq,yfreq,2);

% coff = [-0.0000    0.0000   -0.0000    0.0000    0.1136];
%  coffreq = [0.0000   -0.0000    7.65690];
% coffTP = [0.0000   -0.0000    0.0000   -0.0000    0.0000   -0.0000    0.0000   -0.0003    3.6295];

 %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 M=2; V=3;
   x1 = [4 8 16 32 64 128 256]; % cache size in Khz

  y1 = [1.37e-01 2.07e-01 3.29e-01 3.65e-01 4.48e-01 5.48e-01 6.87e-01]; % energy jouls

  z1 = [2.39 2.38 2.38 2.42 2.46 2.36 2.34]; %cache throughput with 33mHz frequency
    
 
  coff = polyfit(x1,y1,4);
  coffTP = polyfit(x1,z1,5);
  
  xfreq = [10E+6 20E+6 30E+6 40E+6 50E+6 60E+6 70E+6 80E+6]; 
  EP = [0.085E-07 1.54E-08 2.15E-08 2.68E-08 3.2E-08 3.75E-08 4.3E-08 4.8E-08];
  
  cofEP = polyfit(xfreq,EP,4);
Energy_sum = 0;
for i = 1 : V 
            if i == 1
%                 single_Core_Energy=10;         
            single_Core_Energy = ((coff(1).*x(2)^4)+ (coff(2).*x(2)^3)+ (coff(3).*x(2)^2)+ (coff(4).*x(2)^1)+ (coff(5).*x(2)^0));
            Core_Energy = single_Core_Energy;%.*x(i);
%             Core_Energy = (0.8).*(single_Core_Energy).*(x(1));
            elseif i == 2
%                 Cache_Energy = 10.*x(i);
                Cache_Energy = ((coff(1).*x(2)^4)+ (coff(2).*x(2)^3)+ (coff(3).*x(2)^2)+ (coff(4).*x(2)^1)+ (coff(5).*x(2)^0));
                c = [80361015.4 81675785.6 78525665.8 78577508 78477295.2 79694364 80892262.6];
                    if (x(2)== 4)   % (count < limit) && ((height - offset) >= 0) 
                         cycle = c(1); 
                    elseif ( x(2)> 4) && (x(2)<= 8)
                         cycle = c(2); 
                    elseif ( x(2)> 8) && (x(2)<= 16)                       
                         cycle = c(3); 
                    elseif  ( x(2)> 16) && (x(2)<= 32) 
                         cycle = c(4);
                    elseif ( x(2)> 32) && (x(2)<= 64)
                         cycle = c(5);
                    elseif  ( x(i)> 64) && (x(2)<= 128)
                         cycle = c(6); 
                    elseif ( x(2)> 128) && (x(2)<= 256)
                        cycle = c(7);
                    end
                           
            elseif i == 3
                EPC =  ((cofEP(1).*x(3)^4)+ (cofEP(2).*x(3)^3)+ (cofEP(3).*x(3)^2)+(cofEP(4).*x(3)^1)+(cofEP(5).*x(3)^0));
              %                 
            end
        
  
end 
%           EPCN = abs(EPC.* cycle);
          EPCN = (EPC.* (cycle));
%         Energy_sum = ((Core_Energy + Cache_Energy).*Frequency_Energy)
%         Energy_sum = (x(1)./((33)./x(3)))*((0.8.*Core_Energy) + (0.2.*Cache_Energy));% .* Frequency_Energy;
%         Energy_sum = ((x(1).*(EPCN-0.1020+Cache_Energy)))%.* Frequency_Energy;
        Energy_sum = abs(x(1).*(EPCN-0.01020+Cache_Energy));
%         Energy_sum = Energy_sums +1;
        % Decision variables are used to form the objective function.
        % -0.1020
%         f(1) = round(Energy_sum);
        f(1) = (Energy_sum);


%========================================================================
% Objective function two
TP_sum = 0;

for i = 1 : V 
    
            if i == 1
                         
            Core_TP = (1./((1-0.75)+(0.75/x(i))));
            
            elseif i == 2
            Cache_TP = ((coffTP(1).*x(2)^5)+ (coffTP(2).*x(2)^4)+ (coffTP(3).*x(2)^3)+ (coffTP(4).*x(2)^2)+(coffTP(5).*x(2)^1)+(coffTP(6).*x(2)^0));% 
              
            elseif i == 3 
            Frequency_TP = (x(i)./(33));
            end
       
end 
%         TP_sum = round(Core_TP + Cache_TP + Frequency_TP)
        TP_sum = (-1).*((Core_TP + Cache_TP).* Frequency_TP);
        % Decision variables are used to form the objective function.
%         f(2) = round(TP_sum);
        f(2) = (TP_sum);
% save solution2.txt chromosome -ASCII
%% Check for error
if length(f) ~= M
    error('The number of decision variables does not match you previous input. Kindly check your objective function');
end