%% 
clc
clear all
close all

% load("OE12_240219_Stim_movie.mat") % 16 and 19
% load("OE12_240219_trial_history.mat")

% load("OE15_240316_Stim_movie.mat") % 12 and 16
% load("OE15_240316_trial_history.mat")

load("OE24_240921_Stim_movie.mat") % 13 and 21
load("OE24_240921_trial_history.mat")

% load("OE35_250213_Stim_movie.mat") % 08 and 13
% load("OE35_250213_trial_history.mat")

% load("OE39_250209_Stim_movie.mat") % 09 and 13
% load("OE39_250209_trial_history.mat")

% load("OE40_250214_Stim_movie.mat") % 10 and 14
% load("OE40_250214_trial_history.mat")

% load("OE48_250407_Stim_movie.mat") % 07 and 14
% load("OE48_250407_trial_history.mat")

% load("OE49_250407_Stim_movie.mat") % 07 and 12
% load("OE49_250407_trial_history.mat")

% load("OE50_250407_Stim_movie.mat") % 07 and 12
% load("OE50_250407_trial_history.mat")

%if reversal session set to 1
rev = 0;

ABCD_trial=1;
A_CD_trial=2;
AB_D_trial=3;
AAAA_trial=4;
DCBA_trial=5;

% num_frames = size(movie,3);
num_frames = 6000;
num_per_stim=30;
num_trials=num_frames/num_per_stim
image_time_res=0.1;

% low pass filter movie
hsize=[7, 7];
sigma = 3;
t=fspecial('gaussian',hsize,sigma);
movieLP=zeros(size(movie));

for i=1:num_frames
    movieLP(:,:,i)=imfilter(movie(:,:,i),t);
end

prestim_F=zeros(size(movieLP(:,:,num_trials),1),size(movieLP(:,:,num_trials),2),num_trials);

for i=1:num_trials
    start=num_per_stim*(i-1)+1; %%% TO UNDO DIFF, CHANGE 2 to 1
    range=start:start+9; %%% TO UNDO DIFF, CHANGE 8 to 9
    prestim_F(:,:,i)=mean(movieLP(:,:,range),3); %%% TO UNDO DIFF, CHANGE HERE
end
    
prestim_dFF=zeros(size(movieLP(:,:,num_trials),1),size(movieLP(:,:,num_trials),2),num_trials.*num_per_stim);
index_trials=ceil((1:num_trials*num_per_stim)./num_per_stim);

for i=1:size(prestim_dFF,3)
    prestim_dFF(:,:,i)=(movieLP(:,:,i)-prestim_F(:,:,index_trials(i)))./prestim_F(:,:,index_trials(i)); %%% TO UNDO DIFF, CHANGE HERE
end

%% Define trial types

All_trials = 1:num_trials;
rows=size(movie,1);
columns=size(movie,2);

All_movie=zeros(rows,columns,num_per_stim*length(All_trials));
All_indiv_movie=zeros(rows,columns,num_per_stim,length(All_trials));

for i=1:length(All_trials)
    for j=1:num_per_stim        
        All_movie(:,:,num_per_stim*(i-1)+j)=prestim_dFF(:,:,num_per_stim*(All_trials(i)-1)+j);
    end
    All_indiv_movie(:,:,:,i)=prestim_dFF(:,:,num_per_stim*(All_trials(i)-1)+1:num_per_stim*(All_trials(i)-1)+num_per_stim);
end

% implay(R_movie,5)

All_avg_movie=zeros(rows,columns,num_per_stim);
for i=1:num_per_stim
    frames=(0:length(All_trials)-1)*num_per_stim+i;
    All_avg_movie(:,:,i)=mean(All_movie(:,:,frames),3);
end

% ABCD trials only

ABCD_trials=find(trial_history(1,1:200)==1);
ABCD_avg_movie=zeros(rows,columns, num_per_stim); %This is the issue(?)
for i=1:num_per_stim
    temp_frames=(0:length(All_trials)-1)*num_per_stim+i;
    frames=temp_frames(ABCD_trials);
    ABCD_avg_movie(:,:,i)=mean(All_movie(:,:,frames),3);
end

figure
for i=1:num_per_stim
    subplot(6,5,i)%change 5 to 4
    imagesc(ABCD_avg_movie(:,:,i))
    colormap('jet')
    colorbar
    % caxis([-0.05 0.05])
    caxis([-0.01 0.02])
    title(['frame', num2str(i)])
end

% % AAAA_trials only
% 
% %AAAA_trials=find(event_history(1,:)==4);
% AAAA_trials=find(trial_history(1,:)==4);
% AAAA_avg_movie=zeros(rows,columns, num_per_stim); %This is the issue
% for i=1:num_per_stim
%     temp_frames=(0:length(All_trials)-1)*num_per_stim+i;
%     frames=temp_frames(AAAA_trials);
%     AAAA_avg_movie(:,:,i)=mean(All_movie(:,:,frames),3);
% end
% 
% figure
% title('AAAA');
% for i=1:num_per_stim
%     subplot(6,5,i)%change 5 to 4
%     imagesc(AAAA_avg_movie(:,:,i))
%     colormap('jet')
%     colorbar
%   %  caxis([-0.05 0.05])
%     caxis([-0.01 0.02])
%     title(['frame', num2str(i)])
% end
% set(gcf,'Position',[10 10 1104 847])
% 
% % savefig([ 'Stim_movie_AAAA.fig']);
% % saveas(gcf,[ 'Stim_movie_AAAA.png']);
% 
% % DCBA_trials only
% 
% %DCBA_trials=find(event_history(1,:)==5);
% DCBA_trials=find(trial_history(1,:)==5);
% DCBA_avg_movie=zeros(rows,columns, num_per_stim); %This is the issue
% for i=1:num_per_stim
%     temp_frames=(0:length(All_trials)-1)*num_per_stim+i;
%     frames=temp_frames(DCBA_trials);
%     DCBA_avg_movie(:,:,i)=mean(All_movie(:,:,frames),3);
% end
% 
% figure
% title('DCBA');
% for i=1:num_per_stim
%     subplot(6,5,i)%change 5 to 4
%     imagesc(DCBA_avg_movie(:,:,i))
%     colormap('jet')
%     colorbar
% %    caxis([-0.05 0.05])
%      caxis([-0.01 0.02])
%     title(['frame', num2str(i)])
% end
% set(gcf,'Position',[10 10 1104 847])
% 
% % savefig([ 'Stim_movie_DCBA.fig']);
% % saveas(gcf,[ 'Stim_movie_DCBA.png']);

mask=0;

%% Encoding analyses

stim_frame=[7 12 17 22 27]
%stim_frame=[6 11 16 21 26]

figure
for i=1:length(stim_frame)
    subplot(length(stim_frame),2,(i-1)*2+1)
    imagesc(ABCD_avg_movie(:,:,stim_frame(i))-ABCD_avg_movie(:,:,stim_frame(i)-1))
    colormap('jet')
    colorbar
    % caxis([-0.05 0.05])
    caxis([-0.01 0.02])
    title(['frame', num2str(stim_frame(i))])
end
set(gcf,'Position',[10 10 1104 847])

encoding_frames=zeros(length(stim_frame),rows,columns,length(ABCD_trials));
for i=1:length(stim_frame)
    temp=(ABCD_trials-1)*num_per_stim+stim_frame(i);
    encoding_frames(i,:,:,:)=All_movie(:,:,temp)-All_movie(:,:,temp-1);
end

hist_bins=(min(min(min(min(encoding_frames)))):0.001:max(max(max(max(encoding_frames)))));

all_encoding=zeros(length(stim_frame),rows,columns);

for m=1:length(stim_frame)
    for i=1:rows
        for j=1:columns
            stim_hist=histcounts(reshape(encoding_frames(m,i,j,:),1,[]),hist_bins);
            not_stim_hist=histcounts(reshape(encoding_frames(setdiff(1:length(stim_frame),m),i,j,:),1,[]),hist_bins);
            stim_sum=4*cumsum(stim_hist(end:-1:1));
            not_stim_sum=cumsum(not_stim_hist(end:-1:1));
            AUC=trapz(not_stim_sum,stim_sum)./(not_stim_sum(end).*stim_sum(end));
            all_encoding(m,i,j)=sqrt(2).*norminv(AUC);
        end
    end
end


for i=1:length(stim_frame)
    subplot(length(stim_frame),2,i*2)
    imagesc(squeeze(all_encoding(i,:,:)))
    colormap('jet')
    colorbar
    caxis([0 2])
    title(['frame', num2str(stim_frame(i))])
end
set(gcf,'Position',[10 10 600 900])

    
%%

% Align center of mass for A–D d′ maps (indices 2–5)
aligned_encoding = zeros(4, size(all_encoding,2), size(all_encoding,3));
[~, rows, cols] = size(all_encoding);
target_center = [round(rows/2), round(cols/2)];

for stim = 1:4  % A = 2, B = 3, C = 4, D = 5
    dmap = squeeze(all_encoding(stim+1,:,:));  % +1 to map 2–5
    
    % Use only positive d' for center of mass
    mask = dmap > 0;
    
    % Get weighted COM
    [X, Y] = meshgrid(1:cols, 1:rows);
    total = sum(dmap(mask));
    if total == 0
        cx = round(cols/2);
        cy = round(rows/2);
    else
        cx = sum(X(mask) .* dmap(mask)) / total;
        cy = sum(Y(mask) .* dmap(mask)) / total;
    end
    
    % Shift to center
    shift_x = round(target_center(2) - cx);
    shift_y = round(target_center(1) - cy);
    
    aligned_map = imtranslate(dmap, [shift_x, shift_y], 'FillValues', 0);
    aligned_encoding(stim,:,:) = aligned_map;
end

% Plot original vs aligned maps (A–D)
stim_labels = {'A', 'B', 'C', 'D'};
clims = [min(all_encoding(:)), max(all_encoding(:))];

figure;
for i = 1:4
    subplot(2,4,i);
    imagesc(squeeze(all_encoding(i+1,:,:)));
    title(['Raw ' stim_labels{i}]);
    axis image; colorbar;
    caxis(clims);

    subplot(2,4,i+4);
    imagesc(squeeze(aligned_encoding(i,:,:)));
    title(['Aligned ' stim_labels{i}]);
    axis image; colorbar;
    caxis(clims);
end
