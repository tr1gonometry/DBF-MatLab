%% MISSION TIME CALCULATOR
% Design Build Fly - Mission 2
% Calculate time required to complete 5 laps
clc;
clear;
%% 1. AIRCRAFT INPUTS
weight = 32.86;          % Takeoff weight (lb)
velocity = 92;           % Cruise velocity (ft/s)
thrust = 7.5;            % Available thrust (lbf)
drag = input('Enter aircraft drag (lbf): ');
%% 2. MISSION INPUTS
laps = 5;                % Required number of laps
missionLimit = 300;      % Maximum mission time (seconds)
straightDistance = input('Enter total straight distance per lap (ft): ');
turnsPerLap = input('Enter number of turns per lap: ');
turnAngle = input('Enter heading change per turn (degrees): ');
bankAngle = input('Enter bank angle (degrees): ');
g = 32.174;              % Gravity (ft/s^2)
%% 3. TURNING MECHANICS
% Convert bank angle to radians
bankRadians = deg2rad(bankAngle);
% Calculate turn radius
turnRadius = velocity^2 / (g * tan(bankRadians));
% Calculate time for one turn
turnTime = (2 * pi * turnRadius / velocity) ...
    * (turnAngle / 360);
% Total time spent turning per lap
totalTurnTime = turnsPerLap * turnTime;
%% 4. STRAIGHT-LINE FLIGHT TIME
straightTime = straightDistance / velocity;
%% 5. TOTAL LAP TIME
lapTime = straightTime + totalTurnTime;
%% 6. TOTAL MISSION TIME
totalMissionTime = lapTime * laps;
%% 7. THRUST AND DRAG CHECK
thrustMargin = thrust - drag;
% Calculate load factor during the turn
loadFactor = 1 / cos(bankRadians);
% Calculate lift required during the turn
requiredLift = weight * loadFactor;
%% 8. DISPLAY RESULTS
fprintf('\n----- MISSION TIME RESULTS -----\n');
fprintf('Aircraft Weight: %.2f lb\n', weight);
fprintf('Cruise Velocity: %.2f ft/s\n', velocity);
fprintf('Turn Radius: %.2f ft\n', turnRadius);
fprintf('Time Per Turn: %.2f seconds\n', turnTime);
fprintf('Straight Flight Time: %.2f seconds\n', straightTime);
fprintf('Total Time Per Lap: %.2f seconds\n', lapTime);
fprintf('\nTotal Time for 5 Laps: %.2f seconds\n', ...
    totalMissionTime);
fprintf('Thrust Margin: %.2f lbf\n', thrustMargin);
fprintf('Turn Load Factor: %.2f\n', loadFactor);
fprintf('Required Lift in Turn: %.2f lb\n', requiredLift);
%% 9. MISSION REQUIREMENT CHECK
if thrustMargin >= 0
    fprintf('\nThrust is sufficient to overcome the entered drag.\n');
else
    fprintf('\nWARNING: Thrust is less than the entered drag.\n');
end
if totalMissionTime <= missionLimit
    fprintf('MISSION SUCCESS: Completed within 300 seconds!\n');
else
    fprintf('MISSION FAILURE: Exceeded the 300-second limit.\n');
end