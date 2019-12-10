function [rlf,all_levels,thr,amp,DR,MI]=getRLFN(sst,bInd,tInd,chan,unit,plotit,fInd)


trials=sst.TrialSelect('bind',bInd,'tind',tInd,'find',fInd);
all_levels=SortedEpocs(sst,'lev1',trials);

rlf=nan(length(all_levels),1);
for k=1:length(all_levels)
    rlf(k,1)=SpikeRate(sst,[0 0.05],TrialSelect(sst,'lev1',all_levels(k),'bind',bInd,'tind',tInd,'find',fInd),'type','S1','norm','rate');
end

rlfN=smooth(rlf); % smoothed version to do calculations on
rlfNcor=rlfN-rlfN(1); % corrected for SFR at noise = 0 dB
amp=max(rlfNcor);
Idxsatur=find(rlfNcor>0.9*amp,1,'first'); satur=all_levels(Idxsatur);
Idxthr=find(rlfNcor>0.1*amp,1,'first'); thr=all_levels(Idxthr);
DR=satur-thr;
MI=(rlfN(end)-rlfN(1))/(max(rlfN)-rlfN(1));

if plotit==1 && ~isempty(rlf)
    figure;
    plot(all_levels,rlfN,'k','LineWidth',3);
    title(sprintf('RLF noise - Channnel %d, unit %d',chan,unit))
    xlabel('Intensity (dB SPL)'); ylabel('Firing rate (sp/sec)');
    line([thr thr],[0 rlfN(Idxthr)],'Color','r','LineStyle','--')
    line([0 thr],[rlfN(Idxthr) rlfN(Idxthr)],'Color','r','LineStyle','--')
    line([satur satur],[0 rlfN(Idxsatur)],'Color','b','LineStyle','--')
    line([0 satur],[rlfN(Idxsatur) rlfN(Idxsatur)],'Color','b','LineStyle','--')
    set(gca,'FontSize',16)
end






    
    