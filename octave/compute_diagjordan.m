% =========================================================================
% Análise dos Subsistemas - Ponte Rolante
% =========================================================================
% Necessário pacote de controle para as funções de transferência
pkg load control

% 1. Parâmetros Numéricos (Tabela 1)
Mx = 148.16;   % Massa efetiva do eixo X (kg)
My = 154.05;   % Massa efetiva do eixo Y (kg)
Ml = 134.08;   % Massa efetiva de içamento (kg)
m  = 5.82;     % Massa da carga (kg)
Dx = 2475.66;  % Amortecimento X (Ns/m)
Dy = 4000.00;  % Amortecimento Y (Ns/m)
Dl = 2913.24;  % Amortecimento L (Ns/m)
g  = 9.81;     % Gravidade (m/s^2)

% Valor nominal de l para cálculo das FTs e Forma de Jordan
l0 = 0.55;     

disp('====================================================');
disp(['ANALISANDO SISTEMAS PARA l0 = ', num2str(l0), ' metros']);
disp('====================================================');

% =========================================================================
% i) SUBSISTEMA X (Ponte)
% Estados: [ \dot{x}, \dot{\theta}_x, x, \theta_x ]^T
% =========================================================================
Ax = [ -Dx/Mx,        0, 0,  (m*g)/Mx ;
        Dx/(Mx*l0),   0, 0, -(g*(Mx+m))/(Mx*l0) ;
        1,            0, 0,  0 ;
        0,            1, 0,  0 ];
        
% Bx considera apenas a entrada f_x
Bx = [ 1/Mx ; -1/(Mx*l0) ; 0 ; 0 ]; 
Cx = [ 0, 0, 1, 0 ]; % Saída é a posição x
Dx_mat = 0;

sys_x = ss(Ax, Bx, Cx, Dx_mat);
tf_x = tf(sys_x);

% Transformação de Similaridade
[Vx, Jx] = eig(Ax); 
Bx_diag = inv(Vx) * Bx;
Cx_diag = Cx * Vx;

disp('--- 1) SUBSISTEMA X (PONTE) ---');
disp('Funcao de Transferencia X(s)/Fx(s):');
tf_x
disp('Matriz de Transformacao Vx:');
disp(Vx)
disp('Novo modelo Diagonal/Jordan (Ax_diag, Bx_diag, Cx_diag):');
disp('Ax_diag = Jx ='); disp(Jx)
disp('Bx_diag ='); disp(Bx_diag)
disp('Cx_diag ='); disp(Cx_diag)

% =========================================================================
% ii) SUBSISTEMA Y (Carro)
% Estados: [ \dot{y}, \dot{\theta}_y, y, \theta_y ]^T
% =========================================================================
Ay = [ -Dy/My,        0, 0,  (m*g)/My ;
        Dy/(My*l0),   0, 0, -(g*(My+m))/(My*l0) ;
        1,            0, 0,  0 ;
        0,            1, 0,  0 ];
        
By = [ 1/My ; -1/(My*l0) ; 0 ; 0 ]; 
Cy = [ 0, 0, 1, 0 ]; % Saída é a posição y
Dy_mat = 0;

sys_y = ss(Ay, By, Cy, Dy_mat);
tf_y = tf(sys_y);

% Transformação de Similaridade
[Vy, Jy] = eig(Ay);
By_diag = inv(Vy) * By;
Cy_diag = Cy * Vy;

disp('--- 2) SUBSISTEMA Y (CARRO) ---');
disp('Funcao de Transferencia Y(s)/Fy(s):');
tf_y
disp('Matriz de Transformacao Vy:');
disp(Vy)
disp('Novo modelo Diagonal/Jordan (Ay_diag, By_diag, Cy_diag):');
disp('Ay_diag = Jy ='); disp(Jy)
disp('By_diag ='); disp(By_diag)
disp('Cy_diag ='); disp(Cy_diag)

% =========================================================================
% iii) SUBSISTEMA L (Içamento)
% Estados: [ \dot{l}, l ]^T
% =========================================================================
Al = [ -Dl/(Ml+m), 0 ;
        1,         0 ];
        
Bl = [ 1/(Ml+m) ; 0 ]; 
Cl = [ 0, 1 ]; % Saída é a posição l
Dl_mat = 0;

sys_l = ss(Al, Bl, Cl, Dl_mat);
tf_l = tf(sys_l);

% Transformação de Similaridade
[Vl, Jl] = eig(Al);
Bl_diag = inv(Vl) * Bl;
Cl_diag = Cl * Vl;

disp('--- 3) SUBSISTEMA L (IÇAMENTO) ---');
disp('Funcao de Transferencia L(s)/Fl(s):');
tf_l
disp('Matriz de Transformacao Vl:');
disp(Vl)
disp('Novo modelo Diagonal/Jordan (Al_diag, Bl_diag, Cl_diag):');
disp('Al_diag = Jl ='); disp(Jl)
disp('Bl_diag ='); disp(Bl_diag)
disp('Cl_diag ='); disp(Cl_diag)


% =========================================================================
% PARTE 2: PLOT DO LUGAR DAS RAÍZES (l variando de 0.1 a 1.0)
% =========================================================================
l_vetor = linspace(0.1, 1.0, 500); 
polos_x = zeros(4, length(l_vetor));
polos_y = zeros(4, length(l_vetor));

for i = 1:length(l_vetor)
    l_atual = l_vetor(i);
    
    % Atualiza apenas os polos de X
    A_temp_x = [ -Dx/Mx,            0, 0,  (m*g)/Mx ;
                  Dx/(Mx*l_atual),  0, 0, -(g*(Mx+m))/(Mx*l_atual) ;
                  1, 0, 0, 0 ;  0, 1, 0, 0 ];
    polos_x(:, i) = eig(A_temp_x);
    
    % Atualiza apenas os polos de Y
    A_temp_y = [ -Dy/My,            0, 0,  (m*g)/My ;
                  Dy/(My*l_atual),  0, 0, -(g*(My+m))/(My*l_atual) ;
                  1, 0, 0, 0 ;  0, 1, 0, 0 ];
    polos_y(:, i) = eig(A_temp_y);
end

% O subsistema L não depende de l! Seus polos são fixos.
% Plotando os resultados
figure;
subplot(1,2,1);
plot(real(polos_x), imag(polos_x), '.', 'MarkerSize', 8);
title('Movimento dos Polos (Subsistema X)');
xlabel('Eixo Real'); ylabel('Eixo Imaginário');
grid on;

subplot(1,2,2);
plot(real(polos_y), imag(polos_y), '.', 'MarkerSize', 8);
title('Movimento dos Polos (Subsistema Y)');
xlabel('Eixo Real'); ylabel('Eixo Imaginário');
grid on;

% =========================================================================
% EXPORTAÇÃO PARA CSV (Para plotagem no PGFPlots/LaTeX)
% =========================================================================
% Prepara a matriz de dados: 
% Coluna 1: l
% Colunas 2 a 9: Re e Im dos 4 polos do eixo X
% Colunas 10 a 17: Re e Im dos 4 polos do eixo Y
dados_csv = zeros(length(l_vetor), 1 + 8 + 8);
dados_csv(:, 1) = l_vetor(:);

for i = 1:length(l_vetor)
    p_x = polos_x(:, i);
    p_y = polos_y(:, i);
    
    % Ordena os polos pela parte imaginária para evitar que as linhas se cruzem no plot
    [~, idx_x] = sort(imag(p_x)); p_x = p_x(idx_x);
    [~, idx_y] = sort(imag(p_y)); p_y = p_y(idx_y);
    
    dados_csv(i, 2:9) = [real(p_x(1)), imag(p_x(1)), real(p_x(2)), imag(p_x(2)), real(p_x(3)), imag(p_x(3)), real(p_x(4)), imag(p_x(4))];
    dados_csv(i, 10:17) = [real(p_y(1)), imag(p_y(1)), real(p_y(2)), imag(p_y(2)), real(p_y(3)), imag(p_y(3)), real(p_y(4)), imag(p_y(4))];
end

% Grava o arquivo CSV
cabecalho = 'l,ReX1,ImX1,ReX2,ImX2,ReX3,ImX3,ReX4,ImX4,ReY1,ImY1,ReY2,ImY2,ReY3,ImY3,ReY4,ImY4\n';
fid = fopen('lugar_das_raizes.csv', 'w');
fprintf(fid, cabecalho);
dlmwrite(fid, dados_csv, '-append', 'precision', 6);
fclose(fid);
disp('Arquivo lugar_das_raizes.csv exportado com sucesso!');
