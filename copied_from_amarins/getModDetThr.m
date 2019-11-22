function [DetThr,BMDF,MTFa]=getModDetThr(sst,blocks,tanks,rfs_user,chan,unit,AnIdx,MTFa,plotit)
% This function returns the modulation detection threshold according to the
% paper of Sayles, 2013. 
% This is de master function, calling getVSpp.m, getAUC.m (who calls 
% ROCfun.m), and getFitDetThr.m. It is being called by ModDetThresholds,
% who loops over all the units.

% Designed for phaselocking in response to amplitude modulated noise.
% Considers the modulation to start at the same phase in every repetition, 
% at phase = 0 rad. 

% loops over each sst to get detection threshold

% By Amarins. June 2016


% --- 1. first calculate the VSpp and save that in the MTFa
for j=1:length(blocks)    
    fprintf('Start with block %d\n',j)
    
    % find the right block and tank index
    nrfs_user=rfs_user(:,rfs_user(2,:)==tanks(j));
    bInd=find(nrfs_user(1,:)==blocks(j));
    tInd=tanks(j);
    
    % get the different frequencies to which responses are recorded
    trials=sst.TrialSelect('bind',bInd,'tind',tInd);
    amnt=unique(sst.Epocs.Values.mfr1(trials));
    
    % calculate VSpp for each frequency in the block
    [VSpp,VS,phase]=getVSpp(amnt,sst,bInd,tInd);

    % put all info in the MTFa matrix
    MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(j).depth=sst.Epocs.Values.mdp1(trials(1));
    MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(j).mfrq=amnt;
    MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(j).VS=VS;
    MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(j).pha=phase;
    MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(j).VSpp=VSpp;
end

% --- 2. get the ROC curves and calculate area under the curve (AUC)
plotit=0; % if 1, ROC will be plotted, if 0 not
AUC=getAUC(MTFa,blocks,amnt,AnIdx,chan,unit,plotit);
MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(1).AUC=AUC;

% --- 3. get the detection threshold
plotit=1; % if 1, AUCvsModDep fitted curves and DetThrvsModFrq will be plotted
[Thrs,DetThr,BMDF]=getFitDetThr(amnt,blocks,MTFa,AnIdx,chan,unit,AUC,plotit);
MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(1).DetThr=Thrs;

% save('Z:\\Amarins\\Analysis\\MatLab scripts\\MTFastruct.mat','MTFa')




        
        


   




