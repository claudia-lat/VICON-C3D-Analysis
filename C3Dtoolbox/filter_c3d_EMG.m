function [session, c3d_config] = filter_c3d_EMG(session,c3d_config)

%
% TEMPLATE
%
% [session, c3d_config] = filter_c3d_EMG(session,c3d_config)
%
% Filtra il dato analogico come un EMG passa banda + rettifica + inviluppo
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
    
    if session{trial}.info.ANALOG.RATE{:} > 0
        
        % Se esiste acquisizione analogica
        % Ogni funzione dovrebbe aggiungere "se stessa" alla pipeline
        session{trial} = add_pipeline(session{trial},['Rettifica  inviluppo EMG']);
        % Create filter info struct
        session{trial}.info.filtro.analog.fc = session{trial}.info.ANALOG.RATE{:} ; % Frequenza di campionamento Coordinate
        session{trial}.info.filtro.analog.ft = c3d_config.filter.analog.cutoff; % Frequenza di taglio passa banda
        session{trial}.info.filtro.analog.fn = session{trial}.info.filtro.analog.fc/2; % Frequenza Nyquist
        session{trial}.info.filtro.analog.wn = session{trial}.info.filtro.analog.ft./session{trial}.info.filtro.analog.fn;
        [session{trial}.info.filtro.analog.b,session{trial}.info.filtro.analog.a] = butter(2,session{trial}.info.filtro.analog.wn);
        session{trial}.info.filtro.analog.type =c3d_config.filter.type;
        for emg_label = session{trial}.info.ANALOG.LABELS
            emg = session{trial}.analogs.(emg_label{:}).raw;
            session{trial}.analogs.(emg_label{:}).filt = filtfilt(session{trial}.info.filtro.analog.b,session{trial}.info.filtro.analog.a,double(emg));
            session{trial}.analogs.(emg_label{:}).filt = abs(session{trial}.analogs.(emg_label{:}).filt);
            wn = c3d_config.filter.analog.low_pass./session{trial}.info.filtro.analog.fn;
            [b,a] = butter(2,wn);
            emg = session{trial}.analogs.(emg_label{:}).filt;
            session{trial}.analogs.(emg_label{:}).filt = filtfilt(b,a,double(emg));
            
        end
        fprintf('Filtering trial %d\n',trial);

        
    end
end