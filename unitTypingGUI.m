function [unittype,bf,thr] = unitTypingGUI(sst,varargin)
%
%
%
%
% bloc=1;
% tloc=1;
%%

if isempty(varargin)
    bf=200;
else
    bf=varargin{1};
end

trsel=find_rf_trial(sst);

frqlist=sst.SortedEpocs('frq1',trsel);
bf=min(frqlist);
levlist=sst.SortedEpocs('lev1',trsel);
frqidx=find(abs(frqlist-bf)==min(abs(frqlist-bf)));

try
    fsel=[frqlist(frqidx-1) frqlist(frqidx) frqlist(frqidx+1)];
catch
    fsel=bf;
end

tr=intersect(sst.TrialSelect('frq1',fsel),trsel);
LocalSpikes=sst.GetSpikes(tr,'S1');
if ~isempty(LocalSpikes)
clf
set(gcf,'position',[200 300 800 200],'Name','Draw box on RF to plot PSTH, click on BF-THR to select')
s2=subplot(1,3,2);
x=-0.05:0.001:0.1;
y=histc(LocalSpikes,x)./(length(tr).*0.001);
bar(x,y,'k');
hold on;
xlim([-0.05 0.1]);
box off;
xlabel('Time (s)');ylabel('Spike Rate (1/s)');
set(gca,'fontsize',8)

s3=subplot(1,3,3);
ts_cell=cell(length(tr),1);
for j=1:length(tr)
    ts_cell{j}=sst.GetSpikes(tr(j),'SW');
end
[cv_winter cv_young bin fsl fisi] = get_CV(ts_cell,0.001);   
hold on;
cv=cv_winter(bin<0.15);
plot(bin(bin<0.15),cv,'b-');
plot(bin,cv_young,'r:');
plot([fsl fsl],get(gca,'ylim'),'k:')
ylim([0 1]);xlim([0.1 0.15]);
if ~isnan(fsl)&~isnan(fisi)
set(gca,'xtick',[fsl,fsl+fisi],'xticklabel',{round((fsl-0.1)*1000,1),round(1000*fisi,1)},...
    'xticklabelrotation',90,'ytick',[0,1],'box','off');
end
plot(fsl+[0.015 0.020],[0.35 0.35],'k-','linewidth',1)
xlabel('time (ms)');ylabel('cv');
set(gca,'fontsize',8)

subplot(1,3,1)
y=sst.SortedEpocs('lev1',trsel);
x=sst.SortedEpocs('frq1',trsel);

x(x==200)=[];
data=[];
for i = 1:length(x)
    for j = 1:length(y)
        idx=intersect(sst.TrialSelect('frq1',x(i),'lev1',y(j)),trsel);
        data(j,i)=SpikeRate(sst,[0 0.05],idx,'type','S1','norm','rate')-SpikeRate(sst,[0 0.05],idx,'type','SW','norm','rate');
    end
end

unittype=NaN;
thr=NaN;

if sum(sum(data))~=sum(data(1,:))
    [data_t,zt,zl]=rf_logz(data,3);
    set(gca,'Layer','top',...
        'xscale','log');
    
traced_line = traceRF(x,y,data);

xlim([min(x) max(x)]);
ylim([min(y) max(y)]);
box on
hold(gca,'all');
h=pcolor(x,y,data_t);
set(h,'edgecolor','none')
xlabel('Frequency (kHz)');
ylabel('Intensity (dB SPL)');
h=colorbar;
delete(h);
if ~isnan(traced_line)
plot(traced_line(:,1),traced_line(:,2),'-','color',[0.5 0.5 0.5],'linewidth',1);
end
line([bf bf],get(gca,'ylim'),'color',[0.5 0.5 0.5],'linewidth',1);
line(get(gca,'xlim'),[thr thr],'color',[0.5 0.5 0.5],'linewidth',1);
set(gca,'fontsize',8,'xtick',2000*2.^[0:4],'xticklabel',num2cell((2000*2.^[0:4])/1000),...
    'ytick',30:30:90);

drawnow;

h=imrect;

k=0;
hr=[];

while ~k
    pos = getPosition(h);
    if pos(3)==0&pos(4)==0
        k=1;
        bf=pos(1);
        thr=pos(2);
    else
        delete(s2)
        delete(s3)
        delete(h)
        delete(hr)
        hr=rectangle('position',pos,'edgecolor',[0.5 0.5 0.5]);
        fsel=frqlist(frqlist>=pos(1)&frqlist<=(pos(1)+pos(3)));
        lsel=levlist(levlist>=pos(2)&levlist<=(pos(2)+pos(4)));
        
        s2=subplot(1,3,2);
        tr = intersect(sst.TrialSelect('frq1',fsel,'lev1',lsel),trsel);
        LocalSpikes=sst.GetSpikes(tr,'S1');
        x=-0.05:0.001:0.1;
        y=histc(LocalSpikes,x)./(length(tr).*0.001);
        bar(x,y,'k');
        hold on;
        xlim([-0.05 0.1]);
        box off;
        xlabel('Time (s)');ylabel('Spike Rate (1/s)');
        set(gca,'fontsize',8)
        
        s3=subplot(1,3,3);
        ts_cell=cell(length(tr),1);
        for j=1:length(tr)
            ts_cell{j}=sst.GetSpikes(tr(j),'SW');
        end
        [cv_winter cv_young bin fsl fisi] = get_CV(ts_cell,0.001);   
        hold on;
        cv=cv_winter(bin<0.15);
        plot(bin(bin<0.15),cv,'b-');
        plot(bin,cv_young,'r:');
        plot([fsl fsl],get(gca,'ylim'),'k:')
        ylim([0 1]);xlim([0.1 0.15]);
        if ~isnan(fsl)&~isnan(fisi)
        set(gca,'xtick',[fsl,fsl+fisi],'xticklabel',{round((fsl-0.1)*1000,1),round(1000*fisi,1)},...
            'xticklabelrotation',90,'ytick',[0,1],'box','off');
        end
        plot(fsl+[0.015 0.020],[0.35 0.35],'k-','linewidth',1)
        xlabel('time (ms)');ylabel('cv');
        set(gca,'fontsize',8)
        
        subplot(1,3,1)
        delete(h)
        h=imrect;
    end
end



TypeList={'P/B','B','PL','PLN','Cs','Ct','O','Ol','Oc','Oi','Og','CX','LF','UN','NR'};
[sel,v] = listdlg('PromptString','PSTH Type:',...
    'SelectionMode','single',...
    'ListString',TypeList);
if v==1
    unittype=TypeList{sel};
elseif v==0
    unittype='Check';
end
end
close all
else
    unittype=NaN;
        bf=NaN;
        thr=NaN;
end

end



function trsel=find_rf_trial(sst)
%%

trsel=[];
if ismember('tind',sst.Epocs.Values.Properties.VarNames)
    [u,b,c]=unique(sst.Epocs.Values(:,{'tind','bind'}));
	for i=1:max(c)
        u.frq(i,1)=length(unique(sst.Epocs.Values.frq1(c==i)));
        u.eamp(i,1)=max(sst.Epocs.Values.eamp(c==i));
    end
    im=find(u.frq>10&u.eamp==0);
    vn = u.Properties.VarNames;
    vnv = double(u(im,:));
    trsel = sst.TrialSelect(vn{1},vnv(1,1),vn{2},vnv(1,2));
elseif ismember('bind',sst.Epocs.Values.Properties.VarNames)
    [u,b,c]=unique(sst.Epocs.Values.bind);
    for i=1:max(c)
        u(i,2)=length(unique(sst.Epocs.Values.frq1(c==i)));
        if ismember('eamp',sst.Epocs.Values.Properties.VarNames)
            u(i,3)=nanmax(sst.Epocs.Values.eamp(c==i));
        else
            u(i,3) = nan;
        end
%         u(i,4)=~any(sst.Epocs.Values.frq1(c==i)==200);
    end
    im=find((u(:,2)>10)&(u(:,3)==0|isnan(u(:,3))),2);
    trsel = sst.TrialSelect('bind',im);
else
    trsel = sst.TrialSelect();
end

end

