subjectList = 1:12;
trialList = 1:5;

for subjectID = 1:length(subjectList)
    for trialID = 1:length(trialList)
        clear rawData;
        rawData = importdata(sprintf('./capture_22_01_2016/xsense_save_%d_%d.dat',subjectID,trialID));
        t = rawData(:,end) - rawData(1,end);

        accln = rawData(:,1:3);
        gyro = rawData(:,4:6);
        imuData(subjectID,trialID).t = t;
        imuData(subjectID,trialID).accln = accln;
        imuData(subjectID,trialID).gyro = gyro;
    end
end

save('./imuExtractedData_newData.mat','imuData');
