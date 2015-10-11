% expansion.m
%
% Description: 
%   Takes an array of scalefactors (a), and integrates 1/(da/dt)
%   to get time as a function of scalefactor.
%
% Options to vary:
%   OM = normalised matter density,
%   OL = normalised cosmological constant density
% 
% User defined functions called:
%   adotinv(a,OM,OL): 
%       contains da/dt with parameters a, OM, and OL
% 
% MATLAB functions called:
%   quad(@(x)func(x,c1,c2),low,high): 
%       performs numerical integration of func with respect to x
%       from x=low to x=high
%       c1 and c2 are constants the function needs.
%   numel(x): 
%       counts the number of elements in array x

%-------------------
% INITIALISE ARRAYS
%-------------------
clear all
% Initialise an array of scalefactors
z_lo   = 0;
z_hi   = 100;
z_step = 0.5;
zz     = [z_lo : z_step : z_hi];

% Initialise values of OM to loop over
OM_lo   = 0;
OM_hi   = 2;
OM_step = 0.4;
OMarr   = [OM_lo : OM_step : OM_hi];  

% Set a value of OL
OL=0.7; 

%--------------------------------------------
% CALCULATE time as a function of scalefactor
%--------------------------------------------
% The integration function is called "quad" and works like this:
% quad(@(x)function(x,parameter1,parameter2),lower_limit,upper_limit)
% @(x) tells it to integrate with respect to x
% function(x,parameter1,parameter2) is the function being integrated, 
%      it must depend on x, but the additional parameters are optional.
% lower_limit and upper_limit are the limits of the integral.

c=3e8; %in m/s
H0=70.*3.24e-20; %in 1/s
for j=[1:numel(OMarr)]
    OM=OMarr(j)
    OK = 1-OM-OL;
    Hz = @(z)c./(H0.*sqrt(OK.*(1+z).^2 + OM.*(1+z).^3 + OL));
    for i=[1:numel(zz)]
        z=zz(i);
        %in Mpc
        d_p(i,j)=quad(Hz,0,z)*3.241e-23;
    end

end

%---------------------
% MAKE PLOT OF RESULTS
%---------------------
% Clear existing graphs and create axes
clf
axes1 = axes('FontSize',16);
box('on');
hold('all');

% Plot the result
col=['r';'y';'g';'b';'c';'m';'r';'y';'g';'b';'c';'m';'r';'y';'g';'b';'c';'m'];
for j=[1:numel(OMarr)]
    plot(zz,d_p(:,j),'color',col(j),'LineWidth',1.2)
end
% Add annotations to plot
dp_min = min(min(d_p));
dp_max = max(max(d_p));
ylim([dp_min,dp_max]);
title('Proper Distance vs Redshift','Fontsize',16);
xlabel('Redshift' ,'FontSize',16);
ylabel('Proper Distance (Mpc)','FontSize',16);
% Legend
dpposleft = dp_min+(dp_max-dp_min)*0.05;
zposup   = z_hi -(z_hi -z_lo )*0.1;
dpposright= dp_max-(dp_max-dp_min)*0.1;
zposmid  = z_lo +(z_hi -z_lo )*0.55;
text(dpposleft,zposup,sprintf('\\Omega_\\Lambda=%0.2f',OL),'FontSize',16,'FontName','Ariel');
text(dpposright,zposmid,'\Omega_M'    ,'FontSize',16,'FontName','Ariel');
OMs = num2str(OMarr');
legend(OMs,'Location','SouthEast');
legend('boxoff');
hold('off');

