
function filtro = create_filter(varargin)
%
% PROTOTYPE
% filtro = create_filter(coordinate_filter,analog_filter)
% 
% EXAMPLE
% filtro = create_filter(7,[20 250])
% filtro = create_filter(25,200)
%
% 
% INPUT
% coordinate_filter : cut frequency for coordinates, one element for LOW PASS
% filter, two element for BAND PASS filter
% analog_filter : cut frequency for analog data, one element for LOW PASS
% filter, two element for BAND PASS filter
%
% OUTPUT
% filter_struct
%
% Filtro 
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

filtro.coord.fc = session{1}.info.HEADER.fRate ; % Frequenza di campionamento Coordinate
filtro.coord.ft = 6; % Frequenza di taglio passa basso
filtro.coord.fn = filtro.coord.fc/2; % Frequenza Nyquist
filtro.coord.wn = filtro.coord.ft/filtro.coord.fn;
[filtro.coord.b,filtro.coord.a] = butter(2,filtro.coord.wn);

%% Filtro emg
filtro.emg.fc = 1000 ; % Frequenza di campionamento Coordinate
filtro.emg.ftbanda = [10 250] ; % Passa Banda
filtro.emg.ft = 5; % Frequenza di taglio passa basso
filtro.emg.fn = filtro.emg.fc/2; % Frequenza Nyquist
filtro.emg.wnbanda = filtro.emg.ftbanda/filtro.emg.fn;
filtro.emg.wn = filtro.emg.ft/filtro.emg.fn;
[filtro.emg.bbanda,filtro.emg.abanda] = butter(2,filtro.emg.wnbanda);
[filtro.emg.b,filtro.emg.a] = butter(2,filtro.emg.wn);