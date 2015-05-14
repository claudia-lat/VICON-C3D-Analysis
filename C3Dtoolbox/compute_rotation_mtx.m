function [Rmtx,Po] = compute_rotation_mtx(X1,X2,X3)

versx = normr(X2-X1);
r = normr(X3-X1);
versz = normr(cross(r,versx));
versy = (cross(versx,versz));

Rmtx = [versx(:) versy(:) versz(:)];
Po = X1;




