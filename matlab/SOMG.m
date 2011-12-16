whole_thang = featuresandlabels(randperm(size(featuresandlabels,1)),:);
train_thang = zscore(whole_thang(:,1:30));
label_color = [255,255,0;0,255,255;255,0,255;0,0,0;100,100,100;200,200,200;255,255,255;0,0,255;0,255,0;255,0,0];

width = 20;
height = 20;
iterations = 2000;
maxradius = min(width, height)/2;
baselearn = .1;
numweights = 30;
map = 2*rand([numweights, width, height])-ones([numweights, width,height]);
for i=1:width
    for j=1:height
        map(:,i,j)=map(:,i,j)/norm(map(:,i,j));
    end
end

lambda = iterations/log(maxradius);
decay = 1;
for i=1:iterations
  decay = exp(-1*i/lambda);
  learn = baselearn*decay;
  radius = maxradius*decay;
  train = train_thang(i,:)';
  findmax = -1*numweights;
  maxrow = 0;
  maxcol = 0;
if mod(i,100)<=0
i
end
  for w=1:width
      for h=1:height
          if dot(train,map(:,w,h))>findmax
              findmax=dot(train,map(:,w,h));
              maxrow=h;
              maxcol=w;
          end
      end
  end
  radius=round(radius);
  for w2=max(1,maxcol-radius):min(width,maxcol+radius)
      for h2=max(1,maxrow-radius):min(height,maxrow+radius)
               if radius > ((w2-maxcol).^2+(h2-maxrow).^2).^.5
                   map(:,w2,h2)=map(:,w2,h2)+learn*exp(-1*((w2-maxcol).^2+(h2-maxrow).^2)/(2*radius.^2))*(train-map(:,w2,h2));;
               end
      end
  end
  %dlmwrite('lisztomania.txt',map,' ');
end

countMat = zeros(width,height,10);
for i=1:size(whole_thang,1)
    findmax = 0;
    max_row = 1;
    max_col = 1;
    for w=1:width
        for h=1:height
            if dot(map(:,w,h),train_thang(i,:))>findmax
                findmax = dot(map(:,w,h),train_thang(i,:));
                max_row = h;
                max_col = w;
            end
        end
    end
    countMat(max_col,max_row,whole_thang(i,31)) = countMat(max_col,max_row,whole_thang(i,31))+1;
    if mod(i,1000)==0
        i/size(whole_thang,1)
    end
end

COLORMAT = zeros(w,h,3);
for w=1:width
    for h=1:height
        tot_count = 0;
        c = [0,0,0];
        for i=1:10
            tot_count = tot_count+countMat(w,h,i);
            c = c+countMat(w,h,i)*label_color(i,:);
            %IHATE(w*width+h*height+i,:)=label_color(i);
        end
        c = c/(tot_count*255);
        COLORMAT(w,h,:)=c;
    end
end
imshow(COLORMAT)
        