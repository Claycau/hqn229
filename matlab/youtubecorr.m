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

for i=1:9020
    loompa(i,:) = viewstrings{i,2};
end

for n=1:11
    name = num2str(n);
    fid = fopen(strcat('files/millionsongs/spectra/spectra_data',name,'.txt'));
    C2 = textscan(fid, '%s %s');
    CC = C2{1};
    [qwe,rty]=sort(CC);
    couner=1;
    viewstrings = cell(9020,2);
    for i=1:10000
        %Textdata is youtube data, asi is index list from sort(track_id list)
        %C2 is track_id, string data with rty index list from sort(track_id)
        if strcmp(textdata{asi(i),1},C2{1}{rty(couner)})
            viewstrings{couner,2} = C2{2}{rty(couner)};
            viewstrings{couner,1} = a(asi(i),1);
            couner = couner+1;
        end
    end

    classlabels = 2*(cell2mat(viewstrings(:,1))>100000)-1;



    fid = fopen(strcat('specdat/spectrain', name, '.data'), 'w');
    for i=1:6050
    fprintf(fid, '%d', classlabels(i));
    fprintf(fid, ' %s \n', viewstrings{i,2});
    end
    fclose(fid);

    fid = fopen(strcat('specdat/spectest', name, '.data'), 'w');
    for i=6051:9020
    fprintf(fid, '%d', classlabels(i));
    fprintf(fid, ' %s \n', viewstrings{i,2});
    end
    fclose(fid);
end