%% Solana Radiaiton Stress Investigation

% Author: Trenton Saunders
% Date: 06-28-2024

% Calculate alongshore radiation stress gradient (Ludka et al. 2018)

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
MOPstn = 675:-1:630;
% startdate = '01/01/2021 00:00';
% enddate = '01/31/2021 23:59';

%% Pull MOP data from THREDDS

for i = 1:length(MOPstn)

test_url1 = 'https://thredds.cdip.ucsd.edu/thredds/dodsC/cdip/model/MOP_alongshore/D0';

test_url2 = '_hindcast.nc';

test_url = [test_url1,num2str(MOPstn(i)),test_url2];

MOP_info = ncinfo(test_url)

Data.Sxy = ncread(test_url,'waveSxy');
Data.Hs = ncread(test_url,'waveHs');
Data.Time = ncread(test_url,'waveTime');

Data.MOP(i) = MOPstn(i);
Data.Lat(i) = ncread(test_url,'metaLatitude');
Data.Lon(i) = ncread(test_url,'metaLongitude');
Data.Average_Sxy(i) = mean(Data.Sxy);
Data.Average_Hs(i) = mean(Data.Hs);

[Data.X(i),Data.Y(i),Data.utmzone{i}] = deg2utm(Data.Lat(i),Data.Lon(i));

end
%%
% figure
% plot(Data.MOP(:),Data.Average_Sxy(:))
%% Figure

figure
subplot(1,2,1)
geobubble(Data.Lat(:),Data.Lon(:),Data.Average_Hs(:))
geobasemap satellite
sgtitle('$\overline {H_{s}}$ ', 'Interpreter','Latex')

subplot(1,2,2)
geobubble(Data.Lat(:),Data.Lon(:),Data.Average_Sxy(:))
geobasemap satellite
sgtitle('$\overline {S_{xy}}$ ', 'Interpreter','Latex')

%% Calculate mean Sxy alongshore gradient (nned to check this calculation)


figure
plot(Data.Y,Data.Average_Sxy,'.')

diff_Y = diff(Data.Y)
diff_Sxy = diff(Data.Average_Sxy)

grad_Sxy = diff(Data.Average_Sxy)./diff(Data.Y);


%% Calculate corresponding location of gradinet calcultion
meanX = movmean(Data.X,2,"Endpoints","discard");
meanY = movmean(Data.Y,2,"Endpoints","discard");


Sxy_Range = linspace(min(grad_Sxy)*10000,max(grad_Sxy)*10000,100);
Sxy_Range = linspace(-.4,.4,100);
colors = parula(100)

figure 


for j = 1:length(meanX)

    [MeanLat(j),MeanLon(j)] = utm2deg( meanX(j),meanY(j),'11 S' );


    [~, indx] = min(abs(Sxy_Range - 10000*grad_Sxy(j)))

    geoscatter(MeanLat(j),MeanLon(j),200,[colors(indx,:)],'filled')
hold on

end

geobasemap satellite
colorbar
clim([Sxy_Range(1),Sxy_Range(end)])

%%
Sxy_Range = linspace(min(grad_Sxy)*10000,max(grad_Sxy)*10000,100);
cool(100)


% Data.DateTime = datetime(Data.Time,'ConvertFrom','posixtime','TimeZone','UTC');
% 
% figure
% plot(Data.DateTime,Data.Sxy)
% 

