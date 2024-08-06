%% Solana Beach MOP Wave Height Analysis
% Author: Trenton Saunders
% Date: 08-05-2024

% Pull MOP Hindcast Wave Data. Isolate Oct, Nov, Dec, Jan wave data.
% Determine a significant wave event for emergency nourishment surveying.

close all
clear all
clc

dir_string = cd;

%% Set Up NCTOOLBOX %%
cd ..\
addpath(fullfile(cd,'nctoolbox'))

setup_nctoolbox

cd(dir_string)

%% USER ENTERS STATION NUMBER %%
MOPstn = 658:-1:650;  % 654 Flecther Cove

%% Pull MOP data from THREDDS  %%

for i = 1:length(MOPstn)

test_url1 = 'https://thredds.cdip.ucsd.edu/thredds/dodsC/cdip/model/MOP_alongshore/D0';

test_url2 = '_hindcast.nc';

test_url = [test_url1,num2str(MOPstn(i)),test_url2];

MOP_info = ncinfo(test_url)

Data.Tp(:,i) = ncread(test_url,'waveTp');   % Peak Period
Data.Hs(:,i) = ncread(test_url,'waveHs');   % Sign. Wave Height
Data.Time(:,i) = ncread(test_url,'waveTime');  
Data.WD_Peak(:,i) = ncread(test_url,'waveDp');   % Peak Wave Direction

Data.MOP(1,i) = MOPstn(i);
Data.Lat(1,i) = ncread(test_url,'metaLatitude');
Data.Lon(1,i) = ncread(test_url,'metaLongitude');

[Data.X(1,i),Data.Y(1,i),Data.utmzone{i}] = deg2utm(Data.Lat(1,i),Data.Lon(1,i));

end


%% Average Bulk Wave Parameters across all MOPs  %%

MeanWave.Hs = mean(Data.Hs,2);
MeanWave.Tp = mean(Data.Tp,2);
MeanWave.WD_peak = mean(Data.WD_Peak,2);

%% Convert to DateTime  (STAYING IN UTC)  %%

Data.DateTime = datetime(Data.Time(:,1),'ConvertFrom','posixtime','TimeZone','UTC');  
% Data.DateTime.TimeZone = 'America/Los_Angeles';    % Get to Local Datetime.

%%  OLD PLOT  %%
figure
hold on
plot(Data.DateTime,MeanWave.Hs)

MonthMask = ismember(month(Data.DateTime),[10 11 12 1]);

plot(Data.DateTime(MonthMask),MeanWave.Hs(MonthMask),'o')

%% Initialize Year + Month Mask Figures %%

Winter = figure;    % 
hold on
ylim([1.25 4])
title('Winter','FontSize',22,'FontWeight','bold')
yline(3,'r--','HandleVisibility','off','LineWidth',1)
yline(2.5,'b--','HandleVisibility','off','LineWidth',1)
yline(2.19,'k--','HandleVisibility','off','LineWidth',1)
set(gca,'FontSize',18,'FontWeight','bold')


October = figure;
hold on
ylim([1.25 4])
title('October','FontSize',22,'FontWeight','bold')
set(gca, 'xtick',[])
yline(3,'r--','HandleVisibility','off','LineWidth',1)
yline(2.5,'b--','HandleVisibility','off','LineWidth',1)
yline(2.19,'k--','HandleVisibility','off','LineWidth',1)
set(gca,'FontSize',18,'FontWeight','bold')


November = figure;
hold on
ylim([1.25 4])
title('November','FontSize',22,'FontWeight','bold')
set(gca, 'xtick',[])
yline(3,'r--','HandleVisibility','off','LineWidth',1)
yline(2.5,'b--','HandleVisibility','off','LineWidth',1)
yline(2.19,'k--','HandleVisibility','off','LineWidth',1)
set(gca,'FontSize',18,'FontWeight','bold')


December = figure;
hold on
ylim([1.25 4])
title('December','FontSize',22,'FontWeight','bold')
set(gca, 'xtick',[])
yline(3,'r--','HandleVisibility','off','LineWidth',1)
yline(2.5,'b--','HandleVisibility','off','LineWidth',1)
yline(2.19,'k--','HandleVisibility','off','LineWidth',1)
set(gca,'FontSize',18,'FontWeight','bold')

   
January = figure;
hold on
ylim([1.25 4])
title('January','FontSize',22,'FontWeight','bold')
set(gca, 'xtick',[])
yline(3,'r--','HandleVisibility','off','LineWidth',1)
yline(2.5,'b--','HandleVisibility','off','LineWidth',1)
yline(2.19,'k--','HandleVisibility','off','LineWidth',1)
set(gca,'FontSize',18,'FontWeight','bold')


TimeSeries = figure;
hold on
plot( Data.DateTime(:,1),  MeanWave.Hs,'color',[0 0 0],'LineWidth',1.5,'HandleVisibility','off')
ylim([0 4])
set(gca,'FontSize',18,'FontWeight','bold')


Winter_Hist = figure;
title('Winter')
set(gca,'FontSize',12,'FontWeight','bold')

%%  Plotting  %%

colors = jet(length(2001:2023));

for year = 2001:2023

    year_prior = year - 2001;

    Oct_Start = posixtime(datetime('2000-10-01 00:00:00') + calyears(year_prior));
    Oct_End =   posixtime(datetime('2000-10-31 23:00:00') + calyears(year_prior));
    Nov_Start = posixtime(datetime('2000-11-01 00:00:00') + calyears(year_prior));
    Nov_End =   posixtime(datetime('2000-11-30 23:00:00') + calyears(year_prior));
    Dec_Start = posixtime(datetime('2000-12-01 00:00:00') + calyears(year_prior));
    Dec_End =   posixtime(datetime('2000-12-31 23:00:00') + calyears(year_prior));
    Jan_Start = posixtime(datetime('2001-01-01 00:00:00') + calyears(year_prior));
    Jan_End =   posixtime(datetime('2001-01-31 23:00:00') + calyears(year_prior));
    

    figure(October)
    plot( MeanWave.Hs(Data.Time(:,1) >= Oct_Start & Data.Time(:,1) <= Oct_End) , 'Color', [colors(year_prior+1,:)] , 'DisplayName', [num2str(year-1),'-', num2str(year)],'LineWidth',1.5)
    % legend

        figure(November)
    plot( MeanWave.Hs(Data.Time(:,1) >= Nov_Start & Data.Time(:,1) <= Nov_End) , 'Color', [colors(year_prior+1,:)] , 'DisplayName', [num2str(year-1),'-', num2str(year)],'LineWidth',1.5)

    %legend 

        figure(December)
    plot( MeanWave.Hs(Data.Time(:,1) >= Dec_Start & Data.Time(:,1) <= Dec_End) , 'Color', [colors(year_prior+1,:)] , 'DisplayName', [num2str(year-1),'-', num2str(year)],'LineWidth',1.5)

    % legend 

        figure(January)
    plot( MeanWave.Hs(Data.Time(:,1) >= Jan_Start & Data.Time(:,1) <= Jan_End) , 'Color', [colors(year_prior+1,:)] , 'DisplayName', [num2str(year-1),'-', num2str(year)],'LineWidth',1.5)

    % legend 


    figure(Winter)
    plot( MeanWave.Hs(Data.Time(:,1) >= Oct_Start & Data.Time(:,1) <= Jan_End) , 'Color', [colors(year_prior+1,:)] , 'DisplayName', [num2str(year-1),'-', num2str(year)],'LineWidth',1.5)
    % legend

    figure(TimeSeries)
    plot( Data.DateTime(Data.Time(:,1) >= Oct_Start & Data.Time(:,1) <= Jan_End),  MeanWave.Hs(Data.Time(:,1) >= Oct_Start & Data.Time(:,1) <= Jan_End),'Color', [colors(year_prior+1,:)],'LineWidth',2,'DisplayName', [num2str(year-1),'-', num2str(year)])
    leg = legend;
    set(leg,'FontSize',11,'FontWeight','bold')

    figure(Winter_Hist)
    subplot(6,4,year_prior+1)
    histogram( MeanWave.Hs(Data.Time(:,1) >= Oct_Start & Data.Time(:,1) <= Jan_End) , 'FaceColor', [colors(year_prior+1,:)] )
    xlim([0 4])
    set(gca, 'YScale', 'log')

    xline(3,'r--','LineWidth',1)
    xline(2.5,'b--','LineWidth',1)
    xline(2.19,'k--','LineWidth',1)

    
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