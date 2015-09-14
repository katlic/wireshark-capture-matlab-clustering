% Clustering and Classification of Computer Network Traffic
% k-means clustering

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
%clusterData = double([packet.srcPort; packet.rx]');

% filter data
%T = Y([packet.srcPort]'==80,:);
%T = Y([packet.rx]'==1 & [packet.srcPort]'==80,:);
%scatter(T(:,1),T(:,2))

% perform k-means clustering
%clusterCount = 3;
%distanceMethod = 'sqEuclidean';%'sqEuclidean','cityblock','cosine','correlation','Hamming'
%replicationCount = 10;
%emptyAction = 'singleton';
%displayType = 'iter';%final
opts = statset('Display',displayType);
[idx,ctrs] = kmeans(clusterData,clusterCount,'distance',distanceMethod,'replicates',replicationCount,'emptyaction',emptyAction,'options',opts);

% evaluate clusters


% plot clusters
figure
% x,y clustering
%subplot(4,3,1)
%positionVector1 = [0.1, 0.7, 0.2, 0.2];
%subplot('Position',positionVector1)
plot(clusterData(idx==1,1),clusterData(idx==1,2),'r.','MarkerSize',22)
hold on
plot(clusterData(idx==2,1),clusterData(idx==2,2),'b.','MarkerSize',22)
plot(clusterData(idx==3,1),clusterData(idx==3,2),'g.','MarkerSize',22)
plot(ctrs(:,1),ctrs(:,2),'kx','MarkerSize',12,'LineWidth',2)
plot(ctrs(:,1),ctrs(:,2),'ko','MarkerSize',12,'LineWidth',2)
%legend('Cluster 1','Cluster2','Centroids','Location','NW')
suptitle('K-means Clustering');
title('Feature 1 vs. 2');
xlabel(xFeature);
ylabel(yFeature);
zlabel(zFeature);
hold off

% x,z clustering
figure
%subplot(4,3,2)
%positionVector2 = [0.433, 0.7, 0.2, 0.2];
%subplot('Position',positionVector2)
plot(clusterData(idx==1,1),clusterData(idx==1,3),'r.','MarkerSize',22)
hold on
plot(clusterData(idx==2,1),clusterData(idx==2,3),'b.','MarkerSize',22)
plot(clusterData(idx==3,1),clusterData(idx==3,3),'g.','MarkerSize',22)
plot(ctrs(:,1),ctrs(:,3),'kx','MarkerSize',12,'LineWidth',2)
plot(ctrs(:,1),ctrs(:,3),'ko','MarkerSize',12,'LineWidth',2)
suptitle('K-means Clustering');
title('Feature 1 vs. 3');
xlabel(xFeature);
ylabel(zFeature);
hold off

% y,z clustering
figure
%subplot(4,3,3)
%positionVector2 = [0.766, 0.7, 0.2, 0.2];
%subplot('Position',positionVector2)
plot(clusterData(idx==1,2),clusterData(idx==1,3),'r.','MarkerSize',22)
hold on
plot(clusterData(idx==2,2),clusterData(idx==2,3),'b.','MarkerSize',22)
plot(clusterData(idx==3,2),clusterData(idx==3,3),'g.','MarkerSize',22)
plot(ctrs(:,2),ctrs(:,3),'kx','MarkerSize',12,'LineWidth',2)
plot(ctrs(:,2),ctrs(:,3),'ko','MarkerSize',12,'LineWidth',2)
suptitle('K-means Clustering');
title('Feature 2 vs. 3');
xlabel(yFeature);
ylabel(zFeature);
hold off

% x,y,z scatter clustering
figure
%subplot(4,3,[4:12])
%positionVector2 = [0.1, 0.1, 0.85, 0.4];
%subplot('Position',positionVector2)
scatter3(clusterData(:,1),clusterData(:,2),clusterData(:,3),100,idx,'filled')
hold on
scatter3(ctrs(:,1),ctrs(:,2),ctrs(:,3),150,'kx','LineWidth',2);
scatter3(ctrs(:,1),ctrs(:,2),ctrs(:,3),150,'ko','LineWidth',2);
suptitle('K-means Clustering');
title('All Features');
xlabel(xFeature);
ylabel(yFeature);
zlabel(zFeature);
hold off

% plot silhouette
%figure
%[silh3,h] = silhouette(clusterData,idx,distanceMethod);
%clusterMean = mean(silh3)%higher is better, try for different cluster counts
%xlabel('Silhouette Value')
%ylabel('Cluster')