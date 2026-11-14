%% Weight Convergence Script
clear
clc

PayLoadWeight = input('Enter Payload Weight: ');
EmptyAircraftWeight = input('Enter Aircraft Weight: ');
BatteryWeight = input('Enter Battery Weight: ');

TakeOffWeight = PayLoadWeight + EmptyAircraftWeight + BatteryWeight

takeoffSpeed = input('Enter takeoff speed (m/s): ');
takeoffDistance = input('Enter takeoff ground distance (m): ');

CruiseSpeed = input('Enter cruise speed (m/s): ');



g = 9.8;                        % gravity
AirDensity = 1.2250;            % air density at sea level
RemainingBattery = 0.20;        % remaining battery percentage

MaxIterations = 200;
Weight = TakeOffWeight * g;
LiftCoefficient = 2 * Weight / (AirDensity * takeoffSpeed^2);
DragCoefficient = 0.03 + 0.04 * LiftCoefficient^2;
DragForce = 0.5 * AirDensity * takeoffSpeed^2 * DragCoefficient;
RequiredThrust = DragForce + Weight * 0.02;

for n = 1:MaxIterations


% The takeoff will include thrust, drag, and surface friction.