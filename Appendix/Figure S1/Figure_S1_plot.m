clear
clf
par.alpha = 0.75;   % Metabolic power scaling
par.f = 2.67;       % Activity metabolism slope
par.B0_T = 1909;    % Normalization constant
par.E_c = 24000;    % Combustion energy content per mass
par.E_m = 2400;     % Energy expended to synthesize per mass
par.e = 0.45;       % Predator assimilation rate
par.GGE_C = 0.75;   % GGE for Carbon
par.v_m = 800;      % energy cost for mass-specific maintenance

theta_C_list = [0.98 0.986 0.9865 0.99];
for yy = 1:4
    clear mass
    par.h = 0;
    par.ideal_C_content = 0.9;
    par.ideal_N_content = 1 - par.ideal_C_content;

    initial_consumer_C = 0.95;
    initial_consumer_N = 1 - initial_consumer_C;

    % prey
    m_prey = 4.5;

    tau = 0.5;

    if yy == 1
        Time = 399;
    elseif yy == 2
        Time = 1999;
    elseif yy == 3
        Time = 5999;
    elseif yy == 4
        Time = 199;
    end




    M_E = par.E_c * par.e * m_prey /(par.f * par.v_m);
    par.M_E = M_E;


    theta_C = theta_C_list(yy);
    par.theta_C = theta_C;par.theta_N = 1-par.theta_C;

    mass(:,1)= 6 * [1; initial_consumer_C; initial_consumer_N]; % predator'mass at birth
    % body mass
    for sim=1:Time
        [d_body, G, C_track, N_track, E_track, limitation] = body_mass_increase(mass(:,sim), par, m_prey);
        mass(:,sim+1) = mass(:,sim)+tau*d_body;

    end
    mass=mass';
    t =1:size(mass,1);
    subplot(2,4,yy)
    if yy <=3; plot(t, par.M_E  + 0*mass(:,1), 'r-', 'linewidth', 2);  hold on; end
    plot(t, mass(:,1), 'k-', 'linewidth', 2);hold on;
    % ylim([0 25])
    ylabel('Consumer body mass');
    set(gca, 'FontName', 'Arial', 'FontSize', 14, 'LineWidth', 1.5);box on;
    xlabel('Time');

    subplot(2,4,yy+4)
    plot(t,mass(:,3)./mass(:,2),'b-', 'linewidth',2); hold on;
    set(gca,'FontName','Arial','FontSize',14,'LineWidth',1.5)
    ylabel('Consumer N:C ratio');   xlabel('Time');
    ylim([0.01 0.06])

    hold on

end

set(gcf, 'Position', [50, 50, 1400, 600]);
exportgraphics(gcf, 'Figure_S1.png', 'Resolution', 600);