% plot Figure 3 in main text

clear;
close all;
clc;

% Load data
load Data_Figure_3
subplot(121)
% Calculate parameters
RE(:,9) = (par.E_c * par.e * RE(:,1) /(par.f * par.v_m)).^(1/par.alpha);

RR = zeros(size(RE,1),4);

for i = 1:size(RE,1)

    RR(i,1) = RE(i,1);

    RR(i,2) = (1-RE(i,2))/RE(i,2);

    v = find(RE(i,6:8)==1);

    if length(v)==1
        RR(i,3) = v;
    else
        RR(i,3) = 3;
    end

    % body mass
    RR(i,4) = RE(i,3);
    RR(i,5) = RE(i,3)/RE(i,9);

end

% Extract variables
m_prey          = RR(:,1);
theta_C         = RR(:,2);
limiting_factor = RR(:,3);
body_mass       = RR(:,4);

% Unique parameter values
m_vals     = unique(m_prey);
theta_vals = unique(theta_C);

n_m     = length(m_vals);
n_theta = length(theta_vals);

% Reconstruct matrices
[Theta_grid,M_grid] = meshgrid(theta_vals,m_vals);

Body_grid      = nan(n_m,n_theta);
Limiting_grid  = nan(n_m,n_theta);

for i=1:size(RR,1)

    r = find(m_vals==m_prey(i));
    c = find(theta_vals==theta_C(i));

    Body_grid(r,c)     = body_mass(i);
    Limiting_grid(r,c) = limiting_factor(i);

end


Body_plot = Body_grid;

Body_plot(Limiting_grid==2) = NaN;

pcolor(Theta_grid,M_grid,Body_plot)


shading flat

hold on

% Colormap
colormap(parula)

% Colorbar
cb = colorbar;
cb.Label.FontName = 'Arial';
cb.Label.FontSize = 18;
% clim([10 30])

set(gca,'Color','w')

%% Add contour lines of body mass
% contour_levels = 10:3:30;
% 
% [C_body, h_body] = contour(Theta_grid, ...
%                            M_grid, ...
%                            Body_plot, ...
%                            contour_levels, ...
%                            'Color',[0.60 0.60 0.60], ...
%                            'LineWidth',0.6);
% 
% clabel(C_body, h_body, ...
%        'FontName','Arial', ...
%        'FontSize',12, ...
%        'Color','k', ...
%        'LabelSpacing',400);

% two point
plot(0.15/0.85, 4.5, 'ro', ...
    'MarkerFaceColor','r', ...
    'MarkerEdgeColor','r', ...
    'MarkerSize',8);

plot(0.03/0.97, 4.5, 'ko', ...
    'MarkerFaceColor','k', ...
    'MarkerEdgeColor','k', ...
    'MarkerSize',8);



text(0.0104, 3.05, ...
    '(I)', ...
    'FontName','Arial','FontWeight','bold', ...
    'FontSize',16, ...
    'Color','k', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','bottom');
text(0.04, 4, ...
    '(II)', ...
    'FontName','Arial','FontWeight','bold', ...
    'FontSize',16, ...
    'Color','k', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','bottom');
text(0.11, 4, ...
    '(III)', ...
    'FontName','Arial','FontWeight','bold', ...
    'FontSize',16, ...
    'Color','k', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','bottom');


% 1-2 boundary
contour(Theta_grid,...
        M_grid,...
        Limiting_grid,...
        [2 2],...
        'w',...
        'LineWidth',1.8);

% contour(Theta_grid,...
%         M_grid,...
%         Limiting_grid,...
%         [1 2],...
%         'b',...
%         'LineWidth',1.8);


% Labels

xlabel('Food nutrient-to-carbon ratio'); ylabel('Food ingestion rate')
set(gca,'Layer','top')
set(gca,...
    'FontName','Arial',...
    'FontSize',18,...
    'LineWidth',1.5,...
    'TickDir','in',...
    'Box','on');

text(-0.18,1.05,'A','Units','normalized', ...
    'FontName','Arial','FontSize',20,'FontWeight','bold', ...
    'HorizontalAlignment','left','VerticalAlignment','top');
% axis tight
xlim([0.01 0.30])
set(gca,'XScale','log')
xticks([0.01 0.02 0.05 0.15 0.3])
xticklabels({'0.01','0.02','0.05','0.15','0.30'})







%% Load data
clear
subplot(122)
load Data_Figure_3

%% Calculate parameters
RE(:,9) = (par.E_c * par.e * RE(:,1) /(par.f * par.v_m)).^(1/par.alpha);

RR = zeros(size(RE,1),4);

for i = 1:size(RE,1)

    RR(i,1) = RE(i,1);
    RR(i,2) = (1 - RE(i,2)) / RE(i,2);

    v = find(RE(i,6:8) == 1);

    if length(v) == 1
        RR(i,3) = v;
    else
        RR(i,3) = 3;
    end

    % Relative body mass
    RR(i,4) = RE(i,3) / RE(i,9);

end

%% Manually correct limiting factor
RR(RR(:,2)<0.02 & RR(:,4)<0.999, 3) = 2;
RR(RR(:,4)>0.9999999, 3) = 3;
%% Extract variables
m_prey          = RR(:,1);
theta_C         = RR(:,2);
limiting_factor = RR(:,3);
body_mass       = RR(:,4);

%% Unique parameter values
m_vals     = unique(m_prey);
theta_vals = unique(theta_C);

n_m     = length(m_vals);
n_theta = length(theta_vals);

%% Reconstruct matrices
[Theta_grid, M_grid] = meshgrid(theta_vals, m_vals);

Body_grid     = nan(n_m, n_theta);
Limiting_grid = nan(n_m, n_theta);

for i = 1:size(RR,1)

    r = find(m_vals == m_prey(i));
    c = find(theta_vals == theta_C(i));

    Body_grid(r,c)     = body_mass(i);
    Limiting_grid(r,c) = limiting_factor(i);

end

%% Mask invalid region
Body_plot = Body_grid;
Body_plot(Limiting_grid == 2) = NaN;


pcolor(Theta_grid, M_grid, Body_plot);
shading flat;
hold on;

colormap(parula);
set(gca,'Color','w');

%% Fix color scale for relative body mass
clim([0.75 1.0]);

%% Colorbar
cb = colorbar;
% cb.Label.String = 'Relative body mass';
cb.Label.FontName = 'Arial';
cb.Label.FontSize = 18;


%% Add boundary line
contour(Theta_grid, ...
        M_grid, ...
        Limiting_grid, ...
        [2 2], ...
        'w', ...
        'LineWidth',1.8);

% Very important: reset color scale after contour of Limiting_grid
% clim([0.8 1.0]);


% % Add contour lines of relative body mass
% contour_levels = 0.81:0.03:0.99;
% 
% [C_body, h_body] = contour(Theta_grid, ...
%                            M_grid, ...
%                            Body_plot, ...
%                            contour_levels, ...
%                            'Color',[0.60 0.60 0.60], ...
%                            'LineWidth',0.6);
% clabel(C_body, h_body, ...
%        'FontName','Arial', ...
%        'FontSize',12, ...
%        'Color','k', ...
%        'LabelSpacing',400);

%% Add two points
plot(0.15/0.85, 4.5, 'ro', ...
    'MarkerFaceColor','r', ...
    'MarkerEdgeColor','r', ...
    'MarkerSize',8);

plot(0.03/0.97, 4.5, 'ko', ...
    'MarkerFaceColor','k', ...
    'MarkerEdgeColor','k', ...
    'MarkerSize',8);

%% Add region labels
text(0.0104, 3.05, ...
    '(I)', ...
    'FontName','Arial', ...
    'FontWeight','bold', ...
    'FontSize',16, ...
    'Color','k', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','bottom');

text(0.03, 4, ...
    '(II)', ...
    'FontName','Arial', ...
    'FontWeight','bold', ...
    'FontSize',16, ...
    'Color','k', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','bottom');

text(0.11, 4, ...
    '(III)', ...
    'FontName','Arial', ...
    'FontWeight','bold', ...
    'FontSize',16, ...
    'Color','k', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','bottom');

%% Axis labels and style
xlabel('Food nutrient-to-carbon ratio');
ylabel('Food ingestion rate');

set(gca, ...
    'FontName','Arial', ...
    'FontSize',18, ...
    'LineWidth',1.5, ...
    'TickDir','in', ...
    'Box','on', ...
    'Layer','top');

xlim([0.01 0.30]);
ylim([3 6]);

set(gca,'XScale','log');

xticks([0.01 0.02 0.05 0.15 0.30]);
xticklabels({'0.01','0.02','0.05','0.15','0.30'});

text(-0.18,1.05,'B','Units','normalized', ...
    'FontName','Arial','FontSize',20,'FontWeight','bold', ...
    'HorizontalAlignment','left','VerticalAlignment','top');

set(gcf, 'Position', [50, 50, 1400, 500]); 

