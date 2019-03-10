   
%% ===== filter_design =====
% function h_filter = filter_design(filter_type,param,order, Fs,show_plot)
%
% Easy interface to design a highpass or lowpass filter using firls
% The function firls Designs a linear-phase FIR filter that minimizes the weighted,
% integrated squared error between an ideal piecewise linear function and the magnitude
% response of the filter over a set of desired frequency bands.
%
% INPUTS:
%
%   filter_type: string containing the values 'highpass' or 'lowpass' or 'bandpass' or 'notch'
%
%   param: parameters of the filter
%       if 'highpass', params is a scalar denoting the cutoff frequency
%       if 'lowpass', params is a scalar denoting the cutoff frequency
%       if 'notch', params is a 2x1 vector [fnotch delta], and the notch filter cancels all frequencies between fnotch-delta and fnotch+delta
%       if 'bandpass', params is a 2x1 vector [fmin fmax], denoting the band pass
%       if 'bandstop', params is a 2x1 vector [fmin fmax], denoting the band stop
%
%   order: (default 50) order of the FIR filter. The higher the value, the more precise the filter response
%
%   Fs: sampling frequency of the signal to be filtered
%
%   show_plot: (0 or 1, optional) plots the filter response and some test signals
%
% OUTPUT:
%   Filter coefficients
%
% EXAMPLES:
%
%   order = 50;
%   Fs = 200; %sampling frequency at 200Hz
%   h = filter_design('lowpass',20,order,Fs,1); %low pass filter at 20Hz
%   h = filter_design('highpass',30,order,Fs,1); %high pass filter at 30Hz
%   h = filter_design('bandpass',[20 30],order,Fs,1); %band pass filter at 20-30Hz
%   h = filter_design('bandstop',[20 30],order,Fs,1); %band stop filter at 20-30Hz
%   h = filter_design('notch',[60 1.5],200,Fs,1); %notch filter at 60Hz (with pass at 58.5-61.5 Hz)
%
% Adopted from Brainstorm Toolbox
function h_filter = filter_design(filter_type,param,order,Fs,show_plot)
    % Test inputs
    if nargin == 0 %if no input
        help filter_design %display help
        return
    end
    if ~exist('show_plot', 'var')
        show_plot = 1;
    end
    if ~exist('order', 'var')
        order = 50;
    end

    switch filter_type
        case 'highpass'
            fhigh = param(1);
            fc = fhigh * 2/Fs;   %1 for Nyquist frequency (half the sampling rate)
            h_filter = firls(order, [0 fc fc 1], [0 0 1 1]).*kaiser(order+1,5)';

        case 'lowpass'
            flow = param(1);
            fc = flow * 2/Fs;   %1 for Nyquist frequency (half the sampling rate)
            h_filter = firls(order, [0 fc fc 1], [1 1 0 0]).*kaiser(order+1,5)';

        case 'notch'
            fnotch = param(1);
            delta = param(2);
            fc = fnotch * 2/Fs;   %1 for Nyquist frequency (half the sampling rate)
            d = delta * 2/Fs;
            h_filter = firls(order, [0 fc-d fc-d fc+d fc+d 1], [1 1 0 0 1 1]).*kaiser(order+1,5)';

        case 'bandpass'
            flow = param(1);
            fhigh = param(2);
            fc1 = flow * 2/Fs;
            fc2 = fhigh * 2/Fs;
            h_filter = firls(order, [0 fc1 fc1 fc2 fc2 1], [0 0 1 1 0 0]).*kaiser(order+1,5)';

        case 'bandstop'
            flow = param(1);
            fhigh = param(2);
            fc1 = flow * 2/Fs;
            fc2 = fhigh * 2/Fs;
            h_filter = firls(order, [0 fc1 fc1 fc2 fc2 1], [1 1 0 0 1 1]).*kaiser(order+1,5)';
    end

    % Create test sinusoids
    fcutoff = param(1);
    t_end = max((30*1/fcutoff)*Fs,order*3);   %data must have length more that 3 times filter order
    t = 0:1/Fs:t_end/Fs;
    xcut = sin(2*pi*fcutoff*t);
    x1 = sin(2*pi*(fcutoff*90/100)*t);
    x2 = sin(2*pi*(fcutoff*110/100)*t);
    xcutf = filtfilt(h_filter,1,xcut);
    x1f = filtfilt(h_filter,1,x1);
    x2f = filtfilt(h_filter,1,x2);

    % Display and test filter
    if show_plot
        [h,f] = freqz(h_filter,1,linspace(0,Fs/2,1000),Fs);
        figure;
        subplot(321);
        plot(f,abs(h));
        grid on
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        title('Filter Response','fontsize',12)
        subplot(323)
        plot(f,20*log10(abs(h)));
        grid on
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        subplot(325);
        plot(f,(180/pi*unwrap(angle(h))))
        grid on
        xlabel('Frequency (Hz)');
        ylabel('Phase (degrees)');
        subplot(322);
        plot(t,x1f);
        xlabel('Time (sec)');
        ylabel(['Sinusoid at ' num2str(fcutoff*90/100) ' Hz' ]);
        title('Filtered Sinusoids of Amplitude 1','fontsize',12)
        subplot(324);
        plot(t,xcutf);
        xlabel('Time (sec)');
        ylabel(['Sinusoid at ' num2str(fcutoff) ' Hz' ]);
        subplot(326);
        plot(t,x2f);
        xlabel('Time (sec)');
        ylabel(['Sinusoid at ' num2str(fcutoff*110/100) ' Hz' ]);
    end
end