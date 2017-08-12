function calcObjBinCentroids()
close all
clear all
objId=5
binDim=2
base_path = '/Users/apurvnigam/study_ucl/term1/MScThesis/hinterstoisser/'
ptCloud = pcread(sprintf('%smodels/obj_05.ply',base_path));
obj = ptCloud.Location;
obj=obj*rotz(180)*rotx(180)/1000;
pc = zeros(307200,3);
colorMap = zeros(307200,3);
maxExtent= [0.100792;0.181796 ;0.193734 ];
num3DPts= size(obj,1)
colors= distinguishable_colors(power(binDim,3),[0,0,0]);
labels = generateLabels(binDim);
bin3DCents= zeros(power(binDim,3),4);

% Get the 3D boinding box
bb3D = getBB3D(maxExtent);


minX = min(bb3D(:,1));
maxX = max(bb3D(:,1));
minY = min(bb3D(:,2));
maxY = max(bb3D(:,2));
minZ = min(bb3D(:,3));
maxZ = max(bb3D(:,3));

% Find the dimension of bin along each dimension
unitX=(maxX-minX)/binDim;
unitY = (maxY-minY)/binDim;
unitZ= (maxZ-minZ)/binDim;

numPt=0

for i=1:num3DPts
    i;
    obX = obj(i,1);
    obY = obj(i,2);
    obZ = obj(i,3);
    
    numPt=numPt+1;
    
    lx=  ceil( (obX-minX)/unitX);
    if(lx==0)
        lx=1;
    end;
    ly=  ceil( (obY-minY)/unitY);
    if(ly==0)
        ly=1;
    end;
    lz=  ceil( (obZ-minZ)/unitZ);
    if(lz==0)
        lz=1;
    end;
    
    strLabel = sprintf('%d%d%d',lx,ly,lz);
    
    l = find(labels== ( str2num(strLabel) ));
    bins3d(numPt,1:4)=[obX  obY obZ l] ;
    
    
    pc(i,1) = obj(i,1);
    pc(i,2) = obj(i,2);
    pc(i,3) = obj(i,3);
    
    
    colorMap(i,1) = colors(l,1);
    colorMap(i,2) = colors(l,2);
    colorMap(i,3) = colors(l,3);
    
end

orpc = pointCloud(pc,'Color',colorMap);
pcshow(orpc)
xlabel('X');
ylabel('Y');
zlabel('Z');
view(0,0)

hold on

drawBB3D(bb3D)

binIds3D = unique(bins3d(:,4))
    for  b =1:size(binIds3D,1)
        id = binIds3D(b);
        if(id~=0)
            num = size (find(bins3d(:,4)==id),1);
            bx = sum(bins3d(find(bins3d(:,4)==id),1))/num;
            by = sum( bins3d( find(bins3d(:,4)==id),2))/num;
            bz = sum(bins3d(find(bins3d(:,4)==id),3))/num;
%             if((id ==103)|(id ==123)|(id ==81)|(id ==12))
            bin3DCents(id,:)=[bx,by,bz, id];
            disp(sprintf('%f,%f,%f,',bx,by,bz))
%             end
        end
    end
    binPC = pointCloud(bin3DCents(:,1:3),'Color',colors);
    
    
    pcshow(binPC,'MarkerSize',800,'VerticalAxis','Y', 'VerticalAxisDir','Up');

end