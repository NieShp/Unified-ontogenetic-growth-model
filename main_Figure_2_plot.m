clear
close all
% basal parameter
par.alpha = 0.75;   % Metabolic power scaling
par.f = 2.67;       % Activity metabolism slope
par.B0_T = 1909;    % Normalization constant
par.E_c = 24000;    % Combustion energy content per mass
par.E_m = 2400;     % Energy expended to synthesize per mass
par.e = 0.45;       % Predator assimilation rate
par.GGE_C = 0.75;   % GGE for Carbon
par.v_m = 800;      % energy cost for mass-specific maintenance
par.alpha = 0.75;   % metabolic rate

par.h = 0;
par.ideal_C_content = 0.9;
par.ideal_N_content = 1 - par.ideal_C_content;

initial_consumer_C = 0.95;
initial_consumer_N = 1 - initial_consumer_C;

% prey mass (ingested food)
m_prey = 4.5;

tau = 1;  % step for simualation
Time = 699; % simulation time

M_E = (par.E_c * par.e * m_prey /(par.f * par.v_m))^(1/par.alpha);
par.M_E = M_E;

% food quality - 1
theta_C = 0.85; par.theta_C = theta_C;par.theta_N = 1-par.theta_C;
% predator'mass at birth
mass(:,1)= 6 * [1; initial_consumer_C; initial_consumer_N]; 

% body mass increase 
for sim=1:Time
    [d_body, G, C_track, N_track, E_track, limitation] = body_mass_increase(mass(:,sim), par, m_prey);
    mass(:,sim+1) = mass(:,sim)+tau*d_body;
    GG(sim)=G;
    C_Track(:,sim)=C_track;
    N_Track(:,sim)=N_track;
    E_Track(:,sim)=E_track;
end
mass=mass';
t =1:size(mass,1);
subplot(241)
plot(t, par.M_E  + 0*mass(:,1), 'r:', 'linewidth', 2);  hold on;
plot(t, mass(:,1), 'k-', 'linewidth', 2);
ylim([0 70])
ylabel('Consumer body mass');
set(gca, 'FontName', 'Arial', 'FontSize', 18, 'LineWidth', 1.5);box on;
xlabel('Time');
text(-0.18, 1, 'A', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')
subplot(242)
plot(1:Time,C_Track(1,:)./sum(C_Track,1),'ro-','MarkerIndices', 10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'r'); hold on;
plot(1:Time,C_Track(2,:)./sum(C_Track,1),'ks-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'k'); hold on;
plot(1:Time,C_Track(3,:)./sum(C_Track,1),'b^-','MarkerIndices', 20:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'b'); hold on;
plot(1:Time,C_Track(4,:)./sum(C_Track,1),'m<-','MarkerIndices',10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'm'); hold on;
legend({'Excretion','Maintainance & activity','Biosynthesis','Releasing'},'EdgeColor', [1 1 1]);
set(gca,'FontName','Arial','FontSize',18,'LineWidth',1.5)
ylabel('Carbon allocation fraction');   xlabel('Time');
ylim([0 1])
text(-0.18, 1, 'B', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')
subplot(243)
plot(1:Time,N_Track(1,:)./sum(N_Track,1),'ro-','MarkerIndices', 10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'r'); hold on;
plot(1:Time,N_Track(2,:)./sum(N_Track,1),'ks-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'k'); hold on;
plot(1:Time,N_Track(3,:)./sum(N_Track,1),'b^-','MarkerIndices', 20:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'b'); hold on;
plot(1:Time,N_Track(4,:)./sum(N_Track,1),'m<-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'm'); hold on;
legend({'Excretion','Maintainance & activity','Biosynthesis','Releasing'},'EdgeColor', [1 1 1]);
ylim([0 1])
ylabel('Nutrient allocation fraction');  xlabel('Time');
set(gca,'FontName','Arial','FontSize',18,'LineWidth',1.5)
text(-0.18, 1, 'C', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')
subplot(244)
plot(1:Time,E_Track(1,:)./sum(E_Track,1),'ro-','MarkerIndices', 10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'r'); hold on;
plot(1:Time,(E_Track(2,:) + E_Track(3,:))./sum(E_Track,1),'ks-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'k'); hold on;
plot(1:Time,E_Track(4,:)./sum(E_Track,1),'b^-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'b'); hold on;
plot(1:Time,E_Track(5,:)./sum(E_Track,1),'m<-','MarkerIndices',20:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'm'); hold on;
plot(1:Time,E_Track(6,:)./sum(E_Track,1),'gd-','MarkerIndices', 10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'g'); hold on;
legend({'Excretion','Maintainance & activity','Biosynthesis','Releasing','Stroage'},'EdgeColor', [1 1 1]);
ylim([0 1])
ylabel('Energy allocation fraction');   xlabel('Time');
set(gca,'FontName','Arial','FontSize',18,'LineWidth',1.5)
text(-0.18, 1, 'D', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')


% food quality - 2
clear mass C_Track N_Track E_Track
theta_C = 0.97; par.theta_C = theta_C;par.theta_N = 1-par.theta_C;
mass(:,1)= 6 * [1; initial_consumer_C; initial_consumer_N]; 
for sim=1:Time
    [d_body,  G, C_track, N_track, E_track, limitation] = body_mass_increase(mass(:,sim), par, m_prey);
    mass(:,sim+1) = mass(:,sim)+tau*d_body;
    GG(sim)=G;
    C_Track(:,sim)=C_track;
    N_Track(:,sim)=N_track;
    E_Track(:,sim)=E_track;
end
mass=mass';
t =1:size(mass,1);
subplot(245)
plot(t, par.M_E  + 0*mass(:,1), 'r:', 'linewidth', 2); hold on;
plot(t, mass(:,1), 'k-', 'linewidth', 2);
ylim([0 70])
ylabel('Consumer body mass');
xlabel('Time');
set(gca, 'FontName', 'Arial', 'FontSize', 18, 'LineWidth', 1.5);box on;
text(-0.18, 1, 'E', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')
subplot(246)
plot(1:Time,C_Track(1,:)./sum(C_Track,1),'ro-','MarkerIndices', 10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'r'); hold on;
plot(1:Time,C_Track(2,:)./sum(C_Track,1),'ks-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'k'); hold on;
plot(1:Time,C_Track(3,:)./sum(C_Track,1),'b^-','MarkerIndices', 20:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'b'); hold on;
plot(1:Time,C_Track(4,:)./sum(C_Track,1),'m<-','MarkerIndices',10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'm'); hold on;
ylabel('Carbon allocation fraction');   xlabel('Time');
set(gca,'FontName','Arial','FontSize',18,'LineWidth',1.5)
ylim([0 1])
text(-0.18, 1, 'F', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')
subplot(247)
plot(1:Time,N_Track(1,:)./sum(N_Track,1),'ro-','MarkerIndices', 10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'r'); hold on;
plot(1:Time,N_Track(2,:)./sum(N_Track,1),'ks-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'k'); hold on;
plot(1:Time,N_Track(3,:)./sum(N_Track,1),'b^-','MarkerIndices', 20:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'b'); hold on;
plot(1:Time,N_Track(4,:)./sum(N_Track,1),'m<-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'm'); hold on;
ylim([0 1])
ylabel('Nutrient allocation fraction'); xlabel('Time');
set(gca,'FontName','Arial','FontSize',18,'LineWidth',1.5)
text(-0.18, 1, 'G', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')
subplot(248)
plot(1:Time,E_Track(1,:)./sum(E_Track,1),'ro-','MarkerIndices', 10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'r'); hold on;
plot(1:Time,(E_Track(2,:) + E_Track(3,:))./sum(E_Track,1),'ks-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'k'); hold on;
plot(1:Time,E_Track(4,:)./sum(E_Track,1),'b^-','MarkerIndices',30:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'b'); hold on;
plot(1:Time,E_Track(5,:)./sum(E_Track,1),'m<-','MarkerIndices',20:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'm'); hold on;
plot(1:Time,E_Track(6,:)./sum(E_Track,1),'gd-','MarkerIndices', 10:60:Time, 'linewidth',2,'MarkerSize',8, 'MarkerFaceColor', 'g'); hold on;
ylim([0 1])
ylabel('Energy allocation fraction');   xlabel('Time');
set(gca,'FontName','Arial','FontSize',18,'LineWidth',1.5)
text(-0.18, 1, 'H', 'Units', 'normalized', 'FontSize', 20, 'FontWeight', 'bold')

set(gcf, 'Position', [50, 50, 2000, 1000]); 