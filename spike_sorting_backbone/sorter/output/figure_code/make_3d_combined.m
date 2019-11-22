function [] = make_3d_combined(tbl, feature, loc, iter, nSample)

% SEE MAKE_3D


    h = figure('Visible', 'off');
    set(h, 'CreateFcn', 'set(gcf, ''Visible'', ''on'')');
    
    chan = tbl.chan(1);
    
    fname = sprintf('ch%d_3D', chan);
    hold on;
    
	if nSample==0
        nSample=10000000000000000;
    end
    
    idx_all = 1:height(tbl);
    if length(idx_all)>nSample
        idx_all=datasample(idx_all,nSample);
    end
    
    tbl_sel = tbl(idx_all,:);

    fspace = feature(tbl_sel.waves);

    allC=unique(tbl_sel.sortc);
    
    cOrder=get(groot,'defaultAxesColorOrder');
    
    for i=1:length(allC)
        idx=find(tbl_sel.sortc==allC(i));
        if allC(i)==0
            scatter3(fspace(idx, 1), fspace(idx, 2), fspace(idx, 3),2,[0.5 0.5 0.5],'filled');
        else
            scatter3(fspace(idx, 1), fspace(idx, 2), fspace(idx, 3),4,cOrder(allC(i),:),'filled');
        end
	end

    
    if iter > 0
        fname = sprintf('%s_%d', fname, iter);
    end
    
    fname1 = sprintf('%s.fig', fname);
    savefig(h, fullfile(loc, fname1));

%     fname2 = sprintf('%s.pdf', fname);
%     set(h,'paperpositionmode','auto')
%     saveas(h,fullfile(loc, fname2),'pdf')
    
    close(h);
end
