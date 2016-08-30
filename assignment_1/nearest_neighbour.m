function [ Labelans  ] = nearest_neighbour ( value , class ,nearest,index )
k=size(value);
val=value;
for i=1 : k(1);
    for j=1 : k(1);
        val(i,j)=class(value(i,j));
    end
end
mod = repmat(0, [nearest nearest]);
for i=1 : k(1);
    for j=index : (nearest+index-1);
        if (index == 2);
            mod(i,j-1)=val(i,j-1) ;
        elseif (index == 1);
            mod(i,j)=val(i,j) ;
        end
    end
end
Labelans = [] ;
temp = [];
for i=1 : k(1);
    temp = [];
    for j=1 : nearest;
        temp(j) =  mod(i,j) ;
    end
    Labelans(i,1)=mode(temp);
end
end