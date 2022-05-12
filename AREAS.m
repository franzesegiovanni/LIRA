function [center, angle, smallest_eigenval,  largest_eigenval, area] = AREAS(pos,pos_EE,contact)
num_mp  =size(pos,2);
num_iter=size(pos,1);
num_frames=size(pos,3);
num_dim=size(pos,4);
for i=1:num_mp
    for j=1:num_frames
        center(i, j, :)=mean(reshape(-pos(:,i,j,:),[num_iter num_dim])+reshape(pos_EE(:,i,:), [num_iter 2]),1); % todo : This need to be changed
        covariance=cov(reshape(-pos(:,i,j,:),[num_iter num_dim])+reshape(pos_EE(:,i,:), [num_iter 2]));
        if size(covariance,1)==1
            area(i,j)=0.01;
            angle(i,j)=0;
            smallest_eigenval(i,j)=0.1;
            largest_eigenval(i,j)=0.1;
        elseif  size(covariance,1)==2
            [~, eigenval] = eig(covariance);
            largest_eigenval(i,j) = max(max(eigenval));
            smallest_eigenval(i,j)=largest_eigenval(i,j);
            area(i,j)=sqrt(largest_eigenval(i,j))*sqrt(smallest_eigenval(i,j));
            angle(i,j)=0;
        else size(covariance,1)>2;
            [eigenvec, eigenval] = eig(covariance);
            [largest_eigenvec_ind_c, ~] = find(eigenval == max(max(eigenval)));
            largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);
            
            % Get the largest eigenvalue
            largest_eigenval(i,j) = max(max(eigenval));
            
            % Get the smallest eigenvector and eigenvalue
            if(largest_eigenvec_ind_c == 1)
                smallest_eigenval(i,j) = max(eigenval(:,2));
                smallest_eigenvec = eigenvec(:,2);
            else
                smallest_eigenval(i,j) = max(eigenval(:,1));
                smallest_eigenvec = eigenvec(1,:);
            end
            
            % Calculate the angle between the x-axis and the largest eigenvector
            angle(i,j) = atan2(largest_eigenvec(2), largest_eigenvec(1));
            
            area(i,j)=sqrt(largest_eigenval(i,j))*sqrt(smallest_eigenval(i,j));
        end
        
    end
    
end
% Use of the manipulation prior for filtering 
mp_contact=find(contact);
for i=1:length(mp_contact)
    for j=1:num_frames
        NORM=norm([center(mp_contact(i),j,1)-center(mp_contact(i)+1,j,1), center(mp_contact(i),j,2)-center(mp_contact(i)+1,j,2)]);
        if NORM < 0.05
            area(mp_contact(i),j)=eps;
            area(mp_contact(i)+1,j)=10;
        end
    end   
end
end