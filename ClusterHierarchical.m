%% Peter Katlic
% ECSE-6610
% Project
% Clustering and Classification of Computer Network Traffic
% hierarchical clustering

%clear
%clc

% set up cluster data
%xFeature = 'srcPort';
%yFeature = 'dstPort';
%zFeature = 'rx';
xIndex = lookup(xFeature);
yIndex = lookup(yFeature);
zIndex = lookup(zFeature);
clusterData = packetData(:,[xIndex yIndex zIndex]);

% perform hierarchical clustering
%clusterCount = 3;
%distanceMethod = 'euclidean';
%linkageType = 'ward';

clusters = clusterdata(clusterData,'linkage',linkageType,'distance',distanceMethod,'savememory','on','maxclust',clusterCount);

% separate linkage
%wardsLinkage = linkage(clusterData,linkageType,distanceMethod,'savememory','on');
%clustersWithLinkage = cluster(wardsLinkage,'maxclust',clusterCount);

% evaluate clusters


% plot clusters
figure
scatter3(clusterData(:,1),clusterData(:,2),clusterData(:,3),100,clusters,'filled')
suptitle('Hierarchical Clustering');
title('All Features');
xlabel(xFeature);
ylabel(yFeature);
zlabel(zFeature);

% method 3
%figure
%scatter3(clusterData(:,1),clusterData(:,2),clusterData(:,3),100,clustersWithLinkage,'filled')
%title('hierarchical');
%xlabel(xFeature);
%ylabel(yFeature);
%zlabel(zFeature);