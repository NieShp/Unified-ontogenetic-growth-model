close all
clear 
figure('Color','w'); 
hold on;

load RE_main2_86
for i = 1:size(RE,1)
    RR(i,1) = RE(i,1);
    RR(i,2) = (1-RE(i,2))/RE(i,2);
    % RR(i,2) = RE(i,2);
    v = find(RE(i,6:8)==1);
    if length(v) ==  1
        RR(i,3) = find(RE(i,6:8)==1);
    else
        RR(i,3) = NaN;
        RR(i,3) = 3;
    end
    RR(i,4)=RE(i,3);          % 停止生长时候  body mass 
end
U = RR;
U = sortrows(U, 1, 'descend');
U = sortrows(U, 2);
limtaion_factor = reshape(U(:,3),[length(unique(U(:,1))) length(unique(U(:,2)))]);

[M, N] = size(limtaion_factor);
x = 1:N;
y = 1:M;

contour(x, y, limtaion_factor, [1 1], 'r', 'LineWidth', 2);  % 分界线 1
contour(x, y, limtaion_factor, [3 3], 'r', 'LineWidth', 2);  % 分界线 3



clear 
load RE_main2_875
RE(:,9) = par.E_c * par.e * RE(:,1) /(par.f * par.v_m);
for i = 1:size(RE,1)
    RR(i,1) = RE(i,1);
    RR(i,2) = (1-RE(i,2))/RE(i,2);
    % RR(i,2) = RE(i,2);
    v = find(RE(i,6:8)==1);
    if length(v) ==  1
        RR(i,3) = find(RE(i,6:8)==1);
    else
        RR(i,3) = NaN;
        RR(i,3) = 3;
    end
    RR(i,4)=RE(i,3);          %  body mass 
end
U = RR;
U = sortrows(U, 1, 'descend');
U = sortrows(U, 2);
limtaion_factor = reshape(U(:,3),[length(unique(U(:,1))) length(unique(U(:,2)))]);
[M, N] = size(limtaion_factor);
x = 1:N;
y = 1:M;
contour(x, y, limtaion_factor, [1 1], 'k', 'LineWidth', 2);  % 分界线 1
contour(x, y, limtaion_factor, [3 3], 'k', 'LineWidth', 2);  % 分界线 3


clear 
load RE_main2_90
for i = 1:size(RE,1)
    RR(i,1) = RE(i,1);
    RR(i,2) = (1-RE(i,2))/RE(i,2);
    % RR(i,2) = RE(i,2);
    v = find(RE(i,6:8)==1);
    if length(v) ==  1
        RR(i,3) = find(RE(i,6:8)==1);
    else
        RR(i,3) = NaN;
        RR(i,3) = 3;
    end
    RR(i,4)=RE(i,3);          % body mass 
end
U = RR;
U = sortrows(U, 1, 'descend');
U = sortrows(U, 2);
limtaion_factor = reshape(U(:,3),[length(unique(U(:,1))) length(unique(U(:,2)))]);
[M, N] = size(limtaion_factor);
x = 1:N;
y = 1:M;
contour(x, y, limtaion_factor, [1 1], 'b', 'LineWidth', 2); 
contour(x, y, limtaion_factor, [3 3], 'b', 'LineWidth', 2);  


set(gca, 'YDir','reverse');
xlabel('Food nutrient-to-carbon ratio'); ylabel('Food ingestion rate')
y_ticks = unique(U(:,1));
y_ticks = sort(y_ticks, 'descend');
x_ticks = unique(U(:,2));
set(gca, 'YTick', linspace(1, length(x_ticks), 5), 'YTickLabel', y_ticks(linspace(1, length(x_ticks), 5)));
set(gca, 'XTick', linspace(1, length(x_ticks), 5), 'XTickLabel', round(x_ticks(linspace(1, length(x_ticks), 5)),4));
set(gca, 'FontSize', 18);
box on
