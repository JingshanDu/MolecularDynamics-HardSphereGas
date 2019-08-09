% Exercise 3
% Molecule Dynamics with Hard Sphere Model
% Periodic boundary conditions and uniform distributed initial conditions
% Traditional searching algorithm (WITHOUT NEIGHBOR TABLE)
% Jingshan Du, Zhejiang University, dujingshan@zju.edu.cn
clear all;
close all;
clc;
global Position Velocity CollideMap1 diameter graphpause;

% Parameters
graph = 1;          % whether draw a graph of position every 10 steps
graphpause = 1e-3;   % seconds between frames
stepMax = 5000;
% t_max = 1000;
length = 10;        % overall box length
n = 256;            % number of molecules, MUST BE EVEN NUMBER!
diameter = 1e-1;    % sphere diameter
delta = 0.05;       % delta v in function H

% Variables
Position = zeros(n,3);
Velocity = zeros(n,3);
CollideMap1 = zeros(n,n);    % stores time span
CollideNext = zeros(n,2);	% 1:number, 2:time span
time = zeros(stepMax,1);
macroEnergy = zeros(stepMax,1);
macroSDVelocity = zeros(stepMax,1);
macroVelocity = zeros(stepMax,1);
macroH = zeros(stepMax,1);
tempVnorm = zeros(n,1);
tempmv = zeros(3);
position1 = zeros(stepMax,3);

% Initialization
% NOTE: GNU Octave have no 'random' function. modify before use!
Position(1:n,:) = random('unif',zeros(n,3),length*ones(n,3));
Velocity(1:n/2,:) = random('unif',zeros(n/2,3),ones(n/2,3));
Velocity(n/2+1:n,:) = -Velocity(1:n/2,:);   % to ensure sum velocity = 0

% Run
% check & calc one to one
for i=1:n
    for j=i+1:n
        CollideMap1(i,j) = CalcCollision(i,j);
    end
end
CollideMap = CollideMap1 + CollideMap1';

% Circulation
if graph == 1
    figure(1);
end
for step = 1:stepMax
    % find smallest
    for i=1:n
        [CollideNext(i,1) CollideNext(i,2)] = FindSmallest(CollideMap(:,i));
    end
    [TheNext(1),TheNext(2)] = FindSmallest(CollideNext(:,2));

    % turn to the time a collision happens
    % update position and velocity
    Position = Position + Velocity * TheNext(2);
    tempV = [Velocity(TheNext(1),:);Velocity(CollideNext(TheNext(1),1),:)];
    tempR = Position(TheNext(1),:) - Position(CollideNext(TheNext(1),1),:);
    tempR = tempR/norm(tempR);
    Velocity(TheNext(1),:) = tempV(1,:) - dot(tempV(1,:),tempR)*tempR + dot(tempV(2,:),tempR)*tempR;
    Velocity(CollideNext(TheNext(1),1),:) = tempV(2,:) - dot(tempV(2,:),tempR)*tempR + dot(tempV(1,:),tempR)*tempR;
    
    % handle periodic conditions
    Position = PeriodicHandler(Position,length);
    
    % update all other estimated collision time
    for li=1:n
        for lj=1:n
            if CollideMap(i,j)>0
                CollideMap(i,j) = CollideMap(i,j) - TheNext(2); 
            end
        end
    end
              
    % update estimated collision for only the two collided spheres
    for k=1:n
        CollideMap(TheNext(1),k) = CalcCollision(TheNext(1),k);
    end
    for k=1:n
        CollideMap(CollideNext(TheNext(1),1),k) = CalcCollision(CollideNext(TheNext(1),1),k);
    end
    
    % Calculate macro quantities
    for i = 1:n
        tempVnorm(i) = norm(Velocity(i,:));
    end
    macroEnergy(step+1) = dot(tempVnorm,tempVnorm);
    macroSDVelocity(step+1) = std(tempVnorm);
    for i = 1:3
        tempmv(i) = sum(Velocity(:,i));
    end
    macroVelocity(step+1) = norm(tempmv);
    fv(1,:) = DrawDG(Velocity(:,1),delta,1);
    fv(2,:) = DrawDG(Velocity(:,2),delta,0);
    fv(3,:) = DrawDG(Velocity(:,3),delta,0);
    temph = 0;
    for i = 1:3
        temph = temph + sum(dotr(fv(1,:),log(fv(1,:)))*delta);
    end
    macroH(step+1) = temph/3;
    time(step+1) = time(step) + TheNext(2);                       % update time
    
    % update graphics
    if graph == 1
        if mod(step,10)==0
            subplot(121);
            %scatter(Position(:,1),Position(:,2),[],Position(:,3))
            scatter3(Position(:,1),Position(:,2),Position(:,3))
            pause(graphpause)
        end
    end
end

% generate chart for macro properties
figure(2);
subplot(221);
plot(macroSDVelocity(2:size(macroSDVelocity)))
ylabel('Standard Deviation of Velocity');
subplot(222);
plot(macroEnergy(2:size(macroEnergy)))
ylabel('Energy');
subplot(223);
plot(macroVelocity(2:size(macroVelocity)))
ylabel('Velocity');
subplot(224);
plot(macroH(2:size(macroH)))
ylabel('H Function');

