function [session,c3d_config] = read_c3d_session(c3d_config)
%
%
%  READ_C3D_SESSION
%
%  [session,c3d_config] = read_c3d_session(c3d_config)
%
%   Create session structure. Load every C3D trial inside folder specified
%   in c3d_config.path.session. To properly create c3d_config structure see
%   also CREATE_CONFIG
%
%   OUTPUT
%   session is the session structure, a collection of c3d
%   structure.
%   See also CREATE_CONFIG, READ_C3D_TRIAL
%
% Copyright (c) 2014, Marco Jacono
%
% BSD LICENSE
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
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF 
% THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% Clear Command Window
clc

% Assign Input Arguments
session_path            = c3d_config.path.session;
itf                     = c3d_config.itf;
file_list               = dir(session_path);
fprintf('Processing folder: %s\n', session_path);

% for..loop in the entire folder, not all files can be c3d, but only c3d
% will be processed

trial = 0;
fprintf('Building struct\n',trial)
for file_id = 1:length(file_list )
    [PATHSTR,NAME,EXT] = fileparts(file_list(file_id).name); %#ok<ASGLU>
    
    if strcmp(EXT,'.c3d')             % If file extension is c3d
        trial = trial + 1;
        % Call read_c3d_trial 
        % [c3d,c3d_config] = read_c3d_trial(varargin)
        
        [session{trial},c3d_config] = read_c3d_trial(fullfile(session_path,file_list(file_id).name),itf,c3d_config);
        fprintf('.%04d',trial)
        if rem(trial,10)==0
            fprintf('\n');
        end
        session{trial}.info.trial_id       = str2num(NAME((double(NAME) >= 48) & (double(NAME) <= 56)));
        session{trial}.info.nSamples = session{trial}.info.HEADER.nEndFrame-session{trial}.info.HEADER.nStartFrame + 1;
        fRate = session{trial}.info.HEADER.fRate;
        if session{trial}.info.HEADER.nPoints > 0
            session{trial}.info.Tmax = session{trial}.info.nSamples/fRate;
            session{trial}.info.time = linspace(0,session{trial}.info.Tmax,session{trial}.info.nSamples);
        end
        if session{trial}.info.HEADER.nAnalog > 0 % Esistono canali analogici
            aRate = session{trial}.info.ANALOG.RATE{:};
            session{trial}.info.time_analog = linspace(0,session{trial}.info.Tmax,round(session{trial}.info.nSamples*aRate/fRate));
        end
        
        
    end
end
c3d_config.Max_trial = trial;
fprintf('\nc3d_config updated\n')