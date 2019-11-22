function [] = make_units(tbl, loc, iter)
% MAKE_UNITS side-by-side comparision of identified spike units and their
% mean cluster spike.
%
% MAKE_UNITS(TBL, LOC, ITER)
%
% Plots all the identified units (i.e. those with non-zero sort code)
% contained in table TBL into side-by-side plots of their respective
% clusters. This function assumes that the number of identified units is no
% greater than 6, for convenience of plotting. If there are more than 6
% units, only the first 6 will be plotted.
%
% Note that TBL should only represent the units on a single channel only.
% All the spikes should have non-zero unit class labels.
%
% The figure is saved to "LOC/ch<channel number>_units_<iter>.fig". If ITER is
% zero the <iter> suffix is dropped.
%
% INPUT:
% TBL       Table containing superblock data
% LOC       String path to directory to save the figure file
% ITER      Integer of number of times the superblock has been previously sorted
%
% OUTPUT:
% NONE
    co=get(groot,'defaultAxesColorOrder');
    h = figure('Visible', 'off');    
    set(h, 'CreateFcn', 'set(gcf, ''Visible'', ''on'')');
    units = unique(tbl.sortc);
    nUnits = length(units);
    
    chan = tbl.chan(1);
    
    % colormap
    if nUnits < 6
        cm = parula(nUnits);
    else
        cm = parula(6);
    end
    
    for i = 1:nUnits
        hold on;
        draw_unit_cluster(tbl, i, co(i, :));
    end
    
    fname = sprintf('ch%d_units', chan);
    fname = sprintf('%s.fig', fname);
    
    savefig(h, fullfile(loc, fname));

    close(h);

end

function [] = draw_unit_cluster(table, unit, color)
% Draw the spikes belonging to unit UNIT on the same figure. Assumes that
% subplot is called before this is called. Also plots the mean spike in a
% thick red line and 95% confidence as dashed red lines.

    unit_spikes = table(table.sortc == unit, :);
    
    nSpikes = length(unit_spikes.sortc);
    
    hold on;
    
%     idx=randsample([1:nSpikes],1000);
%     plot(unit_spikes.waves(idx, :)', 'Color', color, 'LineWidth', 0.25);

    mean_spike = get_mean_spike(unit_spikes.waves);
    plot(mean_spike, 'Color', color, 'LineWidth', 2);
    
    sd = std(unit_spikes.waves, 0, 1);
    plot(mean_spike + 2 * sd, 'Color', color, 'LineStyle', '--');
    plot(mean_spike - 2 * sd, 'Color', color, 'LineStyle', '--');

    hold off;

end
