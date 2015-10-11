function Hz_inv = Hz_eq(z,OM,OL)

c=3e8;
H0=70.*3.24e-20;
OK = 1-OM-OL;
Hz_inv = c./(H0.*sqrt(OK.*(1+z).^2 + OM.*(1+z).^3 + OL));

end
