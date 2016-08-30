function conf=ConfusionMatrix(GTclasses,result_classes,Nclasses)

% creat a confusion matrix

Confmatrix=zeros(Nclasses,Nclasses);

for i=1:length(GTclasses),
    Confmatrix(GTclasses(i),result_classes(i))=Confmatrix(GTclasses(i),result_classes(i))+1;
end

conf=(Confmatrix ./ repmat(sum(Confmatrix,2),1,Nclasses))*100;
