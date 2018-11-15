# Feature Extraction
A Matlab implemetation of extraction of SIFT, SURF and KAZE features. This is part of my Computer Vision course assignment during the 
Winter 2018 term. The idea is to compare and evaluate state-of-the-art feature detector and descriptors namely, SIFT, SURF and KAZE. The detectors and descriptors are run on the Affine Covariant Dataset available for download [here](http://www.robots.ox.ac.uk/~vgg/research/affine/)


# Usage
1. Load 'assignment1.m' into MATLAB.

2. Change the 'path' variable in line 33 to point to the desired path.

3. Uncomment the correct section under 'REPEATABILITY PLOTS' that corresponds to the selected category of the Affine Covarint Dataset.

# Blurred Bikes Sequence
|         | SIFT | SURF | KAZE |
|---------|------|------|------|
| Normal  |  <img src="/images/bike_img1_sift.jpg" heigth="240" width="240"></img>    |   <img src="/images/bike_img1_surf.jpg" heigth="240" width="240"></img>   |   <img src="/images/bike_img1_kaze.jpg" heigth="240" width="240"></img>   |
| Blurred |   <img src="/images/bike_img4_sift.jpg" heigth="240" width="240"></img>   |   <img src="/images/bike_img4_surf.jpg" heigth="240" width="240"></img>   |   <img src="/images/bike_img4_kaze.jpg" heigth="240" width="240"></img>   |

## Repeatability and Precision-Recall Plots
<img src="/images/bike_repeatability.jpg" heigth="500" width="500"></img><img src="/images/bikes_comparison.jpg" heigth="500" width="500"></img>


# References
1. `K. Mikolajczyk, T. Tuytelaars, C. Schmid, A. Zisserman, J. Matas, F. Schaffalitzky, T. Kadir and L. Van Gool, 
    A comparison of affine region detectors. In IJCV 65(1/2):43-72, 2005.`
 
2. `K. Mikolajczyk, C. Schmid,  A performance evaluation of local descriptors. In PAMI 27(10):1615-1630.`

3. `Computer Vision 2000, Linda Shapiro and George Stockman.`
