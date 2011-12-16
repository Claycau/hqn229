clc;
load('C:\ANN1_AB110\AB110daten\AB110tv.mat');     % Training/Testdaten normiert einlesen
load('C:\ANN1_AB110\AB110daten\AB110rnstruc.mat');   % mw + s einlesen

xvar=AB110t(:,2:6)';       %Merkmale für LogReg auswählen
tori=mapstd('reverse',xvar,strun);              % originale Trainingsdaten herstellen
xvar=tori';
ytar=AB110t(:,7);         %Targets für LogReg auswählen
res=logreg(ytar,xvar);  %Logist. Regression

%LogRegModell auf Testdaten anwenden
lrtest=AB110v(:,2:6)';
vori=mapstd('reverse',lrtest,strun);              % originale Testdaten herstellen
lrtest=vori';
lrout=logregsim(res,lrtest);
bcd=[lrtest lrout];

XROCAnalyse;
