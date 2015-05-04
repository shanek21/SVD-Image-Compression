function SVD( filename )
pic = readImage([filename '.jpg']);

dim=size(pic);
[U, S, V] = svd(pic);
rankOnes=zeros(dim(1),dim(2),min(dim));
depth=10;

for layer=1:depth
    rankOneSingle=(S(layer,layer)*U(:,layer)*V(:,layer).');
    rankOnes(:,:,layer) = (rankOneSingle);
end

figure(1)
showRankOnes(rankOnes,depth)

end

function res=readImage(filename)
    pic=im2double(rgb2gray(imread(filename)));
    res=1.-pic;
end

function writeImage(matrix,filename)
    matrix=1.-matrix;
    imwrite(matrix,filename)
end

function showImage(matrix)
    pic=1.-matrix;
    imshow(pic)
end

function showRankOnes(rankOnes,depth)
    for layer=1:depth
        subplot(2,depth,layer)
        showImage(rankOnes(:,:,layer))
        subplot(2,depth,layer+depth)
        showImage(elementSum(rankOnes(:,:,1:layer)))
    end
end

function saveRankOnes(rankOnes,depth,filename)
    for layer=1:depth
        writeImage(rankOnes(:,:,layer),[filename num2str(layer) '.jpeg'])
    end
end

function res=elementSum(matrixes)
    dim=size(matrixes);
    if length(dim)<=2
        res=matrixes;
        return
    end
    total=zeros(dim(1:2));
    for layer=1:dim(3)
        total=total+matrixes(:,:,layer);
    end
    res=total;
end

function res=clamp(matrix)
    indices=find(matrix<0); %find the elements of X, which are negative
    matrix(indices)=0;
    res=matrix;

end

function res=remove(matrix1,matrix2)
    indices=find(matrix2<0);
    matrix2(indices)=0;
    res=matrix1+matrix2;
end