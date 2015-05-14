function [session, c3d_config] = cut_velocity_profile(session,c3d_config)
%
% PROTOTYPE
% [session, c3d_config] = cut_velocity_profile(session,c3d_config)
%
% c3d_config.V_cut_method = = {'threshold-inv' , 0.01, 'wrist'}
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

method = c3d_config.V_cut_method{1};
% Dato che V deve esistere deve essere gia stata lanciata la procedura di
% calcolo delle velocità : il campo Vm deve esistere altrimenti va eseguite


switch method
    case 'threshold-inv'
        for trial = 1:c3d_config.Max_trial
            
            marker_ref = c3d_config.V_cut_method{3};
            Vthreshold = max(session{trial}.markers.(marker_ref).Vm)/2; %mm/sec
            idx_pivot = find(session{trial}.markers.(marker_ref).Vm > Vthreshold,1,'first');
           
            V = session{trial}.markers.(marker_ref).Vm;
             idx_half = round(length(V)*.75);
            
            %% Muoviti a destra fino a che non trovi il valore piu alto
            % Fallisce se trova un picco prima di Vmax
%             Vmax = 0;
%             go = 1;
%             idx_go = idx_pivot;
%             while go
%                 V = session{trial}.markers.(marker_ref).Vm(idx_go);
%                 if V >= Vmax
%                     Vmax = V;
%                 elseif (V < Vmax)
%                     go = 0;
%                     idx_vmax = idx_go - 1;
%                     time_vmax = session{trial}.info.time(idx_vmax) ;
%                 end
%                 idx_go = idx_go + 1;
%             end

            [Vmax,idx_vmax] = max(V(1:idx_half));
            time_vmax = session{trial}.info.time(idx_vmax) ;
            
            %% Muoviti a destra fino a che non scende sotto soglia o trova inversione
            Vmin = Vmax;
            go = 1;
            idx_go = idx_vmax;
            while go    
                idx_go
                V = session{trial}.markers.(marker_ref).Vm(idx_go);
                % Quando inverte direzione
                c1 = 0;%V > Vmin;
                % Quando è minore soglia
                c2 = (V<Vmax*c3d_config.V_cut_method{2}(2));
                % Quando arriva la termine del vettore
                c3 = (idx_go >=session{trial}.info.nSamples);
                if c1 || c2 || c3
                    go = 0;
                    idx_vend = idx_go - 1;
                    time_vend = session{trial}.info.time(idx_vend);
                elseif (V <= Vmin)
                    Vmin = V;
                end                    
                idx_go = idx_go + 1; 
            end
            %% Muoviti a sinistra fino a che non scende sotto soglia o trova inversione
            Vmin = Vmax;
            go = 1;
            idx_go = idx_vmax;
            while go
                V = session{trial}.markers.(marker_ref).Vm(idx_go);
                % Quando inverte direzione
                c1 = 0 ;%V > Vmin;
                % Quando è minore soglia
                c2 = (V<Vmax*c3d_config.V_cut_method{2}(1));
                % Quando arriva la termine del vettore
                c3 = (idx_go < 1);
                if c1 || c2 || c3
                    go = 0;
                    idx_vstart = idx_go + 1;
                    time_vstart = session{trial}.info.time(idx_vstart);
                elseif (V <= Vmin)
                    Vmin = V;
                end                    
                idx_go = idx_go -1 ; 
            end
            session{trial}.proc.cut.tmax =  time_vmax;
            session{trial}.proc.cut.tmax_sample =  idx_vmax;
            session{trial}.proc.cut.tend =  time_vend;
            session{trial}.proc.cut.tend_sample =  idx_vend;
            session{trial}.proc.cut.tstart =  time_vstart;
            session{trial}.proc.cut.tstart_sample =  idx_vstart;
            fprintf('Cutting Velocity profile in trial %d\n',trial);
        end
end







