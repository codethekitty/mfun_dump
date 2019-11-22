function [xout,yout,b]=corline(xin,yin,varargin)
% xin,yin: input matrices x and y
% xout,yout: linspace matrices for regression line
% zero=1: pass through origin

xin=reshape(xin,[],1);
yin=reshape(yin,[],1);
xyin = [xin yin];
xyin(isnan(xyin(:,1)),:)=[];
xyin(isnan(xyin(:,2)),:)=[];
xin=xyin(:,1);
yin=xyin(:,2);

if isempty(xin)|isempty(yin)
    warning('Input is empty or all NaNs.');
    xout=NaN;
    yout=NaN;
    b=NaN;
else
if isempty(varargin)
   po=polyfit(xin,yin,1);
   xt = [ones(length(xin),1) xin];
   b = xt\yin;
else
   po=polyfitZero(xin,yin,1);
   b = xin\yin;
end

xout=linspace(min(xin),max(xin));
% xout=linspace(0,max(xin));
yout=polyval(po,xout);

end


end

