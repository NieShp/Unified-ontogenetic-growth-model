clear

load Data_Figure_4_2
for i = 1:size(RE,1)
    RR(i,1) = (1-RE(i,1))/RE(i,1);
    RR(i,2) = RE(i,2);
    RR(i,3:5) = RE(i,3:5);
    RR(i,6) = RE(i,10);
    RR(i,7) = RE(i,5)/RE(i,4) - (1-RE(i,2))/RE(i,2);
    RR(i,8) = RE(i,12);
end


subplot(232)
U = RR;
U = sortrows(U, 1, 'descend');
U = sortrows(U, 2);
NC_ratio = reshape(U(:,5)./U(:,4),[length(unique(U(:,1))) length(unique(U(:,2)))]);
NC_trend = reshape(U(:,6),[length(unique(U(:,1))) length(unique(U(:,2)))]);
NC_trend_GGE = reshape(U(:,8),[length(unique(U(:,1))) length(unique(U(:,2)))]);
NC_ratio = round(NC_ratio, 4);
imagesc(NC_ratio); %        显示 NC_ratio 作为背景数据
h = colorbar;
caxis([min(NC_ratio(:)), max(NC_ratio(:))]); % 确保颜色范围基于 NC_ratio
y_ticks = round(unique(U(:,1)),4);
y_ticks = sort(y_ticks, 'descend');
x_ticks = round(unique(U(:,2)),4);
set(gca, 'YDir', 'reverse');
set(gca, 'YTick', linspace(1, length(x_ticks), 5), 'YTickLabel', y_ticks(linspace(1, length(x_ticks), 5))); 
set(gca, 'XTick', linspace(1, length(x_ticks), 5), 'XTickLabel', x_ticks(linspace(1, length(x_ticks), 5))); 
set(gca, 'FontSize', 18);
hold on;


% contour(NC_trend, [0 0], 'k', 'LineWidth', 3);
NC_trend_GGE(NC_trend_GGE>0)=1;
NC_trend_GGE(NC_trend_GGE<0)=-1;
contour(NC_trend_GGE+1, [1 1], 'w', 'LineWidth', 3);
% [x, y] = find(NC_trend == 0); plot(y, x, '-w','LineWidth', 3);

text(60, 30, '(II)', 'Color', 'k', 'FontSize', 18, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
text(60, 80, '(I)', 'Color', 'k', 'FontSize', 18, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
  

xlabel('Maximum carbon gross growth efficiency')
ylabel({ ...
    'Ideal consumer', ...
    'nutrient-to-carbon ratio'}, ...
    'HorizontalAlignment','center')

y_lint = max(1/(1 + par.ideal_N_content/par.ideal_C_content* par.GGE_C), y_ticks); 

parameter_com = [
    (1-0.84)/0.84, 0.85;
    (1-0.84)/0.84, 0.75;    
    (1-0.84)/0.84, 0.65];
labels = {'(d)','(e)','(f)'};

for i = 1:size(parameter_com, 1)
    [~, x_idx] = min(abs(x_ticks - parameter_com(i,2)));
    [~, y_idx] = min(abs(y_ticks - parameter_com(i,1)));
    y_pos = find(y_ticks == y_ticks(y_idx));
    x_pos = find(x_ticks == x_ticks(x_idx));
    
    % 画实心黑点
    plot(x_pos, y_pos, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); hold on;
    
    % 添加文字标签，稍微偏移一点点防止遮挡
    text(x_pos - 6, y_pos - 6, labels{i}, 'FontSize', 16, 'Color', 'k');
end
text(-0.3, 1.02, 'B', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')


subplot(235)
Time = 199;
parameter_com = [
    0.84, 0.85;
    0.84, 0.75;    
    0.84, 0.65];
for i = 1:size(parameter_com, 1)
    clear mass
    tt = 1;  
    
    par.GGE_C = parameter_com(i,2);
    
    par.ideal_C_content = parameter_com(i,1); 
    par.ideal_N_content = 1 - par.ideal_C_content;  
    mass(:,1)= 6 * [1; initial_consumer_C;  1 - initial_consumer_C]; % predator'mass at birth
    
    for sim = 1:Time
        [d_body, G, c_track, n_track, e_track, limitation] = body_mass_increase(mass(:,sim), par, m_prey);
        mass(:,sim+1) = mass(:,sim) + tau * d_body;
    end

    % 根据 i 选择颜色
    color_list = {'r','k','b'};
    plot(1:Time+1, mass(3,:)./mass(2,:), color_list{i}, 'LineWidth', 2); hold on;
    set(gca,...
    'FontName','Arial',...
    'FontSize',18,...
    'LineWidth',1.5,...
    'TickDir','in',...
    'Box','on');

end

ylabel('Consumer nutrient-to-carbon ratio');
xlabel('Time');
legend({'(d)','(e)','(f)'});
text(-0.25, 1.02, 'E', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold');
set(gca, 'FontSize', 18);
% set(gcf, 'Position', [100, 100, 1600, 600]);
% ylim([0.045 0.12]);
xlim([0, Time+1]);


% exportgraphics(gcf, 'Result_3 -- 食物NC比与消费者NC比的关系.png', 'Resolution', 600);