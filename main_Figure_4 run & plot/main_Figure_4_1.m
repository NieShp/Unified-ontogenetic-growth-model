clear
% 生长过程中的基本参数
par.alpha = 0.75;   % Metabolic power scaling
par.f = 2.67;       % Activity metabolism slope
par.B0_T = 1909;    % Normalization constant 
par.E_c = 24000;    % Combustion energy content per mass
par.E_m = 2400;     % Energy expended to synthesize per mass
par.e = 0.45;       % Predator assimilation rate
par.GGE_C = 0.75;   % GGE for Carbon
par.v_m = 800;      % energy cost for mass-specific maintenance

par.h = 0; 

% 设置为 max(1/(1 + par.ideal_N_content/par.ideal_C_content* par.GGE_C),
% par.theta_C) --》 寻找N:C比不随时间变化的点
initial_consumer_C = max(1/(1 + (1-0.84)/0.84* par.GGE_C), 0.86); 

tt = 1;
for ideal_C_content = linspace(0.75, 0.95, 101)
    ideal_C_content
    par.ideal_C_content = ideal_C_content;
    par.ideal_N_content = 1 - par.ideal_C_content;
    for food_C = linspace(0.75, 0.95, 101)
        
        % prey 的质量 
        m_prey = 4;
        % 步长
        tau = 0.5;
        % 时间
        Time = 1999;
        
        % predator maximal body mass determiend by prey
        % M = (par.E_c * par.e * m_prey /(par.f*par.B0_T))^(1/par.alpha); par.M = M;
        % par.v_m = par.B0_T * (par.E_c * par.e * m_prey /(par.f*par.B0_T))^((par.alpha-1)/par.alpha);
        
        % 能量决定的最大体重
        M_E = par.E_c * par.e * m_prey /(par.f * par.v_m);
        par.M_E = M_E;
                
        % 食物质量
        par.theta_C = food_C;
        par.theta_N = 1 - par.theta_C;
        mass(:,1)= 6 *[1; initial_consumer_C; 1-initial_consumer_C ]; % predator'mass at birth
                
        % body mass 增长
        for sim=1:Time
            [d_body,  G, C_track,N_track,E_track, limitation] = body_mass_increase(mass(:,sim), par, m_prey);
            mass(:,sim+1) = mass(:,sim)+tau*d_body;
            GG(sim)=G;
            C_Track(:,sim)=C_track;
            N_Track(:,sim)=N_track;
            E_Track(:,sim)=E_track;
            Limitation(:,sim)=limitation;
        end
        
        RE(tt,1:2) = [ideal_C_content,  food_C];
        RE(tt,3:5) = mass(:,end)';
        RE(tt,6:8) = Limitation(:,end)';
                
        % 判断NC比的变化
        NC_ratio = mass(3,:)./mass(2,:);
        if mean(NC_ratio(1:30)) - mean(NC_ratio(end-30:end)) < 1e-6
            NC_trend = 1;    % 上升
        end
        if mean(NC_ratio(1:30)) - mean(NC_ratio(end-30:end)) > 1e-6
            NC_trend = -1;   % 下降  
        end
        if abs(mean(NC_ratio(1:30)) - mean(NC_ratio(end-30:end))) < 1e-10
            NC_trend = 0;    % 不变
        end
        
        RE(tt,9:12) = [par.M_E, NC_trend, ...
            par.ideal_N_content/par.ideal_C_content*par.GGE_C - (1-initial_consumer_C)/initial_consumer_C, ...
            initial_consumer_C - max(1/(1 + par.ideal_N_content/par.ideal_C_content* par.GGE_C), par.theta_C)];
        
        tt = tt +1;        
        
    end
end


Data_Figure_4_1 = RE; save Data_Figure_4_1
