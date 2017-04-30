function [KF_DSI] =  UpdateDSI(KF_DSI, Transformation_to_KF, event_image, KF_Homographies, KF_depths)
% Transformation_to_KF should transform an event_image in to th keyframe
% event_image is 180x240(original) or 231x309 (corrected)


%find first homography from KF image frame to the z0 plane
n_planes = size(KF_DSI,3);

r1 = Transformation_to_KF(:,1);
r2 = Transformation_to_KF(:,2);
r3 = Transformation_to_KF(:,3);
t = Transformation_to_KF(:,4);
z0 = KF_depths(1);

H0 = eye(3)*z0;
H0(3,3) = 1;

%apply homographies to event image to get pixels in all z0-z50 planes

    for i = 1:length(KF_Homographies)
        
        if i==1
            H = H0;
        else
        H = KF_Homographies(i)*Transformation_to_KF;
        end
        % transform event image to keyframe pose
        tform = affine2d(H);
        
        event_im_KF = imwarp(event_image, tform);

        % increment relevant DSI voxels
        KF_DSI(:,:,i) = KF_DSI(:,:,i) + event_im_KF;

    end

end