function [Accuracy,Time] = pairwise_decoding(trial, Time)
%% Pairwise Decoding
%apply SVM classifier on MEG trials of a pair of object categories
% Adopted From Brainstorm Toolbox (for more information see:
% https://neuroimage.usc.edu/brainstorm/Tutorials/Decoding)

% Initialize
ntimes = size(trial{1}{1},2);
ntrials = min([length(trial{1}) length(trial{2}) ]);

%correct for baseline std
tndx = Time<0;
for i = 1:2%for both groups
    for j = 1:ntrials
        trial{i}{j} = trial{i}{j} ./ repmat( std(trial{i}{j}(:,tndx)')',1,ntimes );
    end
end


% == perform decoding ==
%create the train/test set
[nchannels, timeLen] = size(trial{1}{1});

trial_bin_size =8;
num_permutations = 100;
% Get labels for train and test groups
nsamples = floor(ntrials/trial_bin_size);
samples = reshape([1:nsamples*trial_bin_size],trial_bin_size,nsamples)';
train_label = [ones(1,nsamples-1) 2*ones(1,nsamples-1)];
test_label = [1 2];

Accuracy = zeros(num_permutations,ntimes);

for p = 1:num_permutations
    
    
    % Randomize samples
    perm_ndx = randperm(nsamples*trial_bin_size);
    perm_samples = perm_ndx(samples);
    
    % Create samples
    train_trialsA = average_trials_1(trial{1}(perm_samples(1:nsamples-1,:)));
    train_trialsB = average_trials_1(trial{2}(perm_samples(1:nsamples-1,:)));
    train_trials = [train_trialsA;train_trialsB];
    
    test_trialsA = average_trials_2(trial{1}(perm_samples(end,:)));
    test_trialsB = average_trials_2(trial{2}(perm_samples(end,:)));
    test_trials = reshape([test_trialsA test_trialsB],[nchannels,ntimes,2]);
    test_trials = permute(test_trials,[3 1 2]);
    
    for tndx = 1:ntimes
        %lib-SVM
        model = svmtrain(train_label',train_trials(:,:,tndx),'-s 0 -t 0 -q');
        [predicted_label, accuracy, decision_values] = svmpredict(test_label', test_trials(:,:,tndx), model,'-q');
        Accuracy(p,tndx) = ones(1,1)*accuracy(1);
    end
    % Return accuracy
end

end