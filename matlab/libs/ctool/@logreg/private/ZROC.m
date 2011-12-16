%ROC-Kurve (innerhalb der Netzberechnung)
%Netzausg�nge in pmodell, Originalwerte in ptarget

%Schwellen bestimmen (analog zu SPSS-Verfahren)
schw=sort(pmodell);  %aufsteigend nach pmodell-Werten sortieren
[R,C]=size(pmodell);
rast=zeros(1,C);
for j=2:C 
    rast(j)=(schw(j-1)+schw(j))/2; end;
rast(1)=schw(1)-1;
rast=[rast schw(C)+1]';
C=C+1;
Spte=0;

spc=zeros(1,C);   %Spez
sec=zeros(1,C);   %Sens
Sesp=zeros(2,2,C);   %Matrix f�r die aufeinanderfolgenden Kreuztabellen

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
        Sete=cte(1,1)/(cte(1,1)+cte(2,1)); end     %Sensitivit�t Testdaten
    if (cte(1,2)+cte(2,2))>0 
        Spte=cte(2,2)/(cte(1,2)+cte(2,2)); end     %Spezifit�t Testdaten
    Sesp(:,:,j)=cte;
    spc(1,j)=1-Spte;
    sec(1,j)=Sete;
end
spc=spc';
sec=sec';
