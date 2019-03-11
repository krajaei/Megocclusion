
%% Demo MEG Decoding Analysis
%
% This demo will generate the decoding curves of Figure 1 in Rajaei et
% al.,2018/2019: https://www.biorxiv.org/content/10.1101/302034v2 
%
%  Beyond Core Object Recognition: Recurrent processes account for object recognition under occlusion
% Authors: Karim Rajaei, Yalda Mohsenzadeh, Reza Ebrahimpour,  Seyed-Mahdi Khaligh-Razavi
%  
% Demo written by K Rajaei 
% last updated: 9 March 2019
%%
clc
clear
addpath(genpath('Functions'));
addpath(genpath('libsvm-3.23'));%
occlusion_levels={'0% occluded', '60% occluded','80% occluded'};
categories={'camel', 'deer','car','motor'};
Time=[-200:1000];

CatVsCat= [1,2; 1,3; 1,4;2,3;2,4;3,4];% ctegory#1 Vs. category#2
numsubjects=15;% number of human subjects

mask='no mask';%mask or no mask

LowPass = 20;% Lowpass filtering 

%% Decoding 
for sub=1:numsubjects
    fprintf('Loading MEG data for subject #%d ...\n',sub);
    load(['MEG Data\subject' num2str(sub) '.mat'])
    for i=1:length(occlusion_levels)
        for j=1:length(CatVsCat)
            trials=[];
            fprintf( 'Doing pairwise decoding for %s vs. %s (this may take several minutes)... ', categories{CatVsCat(j,1)}, categories{CatVsCat(j,2)});
            % select samples from category#1 vs category#2
            for t=1:length(Data)
                if strcmp(Data(t).Mask_Or_Nomask,mask)
                    if strcmp(Data(t).Occlusion,occlusion_levels(i))
                        if strcmp(Data(t).Category,categories{CatVsCat(j,1)})
                            trials{1}=squeeze(mat2cell(Data(t).MEG_Signals,306,1201,ones(1,size(Data(t).MEG_Signals,3))));
%                             trials{1}=squeeze(mat2cell(Data(t).MEG_Signals,60,1201,ones(1,size(Data(t).MEG_Signals,3))));
                        elseif strcmp(Data(t).Category,categories{CatVsCat(j,2)})
                            trials{2}=squeeze(mat2cell(Data(t).MEG_Signals,306,1201,ones(1,size(Data(t).MEG_Signals,3))));
%                             trials{2}=squeeze(mat2cell(Data(t).MEG_Signals,60,1201,ones(1,size(Data(t).MEG_Signals,3))));
                        end
                    end
                end
            end
            
            % lowpass filter
            trials = filter_signals(trials,LowPass);
            
            % pairwise classification 
            [Accuracy] = pairwise_decoding(trials, Time);
            save(strcat('Results\subject' , num2str(sub) , '_' , categories{CatVsCat(j,1)} , 'Vs' , categories{CatVsCat(j,2)} , '_occlusion' , num2str(i) , '_' , mask , '.mat') ,'Accuracy');
%             save(strcat('Results\subject' , num2str(sub) , '_' , categories{CatVsCat(j,1)} , 'Vs' , categories{CatVsCat(j,2)} , '_occlusion' , num2str(i) , '_' , mask , '.mat') ,'Accuracy');
            fprintf('accuracy matrix saved to "Results" folder\n');

        end
    end
end
fprintf( 'Finished decoding for all subjects\n');


%% Plot decoding  

% load decoding accuracies 
fprintf( 'Plot the decoding accuracies\n');
occlusion_accuracy=[];
for l=1:length(occlusion_levels)
for sub=1:numsubjects
    pairs_accuracy=[];
%     ind=ind+1;
    d=dir(['Results' filesep 'subject' num2str(sub) '*occlusion' num2str(l) '*no mask.mat']);
    for i=1:length(d)
        load([ 'Results' filesep d(i).name])
        pairs_accuracy(i,:)=mean(Accuracy);
    end
    occlusion_accuracy(l,sub,:)=mean(pairs_accuracy);
end
end 


% plot decoding curves
colors=[64,64,64;
201,0,32;
240,160,124]/256;
lineweight = 5;

figure;
p1=plot(Time(100:901), smooth(mean(occlusion_accuracy(1,:,100:901))),'Color',colors(1,:),'linewidth',lineweight);
hold on
p2=plot(Time(100:901), smooth(mean(occlusion_accuracy(2,:,100:901))),'Color',colors(2,:),'linewidth',lineweight);
p3=plot(Time(100:901), smooth(mean(occlusion_accuracy(3,:,100:901))),'Color',colors(3,:),'linewidth',lineweight);

xlim([-100,700])
ylim([ 45 70])
%  set(gca,'XTickLabelRotation' ,45)
 
legend([p1 p2 p3],'0% occlusion','60% occlusion','80% occlusion','FontSize',20,'FontWeight','bold');

xlabel('Time (ms)')
ylabel('Decoding accuracy (%)')
set(gca, 'FontSize',20,'FontWeight','bold')
box off

set(gcf,'Position',[0  0   1100   700])

saveas(gcf,['decoding_occlusion' ],'png')
