function rfs_user = getRFSuser(animal, location)

if ischar(animal)
    var=(str2double(animal(end-1:end)))*10 + location;
else
    var=animal*10 + location;
end

switch var
    
    case 111 % ANH11-1 rfs_user
        rfs_user=[1:19 3:15 6:11];
        rfs_user=cat(1,rfs_user,[ones(1,length(1:19)) ones(1,length(3:15))*2 ones(1,length(6:11))*3]);
        rfs_user=cat(1,rfs_user, [1:length(1:19) 1:length(3:15) 1:length(6:11)]);
        
    case 121 % ANH12-1 rfs_user
%         rfs_user=[1:33 39 41:46 54:59 15:21];
%         rfs_user=cat(1,rfs_user, [ones(1,(length(1:33)+1)) ones(1,length(41:46)) ones(1,length(54:59)) ones(1,length(15:21))*2]);
%         rfs_user=cat(1,rfs_user, [1:(length(1:33)+length(41:46)+length(54:59)+1) 1:length(15:21)]);
%         
        % ANH12 rfs_user for the RF sorted stuff
        rfs_user = [1 3 34 36 47:52 60:67 1:8 10 12:14];
        rfs_user = cat(1,rfs_user, [ones(1,4) ones(1,length(47:52)) ones(1,length(60:67)) ones(1,length(1:8))*2 ones(1,4)*2]);
        rfs_user = cat(1,rfs_user, [1:(4+length(47:52)+length(60:67)) 1:(length(1:8)+4)]);

        
    case 131 % ANH13-1 rfs_user
        rfs_user = [1:17 1:16 1:4];
        rfs_user = cat(1,rfs_user,[ones(1,length(1:17)) ones(1,length(1:16))*2 ones(1,length(1:4))*3]);
        rfs_user = cat(1,rfs_user,[1:length(1:17) 1:length(1:16) 1:length(1:4)]);
        
    case 141 % ANH14-1 rfs_user
        rfs_user = 6:49;
        rfs_user = cat(1,rfs_user,ones(1,length(6:49)));
        rfs_user = cat(1,rfs_user,1:length(6:49));
        
    case 151 % ANH15-1 rfs_user
        rfs_user = [1:30 1:22];
        rfs_user = cat(1,rfs_user,[ones(1,length(1:30)) ones(1,length(1:22))*2]);
        rfs_user = cat(1,rfs_user,[1:length(1:30) 1:length(1:22)]);
        
    case 161 % ANH16-1 rfs_user
        rfs_user=[1:16 2:7 1:9 11:15];
        rfs_user=cat(1,rfs_user,[ones(1,length(1:16)) ones(1,length(2:7))*2 ones(1,length(1:9))*3 ones(1,length(11:15))*3]);
        rfs_user=cat(1,rfs_user,[1:length(1:16) 1:length(2:7) 1:(length(1:9)+length(11:15))]);
        
    case 171 % ANH17-1 rfs_user
        rfs_user=[1:3 1:9 11:30];
        rfs_user=cat(1,rfs_user,[ones(1,length(1:3)) ones(1,length(1:9))*2 ones(1,length(11:30))*2]);
        rfs_user=cat(1,rfs_user,[1:length(1:3) 1:(length(1:9)+length(11:30))]);
        
    case 172 % ANH17-2 rfs_user
        rfs_user=[32:44 1:4 6:8];
        rfs_user=cat(1,rfs_user,[ones(1,length(32:44)) ones(1,length(1:4))*2 ones(1,length(6:8))*2]);
        rfs_user=cat(1,rfs_user,[1:length(32:44) 1:(length(1:4)+length(6:8))]);
        
    case 181 % ANH18-1 rfs_user
        rfs_user=[2 3 1:41 1 3];
        rfs_user=cat(1,rfs_user,[1 1 ones(1,length(1:41))*2 3 3]);
        rfs_user=cat(1,rfs_user,[1 2 1:length(1:41) 1 2]);
        
    case 182 % ANH18-2 rfs_user
        rfs_user=[4:50 1];
        rfs_user=cat(1,rfs_user,[ones(1,length(4:50)) 2]);
        rfs_user=cat(1,rfs_user,[1:length(4:50) 1]);
        
    case 191 % ANH19-1 rfs_user
        rfs_user=[1:41 43:45 47:50];
        rfs_user=cat(1,rfs_user,[ones(1,length(1:41)) ones(1,length(43:45)) ones(1,length(47:50))]);
        rfs_user=cat(1,rfs_user,[1:(length(1:41)+length(43:45)+length(47:50))]);
        
    case 192 % ANH19-2 rfs_user
        rfs_user=[51:76 78:94];
        rfs_user=cat(1,rfs_user,[ones(1,length(51:76)) ones(1,length(78:94))]);
        rfs_user=cat(1,rfs_user,[1:(length(51:76)+length(78:94))]);
        
end