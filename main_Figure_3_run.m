% data for Figure 3 in main text
% Effect of food ingestion rate and nutrient-to-carbon ratio on consumer body mass at the cessation of growth.

clear
close all
par.alpha = 0.75;   % Metabolic power scaling
par.f = 2.67;       % Activity metabolism slope
par.E_c = 24000;    % Combustion energy content per mass
par.E_m = 2400;     % Energy expended to synthesize per mass
par.e = 0.45;       % Predator assimilation rate
par.GGE_C = 0.75;   % GGE for Carbon
par.v_m = 800;      % energy cost for mass-specific maintenance

par.h = 0; 
par.ideal_C_content = 0.9;
par.ideal_N_content = 1 - par.ideal_C_content; 

initial_consumer_C = 0.95;
initial_consumer_N = 1 - initial_consumer_C;

tt = 1;
for food_mass = linspace(3, 6, 91)
    for food_NC_ratio = logspace(log10(0.01), log10(0.3), 301)
        food_C = 1 / (1+food_NC_ratio);
      
        m_prey = food_mass;
        tau = 0.5;
        Time = 9999;
        if food_NC_ratio < 0.025
            Time = 199999;
        end


        M_E = par.E_c * par.e * m_prey /(par.f * par.v_m);
        par.M_E = M_E;

        theta_C = food_C;
        par.theta_C = theta_C;
        par.theta_N = 1 - par.theta_C;
        
        mass(:,1)= 6 * [1;initial_consumer_C;initial_consumer_N]; 
        
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

        clear C_Track N_Track E_Track Limitation GG mass
        
    end
end
Data_Figure_3 = RE; save Data_Figure_3

