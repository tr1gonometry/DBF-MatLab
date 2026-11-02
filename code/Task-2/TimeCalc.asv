%% Marco Murphy
clc, clear, format compact

% + - - - - - - - - - - - - +
% | Time to complete 5 laps |
% | DBF loop rules          |
% +-------------------------+
% | drag                    |
% | turning mechanics       |
% | cruise speed            |
% | takeoff weight          |
% | thrust                  |
% + - - - - - - - - - - - - +

%       Flight Plan (5 lp)
%    :                     : 
%    :  360 here (tp mid)  :
%   /: - - - - -:- - - - - :\
%  ( : start line (bt mid) : )
%   \: _:_ _ _ _:_ _ _ _:_ :/
%    :  :--runway here--:  :
%    :   500m   :   500m   : * 500m to turn from center
%    :                     :

% ok lets treat the flight as a few steps
% REPEAT 5x
% 1a. takeoff stretch (Lap 1 only)
% 1b. cruise 1 (500m)
% 2.  turn 1
% 3.  cruise 2 (500m)
% 4.  360 deg turn
% 5.  cruise 3 (500m)
% 6.  turn 2
% 7a. landing stretch (Lap 5 only) -- ignore landing for now (yippee!)
% 7b. cruise 4 (500m) --> to 1

% assumptions
% 1. ignore landing
% 2. assume optimal flight (no wind)
% 3. assume constantly moving at cruise speed
% 4. assume banking angle is reached instantly
% 5. assume that each cruise stretch is the same
% 6. assume that the plane perfectly maintains is cruise speed during
% cruise (thrust must be throttled or drag must cancel out accel)
% n. lots of other assumptions probably :3

% formulas
% d = r * t
% f = m * a
% v = a * t
% force_drag = AIR_DENS_SL * DRAG_COEFF * 1/2 * V^2 * FRONT_AREA
% turn_radius = V^2 / (G * tan(BANK_ANGLE))

cruise = input("input your desired cruise speed (m/s): ");
mass   = input("input your takeoff mass (kg): ");
thrust = input("input your thrust (N): ");
fprintf("\n");

% variables in full uppercase are constants
% do not modify them during execution
% matlab is stupid and it wont stop you
CRUISE_DIST = 500;           % meters (distance to middle of a cruise!)
DRAG_COEFF  = 0.01;          % dummy value
ACCEL_CRAFT = thrust / mass; % m / s^2
ACCEL_G     = 9.81;          % m / s^2
AIR_DENS_SL = 1.2250;        % kg / m^3 (at sea level)
FRONT_AREA  = 0.5;           % m^2 dummy value
BANK_ANGLE  = 10;            % degrees dummy value
TURN_ANGLE  = 90;            % degrees

fprintf("using constants (modify in code): \n");
fprintf("CRUISE_DIST = %0.2f m\n", CRUISE_DIST);
fprintf("DRAG_COEFF  = %0.2f\n", DRAG_COEFF);
fprintf("ACCEL_CRAFT = %0.2f m/s^2\n", ACCEL_CRAFT);
fprintf("ACCEL_GRAV  = %0.2f m/s^2\n", ACCEL_G);
fprintf("AIR_DENS_SL = %0.4f kg/m^3\n", AIR_DENS_SL);
fprintf("FRONT_AREA  = %0.2f m^2\n", FRONT_AREA);
fprintf("BANK_ANGLE  = %0.2f deg\n", BANK_ANGLE);
fprintf("TURN_ANGLE  = %0.2f deg\n", TURN_ANGLE);
fprintf("\n");

function forceDrag = forceDrag(AIR_DENS_SL, DRAG_COEFF, cruise, FRONT_AREA)
    forceDrag = 1/2 * AIR_DENS_SL * DRAG_COEFF * (cruise^2) * FRONT_AREA;
    % https://en.wikipedia.org/wiki/Drag_equation#
end

function accelDrag = accelDrag(FORCE_DRAG, mass)
    accelDrag = FORCE_DRAG/mass;
    % im not citing this big dawg, you can do F = ma, its OK
end

function findTurnRadius = findTurnRadius(cruise, ACCEL_G, BANK_ANGLE)
    findTurnRadius = (cruise^2) / (ACCEL_G * tan(BANK_ANGLE));
    % https://www.flightschoolusa.com/bank-angle-1-ultimate-guide-to-performance/
end

totalTime = 0;


% find turn time
turnRadius = findTurnRadius(cruise, ACCEL_G, BANK_ANGLE);
arcLength = 2 * pi * turnRadius * (TURN_ANGLE / 360);
fprintf("arc length found: %0.2f m\n", arcLength);

% find takeoff time
v = 0;
v_prev = 0;
t_step = 0.001; % increase this step for more accurate time calc
distToCruise = 0;
timeToCruise = 0;
% kinda hacky workaround for having compounding functions :3
while (v < cruise)
    v_prev = v;
    distToCruise = distToCruise + (v_prev * t_step);
    v = v + ((thrust - forceDrag(AIR_DENS_SL, DRAG_COEFF, v, FRONT_AREA)) / mass) * t_step;
    timeToCruise = timeToCruise + t_step;
    % added just in case drag equalizes with thrust and it stops
    if (v >= cruise)
        fprintf("time to cruise from 0 is: %0.3fs\n", timeToCruise);
        fprintf("traveled: %0.2f m\n", distToCruise);
    elseif (v_prev == v)
        v = cruise; % break out of loop
        fprintf("[ERR] could not compute time to cruise, drag may be too powerful :(\n");
        fprintf("max speed achieved: %0.2f after %0.3fs\n", v_prev,timeToCruise);
        fprintf("traveled: %0.2f m\n", distToCruise);
    end
end

% find cruise time
timeStraight = CRUISE_DIST / cruise;
fprintf("cruise time over %0.0fm found: %0.2fs\n", CRUISE_DIST, timeStraight)
fprintf("total cruise time is: %0.2fs\n", timeStraight * 18)
% 18 = 20 straight (500m) sections minus 2 for takeoff / landing (18=20-2)