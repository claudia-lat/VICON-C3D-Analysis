function [session, c3d_config] = compute_distance(session,c3d_config)
%
% PROTOTYPE
% [session, c3d_config] = compute_distance(session,c3d_config)
%
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


for trial = 1:c3d_config.Max_trial  % Per ogni trial
    Nmarker = length(session{trial}.info.markerlist_name);
    session{trial}.proc.D = cell(Nmarker);
    for marker_id1 = 1:Nmarker-1
        for marker_id2 = (marker_id1 + 1): Nmarker
            
            label1 = session{trial}.info.markerlist_name{marker_id1};
            label2 = session{trial}.info.markerlist_name{marker_id2};
            xyzf1 = session{trial}.markers.(label1).xyzf;  
            xyzf2 = session{trial}.markers.(label2).xyzf;  
            
            session{trial}.proc.D{marker_id1,marker_id2} = sqrt(sum((xyzf1 - xyzf2).^2,2));
            session{trial}.proc.D{marker_id2,marker_id1} = session{trial}.proc.D{marker_id1,marker_id2};
            
        end
    end
    fprintf('Computing Distance in trial %d\n',trial);
end        

    
    

