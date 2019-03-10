function data = filter_signals(trials,LowPass)
%%
% Low-pass filtering
if (LowPass ~= 0)
    % Design low pass filter
    order = max(100,round(size(trials{1}{1},2)/10)); %keep one 10th of the timepoints as model order
    Fs    = 1.0000e+03;%1./msec
    h     = filter_design('lowpass', LowPass, order, Fs, 0);
end


for f = 1:length(trials{1})
    
    if LowPass ~= 0 % do low-pass filtering
        data{1}{f} = filter_apply(double(trials{1}{f}),h); %smooth over time
    else % do not do the filtering
        data{1}{f} = trials{1}{f};
    end
end

for f = 1:length(trials{2})
    
    if LowPass ~= 0 % do low-pass filtering
        data{2}{f} = filter_apply(double(trials{2}{f}),h); %smooth over time
    else % do not do the filtering
        data{2}{f} = trials{2}{f};
    end
end