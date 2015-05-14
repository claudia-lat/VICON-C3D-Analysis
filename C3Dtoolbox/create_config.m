function c3d_config = create_config(session_path)
%% Usage
%  c3d_config = create_config(session_path)
%  Setting up c3d_config structure
%  [session_path] : Folder with c3d data collection
%  [c3d_config] : structure with session configuration parameters
%  Also load C3D Server and set filters properties
%
%  See also GET_PC_SETTINGS

%% MARKERS LIST
%
%  Every data process will be done on markers specified in this list
%  * markerslist = {'MarkerName1','MarkerName2','MarkerName3'}; List of specific markers
%  * markerslist = {'labeled'}; Labeled markers only
%  * markerslist = {'unlabeled'}; Unlabeled markers only
%  * markerslist = {'all'}; All markers

c3d_config.markerlist = {'unlabeled'}; 

%% DEFINE PATHs
%
% Session Path : folder that contains a c3d trial collection
c3d_config.path.session = session_path;

%% C3D SERVER
%
% Load the C3D server according to machine and matlab type
% Retrive PC and MATLAB info to properly setup the C3D COM Object.

[os_ver, os_bit, matlab_ver, matlab_bit, matlab_tlbx] = get_pc_settings();
if strcmp(os_ver, 'Win') && strcmp(os_bit, '32')
    clc
    disp('c3dserver loaded')
    c3d_config.itf = c3dserver;
else
    c3d_config.itf = btkEmulateC3Dserver();
    disp('btkEmulate loaded')
end

%% FILTER CONFIGURATION
%
% Setting filter properties for both analog and coordinates data

c3d_config.filter.coord_cutoff = [6]; % LOW PASS
c3d_config.filter.analog_cutoff = [20 250]; % BAND PASS (for EMG data)
c3d_config.filter.type = 'butter';


