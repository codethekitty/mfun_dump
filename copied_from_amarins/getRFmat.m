function [data,x,y]=getRFmat(sst,bInd,tInd)
% Input:
% sst = superspiketrian object
% bInd = the index of the block containing the RF data
% tInd = the index of the tank containing the RF data
% 
% Output:
% data = matrix containing the spikerate per frequency/intensity
% combination
% x = vector containing all presented frequencies
% y = vector containing all presented intensities

% You can plot the receptivel field from this data by: 
%   pcolor(x,y,data);
%   colormap;
%   axis([min(x) max(x) min(y) max(y)]);
%   ax=gca;
%   set(ax,'XScale','log')
%   xlabel('Frequency (Hz)'); ylabel('Intensity (dB SPL)');

% By: Amarins, June 2016


trials=sst.TrialSelect('bind',bInd,'tind',tInd);
x=sst.SortedEpocs('frq1',trials);
x(x==0)=[];    x(x==200)=[];
y=sst.SortedEpocs('lev1',trials);
data=nan(length(y),length(x));
for i = 1:length(x)
    for j = 1:length(y)
        data(j,i) = SpikeRate(sst,[0 0.05],sst.TrialSelect('s1ig',1,'frq1',x(i),'lev1',y(j),'bind',bInd,'tind',tInd),'type','S1','norm','rate')-SpikeRate(sst,[0 0.05],sst.TrialSelect('frq1',x(i),'lev1',y(j),'bind',bInd,'tind',tInd),'type','SW','norm','rate');
        %             data(j,i) = SpikeRate(sst,[0 0.02],sst.TrialSelect('frq1',x(i),'lev1',y(j)),'type','SW','norm','rate');
    end
end

