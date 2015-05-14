
%% BTK ANALISYS

%% ACQUISITION DATA AND POINTS BTK
% An acquisition contains points (parameter with 3 components), analog 
% channels (parameter with 1 component), events and metadata.


clear all;
close all;
clc;

% acquisition files
acq = btkReadAcquisition('gait-pig.c3d');

% extract markers trajectories: markers is a structure containing the 3D 
% trajectory of each markers.
[markers, markersinfo, markersresidual] = btkGetMarkers(acq);

% % plot a field of markers
% plot(markers.A22_RKNE);
% title ('title');
% xlabel(' x axis name');
% ylabel(' y axis name');

% extract angles, forces, moments, powers
[angles, angleinfo] = btkGetAngles(acq);
[forces, forcesinfo] = btkGetForces(acq);
[moments, momentsinfo] = btkGetMoments(acq);
[powers, powersinfo] = btkGetPowers(acq);

% build points (markers, forces, moments, angles, powers)
[points, pointsinfo]  = btkGetPoints(acq);

% to extract only few points from an acquisition and return then as a matrix
pointsLabel = {'A22_LHipAngles', 'A22_RHipAngles'};
extractedPoints = zeros(btkGetPointFrameNumber(acq), length(pointsLabel)*3);

for i = 1:length(pointsLabel)
    extractedPoints(:, 1+(i-1)*3:i*3) = points.(pointsLabel{i});
end

% % extract 5th row 
% b = extractedPoints(5, :)

% order fields in the struct
markersO = orderfields(markers);

% M = zeros (length(fields(markers)));
% markersLabel = [fields(markers)];
markersC = struct2cell(markersO);
M = cell (length(fields(markers)));

for k = 1:length(fields(markers))
    for j = 1:length(fields(markers))
        if k < j
            M{k,j} = 0;
        else
            M{k,j}= markersC{k,1} - markersC{j,1};
            % markers.(markersLabel{k}) - markers.(markersLabel{j});
        end
    end
end

%% ANALOG CHANNELS
% % The analog channels contains all the 1D measures. All the sensors 
% % measuring voltage, angular velocity, acceleration, etc., should be stored
% % in analog channels. From the hardware point of view, it corresponds to
% % the sensors plugged into the analog to digital converter (ADC) card.
% 
% % create a  struct annalogs where each field correspond to a analog channel
% analogs = btkGetAnalogs(acq);
% 
% % comparing points/analog frequencies
% analogsfreq = btkGetAnalogFrequency(acq);
% pointsfreq = btkGetPointFrequency(acq);
% ratiofreq = btkGetAnalogSampleNumberPerFrame(acq);
% disp(['For 1 video frame you have ' num2str(ratiofreq) ' samples for each analog channel']);

%% EVENTS

% % extract events
% events = btkGetEvents(acq);

%% METADATA
% % A metadata is a generic container to store the acquisition configuration.
% % Or said differently, a metadata contains every informations which cannot
% % be set into markers' trajectories nor analog channels' measures, nor 
% % events. For example, if you want to include subject's informations (sex, 
% % weight, height, ...) or force platform's configuration (corner's 
% % coordinates, analog channel used, ...), then the metadata are the right 
% % place to do this. In the C3D file format, the metadata are known as 
% % groups and parameters.
% 
% md = btkGetMetaData(acq);
% X = md.children.ANALYSIS.children.SUBJECTS..info.values;
% 
% % to verify if a metadata exists
% % md = btkFindMetaData(acq, 'SUBJECTS', 'WEIGHT');
% % if (md ~= 0) % exists
% %   weight = md.info.values; % the returned structure is directly the content of the metadata SUBJECTS:WEIGHT.
% % end
