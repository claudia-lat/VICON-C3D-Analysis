
function [c3d,c3d_config] = read_c3d_trial(varargin)
%
% EXAMPLE
% c3d = read_c3d_trial('C:\test.c3d')
% c3d = read_c3d_trial('C:\test.c3d',itf)
%
% Read a single c3d trial
% INPUT
% fullpath : is the fullpath of c3d file
% OPTIONAL
% itf: server object created using c3dserver or btkEmulateC3Dserver()
%
% OUTPUT
% c3d_struct is the c3d structure (see manual )
%
%
% Copyright (c) 2014, Marco Jacono, Alberto Inuggi, Claudio Campus
% All rights reserved.
%
% BSD LICENSE\
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice,
%    this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
% OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
% AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
% IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
% THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


if nargin < 1 || nargin > 3
    help read_c3d_trial
    error('c3dToolbox:WrongNumberInput','Function require 1 or 2 input -> full pathname and/or c3dserver object\n')
end

if not(ischar(varargin{1}))
    error('c3dToolbox:WrongTypeInput','Pathname must be a char array\n')
end

if not(exist(varargin{1},'file') )
    error('c3dToolbox:FileNotFound','Check fullpath, file not found\n')
end

if nargin == 2
    % verifico se c3d server è coerente
    if not(xor(isa(varargin{2},'COM.C3DServer_C3D') ,isstruct(varargin{2})))
        error('c3dToolbox:C3Dserverfail','C3D server not valid object\n')
    end
    itf = varargin{2};
end

if nargin == 1
    % Retrive PC and MATLAB info to properly setup the C3D COM Object.
    [os_ver, os_bit, matlab_ver, matlab_bit, matlab_tlbx] = get_pc_settings();
    if strcmp(os_ver, 'Win') && strcmp(os_bit, '32')
        clc
        disp('c3dserver loaded')
        itf = c3dserver;
    else
        itf = btkEmulateC3Dserver();
        disp('btkEmulate loaded')
    end
end

c3d_config = varargin{3};
session_path            = c3d_config.path.session;
itf                     = c3d_config.itf;

session_path = varargin{1};
openc3d_mute(itf,0,session_path);
c3d.info.fullpath = session_path;
[PATHSTR,NAME,EXT] = fileparts(session_path);
c3d.info.path = PATHSTR;
c3d.info.name = NAME;
c3d.info.ext = EXT;
c3d.info.HEADER.nPoints = itf.GetNumber3DPoints();
c3d.info.HEADER.nAnalog = itf.GetAnalogChannels();
c3d.info.HEADER.nStartFrame = itf.GetVideoFrameHeader(0);
c3d.info.HEADER.nEndFrame = itf.GetVideoFrameHeader(1);
c3d.info.HEADER.nStartRecord = itf.GetStartingRecord();
c3d.info.HEADER.nRatio = itf.GetAnalogVideoRatio();
c3d.info.HEADER.fRate = itf.GetVideoFrameRate();
c3d.info.HEADER.nType = itf.GetFileType();
c3d.info.HEADER.nDataType = itf.GetDataType();
c3d.info.HEADER.nEvents = itf.GetNumberEvents();




% This gives you the number of markers for which data is present in the file.
% This information is taken from the header record of the file.
c3d.info.LABELIZATION=[];
c3d.info.markerlist_name = {};
Max_Param = itf.GetNumberParameters()-1;
% Nomi dei Parametri
for nParams = 0:Max_Param
    ParamName_list{nParams+1} = itf.GetParameterName(nParams);
end
%Nomi dei Gruppi
for nGroups = 0:itf.GetNumberGroups()-1
    GroupName_list{nGroups+1} = itf.GetGroupName(nGroups);
end



% Ciclo su tutti i nomi e tutti i Parametri
for GroupNameid = GroupName_list
    GroupName= GroupNameid{:};
    for ParamNameid = unique(ParamName_list)
        ParamName= ParamNameid{:};
        % Ricavo index per la coppia GROUP-PARAM
        nIndex = itf.GetParameterIndex(GroupName, ParamName);            
        
        if nIndex > -1 % Esiste la coppia
            % Il parametro è associato ad un gruppo,
            % fprintf('%s:%s:%d\n',GroupName,ParamName,nIndex)
            
            c3d.info.(GroupName).Name = GroupName;
            c3d.info.(GroupName).Number = itf.GetGroupNumber(nGroups);
            c3d.info.(GroupName).Status = itf.GetGroupLock(nGroups);
            c3d.info.(GroupName).Description = itf.GetGroupDescription(nGroups);
            n_elem = itf.GetParameterLength(nIndex);
            %fprintf('Group%d:%s  Param%d:%s n_elem:%d Index:%d\n',nGroups,GroupName,nParams,ParamName,n_elem,nIndex)
            for n = 0:n_elem-1
                value = itf.GetParameterValue(nIndex,n);
                c3d.info.(GroupName).(ParamName){n+1}= value;
                
                if strcmp(GroupName,'POINT') &&  strcmp(ParamName,'LABELS')
                    xyz = [itf.GetPointDataEx(n,0,c3d.info.HEADER.nStartFrame,c3d.info.HEADER.nEndFrame,'1'), ...
                        itf.GetPointDataEx(n,1,c3d.info.HEADER.nStartFrame,c3d.info.HEADER.nEndFrame,'1'), ...
                        itf.GetPointDataEx(n,2,c3d.info.HEADER.nStartFrame,c3d.info.HEADER.nEndFrame,'1')];
                    % Value contiene il nome del marker se sono dentro
                    % questa coppia POINT:LABELS
                    if ischar(value)
                        % Il nome del marker è composta dal nome della
                        % labellizzazione + il contenuto di
                        % SUBJECT.USES_PREFIXES  Rimuovo i ':' e sostituisco
                        % con '_' in quanto non sono supportati com nome campo
                        % di una struttura
                        value(value==':') = '_';
                        value(value=='-') = '_';
                        % se il primo carattere di value è un '*' allora il marker
                        % non è stato labellizzato, imposto un nome di default e
                        % segno con flag = 0 il campo info.LABELIZATION
                        if strcmp(value(1),'*')
                            value(value=='*') = 'M';
                            label = 0;
                            c3d.info.LABELIZATION = [c3d.info.LABELIZATION label];
                        else
                            label = 1;
                            c3d.info.LABELIZATION = [c3d.info.LABELIZATION label];
                        end
                    end
                    % Se nel file di config voglio labellizzati allora
                    % inserisco solo se label = 1
                    if strcmp(c3d_config.markerlist,'labeled') == 1 && label == 1
                        c3d.markers.(value).xyz = cell2mat(xyz);
                        c3d.info.markerlist_name = {c3d.info.markerlist_name{:} value};
                    end
                    
                    % Inserisco solo i marker non labellizzati
                    if strcmp(c3d_config.markerlist,'unlabeled') && label == 0
                        c3d.markers.(value).xyz = cell2mat(xyz);
                        c3d.info.markerlist_name = {c3d.info.markerlist_name{:} value};
                    end
                    
                    % Inserisco solo quelli nella lista
                    if sum(strcmp(c3d_config.markerlist,value))
                        c3d.info.(GroupName).(ParamName){n+1} = value;
                        c3d.info.markerlist_name = {c3d.info.markerlist_name{:} value};
                    end
                    
                    % se uso all li metto tutti
                    if strcmp(c3d_config.markerlist,'all')
                        c3d.markers.(value).xyz = cell2mat(xyz);
                        c3d.info.markerlist_name = {c3d.info.markerlist_name{:} value};
                    end
                end
                
                if strcmp(GroupName,'ANALOG') &&  strcmp(ParamName,'LABELS')
                    analogV = itf.GetAnalogDataEx(n,c3d.info.HEADER.nStartFrame,c3d.info.HEADER.nEndFrame,1,0,0,0);
                    c3d.analogs.(value).raw = cell2mat(analogV);
                    
                end
                
            end
        end
    end
end


