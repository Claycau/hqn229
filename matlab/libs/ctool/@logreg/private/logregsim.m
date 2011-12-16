function  simout = logregsim(lrm,tei)

[R,C]=size(tei);
simout=zeros(R,1);
for i=1:R
    LRout1=lrm.coeffs(1)+lrm.coeffs(2)*tei(i,1)+lrm.coeffs(3)*tei(i,2)+lrm.coeffs(4)*tei(i,3)+ ... 
        lrm.coeffs(5)*tei(i,4)+lrm.coeffs(6)*tei(i,5);           %Modellausgänge berechnen
    simout(i)=(2/(1+exp(-LRout1)))-1;    
end

    