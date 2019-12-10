function [Nrate,edgesRate,respP,respA]=getSp5R(sst,bInd,tInd,chan,unit,plotit)

%
trials=sst.TrialSelect('bind',bInd,'tind',tInd);
ls=sst.GetSpikes(trials,'SW');
delay=sst.Epocs.TSOn.eamp(trials(1))-sst.Epocs.TSOn.bind(trials(1));
stimDur=sst.Epocs.TSOff.etyp(trials(1))-sst.Epocs.TSOn.etyp(trials(1));

bw=0.0001; % define the binwidth
PSTHend=0.2;
ls=ls(ls>0&ls<PSTHend); % get only the spikes from stim onset to 80 sec after
[N,edges]=histcounts(ls,round(PSTHend/bw));
Nrate=(N./bw); Nrate=Nrate/length(trials); % convert spike count to spike rate
edgesRate=edges(2:end)-((edges(2)-edges(1))/2); % convert edges to medium points

startBL=find(edgesRate>0.01,1);
stopBL=find(edgesRate>0.05,1);
BL=mean(Nrate(startBL:stopBL));
startER=find(edgesRate>stimDur+delay,1);
stopER=find(edgesRate>stimDur+delay+0.005,1);
ER=mean(Nrate(startER:stopER));

respP=(ER/BL)*100; respA=ER-BL;


if plotit==1
    figure;
    bar(edgesRate.*1000,Nrate,'k')
    delS=delay*1000; stimS=stimDur*1000; % convert to seconds
    xlabel('time rel. electrical onset (ms)'); ylabel('spike rate (sp/s)'); xlim([0 PSTHend*1000]);
    title(sprintf('Sp5 response - Channel %d, unit %d',chan,unit))
    xlim([delS stimS+15+delS])
    ymx=get(gca,'YLim');
    line([stimS+delS stimS+delS],ymx,'Color','r','LineStyle','--')
    set(gca,'FontSize',16)
    
    txt1=sprintf('Sp5 response = %3.0f%%',respP);
    txt2=sprintf('Sp5 response = %.2f sp/s',respA);
    xmx=get(gca,'XLim');
    
    text(0.92*xmx(2),0.9*ymx(2),txt1,'FontSize',14)
    text(0.92*xmx(2),0.8*ymx(2),txt2,'FontSize',14)
    
    
    
end
            
            
            
            



    