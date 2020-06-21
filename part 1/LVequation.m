function dydt = LVequation(~,y,r)

dydt = zeros(2,1);

sxy = y(1)*y(2);

dydt(1) = r(1)*y(1)-r(2)*sxy;
dydt(2) = r(3)*sxy-r(4)*y(2);

end

