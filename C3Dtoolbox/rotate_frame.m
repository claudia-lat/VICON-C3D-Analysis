function xyzR = rotate_frame(xyz,R,Po)

xyzR = (xyz-Po)*R;