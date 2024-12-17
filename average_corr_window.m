%Average plot
clear all
Subject_id_list=3:7


load("S"+num2str(Subject_id_list(1))+"corr__window_data.mat")
C13_av=C13;
C24_av=C24;

for i=Subject_id_list(2):Subject_id_list(end)
clear C13 C24
load("S"+num2str(i)+"corr__window_data.mat")
C13_av=C13_av+C13;
C24_av=C13_av+C24;
end

C13_av=C13_av/length(Subject_id_list);
C24_av=C24_av/length(Subject_id_list);

plot(t_range,C13_av);
hold on
plot(t_range,C24_av);



