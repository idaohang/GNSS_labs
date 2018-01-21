%% GNSS labs Group2: lab5
% Main code would come here


%% ------------------ GPS timestamps to seconds ---------------------------
clear all
close all
clc

gps_week = 1499; % gps week

start_gps = 259263.5750014; % gps sec of week of data start
sat_1_gps = 259267.5750014; % gps sec of week acquisition of first satellite
TTFF_gps = 259759.5792914; % gps sec of week of TTFF

% conversion to year, month and decimal day
[yr_start, mn_start, dy_start]= jd2cal(gps2jd(gps_week,start_gps,0))
[yr_sat_1, mn_sat_1, dy_sat_1]= jd2cal(gps2jd(gps_week,sat_1_gps,0))
[yr_TTFF, mn_TTFF, dy_TTFF]= jd2cal(gps2jd(gps_week,TTFF_gps,0))

% time in seconds of acquisition of the first satellite
Sat_1_seconds = (dy_sat_1 - dy_start)*86400;

% time in seconds of TTFF
TTFF_seconds = (dy_TTFF - dy_start)*86400;

% sampling rate
first = 259263.5750014;
second = 259264.5750014;
[yr,mn,dy]= jd2cal(gps2jd(gps_week,first,0));
[yr2,mn2,dy2]= jd2cal(gps2jd(gps_week,second,0));
Rate = (dy2 - dy)*86400

%% ------------------- reading text file ---------------------------------
clear all
close all
clc

fid = fopen('GNSSlab_B.txt');

tline = fgetl(fid);
tlines = cell(0,1);
while ischar(tline)
    tlines{end+1,1} = tline;
    tline = fgetl(fid);
end
fclose(fid);

% Find the tlines with F40, F80, F62
messLines_40 = regexp(tlines,'F40','match','once');
eqnLineMask_40 = ~cellfun(@isempty, messLines_40);
F_40 = tlines(eqnLineMask_40==1);

messLines_62 = regexp(tlines,'F62','match','once');
eqnLineMask_62 = ~cellfun(@isempty, messLines_62);
F_62 = tlines(eqnLineMask_62==1);

messLines_80 = regexp(tlines,'F80','match','once');
eqnLineMask_80 = ~cellfun(@isempty, messLines_80);
F_80 = tlines(eqnLineMask_80==1);

% extract columns of interest 
gps_week = extractBetween(F_40,5,8); % gps week for example

No_tracked_sats = extractBetween(F_40,97,97); % tracked satellites
sats = str2double(No_tracked_sats);

figure(1)
histogram(sats)
title('Number of Tracked Satellites')
xlabel('Number of Satellites')
ylabel('Number of Occurence')

%% ------------ splitting the data set into two periods ----------------
% period 1: before reinitialization
% period 2: sfter reinitialization

initialization = regexp(F_40,'14.2000014','match','once');
init = str2double(initialization);
ix = find(init==14.2000014);
period_2_ix = ix(2);

figure(2)
period_1_sats = sats(1:period_2_ix);
histogram(period_1_sats)
title('Number of Tracked Satellites - Period 1')
xlabel('Number of Satellites')
ylabel('Number of Occurence')

figure(3)
period_2_sats = sats(period_2_ix:length(sats));
histogram(period_2_sats)
title('Number of Tracked Satellites - Period 2')
xlabel('Number of Satellites')
ylabel('Number of Occurence')
