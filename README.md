# Megocclusion
Code for analysis of MEG occlusion data

This repository contains implementing code for the decoding curves of Figure 1 in "Beyond Core Object Recognition: Recurrent processes account for object recognition under occlusion": https://www.biorxiv.org/content/10.1101/302034v2.

Please refer to: Megocclusion-vr3 data repository (RepOD. http://dx.doi.org/10.18150/repod.2004402) for downloading MEG data of occlusion.

### Related articles:
author = {Karim Rajaei, Yalda Mohsenzadeh, Reza Ebrahimpour, Seyed-Mahdi Khaligh-Razavi}, title = {Beyond Core Object Recognition: Recurrent processes account for object recognition under occlusion}, journal = {BioRXiv preprint :https://doi.org/10.1101/302034}, year = {2018}

### Sample images of occlusion dataset
![](/Sample images of occlusion dataset.png)

## Results
Decoding curves obtained by running demo.m, which is average across n=15 human subjects
![](/decoding_occlusion.png)


## Usage
1. Create a folder with name "MEG Data". 
2. Download MEG signals for n=15 subjects form "Megocclusion-vr3" (RepOD. http://dx.doi.org/10.18150/repod.2004402) data repository and add them to "MEG Data" .
2. Download and addpath "libsvm"
3. Run demo.m
