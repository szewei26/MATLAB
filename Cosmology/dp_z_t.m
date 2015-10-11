clear all

z_lo   = 0;
z_hi   = 1;
z_step = 0.1;
zz     = [z_lo : z_step : z_hi];

a_lo   = 0;
a_hi   = 2;
a_step = 0.2;
aa     = [a_lo : a_step : a_hi];

index_today = find(abs(aa-1.0) < a_step/2);

OM=0.3;
OL=0.7;
OK=1-OM-OL;

c=3e8; %in m/s
H0=70.*3.24e-20; %in 1/s
for k=[1:numel(aa)]
    a=aa(k);
    ad = @(a)1./sqrt(OK + OM./a + OL.*a.^2);
    t(k)=quad(ad,0,a);
    for i=[1:numel(zz)]
        z=zz(i);
        Hz = @(z)c./(H0.*sqrt(OK.*(1+z).^2 + OM.*(1+z).^3 + OL));
        d_p(i)=quad(Hz,0,z)*3.241e-23;
        DP(i,k)=a.*d_p(i);
    end
end

t_today = t(index_today);
t(:) = t(:) - t_today;
t = t./H0;

clf
axes1 = axes('FontSize',16);
box('on');
hold('all');
mesh(t,zz,DP);
title('Proper distance vs Redshift and Time','Fontsize',16);
xlabel('Time (s)','FontSize',16);
ylabel('Redshift','FontSize',16);
zlabel('Proper Distance (Mpc)','FontSize',16);
hold('off');