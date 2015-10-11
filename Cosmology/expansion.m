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
a_lo   = 0;
a_hi   = 2;
a_step = 0.001;
aa     = [a_lo : a_step : a_hi];

% Find when a=1, so we know which array index corresponds to today
index_today = find(abs(aa-1.0) < a_step/2);

% Initialise values of OM to loop over
OM_lo   = 0;
OM_hi   = 2;
OM_step = 0.4;
OMarr   = [OM_lo : OM_step : OM_hi];  

% Set a value of OL
OL=0.7; 

%--------------------------------------------
% CALCULATE time as a function of scaelfactor
%--------------------------------------------
% The integration function is called "quad" and works like this:
% quad(@(x)function(x,parameter1,parameter2),lower_limit,upper_limit)
% @(x) tells it to integrate with respect to x
% function(x,parameter1,parameter2) is the function being integrated, 
%      it must depend on x, but the additional parameters are optional.
% lower_limit and upper_limit are the limits of the integral.

% To calculate time we need to integrate the function 1/(da/dt), with respect to a 
% which is defined in a file called adotinv.m

% Perform the integral for a number of values of OM  
% ("numel" gives the number of elements in the OM array)
for j=[1:numel(OMarr)]
    OM=OMarr(j)

    for i=[1:numel(aa)]
        a=aa(i);
        t(i,j)=quad(@(a)adotinv(a,OM,OL),0,a);     % !! THIS IS THE KEY STEP !!
    end

    % Find the time today
    t_today = t(index_today,j);
    % Subtract todays time, so t=0 today.
    t(:,j) = t(:,j) - t_today;

end

% Convert time to Gyrs (option)
H0kmsmpc = 70;                   % Choose a value of H0 in km/s/Mpc
H0s = H0kmsmpc * 3.24e-20; %s-1  % Convert to inverse seconds
H0y = H0s* 3.156e16;     %Gyr-1  % Convert to inverse Giga-years 

t = t./H0y;                      % Convert from Hubble time to Gyr


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
    plot(t(:,j),aa,'color',col(j),'LineWidth',1.2)
end
% Add annotations to plot
t_min = min(min(t));
t_max = max(max(t));
xlim([t_min,t_max]);
line([0 0],[a_lo a_hi],'Linestyle','--','Color','black');
line([t_min   t_max  ],[1    1   ],'Linestyle','--','Color','black');
title('Scalefactor vs Time','Fontsize',16);
xlabel('Time (Gyr)' ,'FontSize',16);
ylabel('Scalefactor','FontSize',16);
% Legend
tposleft = t_min+(t_max-t_min)*0.05;
aposup   = a_hi -(a_hi -a_lo )*0.1;
tposright= t_max-(t_max-t_min)*0.1;
aposmid  = a_lo +(a_hi -a_lo )*0.55;
text(tposleft,aposup,sprintf('\\Omega_\\Lambda=%0.2f',OL),'FontSize',16,'FontName','Ariel');
text(tposright,aposmid,'\Omega_M'    ,'FontSize',16,'FontName','Ariel');
OMs = num2str(OMarr');
legend(OMs,'Location','SouthEast');
legend('boxoff');
hold('off');

