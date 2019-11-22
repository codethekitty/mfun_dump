function data = ARF2mat(ff,varargin)
% This function imports ASCII file (generated from BioSig ARF records) and
% collects ABR waveform data with accompanying information.
%
% input e.g:
% ff = 'U:\2Data\ABRs\Calvin\export_test\SC7.txt';
%


%%
if isempty(varargin)
    verbose=1;
elseif sum(strcmpi(varargin,'verbose'))>0
    verbose=varargin{find(strcmpi(varargin,'verbose'))+1};
end

if verbose==1
    disp('Importing file...')
    tic
end


fileID=fopen(ff);
dd = textscan(fileID,'%s');
dd=dd{1};

% frequency_str='Frequency'; % legacy for RP
frequency_str='Freq';


%% word search, divide into group and records
if verbose==1
    disp('Gathering data info...')
end

group_divide=[];
record_divide=[];
for i=1:length(dd)-2
    if strcmp(dd{i},'ABR')&strcmp(dd{i+1},'Group')&strcmp(dd{i+2},'Header')
        group_divide = [group_divide;i];
    end
    if strcmp(dd{i},'Record')&strcmp(dd{i+1},'Number:')
       record_divide =[record_divide;i]; 
    end
end

if isempty(group_divide)
    error('Incorrect file format.');
end
%
group_divide=[group_divide;length(dd)+1];
side_list=[];time_point=[];record_num=[];f_list=[];l_list=[];index_list=[];
duration=[];points=[];d_found=0;p_found=0;no_avg=[];info=[];date_found=0;
for i=1:length(group_divide)-1
    for j=group_divide(i):group_divide(i+1)-1
        if strcmp(dd{j},'Reference')&strcmp(dd{j+1},'#1:')
            side_list=[side_list;dd{j+2}(1)];
        end
        if strcmp(dd{j},'Memo:')
%             if isempty(time_point)
                time_point=[time_point;cellstr(dd{j+1})];
%             end
        end
        if strcmp(dd{j},'Records:')
            record_num = [record_num;str2num(dd{j+1})];
        end
        if strcmp(dd{j},frequency_str)&strcmp(dd{j+1},'=')
            f_list = [f_list;str2num(dd{j+2})];
            index_list=[index_list;i];
        end
        if strcmp(dd{j},'Level')&strcmp(dd{j+1},'=')
            l_list = [l_list;str2num(dd{j+2})];
        end
        if strcmp(dd{j},'No.')&strcmp(dd{j+1},'Averages:')
            no_avg = [no_avg;str2num(dd{j+2})];
        end
        if d_found==0&strcmp(dd{j},'Duration:')
            duration = str2num(dd{j+1});
            d_found=1;
        end 
        if p_found==0&strcmp(dd{j},'Points:')
            points = str2num(dd{j+1});
            p_found=1;
        end
        if strcmp(dd{j},'ID:')
%             if isempty(info)|size(info,2)==length(dd{j+1})
                info=[info;cellstr(dd{j+1})];
%             else
%                 info=[cellstr(info);dd{j+1}(1:size(info,2))];
%             end
        end
        if date_found==0&strcmp(dd{j},'Time:')
            date = [dd{j+1} ' ' dd{j+3} '-' dd{j+2}];
            group_date = datestr(datenum(date,'ddd dd-mmm'),'dd-mmm-yyyy');
            date_found=1;
        end
    end
end

group_divide=group_divide(1:end-1);


%% get ABR data
if verbose==1
    disp('Collecting ABR waveforms...')
end

dd_num=NaN(length(dd),1);
for i=1:length(dd)
   nn = str2num(char(dd{i}));
   if ~isempty(nn)&length(nn)==1
      dd_num(i)=nn; 
   end
end
dd_num_find = ~isnan(dd_num);
dd_num_loc = [];
for i=1:length(dd)-points+1
   if sum(dd_num_find(i:i+points-1))==points
    dd_num_loc=[dd_num_loc;i];
   end
end
abr = zeros(length(dd_num_loc),points);
for i=1:length(dd_num_loc)
    abr(i,:)=dd_num(dd_num_loc(i):dd_num_loc(i)+points-1)';
end


%%
vn1={'index','subject','side','time_point','record_numbers'};
vn2={'index','n_averages','frequency','level','waveform'};

if length(f_list)==0
    f_list=zeros(size(l_list));
    index_list=f_list;
end

data=struct('groups',table([1:size(side_list,1)]',cellstr(info),cellstr(side_list),cellstr(time_point),record_num,'VariableNames',vn1),...
    'records',table(index_list,no_avg,f_list,l_list,abr,'VariableNames',vn2),...
    'samples',points,...
    'duration',duration,...
    'date',group_date);

if verbose==1
    disp('All done.')
    toc
end



end


    