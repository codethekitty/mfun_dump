function [chanDep,absDep] = getDepth(chan,AnIdx)

% designed for ANH MTF experiments
% chanDep is depth relative to top channel, so first channel is only space
% absDep is the absolute depth in the brain, when depth was not recorded, a
% standard value of 7 was taken as depth.
% by Amarins, 9-20-2016, Shore Lab, KHRI

% make from animal index the brain depth, nchannel, and nshank
% considering that AnIdx go from ANH12;ANH11;ANH13;ANH14;ANH15;ANH16;ANH17;ANH18;ANH19
depVec=[7 7 7.2 7.5 7 6.5 7 7 7.5];
nchanVec=[32 32 16 32 32 32 32 32 32];
nshankVec=[2 2 2 2 2 2 2 2 2];
braindep=depVec(AnIdx);
nchan=nchanVec(AnIdx);
nshank=nshankVec(AnIdx);

% determine the order and spacing for that electrode
if nchan<=16 % likely a 16-channel electrode
    if nshank==2 % likely to be A2x8-11mm-125-200-177
        order=[5 13;4 12;6 14;3 11;7 15;2 10;8 16;1 9];
        space=0.125; % in mm
        chanNum=find(order==chan);
        if chanNum>8 % get channel number from top calculated
            chanNum=chanNum-8;
        end
        chanDep=chanNum*space;
        chanNum=(chanNum-9)*-1; % get channel number from bottom calculated
        if isempty(braindep)
            braindep=7; % standard for VCN
        end
        absDep=braindep-(space*chanNum);
    end
elseif nchan<=32 && nchan>16 % likely a 32-channel electrode
    if nshank==2 % likely to be A2x16-10mm-50-500-177
        order=[1 17;9 25;2 18;10 26;8 24;16 32;3 19;11 27;4 20;12 28;...
            7 23;15 31;5 21;13 29;6 22;14 30];
        space=0.05; % in mm
        chanNum=find(order==chan);
        if chanNum>16 % get channel number from top calculated
            chanNum=chanNum-16;
        end
        chanDep=chanNum*space;
        chanNum=(chanNum-17)*-1; % get channel number from bottom calculated
        if isempty(braindep)
            braindep=7; % standard for VCN
        end
        absDep=braindep-(space*chanNum);
    elseif nshank==1 % David's new electrode
        % order=[];
        % space=[];
    end
end




