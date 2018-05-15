# By indication of the Editor-In-Chief of IPOL, this makefile has been
# modified by the IPOL staff on 19 Feb. 2017 to make the source code
# compile: the -WError directive has been removed.

# Copyright (C) 2009-2010, Luis Alvarez <lalvarez@dis.ulpgc.es>
#
# Copying and distribution of this file, with or without
# modification, are permitted in any medium without royalty provided
# the copyright notice and this notice are preserved.  This file is
# offered as-is, without any warranty.

COPT	= -O3 -funroll-loops -fomit-frame-pointer -fopenmp
CFLAGS	= -Wall -Wextra $(COPT)

lens_distortion_estimation:  ami_pol.o lens_distortion.o lens_distortion_estimation.o ami_bmp.o
	$(CXX) $(CFLAGS) -o lens_distortion_estimation ami_pol.o lens_distortion.o lens_distortion_estimation.o ami_bmp.o 

lens_distortion_estimation.o:  lens_distortion_estimation.cpp
	$(CXX) $(CFLAGS) -c lens_distortion_estimation.cpp -Iimage
	
ami_pol.o:  ami_pol.c
	$(CXX) $(CFLAGS) -c ami_pol.c

ami_bmp.o:  image/ami_bmp/ami_bmp.cpp
	$(CXX) $(CFLAGS) -c image/ami_bmp/ami_bmp.cpp 
	
lens_distortion.o:  lens_distortion.cpp
	$(CXX) $(CFLAGS) -c lens_distortion.cpp -Iimage
