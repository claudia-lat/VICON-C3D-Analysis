Nframes = length(c3d.obj1.in1)

for j = 1:Nframes
    
    p1 = c3d.obj1.pol4(j,:);
    p2 = c3d.obj1.pol3(j,:);
    p3 = c3d.obj1.pol1(j,:);    
    [c,r] = circle3d(p1,p2,p3);
    C(j,1:3) = c;
    R(j) = r;
end
    