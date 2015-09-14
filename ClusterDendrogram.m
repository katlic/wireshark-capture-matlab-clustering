% Clustering and Classification of Computer Network Traffic
% hierarchical clustering dendrogram

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

% perform clustering
%distanceMethod = 'euclidean';
%linkageType = 'ward';
clusterDistances = pdist(clusterData,distanceMethod);
clusterLinkage = linkage(clusterDistances,linkageType);

% cophenetic correlation coefficient (closer to 1 = better fit)
c = cophenet(clusterLinkage,clusterDistances)

% plot dendrograms
set(0,'RecursionLimit',2000)
figure
dendrogram(clusterLinkage)

figure
leafCount = 2;
dendrogram(clusterLinkage,leafCount);

D = pdist(clusterData);
tree = linkage(clusterData,'average');
leafOrder = optimalleaforder(tree,D);
figure()
subplot(2,1,1)
dendrogram(tree)
title('Default Leaf Order')
subplot(2,1,2)
dendrogram(tree,'reorder',leafOrder)
title('Optimal Leaf Order')

%figure
%categoryVector = packetData(:,lookup('protocol'));
%[d,p,stats] = manova1(clusterData,categoryVector);
%manovacluster(stats)