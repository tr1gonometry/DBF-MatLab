clear;clc;
%data input 
straightDistance = input('Enter total straight distance per lap (m): ');
turns = input('Enter number of turns per lap: ');
turnRadius = input('Enter radius of each turn (m): ');

cruiseSpeed = input('Enter cruise speed (m/s): ');
weight = input('Enter takeoff weight (N): ');
thrust = input('Enter thrust (N): ');

dragCoefficient = input('Enter drag coefficient: ');
frontalArea = input('Enter frontal area (m^2): ');
airDensity = input('Enter air density (kg/m^3): ');

maxTurningG = input('Enter maximum turning acceleration in g: ');


gravity = 9.81;                 
mass = weight / gravity;        
totalTime = 5 * 60;             


drag = 0.5 * airDensity * dragCoefficient * ...
       frontalArea * cruiseSpeed^2;


netForce = thrust - drag;
acceleration = netForce / mass;


turningAcceleration = maxTurningG * gravity;
turnSpeed = sqrt(turningAcceleration * turnRadius);


actualTurnSpeed = min(cruiseSpeed, turnSpeed);


turnDistance = turns * pi * turnRadius;
lapDistance = straightDistance + turnDistance;


turnTime = turnDistance / actualTurnSpeed;


if acceleration > 0
    accelerationTime = cruiseSpeed / acceleration;
    accelerationDistance = 0.5 * acceleration * accelerationTime^2;

    if accelerationDistance < straightDistance
        remainingDistance = straightDistance - accelerationDistance;
        cruiseTime = remainingDistance / cruiseSpeed;
        straightTime = accelerationTime + cruiseTime;
    else
        
        straightTime = sqrt(2 * straightDistance / acceleration);
    end
else
    disp('Warning: thrust is not greater than drag.');
    straightTime = straightDistance / cruiseSpeed;
end

% laps
timePerLap = straightTime + turnTime;
numberOfLaps = totalTime / timePerLap;

% showing results 
fprintf('\nResults:\n');
fprintf('Mass: %.2f kg\n', mass);
fprintf('Drag force: %.2f N\n', drag);
fprintf('Net force: %.2f N\n', netForce);
fprintf('Turning speed: %.2f m/s\n', actualTurnSpeed);
fprintf('Time per lap: %.2f seconds\n', timePerLap);
fprintf('Number of laps in 5 minutes: %.2f laps\n', numberOfLaps);
fprintf('Completed full laps: %d laps\n', floor(numberOfLaps));

