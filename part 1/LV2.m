function dx = LV2(t,x,Beta)
dx = [
% Beta(1)*x(1)+Beta(2)*x(2);
% Beta(3)*x(1)+Beta(4)*x(2);
Beta(1)+Beta(2)*x(1)+Beta(3)*x(2);
Beta(4)+Beta(5)*x(1)+Beta(6)*x(2);
];