function [session, c3d_config] = compute_velocity(session,c3d_config)
%
% PROTOTYPE
% session = compute_velocity(session,c3d_config)
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


for trial = 1:c3d_config.Max_trial
    for marker_label = session{trial}.info.markerlist_name
        xyzf = session{trial}.markers.(marker_label{:}).xyzf;   
        Vxyzf = [0 0 0; diff(xyzf)*double(session{trial}.info.HEADER.fRate)]; 
        Vm = sqrt(sum(Vxyzf.* Vxyzf,2));              
        session{trial}.markers.(marker_label{:}).Vxyzf = Vxyzf;
        session{trial}.markers.(marker_label{:}).Vm = Vm;   
    end 
    fprintf('Computing trial %d\n',trial);
end