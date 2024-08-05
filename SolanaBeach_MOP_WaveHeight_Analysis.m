%% Solana Radiaiton Stress Investigation

% Author: Trenton Saunders
% Date: 08-05-2024

% Pull MOP Hindcast Wave Data. Isolate Oct, Nov, Dec, Jan wave data.
% Determine a significant wave event for emergency nourishment surveying.

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
MOPstn = 658:-1:650;
% startdate = '01/01/2021 00:00';
% enddate = '01/31/2021 23:59';

%% Pull MOP data from THREDDS

for i = 1:length(MOPstn)

test_url1 = 'https://thredds.cdip.ucsd.edu/thredds/dodsC/cdip/model/MOP_alongshore/D0';

test_url2 = '_hindcast.nc';

test_url = [test_url1,num2str(MOPstn(i)),test_url2];

MOP_info = ncinfo(test_url)

Data.Tp(:,i) = ncread(test_url,'waveTp');
Data.Hs(:,i) = ncread(test_url,'waveHs');
Data.Time(:,i) = ncread(test_url,'waveTime');
Data.WD_Peak(:,i) = ncread(test_url,'waveDp');

Data.MOP(1,i) = MOPstn(i);
Data.Lat(1,i) = ncread(test_url,'metaLatitude');
Data.Lon(1,i) = ncread(test_url,'metaLongitude');

[Data.X(1,i),Data.Y(1,i),Data.utmzone{i}] = deg2utm(Data.Lat(1,i),Data.Lon(1,i));

end


%% Average wave height data

MeanWave.Hs = mean(Data.Hs,2);
Meanwave.Tp = mean(Data.Tp,2);
MeanWave.WD_peak = mean(Data.WD_Peak,2);

%% Convert to DateTime

Data.DateTime = datetime(Data.Time(:,1),'ConvertFrom','posixtime','TimeZone','UTC');
% Data.DateTime.TimeZone = 'America/Los_Angeles';    % Get to Local Datetime.

%%
figure
hold on
plot(Data.DateTime,MeanWave.Hs)

MonthMask = ismember(month(Data.DateTime),[10 11 12 1]);

plot(Data.DateTime(MonthMask),MeanWave.Hs(MonthMask),'o')

%% Year + Month Mask Plot
figure
hold on

colors = jet(length(2001:2022))

for year = 2001:2022

    year_prior = year - 2001

    Oct_Start = posixtime(datetime('2000-10-01') + calyears(year_prior))
    Jan_End = posixtime(datetime('2001-02-01') + calyears(year_prior))
    
    
    
    % plot( Data.DateTime(Data.Time(:,1) > Oct_Start & Data.Time(:,1) < Jan_End),  MeanWave.Hs(Data.Time(:,1) > Oct_Start & Data.Time(:,1) < Jan_End))

    plot( MeanWave.Hs(Data.Time(:,1) > Oct_Start & Data.Time(:,1) < Jan_End) , 'Color', [colors(year_prior+1,:)] , 'DisplayName', num2str(year))

    legend
end
%%%

%% Attempt Months


% %%
% % figure
% % plot(Data.MOP(:),Data.Average_Sxy(:))
% %% Figure
% 
% figure
% subplot(1,2,1)
% geobubble(Data.Lat(:),Data.Lon(:),Data.Average_Hs(:))
% geobasemap satellite
% sgtitle('$\overline {H_{s}}$ ', 'Interpreter','Latex')
% 
% subplot(1,2,2)
% geobubble(Data.Lat(:),Data.Lon(:),Data.Average_Sxy(:))
% geobasemap satellite
% sgtitle('$\overline {S_{xy}}$ ', 'Interpreter','Latex')
% 
% %% Calculate mean Sxy alongshore gradient (nned to check this calculation)
% 
% 
% figure
% plot(Data.Y,Data.Average_Sxy,'.')
% 
% diff_Y = diff(Data.Y)
% diff_Sxy = diff(Data.Average_Sxy)
% 
% grad_Sxy = diff(Data.Average_Sxy)./diff(Data.Y);
% 
% 
% %% Calculate corresponding location of gradinet calcultion
% meanX = movmean(Data.X,2,"Endpoints","discard");
% meanY = movmean(Data.Y,2,"Endpoints","discard");
% 
% 
% Sxy_Range = linspace(min(grad_Sxy)*10000,max(grad_Sxy)*10000,100);
% Sxy_Range = linspace(-.4,.4,100);
% colors = parula(100)
% 
% figure 
% 
% 
% for j = 1:length(meanX)
% 
%     [MeanLat(j),MeanLon(j)] = utm2deg( meanX(j),meanY(j),'11 S' );
% 
% 
%     [~, indx] = min(abs(Sxy_Range - 10000*grad_Sxy(j)))
% 
%     geoscatter(MeanLat(j),MeanLon(j),200,[colors(indx,:)],'filled')
% hold on
% 
% end
% 
% geobasemap satellite
% colorbar
% clim([Sxy_Range(1),Sxy_Range(end)])
% 
% %%
% Sxy_Range = linspace(min(grad_Sxy)*10000,max(grad_Sxy)*10000,100);
% cool(100)
% 
% 
% % Data.DateTime = datetime(Data.Time,'ConvertFrom','posixtime','TimeZone','UTC');
% % 
% % figure
% % plot(Data.DateTime,Data.Sxy)
% 