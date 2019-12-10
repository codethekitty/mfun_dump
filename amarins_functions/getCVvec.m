function [CV,CVvec,xt,mut,sigt]=getCVvec(sst,trials,bw2,stTime,endTime)

% This function creates the CV, based on the times that you give him,
% typically from 12 to 20 ms relative to stimulus onset, the CVvec which is
% a vector that you can plot against xt that shows the relation of how CV
% is changes over time relative to the onset of the stimulus. To plot
% CVvec versus xt, you need to plot xt(2:end).

% By: Amarins. April 2016


stimDur=sst.Epocs.TSOff.s1ig(1)-sst.Epocs.TSOn.s1ig(1)+0.01;
fs=[]; isi=[]; % get the spike times (fs) and the relative isi (isi)
for m=1:length(trials)
    ls2=sst.GetSpikes(trials(m),'S1'); % get all the spikes of one trial
    ls2=ls2(ls2>0&ls2<stimDur); % get all the spikes that were during akoest. stimulation
    if ~isempty(ls2)&&length(ls2)>=2
        fs=[fs;ls2(1:end-1)]; % spike time
        isi=[isi;diff(ls2)]; % interspike interval with next spike
    end
end
fs_isi=[fs,isi]; % put the timestamps and the ISIs next to each other

if ~isempty(fs_isi)
    xt=0:bw2:stimDur; % the x-vector for the CV plot
    mut=[];sigt=[];bin=[];
    for n=1:length(xt)-1 % loop through all the bins
        for o=1:size(fs_isi,1)
            if fs_isi(o,1)>=xt(n)&&fs_isi(o,1)<xt(n+1)
                bin=[bin;fs_isi(o,2)];
            end
        end
        mut(n)=mean(bin); % the mean isis for every time bin
        sigt(n)=std(bin); % the std of isis for every time bin
        bin=[];
    end
    sigt(sigt==0)=NaN;
    
    % make the CV vector
    CVvec=sigt./mut;
    
    % calculate the total CV from 12 ms to 20 ms (see Sayles et al. 2013)
    start=find(xt==stTime); endd=find(xt==endTime);
    CV=nanmean(sigt(start:endd)./mut(start:endd));
else
    CV=NaN;
    CVvec=NaN;
    mut=NaN;
    sigt=NaN;
    xt=NaN;
end

