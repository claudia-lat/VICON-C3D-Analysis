subjectList = [1,2,3];
trialList = [1,2,3];

for subjectID = 1:length(subjectList)
    for trialID = 1:length(trialList)
        clear rawData;
        rawData = importdata(sprintf('xsense_save_%d_%d.dat',subjectID,trialID));
        t = rawData(:,end) - rawData(1,end);

        accln = rawData(:,1:3);
        gyro = rawData(:,4:6);
        imuData(subjectID,trialID).t = t;
        imuData(subjectID,trialID).accln = accln;
        imuData(subjectID,trialID).gyro = gyro;
    end
end

save('./imuExtractedData.mat','imuData');
