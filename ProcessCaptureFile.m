%% Peter Katlic
% ECSE-6610
% Project
% Clustering and Classification of Computer Network Traffic
% process a capture file

clear
clc

%% input parameters
% local IP address to determine tx/rx
localIP = '192.168.1.136';
captureFiles = {'captures/download_30s.cap'
    'captures/music_30s.cap'
    'captures/netflix_30s.cap'
    'captures/skype_30s.cap'
    'captures/upload_30s.cap'
    'captures/web_30s.cap'
    'captures/web_60s.cap'
    'captures/youtube_30s.cap'
    'captures/youtube_60s.cap'};
captureFile = captureFiles{3};
%captureFile = 'captures/netflix_30s.cap';
[filePath,fileName,fileExtension] = fileparts(captureFile);
globalHeaderLength = 24;
packetHeaderLength = 16;
fprintf('capture file: %s\n', captureFile);
fprintf('local IP: %s\n', localIP);

%% load capture file as hex
fprintf('loading capture data...');
fid = fopen(captureFile,'r');
captureData = dec2hex(fread(fid));
fclose(fid);
fprintf('ok\n');

%process global header
fprintf('processing captured packets...');
globalHeader = captureData(1:globalHeaderLength,:);

magicNumber = hex2dec(sscanf(strjoin(cellstr(flipud(globalHeader(1:4,:)))'),'%s'));
majorVersion = hex2dec(sscanf(strjoin(cellstr(flipud(globalHeader(5:6,:)))'),'%s'));
minorVersion = hex2dec(sscanf(strjoin(cellstr(flipud(globalHeader(7:8,:)))'),'%s'));
timezoneOffset = hex2dec(sscanf(strjoin(cellstr(flipud(globalHeader(9:12,:)))'),'%s'));
timestampAccuracy = hex2dec(sscanf(strjoin(cellstr(flipud(globalHeader(13:16,:)))'),'%s'));
%TODO: timestamp
%snapshotLength = flipud(globalHeader(17:20,:));
%sl = strjoin(cellstr(snapshotLength)');
%sl = sscanf(sl,'%s');
snapshotLength = hex2dec(sscanf(strjoin(cellstr(flipud(globalHeader(17:20,:)))'),'%s'));
headerType = hex2dec(sscanf(strjoin(cellstr(flipud(globalHeader(21:24,:)))'),'%s'));

% get packets
packetsData = captureData(globalHeaderLength + 1:end,:);

%for each packet
h = waitbar(0,'','Name','Processing Capture File');
packetCount = 0;
packetPointer = 1;
while (packetPointer < length(packetsData))
    packetCount = packetCount + 1;
    processPercent = ceil(100.0*(packetPointer/length(packetsData)));
    waitbar(processPercent/100,h,sprintf('%d%%',processPercent))
    
    %get packet header
    packetHeader = packetsData(packetPointer:packetPointer+packetHeaderLength-1,:);
   
    %parse header
    timestamp = hex2dec(sscanf(strjoin(cellstr(flipud(packetHeader(1:4,:)))'),'%s'));
    microseconds = hex2dec(sscanf(strjoin(cellstr(flipud(packetHeader(5:8,:)))'),'%s'));
    dataSizeFile = hex2dec(sscanf(strjoin(cellstr(flipud(packetHeader(9:12,:)))'),'%s'));
    dataSizeWire = hex2dec(sscanf(strjoin(cellstr(flipud(packetHeader(13:16,:)))'),'%s'));
    packets(packetCount).dataSize = dataSizeFile;
    
    %update pointer
    packetPointer = packetPointer + packetHeaderLength;
    
    %get packet data
    packetData = packetsData(packetPointer:packetPointer+dataSizeFile - 1,:);
    
    %parse ethernet frame
    ethernetDstMAC = sscanf(strjoin(cellstr(flipud(packetData(1:6,:)))'),'%s');
    ethernetSrcMAC = sscanf(strjoin(cellstr(flipud(packetData(7:12,:)))'),'%s');
    etherType = hex2dec(sscanf(strjoin(cellstr(flipud(packetData(13:14,:)))'),'%s'));
    %packets(packetCount).etherType = etherType;
    
    frameData = packetData(15:end-4,:);
    etherCRC = sscanf(strjoin(cellstr(flipud(packetData(end-3:end,:)))'),'%s');
    
    %ip packet
    if etherType == 8
        protocol = hex2dec(sscanf(strjoin(cellstr(frameData(10,:))'),'%s'));
        protocol = int32(protocol);
        packets(packetCount).protocol = protocol;
        if (exist('protocols')) && (length(protocols) >= protocol)
            protocols(protocol) = protocols(protocol) + 1;
        else
            protocols(protocol) = 1;
        end
        srcIP = sprintf('%d.',hex2dec(frameData(13:16,:))');
        srcIP = srcIP(1:end-1);
        packets(packetCount).srcIP = srcIP;
        dstIP = sprintf('%d.',hex2dec(frameData(17:20,:))');
        dstIP = dstIP(1:end-1);
        packets(packetCount).dstIP = dstIP;
        if strcmp(srcIP,localIP)
            mode = 'tx';
            if (exist('modeCount')) && (length(modeCount) >= 1)
                modeCount(1) = modeCount(1) + 1;
            else
                modeCount(1) = 1;
            end
            packets(packetCount).tx = 1;
            packets(packetCount).rx = 0;
            packets(packetCount).xx = 0;
        elseif strcmp(dstIP,localIP)
            mode = 'rx';
            if (exist('modeCount')) && (length(modeCount) >= 2)
                modeCount(2) = modeCount(2) + 1;
            else
                modeCount(2) = 1;
            end
            packets(packetCount).tx = 0;
            packets(packetCount).rx = 1;
            packets(packetCount).xx = 0;
        else
            mode = 'other';
            if (exist('modeCount')) && (length(modeCount) >= 3)
                modeCount(3) = modeCount(3) + 1;
            else
                modeCount(3) = 1;
            end
            packets(packetCount).tx = 0;
            packets(packetCount).rx = 0;
            packets(packetCount).xx = 1;
        end
        %options(ignore)
        ipData = frameData(21:end,:);
        
        %tcp packet
        if protocol == 6
            type = 'tcp';
            srcPort = hex2dec(sscanf(strjoin(cellstr(ipData(1:2,:))'),'%s'));
            srcPort = int32(srcPort);
            packets(packetCount).srcPort = srcPort;
            if (exist('srcPorts')) && (length(srcPorts) >= srcPort)
                srcPorts(srcPort) = srcPorts(srcPort) + 1;
            else
                srcPorts(srcPort) = 1;
            end
            dstPort = hex2dec(sscanf(strjoin(cellstr(ipData(3:4,:))'),'%s'));
            dstPort = int32(dstPort);
            packets(packetCount).dstPort = dstPort;
            if (exist('dstPorts')) && (length(dstPorts) >= dstPort)
                dstPorts(dstPort) = dstPorts(dstPort) + 1;
            else
                dstPorts(dstPort) = 1;
            end
            seqNum = hex2dec(sscanf(strjoin(cellstr(ipData(5:8,:))'),'%s'));
            ackNum = hex2dec(sscanf(strjoin(cellstr(ipData(9:12,:))'),'%s'));
            tcpData = ipData(21:end,:);
            packets(packetCount).dataLength = length(tcpData);
            if (exist('dataLengths')) && (length(dataLengths) >= srcPort)
                dataLengths(srcPort) = dataLengths(srcPort) + length(tcpData);
            else
                dataLengths(srcPort) = 1;
            end
            if (exist('dataLengths')) && (length(dataLengths) >= dstPort)
                dataLengths(dstPort) = dataLengths(dstPort) + length(tcpData);
            else
                dataLengths(dstPort) = 1;
            end
        %udp packet
        elseif protocol == 17
            type = 'udp';
            srcPort = hex2dec(sscanf(strjoin(cellstr(ipData(1:2,:))'),'%s'));
            srcPort = int32(srcPort);
            packets(packetCount).srcPort = srcPort;
            if (exist('srcPorts')) && (length(srcPorts) >= srcPort)
                srcPorts(srcPort) = srcPorts(srcPort) + 1;
            else
                srcPorts(srcPort) = 1;
            end
            dstPort = hex2dec(sscanf(strjoin(cellstr(ipData(3:4,:))'),'%s'));
            dstPort = int32(dstPort);
            packets(packetCount).dstPort = dstPort;
            if (exist('dstPorts')) && (length(dstPorts) >= dstPort)
                dstPorts(dstPort) = dstPorts(dstPort) + 1;
            else
                dstPorts(dstPort) = 1;
            end
            udpData = ipData(9:end,:);
            packets(packetCount).dataLength = length(udpData);
            if (exist('dataLengths')) && (length(dataLengths) >= srcPort)
                dataLengths(srcPort) = dataLengths(srcPort) + length(udpData);
            else
                dataLengths(srcPort) = 1;
            end
            if (exist('dataLengths')) && (length(dataLengths) >= dstPort)
                dataLengths(dstPort) = dataLengths(dstPort) + length(udpData);
            else
                dataLengths(dstPort) = 1;
            end
        %icmp packet
        elseif protocol == 1
            type = 'icmp';
            %type
            srcPort = hex2dec(sscanf(strjoin(cellstr(ipData(1,:))'),'%s'));
            srcPort = int32(srcPort);
            packets(packetCount).srcPort = srcPort;
            %code
            dstPort = hex2dec(sscanf(strjoin(cellstr(ipData(2,:))'),'%s'));
            dstPort = int32(dstPort);
            packets(packetCount).dstPort = dstPort;
            %data?
            icmpData = ipData(5:end,:);
            packets(packetCount).dataLength = length(icmpData);
        else
            type = 'other';
        end
    %elseif etherType == 56710%ipv6
    %elseif etherType == 1544%arp
    %elseif etherType == 13576%rarp
    else
        %ignore
        packetCount = packetCount - 1;
    end
    
    %update pointer
    packetPointer = packetPointer + dataSizeFile;
end
close(h);
fprintf('ok\n');
fprintf('%d packets\n', packetCount);
%TODO: timestamps
%TODO: avg rx/tx size
%tcpCount = protocols(6)
%udpCount = protocols(17)
%txCount = modeCount(1)
%rxCount = modeCount(2)
%httpCount = srcPorts(80) + dstPorts(80)
%httpsCount = srcPorts(443) + dstPorts(443)
%dnsCount = srcPorts(53) + dstPorts(53)
%httpTraffic = dataLengths(80)
%httpsTraffic = dataLengths(443)

%% store packet features to output file
processedFile = strcat('processed/',fileName,'.dat');
fprintf('processed file: %s\n', processedFile);
fid = fopen(processedFile, 'w');
fprintf('storing packets...');
for packetId=1:packetCount
    fprintf(fid, '%d', packetId);
    %fprintf(fid, ' %d', packets(packetId).etherType);
    fprintf(fid, ' %d', packets(packetId).dataSize);
    fprintf(fid, ' %d', packets(packetId).protocol);
    fprintf(fid, ' %s', packets(packetId).srcIP);
    fprintf(fid, ' %s', packets(packetId).dstIP);
    fprintf(fid, ' %d', packets(packetId).tx);
    fprintf(fid, ' %d', packets(packetId).rx);
    fprintf(fid, ' %d', packets(packetId).xx);
    fprintf(fid, ' %d', packets(packetId).srcPort);
    fprintf(fid, ' %d', packets(packetId).dstPort);
    fprintf(fid, ' %d', packets(packetId).dataLength);
    if(packetId<packetCount)
        fprintf(fid, '\r\n');
    end
end
fclose(fid);
fprintf('ok\n');