clear;
tank='ANH11'; %chck
load(sprintf('Physio Info Animals/%s.mat',tank)) 
lc=1; %chck
blRF=1; %chck
unit_sp=PhyInfo.locs(lc).blck(blRF).unitsp;

blPre=16+19;
% blBim=13;
blPost1=2+16+19;
blPost2=3+16+19;
blPost3=4+16+19;

% only grapping the Pri-like units
unit_sp([3 5 6 7 8 14 15 16 17 19 29 33],:)=[];


%%
VSVar=zeros(length(unit_sp),4);
phaseVar=zeros(length(unit_sp),4);
evVar=zeros(length(unit_sp),4);


for i=1:length(unit_sp)
    VSVar(i,1)=PhyInfo.locs(lc).blck(blPre).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).VS2;
%     VSVar(i,2)=PhyInfo.locs(lc).blck(blBim).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).VS;
    VSVar(i,2)=PhyInfo.locs(lc).blck(blPost1).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).VS2;
    VSVar(i,3)=PhyInfo.locs(lc).blck(blPost2).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).VS2;
    VSVar(i,4)=PhyInfo.locs(lc).blck(blPost3).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).VS2;

    phaseVar(i,1)=PhyInfo.locs(lc).blck(blPre).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).phase2;
%     phaseVar(i,2)=PhyInfo.locs(lc).blck(blBim).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).phase;
    phaseVar(i,2)=PhyInfo.locs(lc).blck(blPost1).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).phase2;
    phaseVar(i,3)=PhyInfo.locs(lc).blck(blPost2).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).phase2;
    phaseVar(i,4)=PhyInfo.locs(lc).blck(blPost3).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).phase2;

    evVar(i,1)=PhyInfo.locs(lc).blck(blPre).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).evR2;
%     evVar(i,2)=PhyInfo.locs(lc).blck(blBim).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).evR;
    evVar(i,2)=PhyInfo.locs(lc).blck(blPost1).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).evR2;
    evVar(i,3)=PhyInfo.locs(lc).blck(blPost2).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).evR2;
    evVar(i,4)=PhyInfo.locs(lc).blck(blPost3).channel(unit_sp.ch(i)).unit(unit_sp.unit(i)).evR2;
end

%%

% for i=1:3
%     subplot(1,3,i);
i=3;
    figure; scatter(VSVar(:,1),VSVar(:,i+1),80,[255,69,0]/255,'filled'); 
    hold on; 
    plot([0 1],[0 1],'--k','LineWidth',2); box on;
    xlabel('vector strength before');
    ylabel('vector strength after');
    title('vector strength')
    ax = gca;
    ax.FontSize=14;
    [hvs pvs civs statsvs]=ttest(VSVar(:,1),VSVar(:,i+1));
% end

% for i=1:3
%     subplot(1,3,i);
i=3;

figure; scatter(phaseVar(:,1),phaseVar(:,i+1),80,[0,128,0]/255,'filled'); 
    hold on; 
    plot([-4 4],[-4 4],'--k','LineWidth',2); box on;
    xlabel('phase (rad) before');
    ylabel('phase (rad) after');
    ax = gca;
    ax.FontSize=14;
    title('phase')
    [hph pph ciph statsph]=ttest(phaseVar(:,1),phaseVar(:,i+1));
    axis([-4 4 -4 4])
    
    
    
   
% end

% for i=1:3
%     subplot(1,3,i);
i=3;


figure; scatter(evVar(:,1),evVar(:,i+1),80,[128,0,128]/255,'filled'); 
hold on; 
plot([0 1.1*max(evVar)],[0 1.1*max(evVar)],'--k','LineWidth',2); box on;
xlabel('evoked rate (sp/s) before');
ylabel('evoked rate (sp/s) after');
title('evoked rate')

ax = gca;
ax.FontSize=14;

[hev pev ciev statsev]=ttest(evVar(:,1),evVar(:,i+1));


% end


evVardif=evVar(:,4)-evVar(:,1);
VSVardif=VSVar(:,4)-VSVar(:,1);
evVardif(isnan(evVardif))=[];
VSVardif(isnan(VSVardif))=[];

p = polyfit(evVardif,VSVardif,1); % p has the coefficients of the polynomial fit in descending order, so y= p(1)x + p(2)
x1=linspace(-100,400,100);
y1=polyval(p,x1);

% specify the marker color
MColor=[30,144,255]; % dodger blue

% plot the data
figure; 
scatter(evVardif,VSVardif,80,'o','MarkerEdgeColor',MColor/255,...
    'LineWidth',2.5)
hold on; plot(x1,y1,'r','LineWidth',2);
% xlim([-6000 1000]); ylim([-20 30])
box on;
xlabel('Evoked rate change (sp/s)'); ylabel('VS change');
ax = gca;
ax.FontSize=14;
[r,p]=corrcoef(evVardif,VSVardif)