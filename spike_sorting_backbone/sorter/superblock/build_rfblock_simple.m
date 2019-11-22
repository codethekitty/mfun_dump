function superblocks = build_rfblock_simple(path, rfs_user)

% see BUILD_RFBLOCK
% This code modified uneccessary considerations for identifying RFs and
% whatnot. This newer version only requests user for a list of blocks in
% array format and builds a superblock, regardless of which block has
% RF(s).
%
% Calvin Wu, 5-6-16

% if ~exist(save_dir)
%     mkdir(save_dir)
% end

for i_block=1:length(rfs_user)
    
    blockN=rfs_user(i_block);
    blockStr=['Block-' num2str(blockN)];

    data=TDT2mat(path,blockStr,'Type',[2 3],'Verbose',0);

    block=ones(length(data.snips.CSPK.chan),1)*blockN;
    chan=data.snips.CSPK.chan;
    ts=data.snips.CSPK.ts;
    waves=single(data.snips.CSPK.data);
    sortc=zeros(length(data.snips.CSPK.chan),1);

    partList=unique(data.epocs.FInd.data);
    part=zeros(length(data.snips.CSPK.chan),1);
    for i_p=1:length(partList)

        idx=find(data.epocs.FInd.data==partList(i_p));

        t_start=data.epocs.FInd.onset(idx(1));
        t_end=data.epocs.FInd.offset(idx(end));
        ts_idx=find(data.snips.CSPK.ts>=t_start&data.snips.CSPK.ts<=t_end);

        part(ts_idx)=partList(i_p);

    end

    SB_com=table(block,chan,ts,sortc,waves,part);
    SB_com(SB_com.part==0,:)=[];

    disp(sprintf('%s compiled. (%d/%d)',blockStr,i_block,length(rfs_user)))
    if i_block==1
        superblocks=cell(1,1);
        superblocks{1}=SB_com;
        first_block=rfs_user(i_block);
    else
        superblocks{1}=[superblocks{1};SB_com];
    end
end

% sf=strfind(path,'\');
% tank_name=path(sf(end)+1:end);
% fname=fullfile(save_dir,[tank_name '_superblock_rf' num2str(first_block) '.mat']);
% save(fname,'superblocks','-v7.3')
% disp(sprintf('Saved as %s',fname))


end