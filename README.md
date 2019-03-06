# Megocclusion
Code for analysis of MEG occlusion data

This repository contains implementing code for the decoding curves in Figure 1 of the article "Beyond Core Object Recognition: Recurrent processes account for object recognition under occlusion": https://www.biorxiv.org/content/10.1101/302034v1.abstract.

Please refer to: Megocclusion-vr2 data repository (RepOD. http://dx.doi.org/10.18150/repod.7536911) for MEG data of occlusion.

Related articles:

[a]	@article{Rajaei ,
		author = {Karim Rajaei, Yalda Mohsenzadeh, Reza Ebrahimpour, Seyed-Mahdi Khaligh-Razavi},
		title = {Beyond Core Object Recognition: Recurrent processes account for object recognition under occlusion},
		journal = {BioRXiv preprint :https://doi.org/10.1101/302034},
		year = {2018}
	}


# Results
Decoding curves obtained by running demo.m
![](/decoding_occlusion.tif)


# Usage
1. Create a folder with name "MEG Data". 
2. Download MEG signals for n=15 subjects form "Megocclusion-vr2" data repository and add them to "MEG Data" .
2. Download and addpath "libsvm-3.23"
3. Run demo.m
