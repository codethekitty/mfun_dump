% make the combined population mean results of the VS and phase at BMF at
% 25% modulation depth after bimodal stimulation

clear; close all;

% the experimental animals
animals = {'ANH11' 'ANH12' 'ANH13' 'ANH14' 'ANH15' 'ANH16' 'ANH17'};
lc = 1;
load('Z:\\Amarins\\Analysis\\MatLab scripts\\MTFstruct.mat')
lMtf=length(MTF);

PL=[]; PN=[]; PLs=[]; CT=[]; OL=[]; OC=[]; LF=[]; AL=[];

for i=1:length(animals)
    
    for j=1:lMtf
        if strcmp(MTF(j).name,animals{i})
            AnIdx=j;
        end
    end
    
    % load unit types
    load(sprintf('O:\\Tanks\\Automated sorted files\\MTFs\\%s-1\\unit types\\%s-1types.mat',animals{i},animals{i}))
    
    Types=unit_types.Type;
    Chans=unit_types.Channel;
    Units=unit_types.Unit;
    
    % Primary likes
    Type=strcmp(Types,'Pri');
    tPL=zeros(sum(Type),3);
    tPL(:,1)=AnIdx; tPL(:,2)=Chans(Type); tPL(:,3)=Units(Type);
    PL=[PL; tPL];
    
    % Primary-like w notch
    Type=strcmp(Types,'Pri-N');
    tPN=zeros(sum(Type),3);
    tPN(:,1)=AnIdx; tPN(:,2)=Chans(Type); tPN(:,3)=Units(Type);
    PN=[PN; tPN];
    
    % All bushy cells
    PLs=[PLs; tPL; tPN];
    
    % Chopper-T
    Type=strcmp(Types,'Ch-T');
    tCT=zeros(sum(Type),3);
    tCT(:,1)=AnIdx; tCT(:,2)=Chans(Type); tCT(:,3)=Units(Type);
    CT=[CT; tCT];
    
    % Onset-L
    Type=strcmp(Types,'On-L');
    tOL=zeros(sum(Type),3);
    tOL(:,1)=AnIdx; tOL(:,2)=Chans(Type); tOL(:,3)=Units(Type);
    OL=[OL; tOL];
    
    % Onset-C
    Type=strcmp(Types,'On-C');
    tOC=zeros(sum(Type),3);
    tOC(:,1)=AnIdx; tOC(:,2)=Chans(Type); tOC(:,3)=Units(Type);
    OC=[OC; tOC];
    
    % Low Frequencies
    Type=strcmp(Types,'LF');
    tLF=zeros(sum(Type),3);
    tLF(:,1)=AnIdx; tLF(:,2)=Chans(Type); tLF(:,3)=Units(Type);
    LF=[LF; tLF];
    
    % all units
    tAL=zeros(length(Types),3);
    tAL(:,1)=AnIdx; tAL(:,2)=Chans; tAL(:,3)=Units;
    AL=[AL; tAL];

end

AL2=[PL; PN; CT; OL; OC; LF];
fprintf('all units (incl Un) %d\n',length(AL))
fprintf('all units added %d\n',length(AL2))
tot=length(PL)+length(PN)+length(CT)+length(OL)+length(OC)+length(LF);
fprintf('all units separately added %d\n',tot)


% the control animals
animalsc = {'ANH18' 'ANH18'};% 'ANH19'};
animalsMTFc = {'ANH18' 'ANH182'};% 'ANH19'};
lcc = [1 2];% 1];
load('Z:\\Amarins\\Analysis\\MatLab scripts\\MTFcstruct.mat')
lMtf=length(MTFc);

PLc=[]; PNc=[]; PLsc=[]; CTc=[]; OLc=[]; OCc=[]; LFc=[]; ALc=[];

for i=1:length(animalsc)
    
    for j=1:lMtf
        if strcmp(MTFc(j).name,animalsMTFc{i})
            AnIdx=j;
        end
    end
    
    % load unit types
    load(sprintf('O:\\Tanks\\Automated sorted files\\MTFs\\%s-%d\\unit types\\%s-%dtypes.mat',animalsc{i},lcc(i),animalsc{i},lcc(i)))
    
    Types=unit_types.Type;
    Chans=unit_types.Channel;
    Units=unit_types.Unit;
    
    % Primary likes
    Type=strcmp(Types,'Pri');
    tPL=zeros(sum(Type),3);
    tPL(:,1)=AnIdx; tPL(:,2)=Chans(Type); tPL(:,3)=Units(Type);
    PLc=[PLc; tPL];
    
    % Primary-like w notch
    Type=strcmp(Types,'Pri-N');
    tPN=zeros(sum(Type),3);
    tPN(:,1)=AnIdx; tPN(:,2)=Chans(Type); tPN(:,3)=Units(Type);
    PNc=[PNc; tPN];
    
    % All bushy cells
    PLsc=[PLsc; tPL; tPN];
    
    % Chopper-T
    Type=strcmp(Types,'Ch-T');
    tCT=zeros(sum(Type),3);
    tCT(:,1)=AnIdx; tCT(:,2)=Chans(Type); tCT(:,3)=Units(Type);
    CTc=[CTc; tCT];
    
    % Onset-L
    Type=strcmp(Types,'On-L');
    tOL=zeros(sum(Type),3);
    tOL(:,1)=AnIdx; tOL(:,2)=Chans(Type); tOL(:,3)=Units(Type);
    OLc=[OLc; tOL];
    
    % Onset-C
    Type=strcmp(Types,'On-C');
    tOC=zeros(sum(Type),3);
    tOC(:,1)=AnIdx; tOC(:,2)=Chans(Type); tOC(:,3)=Units(Type);
    OCc=[OCc; tOC];
    
    % Low Frequencies
    Type=strcmp(Types,'LF');
    tLF=zeros(sum(Type),3);
    tLF(:,1)=AnIdx; tLF(:,2)=Chans(Type); tLF(:,3)=Units(Type);
    LFc=[LFc; tLF];
    
    % all units
    tAL=zeros(length(Types),3);
    tAL(:,1)=AnIdx; tAL(:,2)=Chans; tAL(:,3)=Units;
    ALc=[ALc; tAL];

end

AL2c=[PLc; PNc; CTc; OLc; OCc; LFc];
fprintf('all units (incl Un) of control %d\n',length(ALc))
fprintf('all units added of control %d\n',length(AL2c))
tot=length(PLc)+length(PNc)+length(CTc)+length(OLc)+length(OCc)+length(LFc);
fprintf('all units separately added of control %d\n',tot)