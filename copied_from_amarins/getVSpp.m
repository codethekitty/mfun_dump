function [VSpp,VS,phase]=getVSpp(amnt,sst,bInd,tInd)
% This function calculates the phase-projected vector strength VSpp for
% each trial of a particular block. 
% amnt = the different frequencies presented in that block, typically a vector
% bInd = the block index in the sst
% tInd = the tank index
% The output VSpp is a matrix with the frequencies in the different rows 
% and the columns each representing a trial.
% VSpp is used to calculate the modulation detection threshold.

% By: Amarins, June 2016


triPfrq=length(sst.TrialSelect('bind',bInd,'tind',tInd,'mfr1',amnt(1))); % trials per frequency
VSpp=zeros(length(amnt),triPfrq); % pre-allocate VSpp matrix
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
    %     vec=0;  % old code
    %     sintot=0; costot=0;
    %     for m=1:amSpik
    %         pha=(ls2(m)-lm)/ramp; % get the phase of that spike in the period
    %         vec=vec+(exp(1i*pha));
    %         costot=costot+cos(pha); sintot=sintot+sin(pha);
    %     end
    VSt=(sqrt(costot.^2+sintot.^2))/amSpik;
    phaseT=angle(vec);
    VS(k,1)=VSt; phase(k,1)=phaseT;
    
    % go through each trial and find the phase-projected VS (VSpp)
    for m=1:triPfrq
        ls=sst.GetSpikes(trials2(m),'S1');
        ls=ls(ls>lm&ls<um);
        ls2=[]; % the spikes all normalized to the period
        for n=1:amPer
            newSp1=ls(ls>(lm+(n-1)*per)); % select all the spikes within period k
            newSp2=newSp1(newSp1<(lm)+n*per);
            norma=(n-1)*per;
            newSp=newSp2-norma;
            ls2=[ls2; newSp];
        end
        
        amSpik=length(ls2);

        pha=(ls2-lm)./ramp;
        vec=sum(exp(1i.*pha));
        costot=sum(cos(pha)); sintot=sum(sin(pha));
        
%         vec=0;
%         sintot=0; costot=0;
%         for n=1:amSpik
%             pha=(ls2(n)-lm)/ramp; % get the phase of that spike in the period
%             vec=vec+(exp(1i*pha));
%             costot=costot+cos(pha); sintot=sintot+sin(pha);
%         end
        VSnew=(sqrt(costot.^2+sintot.^2))/amSpik;
        phasenew=angle(vec);
        
        VSpp(k,m)=cos(phasenew-phaseT)*VSnew;
    end
end


