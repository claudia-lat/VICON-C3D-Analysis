function [session, c3d_config] = filter_c3d_coord(session,c3d_config)
%
% TEMPLATE
% 
% session = filter_session_coord(session,session_config);
%
% Copyright (c) 2014, Marco Jacono, Alberto Inuggi, Claudio Campus
% All rights reserved.
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
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
% OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
% AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
% IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
% THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

for trial = 1:c3d_config.Max_trial
    % Ogni funzione dovrebbe aggiungere "se stessa" alla pipeline
    session{trial} = add_pipeline(session{trial},['filtro_coord_' c3d_config.filter.type '_' num2str(c3d_config.filter.coord_cutoff)]);       
    % Create filter info struct
    session{trial}.info.filtro.coord.fc = double(session{trial}.info.HEADER.fRate) ; % Frequenza di campionamento Coordinate
    session{trial}.info.filtro.coord.ft = c3d_config.filter.coord_cutoff; % Frequenza di taglio passa basso
    session{trial}.info.filtro.coord.fn = session{trial}.info.filtro.coord.fc/2; % Frequenza Nyquist
    session{trial}.info.filtro.coord.wn = session{trial}.info.filtro.coord.ft./session{trial}.info.filtro.coord.fn;
    [session{trial}.info.filtro.coord.b,session{trial}.info.filtro.coord.a] = butter(2,session{trial}.info.filtro.coord.wn);
    session{trial}.info.filtro.coord.type =c3d_config.filter.type;   
    for marker_label = session{trial}.info.markerlist_name 
            xyz = session{trial}.markers.(marker_label{:}).xyz;   
            session{trial}.markers.(marker_label{:}).xyzf = filtfilt(session{trial}.info.filtro.coord.b,session{trial}.info.filtro.coord.a,double(xyz));
    end
    fprintf('Filtering trial %d\n',trial);
end