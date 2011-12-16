function [ fl ] = roc(pmodell,ptarget)
%%
%%
%%
%%

%% ROC-Kurve (innerhalb der Netzberechnung)
%% Netzausgänge in pmodell, Originalwerte in ptarget

pmodell = transpose(pmodell(:));
ptarget = transpose(ptarget(:));


%Schwellen bestimmen (analog zu SPSS-Verfahren)
schw=sort(pmodell);  %aufsteigend nach pmodell-Werten sortieren
[R,C]=size(pmodell);
rast=zeros(1,C);    %rast steht für "Raster für die Spez/Sens-Bestimmung"
for j=2:C 
    rast(j)=(schw(j-1)+schw(j))/2; end;
rast(1)=schw(1)-1;      %Endpunkte des Rasters
rast=[rast schw(C)+1]';
C=C+1;
Spte=0;
Sete=0;

%zu jeder Schwelle einen Wert für Sens und 1-Spez bestimmen sowie
%Kreuztabellen abspeichern
spc=zeros(1,C);   %Spez
sec=zeros(1,C);   %Sens
Sesp=zeros(2,2,C);   %Matrix für die aufeinanderfolgenden Kreuztabellen

for j=1:C
    n=rast(j);
    cte=zeros(2,2);
    for j1=1:C-1
        if pmodell(j1)>n 
            zz=1;
        else zz=0;
        end
        if zz==1 
            if ptarget(j1)==1 
                cte(1,1)=cte(1,1)+1;
            else cte(1,2)=cte(1,2)+1;
            end
        else if ptarget(j1)==1 
                cte(2,1)=cte(2,1)+1;
            else cte(2,2)=cte(2,2)+1;
            end
        end
    end
    if (cte(1,1)+cte(2,1))>0 
        Sete=cte(1,1)/(cte(1,1)+cte(2,1)); end     %Sensitivität 
    if (cte(1,2)+cte(2,2))>0 
        Spte=cte(2,2)/(cte(1,2)+cte(2,2)); end     %Spezifität 
    Sesp(:,:,j)=cte;
    spc(1,j)=1-Spte;
    sec(1,j)=Sete;
end
spc=spc';
sec=sec';

rast(1)=0;  %Endpunkte-Aufbereitung
l=length(rast);rast(l)=[];
C=C-1;
%xor=spc;yor=sec;    
spc(l)=[];sec(l)=[]; %Sensitivität und 1-Spezifität 

%AUC
fl=0;
for j=1:C-1
    dx=spc(j)-spc(j+1);
    fl=fl+0.5*dx*(sec(j)+sec(j+1)); %Fläche nach der Trapezformel berechnen
end;


