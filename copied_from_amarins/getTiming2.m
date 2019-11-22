function [FSL, FISI, tCV, sCV]=getTiming2(sst,trials)

lm=0; % lower bound
um=0.2; % upper bound

spac=SpikeRate(sst,[0 0.1],[],'type','SW','norm','count')./0.1; % total count of spontaneous spikes

% spontaneous activity by getting the first 50 ms
% spac=SpikeRate(sst,[0 0.05],[],'type','SW','norm','rate'); 

% for plotting
% ls=sst.GetSpikes(trials,'S1'); 
% binx=0.0001; % binsize
% x=lm:binx:um;
% y=histc(ls,x)./(length(ls).*binx);
% x=reshape(x,length(x),1);
% y=reshape(y,length(y),1);
% figure;
% subplot(2,2,1)
% bar(x,y,'k'); xlabel('PST (s)'); ylabel('Sp/s')
% coef=0.001/binx;
% set(gca,'ytick',get(gca,'ytick'),...
%             'xlim',[lm um],'yticklabel',num2cell(get(gca,'ytick')/coef))
        
% subplot(2,2,3)
ls2=[];
count=0;
for i=1:length(trials)
    ls=sst.GetSpikes(trials(i),'SW'); % get all the spikes during stimulus
    ls=ls(ls>lm&ls<um); % make sure they are all between lower and upper bond
    if ~isempty(ls)&length(ls)>=2
        ls2=[ls2;ls]; % put all the spike time points behind each other in ls2
        count=count+1; % count the amount of trials in which there were then 2 spikes
%         plot(ls,i,'k.');hold on
    end
end
% subplot(2,2,2)
% plot(ls2,1,'.');hold on

% do the poisson method to find the poisson distribution
if ~isempty(ls2)
    pd_fsl=[];
    ls2=sort(ls2);
    for m=0:length(ls2)-1
        pd_fsl(m+1)=poisspdf(m,spac*ls2(m+1));
    end
    
    % subplot(2,2,4)
    % plot(ls2,pd_fsl);hold on
    % set(gca,'yscale','log')
    % ylim([0.0000000000000001 1])
    % xlim([0 0.03])
    % line(get(gca,'xlim'),[10^-6 10^-6],'linestyle',':')
    
    fx=find(pd_fsl<10^-6&ls2'>0.1);
%    fx=find(pd_fsl<10^-6);
    if ~isempty(fx)
        FSL=ls2(fx(1)); % this first-spike latency
        
        
        % subplot(2,2,1)
        % hold on;
        % line([fsl fsl],get(gca,'ylim'))
        
        % subplot(2,2,3)
        % hold on;
        % line([fsl fsl],get(gca,'ylim'))
        
        
        % now find the first spikes and first-interspike interval
        room=0.0003; %
        adjFSL=FSL-room;
        totFS=[];
        totFISI=[];
        for j=1:length(trials)
            ls=sst.GetSpikes(trials(j),'SW');
            ls=ls(ls>lm&ls<um);
            if ~isempty(ls)&length(ls)>=2
                evSp=find(ls>=adjFSL); % find the first spike
                if ~isempty(evSp)&length(evSp)>=2 % only procede when there are spikes larger than the FSL
                    fs=ls(evSp(1));
                    ns=ls(evSp(2));
                    fisi=ns-fs;
                    totFS=[totFS;fs];
                    totFISI=[totFISI;fisi];
                end
            end
        end
        if ~isempty(totFISI)
            FISI=mean(totFISI);
        else
            FISI=NaN;
        end
    else
        FSL=NaN;
        FISI=NaN;
    end
else
    FSL=NaN;
    FISI=NaN;
end



% now get the coefficients of variation

% figure;
% get all spikes during the sound
% ls=sst.GetSpikes(sst.TrialSelect(),'S1');
% lower boundary and upper boundary
lmt=0;
umt=0.01;
lms=0.015;
ums=0.05;
% bin sizes
% binx=0.0005;
binx2=0.001;

% x=lm:binx:um;
% y=histc(ls,x)./(length(ls).*binx);
% x=reshape(x,length(x),1);
% y=reshape(y,length(y),1);
% subplot(2,2,1)
% bar(x,y,'k'); xlabel('PST (s)'); ylabel('Sp/s')
% coef=0.001/binx;
% set(gca,'ytick',get(gca,'ytick'),...
%             'xlim',[lm um],'yticklabel',num2cell(get(gca,'ytick')/coef))

%
fst=[];isit=[]; % transient
fss=[];isis=[]; % sustained
% trials=sst.TrialSelect();
for i=1:length(trials)
    ls=sst.GetSpikes(trials(i),'S1'); % get all the spikes of one trial
    lst=ls(ls>lmt&ls<umt); % get all the spikes that were during akoest. stimulation
    if ~isempty(lst)&length(lst)>=2 % only do this when there were more than 1 spike
        fst=[fst;lst(1:end-1)]; % put all spike times below each other
        isit=[isit;diff(lst)]; % put all the isis below each other
    end
    lss=ls(ls>lms&ls<ums);
    if ~isempty(lss)&length(lss)>=2
        fss=[fss;lss(1:end-1)];
        isis=[isis;diff(lss)];
    end
end

% if ~isempty(isi)
%     x=lm:binx:um;
%     y=histc(isi,x)./(length(isi).*binx);
%     subplot(2,2,3)
%     bar(x,y,'k'); xlabel('ISI (s)'); ylabel('n')
%     set(gca,'xlim',[lm um]);
% end

% calculate the transient CV
fs_isit=[fst,isit]; % put the timestamps and the ISIs next to each other
if ~isempty(fs_isit)
    xt=lmt:binx2:umt;
    mut=[];sigt=[];bin=[];
    for j=1:length(xt)-1
        for i=1:size(fs_isit,1)
            if fs_isit(i,1)>=xt(j)&fs_isit(i,1)<xt(j+1)
                bin=[bin;fs_isit(i,2)];
            end
        end
        mut(j)=mean(bin); % the mean isi for every time bin
        sigt(j)=std(bin);
        bin=[];
    end
    sigt(sigt==0)=NaN;
    tCV=nanmean(sigt./mut);
else
    tCV=NaN;
end

% calculate the sustained CV
fs_isis=[fss,isis];
if ~isempty(fs_isis)
    xs=lms:binx2:ums;
    mus=[];sigs=[];bin=[];
    for j=1:length(xs)-1
        for i=1:size(fs_isis,1)
            if fs_isis(i,1)>=xs(j)&fs_isis(i,1)<xs(j+1)
                bin=[bin;fs_isis(i,2)];
            end
        end
        mus(j)=mean(bin); % the mean isi for every time bin
        sigs(j)=std(bin);
        bin=[];
    end
    sigs(sigs==0)=NaN;
    sCV=nanmean(sigs./mus);
else
    sCV=NaN;
end

% subplot(2,2,2)
% plot(x(1:end-1),mu,'bo');hold on;
% plot(x(1:end-1),sig,'rs');hold off; xlabel('FSL (s)'); ylabel('ISI (s)')
% set(gca,'xlim',[lm um]);
% legend('\mu','\sigma')

% subplot(2,2,4)
% plot(x(1:end-1),sig./mu,'k.'); xlabel('FSL (s)'); ylabel('CV')
% set(gca,'xlim',[lm um]);
% title(sprintf('CV = %.2f',nanmean(sig./mu)));

