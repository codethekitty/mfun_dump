function [Thrs,DetThr,BMDF]=getFitDetThr(amnt,blocks,MTFa,AnIdx,chan,unit,AUC,plotit)
% This function calculates the fitted curve for the AUC points per
% modulation frequency. 
% amnt = vector with all modulation frequencies presented in one block
% blocks = vector with all the blocks, typically each block has one
% modulation depth
% MTF = struct that contains all the data
% AnIdx = the animal index in the struct
% chan = channel
% unit = unit
% AUC = a matrix containing the AUC for each modulation frequency and
% modulation depth, as constructed by getAUC.m (by Amarins)
% plotit = if plotit is 1, the fitted curves and detection threshold curves
% will be plotted.


% preallocating the colors to be used for each modulation frequency - for 9 frequencies
Colors=[255 0 0;255 69 0;255 215 0;... % red, orange, gold
    128 128 0;0 128 0;0 250 154;... % olive, green, medium spring green
    30 144 255;0 0 255;128 0 128]; % dodger blue, blue, purple

% for 16 frequencies
% Colors=[128 0 0;255 0 0;240 128 128;255 69 0;255 215 0;... % maroon, red, light coral, orange, gold
%     128 128 0;0 128 0;0 255 0;0 250 154;0 255 255;... % olive, green, lime, medium spring green, cyan
%     30 144 255;0 0 255;128 0 128;255 0 255;210 105 30;0 0 0]; % dodger blue, blue, purple, magenta, chocolate, black

if plotit==1;
    figure;
end

Thrs=nan(length(amnt),2);
for m=1:length(amnt)
    
    dep=zeros(1,length(blocks));
    for n=1:length(blocks)
        dep(1,n)=MTFa(AnIdx).info.channel(chan).unit(unit).MTF.after(n).depth;
    end
    data=AUC(:,m);
    dep(isnan(data))=[];
    data(isnan(data))=[];
    
    if length(data)>2
        
        if plotit==1
            plot(dep,data,'*','Color',Colors(m,:)./255)
            xlabel('Modulation depth')
            ylabel('AUC')
            hold on
        end
        
        % loop 20x over the fitting procedure, pick the one with the least squares
        for n=1:40
            
            % define the fitting function
            Func=@(a,b,u,s,x) a+(b./(1+exp((x-u)/s)));
            x=dep';
            y=data;
            
            % do the fit over the interpolated data with noise added to it
            xp = 0:1:max(dep);
            yp = interp1(x,y,xp,'pchip');
            yp = yp+0.01*randn(size(yp));
            fitted=fit(xp',yp',Func,'Lower',[0,-1,-Inf,-Inf],'Upper',[1,0,Inf,Inf]); % 0<a<1, -1<b<0
            x=0:1:100;
            c=coeffvalues(fitted);
            y=c(1)+(c(2)./(1+exp((x-c(3))/c(4))));
            
            % the first iteration cannot be compared with anything
            if n==1
                cn=c; y=cn(1)+(cn(2)./(1+exp((x-cn(3))/cn(4))));
                
            % calculate least squares, keep the one with the least
            else
                dataF=c(1)+(c(2)./(1+exp((dep-c(3))/c(4)))); % the new one
                LS=sum((data-dataF').^2);
                dataFn=cn(1)+(cn(2)./(1+exp((dep-cn(3))/cn(4)))); % the last one
                LSn=sum((data-dataFn').^2);
                if LS < LSn
                    cn=c; y=cn(1)+(cn(2)./(1+exp((x-cn(3))/cn(4))));
                end
            end
            if n==1
                w = warning('query','last');
                id = w.identifier;
                warning('off',id);
            end
        end
        
        if plotit==1
            plot(x,y,'Color',Colors(m,:)./255);
            hold on;
        end
        % rewrite the formule to get x for a given y (=0.75)
        Thrs(m,1)=amnt(m);
        if max(y)<=0.755
            Thrs(m,2)=NaN;
        else
            Thrs(m,2)=(cn(4)*log((cn(2)/(0.75-cn(1)))-1))+cn(3);
        end
    end
end

if plotit==1
    figure;
    plot(Thrs(:,1),Thrs(:,2),'--*','Color','k')
    ax=gca;
    set(ax,'XScale','log')
    ylabel('Detection threshold'); xlabel('Modulation frequency');
    title(sprintf('channel %d, unit %d',chan,unit))
end

[DetThr,idx]=min(Thrs(:,2));
BMDF=amnt(idx);
