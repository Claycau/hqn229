%Test der ANN-Ausgabe
%=====================================================
%
%Input Variable bcd mit ANN-Outputs in Spalte 8 und Targets in Spalte 7

[Z,S]=size(bcd);
ps=bcd(:,S);
ptarget=bcd(:,S-1);

[Z,S]=size(ps);
Go=1;Ko=1;      %in ptarget stehen die Indizes für Gesunde 0 und Kranke 1
for i=1:Z
    if ptarget(i)==0
        Go=[Go; ps(i)]; end
    if ptarget(i)==1 
        Ko=[Ko; ps(i)]; end
end;
Go(1)=[];   %Gesunde, original 
Ko(1)=[];   %Kranke, original
row = sum(~isnan(ps));      %Anzahl der Patienten
nbins = ceil(sqrt(row))-1;  %Anzahl der Klassen
rangex=-min(-ps)-min(ps);   %Wertebereich aller Daten
xo=rangex/nbins;            %Klassenbreite Originaldaten
xachso=min(ps):xo:-min(-ps);
no=histc(Go,xachso);    %no: Original-Histogramm für die Gesunden
mo=histc(Ko,xachso);    %mo: Original-Histogramm für die Kranken
subplot(1,2,1);
bar(xachso,no,1);
hold on;
bar(xachso,-mo,1,'r');
xlabel('Originaldaten (2 Gruppen)');

    %Normalverteilungskurven für Originaldatensätze
mG=nanmean(Go); %Mittelwert der Gesunden, transformiert
sG=nanstd(Go);  %Streuung der Gesunden, transformiert
mK=nanmean(Ko); %Mittelwert der Kranken, transformiert
sK=nanstd(Ko);  %Streuung der Kranken, transformiert
xG=(-3*sG+mG:0.1*sG:3*sG+mG);   % x-Achse für erwarteten Datenbereich: Gesunde, transformiert
xK=(-3*sK+mK:0.1*sK:3*sK+mK);   % x-Achse für erwarteten Datenbereich: Kranke, transformiert

     %Normalverteilungskurve Gesunde               
rowg=sum(~isnan(Go));  %Anzahl aller Gesunden
rangeG=-min(-Go)-min(Go); % Finds the range of this data.
binwidthg=rangeG/rowg;    % Finds the width of each bin.
yG=normpdf(xG,mG,sG);  
yG=row*(yG*binwidthg);   % Normalization necessary to overplot the histogram.
plot(xG,yG,'r-','LineWidth',2);     % Plots density line over histogram.
     %Normalverteilungskurve Kranke
rowk=sum(~isnan(Ko));  %Anzahl aller Kranken
rangeK=-min(-Ko)-min(Ko); % Finds the range of this data.
binwidthk=rangeK/rowk;    % Finds the width of each bin.
yK=normpdf(xK,mK,sK);  
yK=row*(yK*binwidthk);   % Normalization necessary to overplot the histogram.
hh2=plot(xK,-yK,'b-','LineWidth',2);     % Plots density line over histogram.

    %ROC-Kurven
pmodell=ps';
ZROC;   %ROC-Kurve der Originale
rast(1)=0;
l=length(rast);rast(l)=[];
C=C-1;
xor=spc;yor=sec;    %Sensitivität und 1-Spezifität der Originaldaten
xor(l)=[];yor(l)=[];

mincut=min([xG(1) xK(1)]);
la=length(xG);
maxcut=-min([-xG(la) -xK(la)]);
tabel=ones(1,3);
if mincut<0 
    mincut=0; end
if maxcut>1 
    maxcut=1; end
for i=mincut:0.02:maxcut
   TN=diff(normcdf([mincut i],mG,sG));
   FP=diff(normcdf([i maxcut],mG,sG));
   TP=diff(normcdf([i maxcut],mK,sK));
   FN=diff(normcdf([mincut i],mK,sK));
   Sens=TP/(TP+FN);
   Spez=TN/(FP+TN);
   scr=[i Sens Spez];
   tabel=[tabel; scr];
end
tabel(1,:)=[];  %tabel1: cutoff-Punkte
xgen=1-tabel(:,3);ygen=tabel(:,2);
subplot(1,2,2);
plot(xor,yor,'b',xgen,ygen,'r');
xlabel('1-Spezifität');
ylabel('Sensitivität')
pause(1);

%Ausgaben

%ROC-Kurven
subplot(2,2,4);
plot(xor,yor,'b',xgen,ygen,'r');
hold on;
plot(xgen,ygen,'r');
xlabel('1-Spezifität');
ylabel('Sensitivität');
title('ROC-Kurven');
trroc=ps';
trout=ptarget';
fl=0;
for j=1:C-1
    dx=xor(j)-xor(j+1);
    fl=fl+0.5*dx*(yor(j)+yor(j+1)); %Fläche nach der Trapezformel berechnen
end;
fle=fl;
AUC=num2str(fle,3);TRA=['LOO-empirisch / AUC=' AUC];

teroc=pmodell';teout=ptarget';    %damit LOO-Spesen läuft
ZLOO_Spesen; %Spez und Sens bei 95 bzw. 90 % berechnen
AUC1=num2str(SpSe95,3);AUC2=num2str(SpSe90,3);
yise95=cose95;  %für Youdenindex
cose95=rast(cose95);cose90=rast(cose90);  %in rast steht cutoff-Länge
co1=num2str(cose95,3);co2=num2str(cose90,3);
TRA1=['Se=95%  Sp=' AUC1 '% co=' co1];TRA2=['Se=90%  Sp=' AUC2 '% co=' co2];
AUC3=num2str(SeSp95,3);AUC4=num2str(SeSp90,3);
yisp95=cosp95;  %für Youdenindex
cosp95=rast(cosp95);cosp90=rast(cosp90);
co3=num2str(cosp95,3);co4=num2str(cosp90,3);
TRA3=['Sp=95%  Se=' AUC3 '% co=' co3];TRA4=['Sp=90%  Se=' AUC4 '% co=' co4];
c1=str2mat(TRA,TRA1,TRA2,TRA3,TRA4);
text(0.39,0.51,c1,'FontSize',8);
%Fläche unter generalisierter ROC-Kurve ermitteln
fl=0;
[C1,S1]=size(tabel);
for j=1:C1-1
    dx=xgen(j)-xgen(j+1);
    fl=fl+0.5*dx*(ygen(j)+ygen(j+1)); %Fläche nach der Trapezformel berechnen
end;
flg=fl;
AUC=num2str(flg,3);TRA0=['LOO-generalisiert / AUC=' AUC];
%Maßzahlen aus generalisierter ROC-Kurve ermitteln
sw=1;
for i=1:l
    if sw==1 
        di=tabel(i,2)-0.95;    %Se 95%
        if di>=0 
            mi=i;
        else sw=0;
        end
    end
end
SpSe295=tabel(mi,3);AUC1=num2str(100*SpSe295,3);
cose295=tabel(mi,1);co1=num2str(cose295,3);
sw=1;
for i=1:l
    if sw==1 
        di=tabel(i,2)-0.90;    %Se 90%
        if di>=0 
            mi=i;
        else sw=0;
        end
    end
end
SpSe290=tabel(mi,3);AUC2=num2str(100*SpSe290,3);
cose290=tabel(mi,1);co2=num2str(cose290,3);
TRA5=['Se=95%  Sp=' AUC1 '% co=' co1];TRA6=['Se=90%  Sp=' AUC2 '% co=' co2];

sw=1;
for i=1:l
    if sw==1 
        di=tabel(i,3)-0.95;    %Sp 95%
        if di<=0 
            mi=i;
        else sw=0;
        end
    end
end
SeSp295=tabel(mi,2);AUC1=num2str(100*SeSp295,3);
cosp295=tabel(mi,1);co1=num2str(cosp295,3);
sw=1;
for i=1:l
    if sw==1 
        di=tabel(i,3)-0.90;    %Sp 90%
        if di<=0 
            mi=i;
        else sw=0;
        end
    end
end
SeSp290=tabel(mi,2);AUC2=num2str(100*SeSp290,3);
cosp290=tabel(mi,1);co2=num2str(cosp290,3);
TRA7=['Sp=95%  Se=' AUC1 '% co=' co1];TRA8=['Sp=90%  Se=' AUC2 '% co=' co2];

c2=str2mat(TRA0,TRA5,TRA6,TRA7,TRA8);
text(0.39,0.16,c2,'FontSize',8);

%Sens-Spez Darstellung
subplot(2,2,1);
Spezi=1-xor;Sensi=yor;
[ax,h1,h2]=plotyy(rast,Spezi,rast,Sensi);
line([cose95 cose95],[0 1],'Color','r');
line([cosp95 cosp95],[0 1],'Color','r');
cosen95=num2str(cose95,3);
cospe95=num2str(cosp95,3);
text(cose95+0.01,0.03,cosen95,'Color','r','FontSize',8);
text(cosp95+0.01,0.03,cospe95,'Color','r','FontSize',8);
line([0 1],[0.95 0.95],'Color','b','LineStyle',':');
title('Sensitivität und Spezifität');
xlabel('cut off');
set(get(ax(1),'Ylabel'),'String','Spezifität');
set(get(ax(2),'Ylabel'),'String','Sensitivität');

%Likelihood-Ratio
subplot(2,2,2);
LRp=rast;
LRp(:)=0;
LRn=LRp;
for i=1:C
    if Spezi(i)>=0.99 
        LRp(i)=NaN; else LRp(i)=Sensi(i)/(1-Spezi(i)); end
end
for i=1:C 
    if Spezi(i)==0
        LRn(i)=NaN; else LRn(i)=(1-Sensi(i))/Spezi(i); end
end
[ay,h3,h4]=plotyy(rast,LRn,rast,LRp,'plot');
line([cose95 cose95],[0 1],'Color','r');
line([cosp95 cosp95],[0 1],'Color','r');
text(cose95+0.01,0.04,'Se95','Color','r','FontSize',8);
text(cosp95+0.01,0.04,'Sp95','Color','r','FontSize',8);
line([0 1],[0.3 0.3],'Color','b','LineWidth',1);    %LR- Schwelle
title('Likelihood-Ratio');
xlabel('cut off');
line([0 1],[10 10],'Parent',ay(2),'LineStyle','-');
lrpSe95=LRp(yise95);ha=num2str(lrpSe95,3);  %LR+ bei Se95
line([cose95 1],[lrpSe95 lrpSe95],'Parent',ay(2),'LineStyle',':');
text(0.94,lrpSe95+0.65,ha,'Parent',ay(2),'Color','r','FontSize',8);
lrpSp95=LRp(yisp95);ha=num2str(lrpSp95,3);  %LR+ bei Sp95
line([cosp95 1],[lrpSp95 lrpSp95],'Parent',ay(2),'LineStyle',':');
text(0.94,lrpSp95+0.65,ha,'Parent',ay(2),'Color','r','FontSize',8);

lrnSe95=LRn(yise95);ha=num2str(lrnSe95,3);  %LR- bei Se95
line([0 cose95],[lrnSe95 lrnSe95],'LineStyle',':');
text(0.02,lrnSe95+0.05,ha,'Color','r','FontSize',8);
lrnSp95=LRn(yisp95);ha=num2str(lrnSp95,3);  %LR- bei Sp95
line([0 cosp95],[lrnSp95 lrnSp95],'LineStyle',':');
text(0.02,lrnSp95+0.05,ha,'Color','r','FontSize',8);

set(get(ay(1),'Ylabel'),'String','LR-'); 
set(get(ay(2),'Ylabel'),'String','LR+'); 


%Youdenindex
subplot(2,2,3);
youdo=rast;
for i=1:C 
    youdo(i)=Spezi(i)+Sensi(i)-1;
    if youdo(i)<0 
        youdo(i)=0; end
end
YISe95=0.95+Spezi(yise95)-1;
YISp95=0.95+Sensi(yisp95)-1;
plot(rast,youdo,'b');
line([cose95 cose95],[0 YISe95],'Color','r');
line([0 cose95],[YISe95 YISe95],'Color','r');
line([cosp95 cosp95],[0 YISp95],'Color','r');
line([cosp95 1],[YISp95 YISp95],'Color','r');
text(cose95+0.01,0.03,'Se95','Color','r','FontSize',8);
ha=num2str(YISe95,3);
text(0.02,YISe95+0.02,ha,'Color','r','FontSize',8);
text(cosp95+0.01,0.03,'Sp95','Color','r','FontSize',8);
ha=num2str(YISp95,3);
text(0.91,YISp95+0.02,ha,'Color','r','FontSize',8);
title('YOUDEN-Index');
xlabel('cut off');
ylabel('Youden-Index');

%Ergebnisvektor
ergeb=ones(24,1);
ergeb(1)=fle;
ergeb(2)=SpSe95;ergeb(3)=cose95;ergeb(4)=SpSe90;ergeb(5)=cose90;
ergeb(6)=SeSp95;ergeb(7)=cosp95;ergeb(8)=SeSp90;ergeb(9)=cosp90;
ergeb(10)=flg;
ergeb(11)=100*SpSe295;ergeb(12)=cose295;ergeb(13)=100*SpSe290;ergeb(14)=cose290;
ergeb(15)=100*SeSp295;ergeb(16)=cosp295;ergeb(17)=100*SeSp290;ergeb(18)=cosp290;
ergeb(19)=lrpSe95;ergeb(20)=lrpSp95;ergeb(21)=lrnSe95;ergeb(22)=lrnSp95;
ergeb(23)=YISp95;ergeb(24)=YISe95;

