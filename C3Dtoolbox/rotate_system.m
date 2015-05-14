function [session, c3d_config] = rotate_system(session,c3d_config)

% session.MARKERNAME.xyzR   [Frame x 3] in New Reference system
% session.MARKERNAME.VmR    [Frame x 1]

markerR1 = c3d_config.markers_rotation_list{1};
markerR2 = c3d_config.markers_rotation_list{2};
markerR3 = c3d_config.markers_rotation_list{3};

for trial = 1:c3d_config.Max_trial
    for marker_label = session{trial}.info.markerlist_name
        for samples = 1:session{trial}.info.nSamples
            X1 = session{trial}.markers.(markerR1).xyzf(samples,:);
            X2 = session{trial}.markers.(markerR2).xyzf(samples,:);
            X3 = session{trial}.markers.(markerR3).xyzf(samples,:);
            [session{trial}.markers.Rmtx(:,:,samples), session{trial}.markers.Po(samples,:)] = compute_rotation_mtx(X1,X2,X3);
            
            xyzf = session{trial}.markers.(marker_label{:}).xyzf(samples,:);
            xyzfR = rotate_frame(xyzf,squeeze(session{trial}.markers.Rmtx(:,:,samples)),session{trial}.markers.Po(samples,:));
            session{trial}.markers.(marker_label{:}).xyzfR(samples,:) = xyzfR;
        end
        VxyzfR = [0 0 0; diff(session{trial}.markers.(marker_label{:}).xyzfR)*double(session{trial}.info.HEADER.fRate)];
        VmR = sqrt(sum(VxyzfR.* VxyzfR,2));
        session{trial}.markers.(marker_label{:}).VxyzfR = VxyzfR;
        session{trial}.markers.(marker_label{:}).VmR = VmR;
    end
end