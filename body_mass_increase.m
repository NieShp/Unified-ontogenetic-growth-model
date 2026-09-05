function [d_body, G, C_track, N_track, E_track, limitation] = body_mass_increase(Mm, par, m_prey)


f = par.f;
v_m = par.v_m;
E_c = par.E_c;
E_m = par.E_m;
e = par.e;
GGE_C = par.GGE_C;
h = par.h; 

delta_C_pie = par.ideal_C_content;
delta_N_pie = par.ideal_N_content;


m = Mm(1);delta_C = Mm(2)/Mm(1);delta_N = Mm(3)/Mm(1);


B_maint = v_m * m;  


A = E_c * m_prey * e;
B_rema = A - f*B_maint; 

if B_rema < 0
    pii = (f*B_maint - A) / E_c;
else
    pii = 0;
end


H_C = max(0, m_prey * par.theta_C * e - f*B_maint/E_c*delta_C );
H_N = max(0, m_prey * par.theta_N * e - f*B_maint/E_c*delta_N );


if H_C == 0
    lambda_C = f*B_maint/E_c*delta_C - m_prey * par.theta_C * e;
else
    lambda_C = 0;
end
if H_N == 0
    lambda_N = f*B_maint/E_c*delta_N - m_prey * par.theta_N * e;
else
    lambda_N = 0;
end


beta = max(max(lambda_C/delta_C, lambda_N/delta_N), pii);


B = max(B_rema, 0);



H_C_1 = H_C;
H_N_1 = min(H_N, (delta_N_pie/delta_C_pie) * H_C*(delta_N)^h*GGE_C/(delta_C)^h);


G = max(1,  (delta_N_pie/delta_C_pie) * GGE_C*(delta_N)^h/(delta_C)^h/(H_N/H_C));
E_m_new = E_m * G;


if H_C_1>0
    eta_C = min(B/(f*E_m_new + E_c)*H_C_1/(H_C_1+H_N_1), H_C_1);
    eta_N = min(B/(f*E_m_new + E_c)*H_N_1/(H_C_1+H_N_1), H_N_1);
else
    eta_C=0; eta_N=0;
end

dm_C = eta_C - beta * delta_C;
dm_N = eta_N - beta * delta_N;
dm = dm_C + dm_N;
d_body = [dm; dm_C; dm_N];


E_paixie = E_c * m_prey * (1-e);
C_paixie = m_prey * (1-e)*par.theta_C;
N_paixie = m_prey * (1-e)*par.theta_N;


C_weichi = f*B_maint/E_c*delta_C;
N_weichi = f*B_maint/E_c*delta_N;
E_weichi_yundong = min(f*B_maint, A);
E_weichi = 1/f * E_weichi_yundong;
E_yundong1 = (f-1)/f * E_weichi_yundong;


E_hecheng_yundong = (eta_C+eta_N)*(f*E_m_new);
if isinf(E_m_new)
    E_hecheng_yundong = 0;
end
E_hecheng = 1/f * E_hecheng_yundong;
E_yundong3 = (f-1)/f * E_hecheng_yundong;
E_yundong = E_yundong1 + E_yundong3;
E_chucun = (eta_C+eta_N)*E_c;
E_shifang = B - E_hecheng_yundong-E_chucun;


C_hecheng = eta_C ;
N_hecheng = eta_N ;


C_shifang = m_prey * par.theta_C - C_paixie - C_weichi - C_hecheng;
N_shifang = H_N - N_hecheng;

C_track = [C_paixie, C_weichi, C_hecheng, C_shifang];
N_track = [N_paixie, N_weichi, N_hecheng, N_shifang];
E_track = [E_paixie, E_weichi, E_yundong, E_hecheng, E_shifang, E_chucun];



energy_limite = 0;
nutrient_limitC = 0;
nutrient_limitN = 0;

if abs(Mm(1) - par.M_E) < 1e-12
    energy_limite = 1;
end

if energy_limite==0 && H_C<1e-12 && H_N>0 
    nutrient_limitC = 1;
elseif energy_limite==0 && H_C>0 && H_N<1e-12 
    nutrient_limitN = 1;
end

limitation =[nutrient_limitC, nutrient_limitN, energy_limite];

