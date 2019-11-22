function [thr,amp,DR,MI]=getRLFT(rlf,all_levels,plotit,chan,unit)


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
    title(sprintf('RLF tone - Channnel %d, unit %d',chan,unit))
    xlabel('Intensity (dB SPL)'); ylabel('Firing rate (sp/sec)');
    line([thr thr],[0 rlfN(Idxthr)],'Color','r','LineStyle','--')
    line([0 thr],[rlfN(Idxthr) rlfN(Idxthr)],'Color','r','LineStyle','--')
    line([satur satur],[0 rlfN(Idxsatur)],'Color','b','LineStyle','--')
    line([0 satur],[rlfN(Idxsatur) rlfN(Idxsatur)],'Color','b','LineStyle','--')
    set(gca,'FontSize',16)
end






    
    