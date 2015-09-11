# wireshark-capture-matlab-clustering
MATLAB clustering of Wireshark packet capture data

## instructions
1. capture network traffic with Wireshark and save in pcap format, put in captures directory
2. run ProcessCaptureFile.m to parse the pcap files, output in processed directory
3. run LoadProcessedFile.m to load data into memory
4. run PlotData.m (optional) to view details
5. run PerformClustering.m to generate clustering information