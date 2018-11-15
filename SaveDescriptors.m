%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Chirag Balakrishna
%%% CCID : cbalakri@ualberta.ca
%%% Student ID : 1559633
%%%
%%% Note : This function has been provided by the instructor Mehdi Faraji.
%%%
%%% Assignment Objective : To extract invariant features from an image using 'state-of-the-art'
%%%             feature detectors and descriptors, namely, SIFT, SURF and
%%%             KAZE and compare and evaluate them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function SaveDescriptors(file,desc,dim)
fid = fopen(file, 'w');
nb = size(desc,2);
fprintf(fid, '%d\n',dim);
fprintf(fid, '%d\n',nb);
for i = 1:nb
fprintf(fid, '% 5.15f', desc(:,i));
fprintf(fid, '\n');
end
fclose(fid);