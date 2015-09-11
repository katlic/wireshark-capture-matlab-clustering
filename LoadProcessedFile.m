%% Peter Katlic
% ECSE-6610
% Project
% Clustering and Classification of Computer Network Traffic
% load a processed capture file

clear
clc

format long g

%% input parameters
processedFiles = {'processed/download_30s.dat'
    'processed/music_30s.dat'
    'processed/netflix_30s.dat'
    'processed/skype_30s.dat'
    'processed/upload_30s.dat'
    'processed/web_30s.dat'
    'processed/web_60s.dat'
    'processed/youtube_30s.dat'
    'processed/youtube_60s.dat'};

% specify input file
processedFile = processedFiles{6};
fprintf('processed file: %s\n', processedFile);

%% load packet features
fprintf('loading packet file...');
fid = fopen(processedFile);
packets = textscan(fid,'%d %d %d %s %s %d %d %d %d %d %d');
fclose(fid);
fprintf('ok\n');

fprintf('loading packet data...');
h = waitbar(0,'','Name','Loading Packet Data');
s=size(packets{1});
packetCount=s(1);
for p=1:packetCount
    processPercent = ceil(100.0*(p/packetCount));
    waitbar(processPercent/100,h,sprintf('%d%%',processPercent))
    
    packet(p).id = packets{1}(p);
    %packet(p).etherType = ; ignore, only looking at IP traffic
    packet(p).packetSize = packets{2}(p);
    packet(p).protocol = packets{3}(p);
    packet(p).srcIPStr = packets{4}{p};
    temp = packets{4}{p};
    temp = str2num(char(strsplit(temp,'.')));
    temp = (temp(1)*16777216)+(temp(2)*65536)+(temp(3)*256)+temp(4);
    packet(p).srcIP = temp;
    packet(p).dstIPStr = packets{5}{p};
    temp = packets{5}{p};
    temp = str2num(char(strsplit(temp,'.')));
    temp = (temp(1)*16777216)+(temp(2)*65536)+(temp(3)*256)+temp(4);
    packet(p).dstIP = temp;
    packet(p).tx = packets{6}(p);
    packet(p).rx = packets{7}(p);
    packet(p).xx = packets{8}(p);
    packet(p).srcPort = packets{9}(p);
    packet(p).dstPort = packets{10}(p);
    packet(p).dataSize = packets{11}(p);
end
close(h);
fprintf('ok\n');
fprintf('%d packets\n', packetCount);

clear h
clear processPercent
clear packets
clear fid
clear p
clear s
clear ans
clear temp

%% parse and split data
fprintf('parsing data...');
packetData = double([packet.id;packet.packetSize;packet.protocol;packet.srcIP;packet.dstIP;packet.tx;packet.rx;packet.xx;packet.srcPort;packet.dstPort;packet.dataSize]');

% index lookup map
% will need to lookup srcIPStr and dstIPStr from packet().
keys = {'id','packetSize','protocol','srcIP','dstIP','tx','rx','xx','srcPort','dstPort','dataSize'};
vals = {1,2,3,4,5,6,7,8,9,10,11};
lookup = containers.Map(keys,vals);
clear keys
clear vals

% split into unique feature values and counts
unique_protocol = unique(packetData(:,lookup('protocol')));
unique_protocolCount = histc(packetData(:,lookup('protocol')), unique_protocol);%histc(x(:),values);
unique_srcIP = unique(packetData(:,lookup('srcIP')));
unique_srcIPCount = histc(packetData(:,lookup('srcIP')), unique_srcIP);
unique_dstIP = unique(packetData(:,lookup('dstIP')));
unique_dstIPCount = histc(packetData(:,lookup('dstIP')), unique_dstIP);
unique_tx = unique(packetData(:,lookup('tx')));
unique_txCount = histc(packetData(:,lookup('tx')), unique_tx);
unique_rx = unique(packetData(:,lookup('rx')));
unique_rxCount = histc(packetData(:,lookup('rx')), unique_rx);
unique_srcPort = unique(packetData(:,lookup('srcPort')));
unique_srcPortCount = histc(packetData(:,lookup('srcPort')), unique_srcPort);
unique_dstPort = unique(packetData(:,lookup('dstPort')));
unique_dstPortCount = histc(packetData(:,lookup('dstPort')), unique_dstPort);
unique_dataSize = unique(packetData(:,lookup('dataSize')));
unique_dataSizeCount = histc(packetData(:,lookup('dataSize')), unique_dataSize);
%scatter(unique_srcPort,unique_srcPortCount);

% split into paired features
%paired_srcPort_rx = packetData(:,[lookup('srcPort') lookup('rx')]);
%paired_srcPort_tx = double([packet.srcPort; packet.tx]');
%paired_dstPort_rx = double([packet.dstPort; packet.rx]');
%paired_dstPort_tx = double([packet.dstPort; packet.tx]');

% split into groups of features to cluser
%clusterFeatures = {'tx' 'rx' 'protocol';
%    'tx' 'rx' 'dataSize';
%    'rx' 'dstPort' 'dataSize';
%    'tx' 'srcPort' 'dataSize';
%    'rx' 'srcIP' 'dataSize';
%    'srcPort' 'dstPort' 'rx';
%    'srcPort' 'dstPort' 'tx'};

fprintf('ok\n');
