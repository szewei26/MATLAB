% hubble_diagram.m
%
% Description: 
%   Plot a magnitude-redshift diagram.
%
% Inputs:
%   MLCS.FITRES  (Results from SDSS SN survey 2009.)
%
% Outputs:
%
% User defined functions called:
%   adotinv(a,OM,OL): 
%       contains da/dt with parameters a, OM, and OL
% 
% MATLAB functions called:
%


%-------------------
% Read in data
%-------------------
clear
fid=fopen('MLCS.FITRES');
data=textscan(fid,'%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','headerlines',3);
fclose(fid);

% Supernova details
snname=data{2};  % Name
zz    =data{3};  % Redshift
zerr  =data{4};  % Redshift uncertainty
mu    =data{5};  % Distance modulus
muerr =data{6};  % Distance modulus uncertainty
%Add 0.02 to the uncertainty to account for the intrinsic diversity of SNe
muerr = muerr+0.02;
id    =data{17}; % Source ID 
                 %  [50 = Nearby sample           ]
                 %  [1  = Sloan Digital Sky Survey]
                 %  [3  = ESSENCE                 ]
                 %  [4  = Supernova Legacy Survey ]
                 %  [100= Hubble Space Telescope  ]
id_nums  = [50 1 3 4 100]
id_names = ['Nearby','SDSS','ESSENCE','SNLS','HST'];


%---------------------------------
% Calculate a model prediction
%---------------------------------
% Define an array of redshifts to calculate the model for
zz_model = [0.02 : 0.02 : 2];
% Calculate the distance modulus for those redshifts
for i=[1:numel(zz_model)]
    mu_model(i)=dist_mod(zz_model(i),0.3,0.7);
end

% To calculate the arbitrary offset we could use:
% total((mu_data-mu_theory)/muerr^2)/total(1./muerr^2)
% But for now I'm just going to set it manually
mscr=43.3;
mu_model = mu_model+mscr

numel(zz_model)
numel(mu_model)

%-------------------
% PLOT DATA WITH ERROR BARS
%-------------------
% Clear existing graphs and create axes
clf
axes1 = axes('FontSize',16);
box('on');
hold('all'); 

% Plot the data (different data sources in different colours)
step=0.2
for i=[1:5] 
    index = find(id == id_nums(i));
    errorbar(zz(index),mu(index),muerr(index),'.')
end
legend('Nearby','SDSS','ESSENCE','SNLS','HST','location','SouthEast')
legend('boxoff')

plot(zz_model,mu_model,'-k','Linewidth',1.2)
% Add annotations to plot 
xlabel('Redshift' ,'FontSize',16);
ylabel('Distance modulus','FontSize',16);
xlim  ([0 1.6])
% Legend
text(0.1,36,'Model: (\Omega_M,\Omega_\Lambda)=(0.3,0.7)','FontSize',16,'FontName','Times New Roman')
text(0.1,35,'Data: SDSS compilation 2009','FontSize',16,'FontName','Times New Roman')

hold('off');
