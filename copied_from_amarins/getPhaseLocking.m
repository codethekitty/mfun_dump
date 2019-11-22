function [VS,phase,phase2,n,amSpik,VS2]=getPhaseLocking(sst,trials)

% This function returns the vector strength VS and the phase relative to 
% the auditory signal when given an sst with a PSTH. This script gets the 
% frequency of the pure tone from the sst.

% Designed for phaselocking in response to low frequency pure tones.
% Considers the tone to start at the same phase in every repetition, at
% phase = 0 deg. 

% By Amarins. 3/2/2016


% get all the trials
% trials=sst.TrialSelect();
% if length(trials)==670
%     trials=trials(1:300); % in case of ANH6/ANH9 evaluation
% end

% get the lower and upper bound
lm=0.010; % start after onset response and latency is done
stimDur=sst.Epocs.TSOff.s1ig(trials(1))-sst.Epocs.TSOn.s1ig(trials(1));
um=stimDur; % upper bound, considering stimulus length is 0.050 ms

% get the frequency of the tone from the sst
freq=sst.Epocs.Values.frq1(trials(1));
per=1/freq; % signal length of 1 period, in sec
amPer=ceil((um-lm)/per);  % get the amount of periods in the given time

% get the spikes
ls=sst.GetSpikes(trials,'S1'); % S1, so start aud. stimulus is 0
ls=ls(ls>lm&ls<um); % select only the ones in the sustained part


% ---- figure out the vector strength ----
ls2=[]; % the spikes all normalized to the period
for k=1:amPer
    newSp1=ls(ls>(lm+(k-1)*per)); % select all the spikes within period k
    newSp2=newSp1(newSp1<(lm)+k*per);
    norma=(k-1)*per;
    newSp=newSp2-norma;
    ls2=[ls2; newSp];
end
ramp=per/(2*pi); 
amSpik=length(ls2);
vec=0;
sintot=0; costot=0;
for m=1:amSpik
    pha=(ls2(m)-lm)/ramp; % get the phase of that spike in the period
    vec=vec+(exp(1i*pha));
    costot=costot+cos(pha); sintot=sintot+sin(pha);
end
% first method from my previous paper
VS=(abs(vec))/amSpik;
phase2=angle(vec);

% second method from Sayles et al. 2013
VS2=(sqrt(costot.^2+sintot.^2))/amSpik;
RS=2*(VS2.^2)*amSpik; % whether it is significant
if RS < 13.8 % RS>13.8 is significant for p<0.001 (Mardia & Jupp, 2000)
    VS2=NaN;
    phase2=NaN;
end
   


% ---- figure out the phase shift ----
n=hist(ls2,1000); % plot of the neural signal

audT=[per/1000:per/1000:per];
dep=1;
aud=1-(dep*sin(2*pi*freq*audT)); % plot of the auditory signal


% do a cross correlation to find the phase shift
[c,lags]=xcorr(n,aud);
[~,i]=max(c);
Ptemp=lags(i);
phase=(Ptemp/2000)*2*pi; % phase of the audio signal relative to a sine wave

