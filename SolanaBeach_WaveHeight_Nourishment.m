%% Solana Beach Nowcast Data


close all
clear all
clc

dir_string = cd;

%% Set Up NCTOOLBOX
cd ..\
addpath(fullfile(cd,'nctoolbox'))

setup_nctoolbox

cd(dir_string)

%% USER ENTERS STATION NUMBER AND START/END DATES FOR PLOT
MOPstn = 655;

startdate = '01-01-2024';
enddate = '07-02-2024';

%% Pull MOP data from THREDDS

for i = 1:length(MOPstn)

test_url1 = 'https://thredds.cdip.ucsd.edu/thredds/dodsC/cdip/model/MOP_alongshore/D0';

test_url2 = '_nowcast.nc';

test_url = [test_url1,num2str(MOPstn(i)),test_url2];

MOP_info = ncinfo(test_url)


Data.Sxy = ncread(test_url,'waveSxy');
Data.Hs = ncread(test_url,'waveHs');
Data.Time = ncread(test_url,'waveTime');

waveFlagPrimary_Full = ncread(test_url,'waveFlagPrimary');
Data.Tp = ncread(test_url,'waveTp');
Data.WD = ncread(test_url,'waveDm');

end

%%

t1 = datetime(startdate,'InputFormat','MM-dd-yyyy'); 
t1 = t1 + 0.5*days(1);    % Add half day (noon)
t1.TimeZone = 'America/Los_Angeles';    % Define Time Zone
p1 = posixtime(t1);    % find equivalent time in epoch time (UTC)

t2 = datetime(enddate,'InputFormat','MM-dd-yyyy'); 
t2 = t2 + 0.5*days(1);
t2.TimeZone = 'America/Los_Angeles';
p2 = posixtime(t2);


Time = Data.Time(Data.Time >= p1 & Data.Time <= p2);
waveFlagPrimary =  waveFlagPrimary_Full(Data.Time >= p1 & Data.Time <= p2);
Hs =  Data.Hs(Data.Time >= p1 & Data.Time <= p2);
Tp =  Data.Tp(Data.Time >= p1 & Data.Time <= p2);
WD =  Data.WD(Data.Time >= p1 & Data.Time <= p2);

%%

Data.DateTime = datetime(Data.Time,'ConvertFrom','posixtime','TimeZone','UTC');
Data.DateTime.TimeZone = 'America/Los_Angeles';    % Get to Local Datetime.


Time = datetime(Time,'ConvertFrom','posixtime','TimeZone','UTC');
Time.TimeZone = 'America/Los_Angeles';    % Get to Local Datetime.


figure
plot(Data.DateTime,Data.Hs)

figure
subplot(3,1,1)
plot(Time,Hs)
subplot(3,1,2)
plot(Time,Tp)
subplot(3,1,3)
plot(Time,WD)

%% this will change a bit depending on which MOP line I use...
Hs_Avg = mean(Hs)
Hs_Std = std(Hs)

Tp_Avg = mean(Tp)
Tp_Std = std(Tp)

WD_Avg = mean(WD)
WD_Std = std(WD)

formatspec = '%.2f';

sgtitle({['MOP ',num2str(MOPstn)],['Avg Hs = ',num2str(Hs_Avg,formatspec),'(',num2str(Hs_Std,formatspec),')']...
    ,['Avg Tp = ',num2str(Tp_Avg,formatspec),'(',num2str(Tp_Std,formatspec),')']...
    ,['Avg WD = ',num2str(WD_Avg,formatspec) ,'(',num2str(WD_Std,formatspec),')'] },'FontSize',11)


