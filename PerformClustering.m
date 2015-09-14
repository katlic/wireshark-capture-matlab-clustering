% Clustering and Classification of Computer Network Traffic
% perform clustering on specified features

%clear
clc

% sets of features to cluster and cluster number
clusterFeatures = {'tx' 'rx' 'protocol' 5;% 1. udp/tcp
    'tx' 'rx' 'dataSize' 4;% 2. bandwidth usage
    'rx' 'dstPort' 'dataSize' 3;% 3. downloading
    'tx' 'srcPort' 'dataSize' 3;% 4. uploading
    'rx' 'srcIP' 'dataSize' 6;% 5. peer-to-peer downloading
    'srcIP' 'dstIP' 'dataSize' 7;% 6. data transfers
    'srcPort' 'dstPort' 'rx' 3;% 7. known service downloading
    'srcPort' 'dstPort' 'tx' 3};% 8. known service uploading

% selected features
clusterFeatureSet = 6;

% maximum/specified number of clusters
clusterCount = clusterFeatures{clusterFeatureSet,4};%5;

xFeature = clusterFeatures{clusterFeatureSet,1};
yFeature = clusterFeatures{clusterFeatureSet,2};
zFeature = clusterFeatures{clusterFeatureSet,3};

% k-means settings
kMeansDistanceMethods = {'sqEuclidean'
    'cityblock'
    'cosine'
    'correlation'
    'Hamming'};
kMeansEmptyActions = {'error'
    'drop'
    'singleton'};
kMeansDisplayTypes = {'off'
    'iter'
    'final'};

distanceMethod = kMeansDistanceMethods{1};
replicationCount = 4;
emptyAction = kMeansEmptyActions{3};
displayType = kMeansDisplayTypes{2};

% perform k-means clustering
ClusterKmeans

% hierarchical settings
hierarchicalDistanceMethods = {'euclidean'
    'seuclidean'
    'cityblock'
    'minkowski'
    'chevychev'
    'mahalanobis'
    'cosine'
    'correlation'
    'spearman'
    'hamming'
    'jaccard'};
hierarchicalLinkageTypes = {'average'
    'centroid'
    'complete'
    'median'
    'single'
    'ward'
    'weighted'};

distanceMethod = hierarchicalDistanceMethods{1};
linkageType = hierarchicalLinkageTypes{6};

% perform hierarchical clustering
ClusterHierarchical

% generate dendrogram for small samples
if packetCount < 2000
    ClusterDendrogram
end