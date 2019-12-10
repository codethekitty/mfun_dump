function [VS,phase]=getVSphase(amnt,sst,bInd,tInd)
% This function calculates the vector strength and phase for a given MTF.
% amnt = the different frequencies presented in that block, typically a vector
% bInd = the block index in the sst
% tInd = the tank index

% By: Amarins, October 2016

triPfrq=length(sst.TrialSelect('bind',bInd,'tind',tInd,'mfr1',amnt(1))); % trials per frequency
VS=zeros(length(amnt),1);
phase=zeros(length(amnt),1);

% loop through the different frequencies
for k=1:length(amnt)
    
    % get all trials in one block that have one frequency
    trials2=sst.TrialSelect('bind',bInd,'tind',tInd,'mfr1',amnt(k));
    
    % first calculate the total VS and phase of that frequency
    lm=0.010;
    stimDur=sst.Epocs.TSOff.s1ig(trials2(1))-sst.Epocs.TSOn.s1ig(trials2(1));
    um=stimDur;
    freq=amnt(k);
    per=1/freq; % signal length of 1 period, in sec
    amPer=ceil((um-lm)/per); % amount of periods in one presentation
    % get the spikes
    ls=sst.GetSpikes(trials2,'S1'); % S1, so start aud. stimulus is 0
    ls=ls(ls>lm&ls<um);
    ls2=[]; % the spikes all normalized to the period
    for m=1:amPer
        newSp1=ls(ls>(lm+(m-1)*per)); % select all the spikes within period m
        newSp2=newSp1(newSp1<(lm)+m*per);
        norma=(m-1)*per;
        newSp=newSp2-norma;
        ls2=[ls2; newSp];
    end
    
    % get the VS and phase
    ramp=per/(2*pi);
    amSpik=length(ls2);
    pha=(ls2-lm)./ramp; % get the phases of the spikes in the period
    vec=sum(exp(1i.*pha));
    costot=sum(cos(pha)); sintot=sum(sin(pha));
    VSt=(sqrt(costot.^2+sintot.^2))/amSpik;
    phaseT=angle(vec);
    VS(k,1)=VSt; phase(k,1)=phaseT;
end


