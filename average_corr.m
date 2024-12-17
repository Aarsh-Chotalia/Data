%Average plot
clear all
Subject_id_list=3:7
ftype="corr_data.mat";
%ftype="corr__window_data.mat";
%Aesthetics
FontSize=25;
Line_width=4;


load("S"+num2str(Subject_id_list(1))+ftype)
C13_mat=zeros(length(Subject_id_list),length(C13));
C24_mat=zeros(length(Subject_id_list),length(C24));

for i=Subject_id_list(1):Subject_id_list(end)
    clear C13 C24
    load("S"+num2str(i)+ftype)
     
    
    C13_mat(i,:)=C13;
    C24_mat(i,:)=C24;
end


C13_av=zeros(length(Subject_id_list),1);
C24_av=zeros(length(Subject_id_list),1);
E13=zeros(length(Subject_id_list),1);
E24=zeros(length(Subject_id_list),1);
for j=1:length(C13)
%     C13_av(j)=mean(C13_mat(:,j));
%     C24_av(j)=mean(C24_mat(:,j));
    C13_av(j)=median(C13_mat(:,j));
    C24_av(j)=median(C24_mat(:,j));
    E13(j)=std(C13_mat(:,j));
    E24(j)=std(C24_mat(:,j));
end



x=t_range/1000;
y=C13_av;
err=E13;
y_upper = y + err;
y_lower = y - err;

% Create Filled area
%fill([x fliplr(x)], [y_upper' fliplr(y_lower')], [0.9 0.9 1], 'LineStyle', 'none','FaceAlpha',0.8);
% 
plot(x, y, 'b-', 'LineWidth', Line_width); % 'k-' specifies a black line

hold on

x=t_range/1000;
y=C24_av;
err=E24;
y_upper = y + err;
y_lower = y - err;

% Create Filled area
%fill([x fliplr(x)], [y_upper' fliplr(y_lower')], [1 0.7 0.7], 'LineStyle', 'none','FaceAlpha',0.6);
% 
plot(x, y, 'r-', 'LineWidth', Line_width); % 'k-' specifies a black line


legend(["Phase (1,3): Stimulus OFF" "Phase (2,4): Stimulus ON" ])
ylabel("Average Correlation")
xlabel("Time (s)")
xlim([0 300])
set(gca,'FontSize',FontSize)
saveas(gcf,"ave_corr_window",'png')


