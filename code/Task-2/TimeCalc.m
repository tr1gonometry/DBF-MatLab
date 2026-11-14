% By Marco Murphy and . . . 
clc, clear, format compact

% Project requirements
% Time to complete 5 laps
% (DBF loop rules)
% drag
% turning mechanics
% cruise speed
% takeoff weight
% thrust

% Flight Plan (5 lp)
%    :                     : 
%    :  360 here (tp mid)  :
%   /: - - - - -:- - - - - :\
%  ( : start line (bt mid) : )
%   \: _:_ _ _ _:_ _ _ _:_ :/
%    :  :--runway here--:  :
%    :   500m   :   500m   :
%    :                     :
% * 500m to turn from center

% Flight as a few steps
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

% Assumptions
% 1. ignore landing
% 2. assume optimal flight (no wind)
% 3. assume constantly moving at cruise speed during straights
% 4. assume banking angle is reached instantly
% 5. assume that each cruise stretch is the same (makes my life easier)
% 6. assume that the plane perfectly maintains is cruise speed during
%    cruise (thrust must be throttled or drag must cancel out accel)
% n. lots of other assumptions probably :3

% Formulas
% d = r * t
% f = m * a
% v = a * t
% force_drag = zAIR_DENS_SL * zDRAG_COEFF * 1/2 * V^2 * zFRONT_AREA
% turn_radius = V^2 / (G * tan(zBANK_ANGLE))
% w = theta / t (angular velocity)
% v = r * w (convert ang to linear)
% 180 deg = 1 * pi rad

% for testing i have been using 100, 5, and 100 respectively
% is that accurate? god no probably not. but its consistent.
speed  = input("cruise speed (m/s): ");
while (~any(speed) || speed < 0)
    speed = input("must be n > 0... ");
end
mass   = input("takeoff mass  (kg): ");
while (~any(mass) || mass < 0)
    mass = input("must be n > 0... ");
end
thrust = input("applied thrust (N): ");
while (~any(thrust) || thrust < 0)
    thrust = input("must be n > 0... ");
end
dbg = lower(input("enable debug (y/n)? ", "s"));
switch (dbg)
    case ("y")
        DEBUG = true;
        fprintf("\n{DBG} debug enabled!\n");
    case ("n")
        DEBUG = false;
        fprintf("\n{DBG} debug disabled!\n");
    otherwise
        DEBUG = false;
        fprintf("\n{DBG} invalid input, disabling debug\n");
end
fprintf("\n");


% variables in full uppercase are constants
% do not modify them during execution
% matlab is stupid and it wont stop you
% and i REFUSE to learn matlab classes
zCRUISE_DIST = 500;    % meters (distance to middle of a cruise!)
zDRAG_COEFF  = 0.01;   % dummy value
zACCEL_G     = 9.81;   % m / s^2
zAIR_DENS_SL = 1.2250; % kg / m^3 (at sea level)
zFRONT_AREA  = 0.5;    % m^2 dummy value
zBANK_ANGLE  = 20;     % degrees dummy value
zTURN_ANGLE  = 180;    % degrees
zLAP_COUNT   = 5;      %

fprintf("using constants:\n");
fprintf("CRUISE_DIST = %0.0f m      | ", zCRUISE_DIST);
fprintf("DRAG_COEFF  = %0.2f \n",        zDRAG_COEFF);
fprintf("ACCEL_G     = %0.2f m/s^2 | ",  zACCEL_G);
fprintf("AIR_DENS_SL = %0.4f kg/m^3\n",  zAIR_DENS_SL);
fprintf("FRONT_AREA  = %0.2f m^2   | ",  zFRONT_AREA);
fprintf("BANK_ANGLE  = %0.0f deg\n",     zBANK_ANGLE);
fprintf("TURN_ANGLE  = %0.0f deg    | ", zTURN_ANGLE);
fprintf("LAP_COUNT   = %0.0f\n",         zLAP_COUNT);
fprintf("\n");

totalTime = 0;

% ok so apparently matlab makes global variables a PAIN so i will
% not be using functions lest I have to pass in EVERY VARIABLE
% WHAT THE FUCK IS A GLOBAL VAR IN THIS HOUSE WE PASS EVERYTHING IN!!!

% find takeoff time
v = 0;
v_prev = 0;
itr = 0;
t_step = 0.001; % increase this step for more accurate time calc
distToCruise = 0;
timeToCruise = 0;
% behold my codeslop!
% this is a compounding function :3
% its basically just a sequence where a_n is modified a_(n-1)
if (DEBUG)
    fprintf("{DBG} starting takeoff loop\n")
end
while (v < speed)
    itr = itr + 1;
    v_prev = v;
    distToCruise = distToCruise + (v_prev * t_step);
    forceDrag = 1/2 * zAIR_DENS_SL * zDRAG_COEFF * (speed^2) * zFRONT_AREA;
    accelWithDrag = ((thrust - forceDrag) / mass);
    v = v + accelWithDrag * t_step;
    timeToCruise = timeToCruise + t_step;
    % added just in case drag equalizes with thrust and it stop
    % this might never execute now because it gets overwhelmed by the
    % takeoff space check, but ill leave it just in case
    if (v >= speed)
        if (DEBUG)
            fprintf("{DBG} completed takeoff calcs in %d steps\n", itr)
            fprintf("[TKF] time to %d m/s from 0 is: %0.3fs\n", speed, timeToCruise);
            fprintf("      traveled: %0.2f m\n", distToCruise);
            fprintf("\n");
        end
    elseif (v_prev == v)
        if (DEBUG)
            fprintf("{DBG} exited takeoff calcs in %d steps\n", itr);
        end
        v = speed; % break out of loop
        fprintf("[TKF] could not compute time to speed, drag may be too powerful :(\n");
        fprintf("{ERR} max speed achieved: %0.2f after %0.3fs\n", v_prev,timeToCruise);
        fprintf("      traveled: %0.2f m\n", distToCruise);
        fprintf("\n");
    end
    % in case takeoff needs more space than provided
    if (distToCruise > zCRUISE_DIST)
        if (DEBUG)
            fprintf("{DBG} exited takeoff calcs in %d steps\n", itr);
        end
        v = speed;
        fprintf("[TKF] takeoff distance exceeds cruise space of %0.0f m!\n", zCRUISE_DIST);
        fprintf("{ERR} retry with new values!\n");
        fprintf("      traveled %0.2f\n", distToCruise);
        fprintf("\n");
    end
    % in case velocity is negative
    if (v < 0)
        if (DEBUG)
            fprintf("{DBG} completed takeoff calcs in %d steps\n", itr);
        end
        v = speed;
        fprintf("[TKF] takeoff velocity became negative\n");
        fprintf("{ERR} not sure why, try new values...\n");
        fprintf("\n");
    end
end
% deallocate variables that are no longer used
clearvars v v_prev t_step itr

% find cruise time
cruiseTime = zCRUISE_DIST / speed;
if (DEBUG)
    fprintf("[CRU] cruise time over %0.0fm found: %0.2fs\n", zCRUISE_DIST, cruiseTime);
    fprintf("      total cruise time is: %0.2fs\n", cruiseTime * 18);
    fprintf("\n");
end

% find turn time
turnRadius = (speed^2) / (zACCEL_G * tand(zBANK_ANGLE)); % m
arcLength = 2 * pi * turnRadius * (zTURN_ANGLE / 360);  % m
turnRate = zACCEL_G * tand(zBANK_ANGLE) / speed;         % rad ?
% debug prints for turning
if (DEBUG)
    fprintf("{DBG} turn radius found: %0.2f m\n", turnRadius);
    fprintf("      arc length found: %0.2f m\n", arcLength);
    fprintf("      turn rate found: %0.2frad/s\n", turnRate);
end
% double check those turn values just in case
turnTime = deg2rad(zTURN_ANGLE) / turnRate;
if (DEBUG)
    fprintf("[TRN] turn time found: %0.2f s\n", turnTime);
    fprintf("      total turn time found: %0.2f s\n", turnTime * 10);
    fprintf("\n");
end

%
% OK using deg2rad in (turnTime = deg2rad(...) seems to help, still not sure
% if its accurate!
% NOTE TURN TIME DOES NOT INCORPORATE RADIUS / ARC LENGTH
%

% circle time calcs
% literally just double the turn time (it already works for 180 deg)
% and do that 5 times... (turnTime * 2 * 5
circleTime = turnTime * 2;
if (DEBUG)
    fprintf("[CRL] circle time found: %0.2f\n", circleTime);
    fprintf("\n");
end

% calc total time
for (i = [1:5])
    if (DEBUG)
        fprintf("{DBG} Step %d\n", i);
    end
    % only skip the first straight stretch
    if (i ~= 1)
        if (DEBUG)
            fprintf("      added cruise time\n");
        end
        totalTime = totalTime + cruiseTime;
    else
        if (DEBUG)
            fprintf("      added takeoff time\n");
            fprintf("      added remaining time after takeoff\n");
        end
        totalTime = totalTime + timeToCruise;
        % add whatever dist is not covered by takeoff
        totalTime = totalTime + ((zCRUISE_DIST - distToCruise) / speed);
    end
    if (DEBUG); fprintf("      added turn time\n"); end
    totalTime = totalTime + turnTime;
    if (DEBUG); fprintf("      added cruise time\n"); end
    totalTime = totalTime + cruiseTime;
    if (DEBUG); fprintf("      added circle time\n"); end
    totalTime = totalTime + circleTime;
    if (DEBUG); fprintf("      added cruise time\n"); end
    totalTime = totalTime + cruiseTime;
    if (DEBUG); fprintf("      added turn time\n"); end
    totalTime = totalTime + turnTime;
    if (i ~= 5)
        if (DEBUG); fprintf("      added cruise time\n"); end
        totalTime = totalTime + cruiseTime;
    else
        % add landing time!
    end
end

% total time of flight
fprintf("[TOT] total time: %0.2fs (%0.2fm)\n", totalTime, totalTime / 60);

% reminders:
% remember that drag will impact turns

% also speed is non-constant during turns

% create a formula for the drag coeff based on Fx
% \ ref: https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/2P7gnfKohR8Rz8LWmu0UvG.html

% turns currently dont use the arc length

% NO AI
% I prefer my shitty codebase made by HUMAN HANDS
% FUCK AI