clear all
Subject_id=7;
Set=1:4;
Fs=1000;
Num_Set=length(Set);

time_range=((1/Fs)*Fs:300*Fs);
transient=25*1000;
max_delay=200;

%Aesthetics
FontSize=25;
Line_width=4;

load("S"+num2str(Subject_id)+"S1.mat");
Oz1=(O1+O2+Oz)/3;
load("S"+num2str(Subject_id)+"S2.mat");
Oz2=(O1+O2+Oz)/3;
load("S"+num2str(Subject_id)+"S3.mat");
Oz3=(O1+O2+Oz)/3;
load("S"+num2str(Subject_id)+"S4.mat");
Oz4=(O1+O2+Oz)/3;


save S7DataAvg

function mx = maxcor(x,y,n)
    C=[];
    for i=1:5:n
        c=corrcoef(x(i:end),y(1:end-i+1));
        C=[C,c(2,1)];
        c=corrcoef(y(i:end),x(1:end-i+1));
        C=[C,c(2,1)];

    end

    mx=max(C);
    
end

