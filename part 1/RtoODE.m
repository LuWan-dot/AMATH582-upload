function solpts = RtoODE(r,tspan,y0)

sol = ode45(@(t,y)LVequation(t,y,r),tspan,y0);
solpts = deval(sol,tspan);

end

