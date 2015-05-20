function dataAnalysis(subject_no,trial_no)

rawData = importdata(sprintf('xsense_save_%d_%d.dat',subject_no,trial_no));

t = rawData(:,end) - rawData(1,end);

accln = rawData(:,1:3);
gyro = rawData(:,4:6);

plot(t./1000,accln);
xlabel('time t(sec)');
ylabel('Accelerometer reading m/sec^2');
axis tight; grid on;
figure;
plot(t./1000,gyro);
xlabel('time t(sec)');
ylabel('Gyro reading rad/sec');
axis tight; grid on;
 %end
