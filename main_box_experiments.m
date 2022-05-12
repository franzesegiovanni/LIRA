clc
close all
clear all
set(0,'units','pixels');
v=get(0,'ScreenSize');
a=v(3)-500;
b=v(4)-500;
%% SCENARIO 1
load('data/pos_dim.mat');
load('data/color_box.mat');
%% KINESTETIC TEACHING
disp('SCENARIO 1')
load('data/pos_EE_xy_1.mat');
load('data/contact.mat');
load('data/Valid_Candidates.mat');
%% LIRA on SCENARIO 1
pos_dim=reshape(pos, [7, 6, 2]);
f=figure;
f.Position=[a b 400 400];
title('SCENARIO 1')
POS=reshape(pos_dim(1,:,:),[6 2]);
plotting(POS, [0,0] ,color)
[GOAL] = LIRA(pos_dim, pos, pos_EE_xy, contact, GOAL);
%% SCENARIO 2
disp('BOX REARRANGEMENT...')
disp('SCENARIO 2')
load('data/pos_test_1')
f=figure;
f.Position=[a 0 400 400];
POS=reshape(pos_test(1,:,:),[6 2]);
title('SCENARIO 2')
plotting(POS, [0,0] ,color)
[GOAL] = LIRA(pos_test, pos, pos_EE_xy, contact, GOAL);
%% SCENARIO 3
disp('BOX REARRANGEMENT...')
disp('SCENARIO 3')
load('data/pos_test_2')
f=figure;
f.Position=[0 b 400 400];
title('SCENARIO 3')
POS=reshape(pos_test(1,:,:),[6 2]);
plotting(POS, [0,0] ,color)
[GOAL] = LIRA(pos_test, pos, pos_EE_xy, contact, GOAL);
%% SCENARIO 4
disp('BOX REARRANGEMENT...')
disp('SCENARIO 4')
load('data/pos_test_3')
f=figure;
f.Position=[0 0 400 400];
title('SCENARIO 4')
POS=reshape(pos_test(1,:,:),[6 2]);
plotting(POS, [0,0] ,color)
[GOAL]=LIRA(pos_test, pos, pos_EE_xy, contact, GOAL)