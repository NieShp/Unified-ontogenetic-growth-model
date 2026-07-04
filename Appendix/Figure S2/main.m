% 探究能量与养分先限制类型
clear
close all
% 生长过程中的基本参数
par.alpha = 0.75;   % Metabolic power scaling
par.f = 2.67;       % Activity metabolism slope
par.E_c = 24000;    % Combustion energy content per mass
par.E_m = 2400;     % Energy expended to synthesize per mass
par.e = 0.45;       % Predator assimilation rate
par.GGE_C = 0.75;   % GGE for Carbon
par.v_m = 800;      % energy cost for mass-specific maintenance

par.h = 0; 
par.ideal_C_content = 0.86;
par.ideal_N_content = 1 - par.ideal_C_content; 

initial_consumer_C = 0.95;
initial_consumer_N = 1 - initial_consumer_C;

tt = 1;
for food_mass = linspace(3, 6, 101)
    food_mass
    for food_NC_ratio = linspace(0.05, 0.1, 101)   
        
        food_C = 1/(1+   food_NC_ratio) ;    
        % prey 的质量和化学计量属性
        m_prey = food_mass;
        % 步长
        tau = 0.5;
        % 时间
        Time = 4999;
        
        % predator maximal body mass determiend by prey
        % M = (par.E_c * par.e * m_prey /(par.f*par.B0_T))^(1/par.alpha); par.M = M;
        % par.v_m = par.B0_T * (par.E_c * par.e * m_prey /(par.f*par.B0_T))^((par.alpha-1)/par.alpha);
        
        % 能量决定的最大体重
        M_E = par.E_c * par.e * m_prey /(par.f * par.v_m);
        par.M_E = M_E;
        
        % 食物质量
        theta_C = food_C;
        par.theta_C = theta_C;
        par.theta_N = 1 - par.theta_C;
        
        % 捕食者出生时候的体重和养分含量
        % predator'mass at birth
        mass(:,1)= 6 * [1;initial_consumer_C;initial_consumer_N]; 
        
        % body mass 增长
        for sim=1:Time
            [d_body, G, C_track, N_track, E_track, limitation] = body_mass_increase(mass(:,sim), par, m_prey);
            mass(:,sim+1) = mass(:,sim)+tau*d_body;
            GG(sim)=G;
            C_Track(:,sim)=C_track;
            N_Track(:,sim)=N_track;
            E_Track(:,sim)=E_track;
            Limitation(:,sim)=limitation;
        end
        
        RE(tt,1:2) = [m_prey, par.theta_C];
        RE(tt,3:5) = mass(:,end)';
        RE(tt,6:8) = Limitation(:,end)';
        tt = tt +1;
        
    end
end
RE_main2_86 = RE; save RE_main2_86

