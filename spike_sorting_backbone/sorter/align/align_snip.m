function aligned = align_snip(snips, shift, fft)
% ALIGN_SNIP align snippet data using normal and FFT alignment methods.
%
% ALIGNED = ALIGN_SNIP(SNIPS, SHIFT, THR)
%           Amplitude alignment on maximum. THR option determines max or
%           min. Maximum time step shift is SHIFT.
%
% ALIGNED = ALIGN_SNIP(SNIPS, SHIFT, THR, FFT)
%           Applies DFT on waveforms after amplitude alignment.
%
% Align snippet data from TDT on maximum and using default alignment parameters.
% Window is symmetric. If FFT is provided and set to True, applies DFT to each
% spike waveform. The result will be complex.
%
% INPUT:
% SNIPS     Matrix of snippet data, rows are waveforms
% SHIFT     Maximum timesteps to shift spikes for alignment.
% THR       Option to align on maximum or miniumum. Options are:
%               'max'
%               'min'
% FFT       (Optional) boolean. If True, apply DFT after amplitude alignment
%           (Default: False)
%
% OUTPUT:
% ALIGNED   Matrix of aligned snippet spikes. Same dimensions as SNIPS. If FFT
%           flag is set to True, this matrix is complex-valued.

%     SetDefaultValue(3, 'fft', false);
    fft = false;
    
    D = defaults();
    width = size(snips, 2);
    
    
    % this function checks if THR is valid.
    [pre,post,thr,~] = event_threshold(snips);
    aligned = align_custom(snips, shift, thr, pre, post);
    
    if fft
        aligned = align_fft(snips);
    end
    
end


function [pre,post,thr,thr_val] = event_threshold(spikes)
    
try
    varian = std(spikes,0,1);
    [~,i_thr] = min(varian);
    
    thr_val = mean(spikes(:,i_thr));
    pre=i_thr-1;
    post=length(varian)-pre;
    
    val_comp = mean(spikes(:,[i_thr-1 i_thr+1]));
    sweep = val_comp(1)>val_comp(2);
    if sweep
        thr='min';
    else
        thr='max';
    end
catch
   pre=15; post=15; thr='max'; thr_val=NaN; 
end

end