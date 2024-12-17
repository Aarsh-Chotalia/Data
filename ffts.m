% Indirect Synchronization of Brainwaves
% We start with the FFT of a time signal with two dominant sinusoids. From that, we scale it to the power spectral density. 
% Individual Analysis
clear all
Subject_id=3
Set=1:4;
Fs=1000
Num_Set=length(Set);
transient=0
time_range=((transient+1/Fs)*Fs:300*Fs);
plot_range=(100)*Fs:102*Fs;
%Aesthetics
FontSize=15;
Line_width=2;

figure
for i=Subject_id
    k=1;
    for j=Set
        Filename="S"+num2str(i)+"S"+num2str(j)+".mat";
        load(Filename)
        
        xn=(Oz(time_range)+O1(time_range)+O2(time_range))/3;
        %xn=bandpass(xn,[5 25],Fs);
        %xn=smooth(xn);
        subplot(Num_Set,4,4*(k-1)+1)
        plot(t(plot_range)/1000,Oz(plot_range),LineWidth=Line_width,Color=line_colour(k))
        ylabel('<O> Voltage (\mu V)');
        ylim([-100 100]);
        if k==1
            title("S"+num2str(i)+" Raw data")
        end
        
        set(gca,'FontSize',FontSize,'Color','k')
        if k==length(Set)
            xlabel('Time (s)');
        end

        subplot(Num_Set,4,4*(k-1)+2)

        N = length(xn); % Number of samples
        xk = (1/(Fs*N))*abs(fft(xn)).^2; % Two-sided power
        xk = xk(1:N/2+1); % One-sided
        xk(2:end-1) = 2*xk(2:end-1); % Double values except for DC and Nyquist
        freq = 0:Fs/N:Fs-1/Fs;        
        plot(freq(freq<40),xk(freq<40), 'LineWidth', Line_width,Color=line_colour(k))
        grid on
        xlabel("Frequency (Hz)")
        ylabel("PSD (\muV)^2/Hz")

      
        if k==length(Set)
            xlabel('Frequency (Hz)');        
        end
        if k==1
            title("PSD")
        end
        
        set(gca,'FontSize',FontSize)

        subplot(Num_Set,4,4*(k-1)+3)
        [auto,lags]=autocorr(xn,NumLags=min(length(xn)-1,1000));
        plot(lags/1000,auto,LineWidth=Line_width,Color=line_colour(k))
        if k==1
            title("Autocorrelation")
        end
        
        
        if k==length(Set)
            xlabel('Lag (s)');        
        end
        set(gca,'FontSize',FontSize)
        
        subplot(Num_Set,4,4*(k-1)+4)
        [s,f,t] = stft(xn,Fs,Window=kaiser(3000,5),OverlapLength=220,FFTLength=4000,FrequencyRange="onesided");
        sdb = (abs(s));
        h=heatmap(t,f(abs(f)<30),(sdb(abs(f)<30,:)));
        XLabels = 1:length(t);
        CustomXLabels = (string(round((t(2)-t(1))*XLabels)));
        CustomXLabels(mod(XLabels,6) ~= 0) = " ";        
        h.XDisplayLabels = CustomXLabels;
        YLabels = 1:length(f(abs(f)<30));
        CustomYLabels = (string(floor((f(2)-f(1))*YLabels)));
        CustomYLabels(mod(YLabels,16) ~= 0) = " ";
        h.YDisplayLabels = CustomYLabels;
        grid off
        colormap(hot)
        colorbar
        if k==1
            title(" STFT")    
        end
        
        if k==length(Set)
            xlabel('Time (s)');        
        end
        ylabel('f (Hz)');
        set(gca,'FontSize',FontSize)

        k=k+1
    end
end
set(gca,'FontSize',FontSize)
set(get(groot, 'Children'), 'WindowState', 'maximized');
saveas(gcf,"S"+num2str(i),'png')

function lc = line_colour(k)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
if mod(k,2)==1
    lc=[0 1 1];
else
    lc="#FF6600";

end
end
