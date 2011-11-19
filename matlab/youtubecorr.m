%Grabbing youtube data and correlating with echonest features of tempo,
%key, etc.

%a is a bunch of cells, first component is the track id, so is aa
F = zeros(10000,7);
a = data;
[as,asi] = sort(textdata(:,1));
aa = datamat;
[aas,aasi] = sort(S);

for i=1:10000
    F(i,1) = a(asi(i),1);
    F(i,2) = a(asi(i),2);
    F(i,3) = a(asi(i),3);
    F(i,4) = aa(aasi(i),1);
    F(i,5) = aa(aasi(i),2);
    F(i,6) = aa(aasi(i),3);
    F(i,7) = aa(aasi(i),4);
end

couner=1;
viewstrings = cell(9020,4);
for i=1:10000
    %Textdata is youtube data, asi is index list from sort(track_id list)
    %C2 is track_id, string data with rty index list from sort(track_id)
    if strcmp(textdata{asi(i),1},C2{1}{rty(couner)})
        viewstrings{couner,1} = a(asi(i),1);
        viewstrings{couner,2} = C2{2}{rty(couner)};
        viewstrings{couner,3} = textdata{asi(i),1};
        viewstrings{couner,4} = C2{1}{rty(couner)};
        couner = couner+1;
    end
    if mod(i,100)==0
        i
    end
end