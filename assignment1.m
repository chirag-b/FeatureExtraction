%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Chirag Balakrishna
%%% CCID : cbalakri@ualberta.ca
%%% Student ID : 1559633
%%% Course : Computer Vision, Winter 2018.
%%% Note : Some elements of the following program has been taken from 
%%%        repeatability_demo available for download from the following
%%%        link
%%%        'http://www.robots.ox.ac.uk/~vgg/research/affine/'
%%%
%%% Assignment Objective : To extract invariant features from 8 different image categories 
%%%             using 'state-of-the-art' feature detectors and descriptors, namely, SIFT, SURF 
%%%             and KAZE and compare and evaluate them.
%%%
%%% References : 
%%% [1] K. Mikolajczyk, T. Tuytelaars, C. Schmid, A. Zisserman, J. Matas, 
%%%     F. Schaffalitzky, T. Kadir and L. Van Gool, A comparison of affine region detectors. 
%%%     In IJCV 65(1/2):43-72, 2005.
%%% 
%%% [2] K. Mikolajczyk, C. Schmid,  A performance evaluation of local descriptors. 
%%%     In PAMI 27(10):1615-1630             
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function assignment1

det_suffix = ['sift';'surf';'kaze'];
des_suffix = ['siftdesc';'surfdesc';'kazedesc'];

%det_nb=3;

path = 'D:\\Chirag B\\ComputerVision\\Assignment1\\affine_data\\graf.tar\\'

for k=1:6
    img = sprintf(strcat(path,'img%d.ppm'),k);
    
    
    %read image
    I = imread(img);
    
%     %boat================
%     img2 = single(I); %SIFT
%     img3 = I; %SURF
%     img4 = I; %KAZE
%     %====================
    
    %input for SIFT
    img2 = single(rgb2gray(I));
    

    %input for SURF
    img3 = rgb2gray(I);
    
    %input for KAZE
    img4 = rgb2gray(I);
    
    index = int2str(k);
    
    %===========================SIFT===============================
    %get SIFT features and detectors.
    [f1, d1] = vl_sift(img2);
    M_sift = get_moment(f1, img2);
    
    %Save Detected Regions.
    sift_file = strcat(path, 'img', index, '.sift');
    SaveDetectors(sift_file, M_sift, 1);
    
    %Save Descriptors.
    desc = [double(M_sift); double(d1)];
    sift_desc = strcat(path, 'img', index, '.siftdesc');
    SaveDescriptors(sift_desc, desc, 128);
    %===============================================================
    
    
    %===========================SURF================================
    %get SURF features and detectors.
    surf_features = detectSURFFeatures(img3);
    [features, valid_points] = extractFeatures(img3, surf_features);
   
    f2 = [valid_points.Location';valid_points.Scale'];
    M_surf = get_moment(f2, I);
    
    %Save Detected Regions.
    surf_file = strcat(path, 'img', index, '.surf');
    SaveDetectors(surf_file, M_surf, 1);
    
    %Save Descriptors.
    desc2 = [M_surf;features'];
    surf_desc = strcat(path, 'img', index, '.surfdesc');
    [s_r, s_c]=size(features');
    SaveDescriptors(surf_desc, desc2, s_r);
    %===============================================================
    
    
    %============================KAZE===============================
    %get KAZE features and detectors.
    kaze_features = detectKAZEFeatures(img4);
    
    [sift_row, sift_col] = size(f1);
    [surf_row, surf_col] = size(valid_points.Location);
    
    % get min(sift and surf)
    n = min(sift_col, surf_row);
    
    kaze_features = selectStrongest(kaze_features, n);
    
    [k_features, k_valid_points] = extractFeatures(img4, kaze_features);
    
    f3 = [k_valid_points.Location';k_valid_points.Scale'];
    M_kaze = get_moment(f3, I);
    
    %Save Detected Regions.
    kaze_file = strcat(path, 'img', index, '.kaze');
    SaveDetectors(kaze_file, M_kaze, 1);
    
    %Save Descriptors.
    desc3 = [M_kaze;k_features'];
    kaze_desc = strcat(path, 'img', index, '.kazedesc');
    [k_r, k_c]=size(k_features');
    SaveDescriptors(kaze_desc, desc3, k_r);
    %===============================================================
        
    if k == 4
        orig_1 = imread(strcat(path, 'img1.ppm'));
        sift_1 = strcat(path, 'img1.sift');
        sift_4 = strcat(path, 'img4.sift');
        
        surf_1 = strcat(path, 'img1.surf');
        surf_4 = strcat(path, 'img4.surf');
        
        kaze_1 = strcat(path, 'img1.kaze');
        kaze_4 = strcat(path, 'img4.kaze')
        
        display_features(sift_1, orig_1, 0, 0);
        saveas(gcf, strcat(path, 'img1_sift.jpg'));

        display_features(sift_4, I, 0, 0);
        saveas(gcf, strcat(path, 'img4_sift.jpg'));

        display_features(surf_1, orig_1, 0, 0);
        saveas(gcf, strcat(path, 'img1_surf.jpg'));

        display_features(surf_4, I, 0, 0);
        saveas(gcf, strcat(path, 'img4_surf.jpg'));

        display_features(kaze_1, orig_1, 0, 0);
        saveas(gcf, strcat(path, 'img1_kaze.jpg'));

        display_features(kaze_4, I, 0, 0);
        saveas(gcf, strcat(path, 'img4_kaze.jpg'));
               
    end
    
end

mark=['-o';'-d';'-s'];

rep = {};
prec = {};
rec = {};

% Plot graphs of Detector performance

hold on;
for d=1:4

if d ~= 4 
    seqrepeat=[];
    seqcorresp=[];
    seqrecall= [];
    seqprecision= [];

    hold on;
        for i=2:6
            file1=sprintf(strcat(path,'img1.%s'),det_suffix(d,:));
            file2=sprintf(strcat(path,'img%d.%s'),i,det_suffix(d,:));

            file3=sprintf(strcat(path,'img1.%s'),des_suffix(d,:));
            file4=sprintf(strcat(path,'img%d.%s'),i,des_suffix(d,:)); 

            Hom=sprintf(strcat(path, 'H1to%dp'),i);
            imf1=strcat(path, 'img1.ppm');
            imf2=sprintf(strcat(path ,'img%d.ppm'),i);

            % Evaluate detectors
            [erro,repeat,corresp, match_score,matches, twi]=repeatability(file1,file2,Hom,imf1,imf2, 1);
            seqrepeat=[seqrepeat repeat(4)]; % 1 value per iteration
            seqcorresp=[seqcorresp corresp(4)];


            % Evaluate descriptors
            [v_overlap, v_repeatability, v_nb_corresp, matching_score, nb_of_matches,...
                    twi]=repeatability(file3, file4, Hom, imf1, imf2, 0);

            [correct_match_nn, total_match_nn, correct_match_sim, total_match_sim,...
                correct_match_rn, total_match_rn]=descperf(file3, file4, Hom, imf1, imf2, v_nb_corresp(5), twi);
            
            corresp_sim=sum(sum(twi));
            recall=correct_match_sim/corresp_sim;
            precision=(total_match_sim-correct_match_sim)./total_match_sim;
            
            recall; % 20 values per iteration
            precision; % 20 values per iteration

            seqrecall = [seqrecall recall];
            seqprecision = [seqprecision precision];
            
        end
        rep{d} = seqrepeat;
        prec{d} = seqprecision;
        rec{d} = seqrecall;
    
else
    disp("DONE........");
    break;
end

end



%=================REPEATABILITY PLOTS======================================
    
    %---------CATEGORY : BLUR Bikes----------------------------------------  
%     figure(2);
%     plot([2 2.5 3 3.5 4],rep{1,1},mark(1,:)); hold on;
%     plot([2 2.5 3 3.5 4],rep{1,2},mark(2,:)); hold on;
%     plot([2 2.5 3 3.5 4],rep{1,3},mark(3,:));
%     legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
%     ylabel('Repeatability %');
%     xlabel('Increasing Blur');
    %----------------------------------------------------------------------

    
    %---------CATEGORY : Zoom + Rotation Bark------------------------------
%     figure(2);
% %     plot([1 1.2 1.4 1.6 1.8],seqrepeat,mark(d,:)); hold on;
%     plot([1 1.2 1.4 1.6 1.8],rep{1,1},mark(1,:)); hold on;
%     plot([1 1.2 1.4 1.6 1.8],rep{1,2},mark(2,:)); hold on;
%     plot([1 1.2 1.4 1.6 1.8],rep{1,3},mark(3,:));   
%     legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
%     ylabel('Repeatability %');
%     xlabel('Scale');
    %----------------------------------------------------------------------
    
    
    %---------CATEGORY : BLUR Trees----------------------------------------
%     figure(2);
% %     plot([2 2.5 3 3.5 4],seqrepeat,mark(d,:)); hold on;
%     plot([2 2.5 3 3.5 4],rep{1,1},mark(1,:)); hold on;
%     plot([2 2.5 3 3.5 4],rep{1,2},mark(2,:)); hold on;
%     plot([2 2.5 3 3.5 4],rep{1,3},mark(3,:));
%     legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
%     ylabel('Repeatability %');
%     xlabel('Increasing Blur');
%     saveas(gcf, strcat(path, 'trees_rep.jpg'));
    %----------------------------------------------------------------------
    
    
    %---------CATEGORY : Zoom + Rotation Boats-----------------------------
%     figure(2);
% %     plot([1 1.2 1.4 1.6 1.8],seqrepeat,mark(d,:)); hold on;
%     plot([1 1.2 1.4 1.6 1.8],rep{1,1},mark(1,:)); hold on;
%     plot([1 1.2 1.4 1.6 1.8],rep{1,2},mark(2,:)); hold on;
%     plot([1 1.2 1.4 1.6 1.8],rep{1,3},mark(3,:));   
%     legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
%     ylabel('Repeatability %');
%     xlabel('Scale');
    %----------------------------------------------------------------------
    
    
    %---------CATEGORY : Viewpoint Graffiti--------------------------------
    figure(2);
%     plot([15 20 25 30 35],seqrepeat,mark(d,:)); hold on;
    plot([15 20 25 30 35],rep{1,1},mark(1,:)); hold on;
    plot([15 20 25 30 35],rep{1,2},mark(2,:)); hold on;
    plot([15 20 25 30 35],rep{1,3},mark(3,:));   
    legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
    ylabel('Repeatability %');
    xlabel('Viewpoint');
    %----------------------------------------------------------------------
    
    
    %---------CATEGORY : Viewpoint Wall------------------------------------
%     figure(2);
% %     plot([15 20 25 30 35],seqrepeat,mark(d,:)); hold on;
%     plot([15 20 25 30 35],rep{1,1},mark(1,:)); hold on;
%     plot([15 20 25 30 35],rep{1,2},mark(2,:)); hold on;
%     plot([15 20 25 30 35],rep{1,3},mark(3,:));   
%     legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
%     ylabel('Repeatability %');
%     xlabel('Viewpoint');
    %----------------------------------------------------------------------
    
    
    %---------CATEGORY : JPEG Compression UBC------------------------------
%     figure(2);
% %     plot([60 65 70 75 80],seqrepeat,mark(d,:)); hold on;
%     plot([60 65 70 75 80],rep{1,1},mark(1,:)); hold on;
%     plot([60 65 70 75 80],rep{1,2},mark(2,:)); hold on;
%     plot([60 65 70 75 80],rep{1,3},mark(3,:));   
%     legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
%     ylabel('Repeatability %');
%     xlabel('JPEG %');
    %----------------------------------------------------------------------
    
    
    %---------CATEGORY : Light Leuven(cars)--------------------------------
%     figure(2);
% %     plot([2 2.5 3 3.5 4],seqrepeat,mark(d,:)); hold on;
%     plot([2 2.5 3 3.5 4],rep{1,1},mark(1,:)); hold on;
%     plot([2 2.5 3 3.5 4],rep{1,2},mark(2,:)); hold on;
%     plot([2 2.5 3 3.5 4],rep{1,3},mark(3,:));   
%     legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
%     ylabel('Repeatability %');
%     xlabel('Decreasing Light');
    %----------------------------------------------------------------------    
%==========================================================================


%==========================PRECISION & RECALL==============================
    figure(3);
    subplot(3, 2, 1)
%     plot(seqprecision(1:20), seqrecall(1:20),mark(d,:)); hold on;
    plot(prec{1,1}(1:20),rec{1,1}(1:20), mark(1,:)); hold on;
    plot(prec{1,2}(1:20),rec{1,2}(1:20), mark(2,:)); hold on;
    plot(prec{1,3}(1:20),rec{1,3}(1:20), mark(3,:)); hold on;
    legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
    xlim([0 1])
    title('img1.ppm and img2.ppm');
    ylabel('Recall');
    xlabel('Precision');
% 
    subplot(3, 2, 2)
%     plot(seqprecision(21:40),seqrecall(21:40),mark(d,:)); hold on;
    plot(prec{1,1}(21:40),rec{1,1}(21:40), mark(1,:)); hold on;
    plot(prec{1,2}(21:40),rec{1,2}(21:40), mark(2,:)); hold on;
    plot(prec{1,3}(21:40),rec{1,3}(21:40), mark(3,:)); hold on;
    legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
    xlim([0 1])
    title('img1.ppm and img3.ppm');
    ylabel('Recall')
    xlabel('Precision');
% 
    subplot(3, 2, 3)
%     plot(seqprecision(41:60),seqrecall(41:60),mark(d,:)); hold on;
    plot(prec{1,1}(41:60),rec{1,1}(41:60), mark(1,:)); hold on;
    plot(prec{1,2}(41:60),rec{1,2}(41:60), mark(2,:)); hold on;
    plot(prec{1,3}(41:60),rec{1,3}(41:60), mark(3,:)); hold on;
    legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
    xlim([0 1])
    title('img1.ppm and img4.ppm');
    ylabel('Recall')
    xlabel('Precision');
% 
    subplot(3, 2, 4)
%     plot(seqprecision(61:80),seqrecall(61:80),mark(d,:)); hold on;
    plot(prec{1,1}(61:80),rec{1,1}(61:80), mark(1,:)); hold on;
    plot(prec{1,2}(61:80),rec{1,2}(61:80), mark(2,:)); hold on;
    plot(prec{1,3}(61:80),rec{1,3}(61:80), mark(3,:)); hold on;
    legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
%     xlim([0 1])
    title('img1.ppm and img5.ppm');
    ylabel('Recall')
    xlabel('Precision');
% 
    subplot(3, 2, 5)
%     plot(seqprecision(81:100),seqrecall(81:100),mark(d,:)); hold on;
    plot(prec{1,1}(81:100),rec{1,1}(81:100), mark(1,:)); hold on;
    plot(prec{1,2}(81:100),rec{1,2}(81:100), mark(2,:)); hold on;
    plot(prec{1,3}(81:100),rec{1,3}(81:100), mark(3,:)); hold on;
    legend(det_suffix(1,:),det_suffix(2,:),det_suffix(3,:));
    xlim([0 1])
    title('img1.ppm and img6.ppm');
    ylabel('Recall')
    xlabel('Precision');
%==========================================================================


disp('DISPLAYING ALL PLOTTABLE VALUES');
disp(rec);
disp(prec);
disp(rep);
disp('-------------------------------');


end

