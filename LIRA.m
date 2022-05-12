function [GOAL] = LIRA(pos_test, pos, pos_EE_xy, contact, GOAL)
num_frames=size(pos_test,2);
num_mp=length(contact);
color(1,:)=[0, 1, 1];
color(2,:)=[0, 1, 0];
color(3,:)=[0, 0, 1];
color(4,:)=[1, 0, 1];
color(5,:)=[1, 0, 0];
color(6,:)=[1, 1, 0];
man_frame=[];
[center, ~, ~, ~, area] = AREAS(pos, pos_EE_xy, contact);
for mp=1:num_mp-1 %For each movement primitive
    POS=reshape(pos_test(mp,:,:),[num_frames 2]); %Read the position of the frames in the current scenario
    %% Calculate the variance area of the goal distribution respect to each frame and apply the prior filter
    AREA=area(mp+1,GOAL{mp});
    %% Rank the valid candidates in ascending order of inter-demonstration variance 
    [area_sort,I] = sort(AREA);
    [~,~,ic]=unique(area_sort(:));
    %% Select the candidates with the lowest variance
    Goal_pot_pos=GOAL{mp}(I(ic==1));
    disp(['MP: ' num2str(mp) '. Valid candidate frames are ', num2str(Goal_pot_pos)])
    GOAL{mp}=Goal_pot_pos;
    %% Create Groups of goals
    [sort_dim_group,Group] = Groups(Goal_pot_pos, mp, center, pos_test);
    %% For each group in descending order
    for i=1:length(Group) 
        p=sort_dim_group(i);
        X0=center(mp+1,Group{p}(1),1)+pos_test(mp,Group{p}(1),1);
        Y0=center(mp+1,Group{p}(1),2)+pos_test(mp,Group{p}(1),2);
        %% If there is only one group left, it is not necessary to ask for feedback
        if i==length(Group)
            GOAL{mp}=Group{p};
            disp(['MP: ' num2str(mp) '. Only one group in the list. LIRA saves goal(s) coherent with frame(s) ' num2str(GOAL{mp})])
            if contact(mp)==0 && contact(mp+1)==1
                [~,man_frame]=min((POS(:,1)-X0).^2+(POS(:,2)-Y0).^2); %Pick a frame (simulated version)
            elseif contact(mp)==1 && contact(mp+1)==0
                pos_test(:,man_frame,1)=X0*ones(1,num_mp);
                pos_test(:,man_frame,2)=Y0*ones(1,num_mp);
                man_frame=[]; %Place a frame (simulated version)
            end
            break
        end
        %% If there is more than one group
        POS_=POS;
        if ~isempty(man_frame)
            POS_(man_frame,:)=[X0,Y0];
        end
        f=figure(10);
        set(0,'units','pixels');
        v=get(0,'ScreenSize');
        a=floor(v(3)/2)-250;
        b=floor(v(4)/2)-500;
        f.Position=[a b 500 500];
        %% Move to the group's goal
        plotting(POS_, [X0,Y0], color) 
        disp(['Ambiguity Detected in MP ' num2str(mp) '. Goal coherent with ' num2str(Group{p}) '. Please Give Feedback.'])
        title(['MP' num2str(mp)])
        %% ASK for feedback
        answer = questdlg('Is this goal Correct?', ...
            'Yes', ...
            'No');
        switch answer
            %% Correct
            case 'Yes'
                disp(['Positive Feedback. Valid Frame Candidates for MP: ' num2str(mp) ' are now ' num2str(Group{p})])
                GOAL{mp}=Group{p};
                if contact(mp)==0 && contact(mp+1)==1
                    [~,man_frame]=min((POS(:,1)-X0).^2+(POS(:,2)-Y0).^2);
                elseif contact(mp)==1 && contact(mp+1)==0
                    pos_test(:,man_frame,1)=X0*ones(1,num_mp);
                    pos_test(:,man_frame,2)=Y0*ones(1,num_mp);
                    man_frame=[];
                end
                close(10)
                break
            %% Wrong
            case 'No'
                disp(['Negative Feedback. Eliminated Candidates ' num2str(Group{p}) ' for MP: ' num2str(mp)])
                disp(['Next group coherent with ' num2str(Group{sort_dim_group(i+1)})])
                close(10)
        end
    end
end
end