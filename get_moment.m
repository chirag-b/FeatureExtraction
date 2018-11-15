%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Chirag Balakrishna
%%% CCID : cbalakri@ualberta.ca
%%% Student ID : 1559633
%%% 
%%% Assignment Objective : To extract invariant features from an image using 'state-of-the-art'
%%%             feature detectors and descriptors, namely, SIFT, SURF and
%%%             KAZE and compare and evaluate them.
%%%
%%%
%%% Reference : Computer Vision 2000, Linda Shapiro and George Stockman.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = get_moment(f, I)

[row1, col1] = size(I);

[r_f,c_f] = size(f);

[X, Y] = meshgrid(1:col1, 1:row1);

for col_f=1:c_f
    point_count = 1;
    points=[;;];
    %co-variance matrix
%     cov_mat = [];
    [row, col] = find((Y-f(2, col_f)).^2 + (X-f(1, col_f)).^2 <= f(3, col_f).^2);

    A = length(row);
    
    r_dash = 0;
    for l=1:A
        r_dash =  r_dash + row(l,1);
    end
    r_dash = r_dash * (1/A);
    
   
    c_dash = 0;
    for m=1:A
        c_dash =  c_dash + col(m,1);
    end
    c_dash = c_dash * (1/A);

    mu_rr = 0;
    mu_cc = 0;
    mu_rc = 0;
    
    for i=1:A
        mu_rr = mu_rr + (row(i,1)-r_dash).^2;
    end
    mu_rr = mu_rr * (1/A);
  
    for j=1:A
        mu_cc = mu_cc + (col(j,1)-c_dash).^2;
    end   
    mu_cc = mu_cc * (1/A);
    
    for k=1:A
        mu_rc = mu_rc + ((row(k,1)-r_dash)*(col(k,1)-c_dash));
    end
    mu_rc = mu_rc * (1/A);
    
    % covariance matrix
%     cov_mat = (1/4)*(1/(mu_rr*mu_cc)-(mu_rc).^2).*[mu_cc -mu_rc;-mu_rc mu_rr];
    cov_mat = (1/(4*((mu_rr*mu_cc)-(mu_rc).^2)))*([mu_cc -mu_rc;-mu_rc mu_rr]);
    %now we amend the region vectors to include 5 components in total.
    f(3,col_f) = cov_mat(1,1);
    f(4,col_f) = cov_mat(1,2);
    f(5,col_f) = cov_mat(2,2);
    
    M = f;
    
end
   

end