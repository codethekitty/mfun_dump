function msort_wrapper
%%


tank_path = uigetdir('\\maize.umhsnas.med.umich.edu\KHRI-SES-Lab','Select Tank to sort');
save_dir = uigetdir(tank_path,'Select save location');

if exist(fullfile(save_dir,'block_list.mat'),'file')
    load(fullfile(save_dir,'block_list.mat'));
    liststr=sprintf('%s',num2str(rf_user_list));
    answer = questdlg(sprintf('Block list already exists: \n%s',liststr),'Block list prompt',...
        'Use existing list','Enter new list','Use existing list');
    if strcmp(answer,'Enter new list')
        rf_user_list = inputdlg('Enter blocks to be combined (use matlab syntax):');
        eval(['rf_user_list =[' rf_user_list{1} ']']);
        save(fullfile(save_dir,'block_list.mat'),'rf_user_list');
    end
else
    rf_user_list = inputdlg('Enter blocks to be combined (use matlab syntax):');
    eval(['rf_user_list =[' rf_user_list{1} '];']);
    save(fullfile(save_dir,'block_list.mat'),'rf_user_list');
end



%%

if ~exist(fullfile(save_dir,'superblock'),'dir')
    superblocks = build_sb(tank_path, save_dir, rf_user_list);
else
    d=dir(fullfile(save_dir,'superblock'));
    if length(d)>2
        superblocks=load_sb(save_dir);
    else
        superblocks = build_sb(tank_path, save_dir, rf_user_list);
    end
end

x = inputdlg('Start at current channel (0) or (0-n):','Enter n');

if isempty(x{1})
    n=0;
else
    n=str2double(x{1});
end

m_sort(superblocks, tank_path, save_dir,n)



end



