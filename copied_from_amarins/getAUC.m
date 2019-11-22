function AUC=getAUC(MTFa,blocks,amnt,AnIdx,chan,unit,plotit)
% If plotit = 0, not AUCs will be plotted, if plotit = 1, the AUCs will be
% plotted.
% the function ROCfun is called here

AUC=nan(length(blocks),length(amnt));
for m=1:length(amnt) % loop through frequencies
    
    if plotit==1
        figure;
    end
    for n=1:length(blocks)
        VSpp1=MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(n).VSpp;
        VSpp1=VSpp1(m,:);
        VSpp0=MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(length(blocks)).VSpp;
        VSpp0=VSpp0(m,:);
        [trp,fp]=ROCfun(VSpp1,VSpp0);
        if sum(isnan(trp))~=100 && length(trp)>1
            AUC(n,m)=trapz(fp,trp)*-1;
        end
        if plotit==1
            plot(fp,trp,'LineWidth',2.5)
            hold on
        end
    end
    if plotit==1
        legend('100%','50%','25%','13%','6%','0%','Location','southeast')
        title(sprintf('ROC of %d Hz modfreq',amnt(m)))
        xlim([0 1]); ylim([0 1])
        xlabel('False positive rate'); ylabel('True positive rate');
        set(gca,'FontSize',20)
        %     line([0 1],[0 1],'Color','k')
    end
end
