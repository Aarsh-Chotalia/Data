clear all
Subject_id=3;
Set=1:4;
Fs=1000;
Num_Set=length(Set);

time_range=((1/Fs)*Fs:300*Fs);
transient=0; %in s
max_delay=0.2; %in s

%Aesthetics
FontSize=15;
Line_width=4;

load("S"+num2str(Subject_id)+"S"+num2str(1)+".mat");
load("S"+num2str(Subject_id)+"S"+num2str(1)+".mat");
x1=(Oz+O1+O2)/3;
load("S"+num2str(Subject_id)+"S"+num2str(2)+".mat");
x2=(Oz+O1+O2)/3;
load("S"+num2str(Subject_id)+"S"+num2str(3)+".mat");
x3=(Oz+O1+O2)/3;
load("S"+num2str(Subject_id)+"S"+num2str(4)+".mat");
x4=(Oz+O1+O2)/3;

C13=[];
C13_idx=[];
C13modidx=[];

C24=[];
C24_idx=[];
C24modidx=[];
t_range=(transient+1/Fs+max_delay)*Fs+1:5000:time_range(end);
for t=t_range
    t/1000
    [mx,idx]=maxcor(x1((transient+1/Fs)*Fs+1:t),x3((transient+1/Fs)*Fs+1:t),max_delay*Fs);
    C13=[C13,mx];
    C13_idx=[C13_idx,idx];
%     modidx=mod(idx/1000,0.1);
% % 
% %     if modidx>0.05
% %         modidx=modidx-0.1;
% %     end
%     modidx_cos=cos(2*pi*modidx/0.1);
%     modidx_sin=sin(2*pi*modidx/0.1);
% %     if modidx>0.05
% %         modidx=modidx-0.1;
% %     end
%     C13modidx=[C13modidx,modidx];
%     
%     C13modidx_sin=[C13modidx_sin,modidx];
    [mx,idx]=maxcor(x2((transient+1/Fs)*Fs+1:t),x4((transient+1/Fs)*Fs+1:t),max_delay*Fs);
    C24=[C24,mx];
    C24_idx=[C24_idx,idx];
%     modidx=mod(idx/1000,0.1);
%     modidx_cos=cos(2*pi*modidx/0.1);
%     modidx_sin=sin(2*pi*modidx/0.1);
% %     if modidx>0.05
% %         modidx=modidx-0.1;
% %     end
%     C24modidx=[C24modidx,modidx];
%     C24modidx_cos=[C24modidx_cos,modidx];
%     C24modidx_sin=[C24modidx_sin,modidx];
    
end

C13modidx_cos=cos(2*pi*(C13_idx/1000)/0.1);
C13modidx_sin=sin(2*pi*(C13_idx/1000)/0.1);
C24modidx_cos=cos(2*pi*(C24_idx/1000)/0.1);
C24modidx_sin=sin(2*pi*(C24_idx/1000)/0.1);

R13=abs(mean(C13modidx_cos+1j*C13modidx_sin));
R24=abs(mean(C24modidx_cos+1j*C24modidx_sin));

subplot(1,3,1)
plot((1/Fs)*(t_range),C13,LineWidth=Line_width)
hold on
plot((1/Fs)*(t_range),C24,LineWidth=Line_width)
%title("S"+num2str(Subject_id))

legend(["Phase (1,3): Stimulus OFF" "Phase (2,4): Stimulus ON"])

xlabel("Time (s)")
ylabel("Correlation C*")
set(gca,'FontSize',FontSize,'Color','k')

subplot(1,3,2)
plot((1/Fs)*(t_range),C13_idx,LineWidth=Line_width)
hold on
plot((1/Fs)*(t_range),C24_idx,LineWidth=Line_width)
%legend(["Phase (1,3): Stimulus OFF" "Phase (2,4): Stimulus ON"])
xlabel("Time (s)")
ylabel("\tau_{max} (ms)")
ylim([-200 200])
set(gca,'FontSize',FontSize,'Color','k')

subplot(1,3,3)
% plot((1/Fs)*(t_range),C13modidx*1000,LineWidth=Line_width)
% hold on
% plot((1/Fs)*(t_range),C24modidx*1000,LineWidth=Line_width)
% legend(["Std Dev="+num2str(std(diff(C13modidx)),'%.4f') "Std Dev="+num2str(std(diff(C24modidx)),'%.4f')])
% xlabel("Time (s)")
% ylabel("Correlation lag maxima (mod* 100) (ms) ")
% ylim([-200 200])
plot((1/Fs)*(t_range),C13modidx_cos,LineWidth=Line_width)
hold on
plot((1/Fs)*(t_range),C24modidx_cos,LineWidth=Line_width)
legend(["R13="+num2str(R13) "R24="+num2str(R24)],Location='southeast')
xlabel("Time (s)")
ylabel("cos(\theta_{max})")
ylim([-1 1])
set(gca,'FontSize',FontSize,'Color','k')
%set(get(groot, 'Children'), 'WindowState', 'maximized');
set(gcf,'position',[10,10,1500,500])

saveas(gcf,"S"+num2str(Subject_id)+"_corr",'png')
fname="S"+ num2str(Subject_id)+"corr_data"
save(fname)
function [mx,mxidx] = maxcor(x,y,n)
    C=[];
    di=5;
    irange=1:di:n;
    for i=irange
        c=corrcoef(x(i:end),y(1:end-i+1));
        C=[C,c(2,1)];
        c=corrcoef(y(i:end),x(1:end-i+1));
        C=[C,c(2,1)];

    end

    [mx,mxidx]=max(C);
    if mod(mxidx,2)==1
        mxidx=irange((mxidx+1)/2);
    else
        mxidx=-irange((mxidx)/2);
    end
 
end

