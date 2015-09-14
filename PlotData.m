% Clustering and Classification of Computer Network Traffic
% plot data for analysis and to help determine clustering features

%clear
clc

%% relationship between features
%figure
%plotmatrix(packetData)
%title('Matrix Plot of Packet Data');

%% 1-d data
% scatter
%figure
%subplot(1,3,1)
%scatter([packet.id],[packet.dataSize])
%subplot(1,3,2)
%scatter([packet.id],[packet.rx])
%subplot(1,3,3)
%scatter([packet.id],[packet.tx])

% histograms
%figure
%hist(double([packet.rx]),50)

%% 2-d data
%x = lookup('rx');%id
%y = lookup('dstPort');%packetSize
%figure
%scatter(packetData(:,x),packetData(:,y),100,'filled')
%xlabel('rx')
%ylabel('dstPort')
%title('2-Feature Interaction')


%% 3-d data
x = lookup('srcIP');%srcPort
y = lookup('dstIP');%dstPort
z = lookup('dataSize');%rx
figure
% filtering example
%scatter3(packetData([packet.srcPort]<1024,x),packetData([packet.srcPort]<1024,y),packetData([packet.srcPort]<1024,z),100,'filled')
scatter3(packetData(:,x),packetData(:,y),packetData(:,z),100,'filled')
xlabel('srcPort')
ylabel('dstPort')
zlabel('rx')
title('3-feature interaction')