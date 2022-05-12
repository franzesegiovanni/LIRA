function [sort_dim_group,Group] = Groups(Goal_pot_pos, mp, center, pos_test)
for i=1:length(Goal_pot_pos)
    X(i)=center(mp+1,Goal_pot_pos(i),1)+pos_test(mp,Goal_pot_pos(i),1); %Projection of goals in X
    Y(i)=center(mp+1,Goal_pot_pos(i),2)+pos_test(mp,Goal_pot_pos(i),2); %PRojection of goals in Y
end
MAT=((X-X').^2+(Y-Y').^2)<0.01; % matrix of overlapping
counter=Goal_pot_pos;
j=1;
for i=1:length(Goal_pot_pos)
    if counter(i)~=0
        Group{j}=Goal_pot_pos(MAT(i,:)==1);
        counter(MAT(i,:)==1)=0 ;
        dim_group(j)=sum(MAT(i,:)==1);
        Goal_Group(j,1)=center(mp+1,Group{j}(1),1)+pos_test(mp,Group{j}(1),1);
        Goal_Group(j,2)=center(mp+1,Group{j}(1),2)+pos_test(mp,Group{j}(1),2);
        j=j+1;
    end
end
[~,sort_dim_group]=sort(dim_group,'descend'); % Sort the group in descent order of dimension
end

