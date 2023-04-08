# upscaled-ear-model-scripts
Companion scripts to "Dataset of acoustic intensity vector measurements around an upscaled ear model", available open access at https://doi.org/10.5281/zenodo.7564880 .

### Loading:

### Preprocessing:

### Visualization:

### Analysis:

# DATASET DOCUMENTATION

## AUTHORS
Direct correspondence to:
Aaron Geldert
aarongeldert@gmail.com

Data collected in July 2022 by Aaron Geldert, Aleksi Öyry and Marton Marschall
Project supported by the Communication Acoustics research group, led by Ville Pulkki

## LICENSE
Open access, per Creative Commons Attribution 4.0 International.
Accessed from Zenodo (zenodo.org).

## DATASET SUMMARY
This dataset contains impulse responses of the sound field around a 3D printed model of a right ear, scaled 7 times larger than anthropometry. 
The ear was mounted on a turntable in the large anechoic chamber, Lampio, at the Aalto Acoustics Labs.
7 loudspeakers (Genelec 8030A) were arranged in an arc at angles of [0,15,...90], with a radius 3.2 meters away.
An interleaved exponential sine sweep (15 seconds, from 10 Hz to 24 kHz) was used, and impulse responses were obtained through deconvolution with the inverse test signal. 
4-channel impulse responses were measured at a sample rate of 48 kHz with a Microflown USP-regular probe and MFPA-4 preamplifier, capturing pressure and XYZ particle velocity signals.
The probe was moved along a dense grid of 225 measurement positions in and around the ear model using a robotic mover system.
The measurement grid is defined with 25 mm intervals in the XY plane and 19 mm intervals in the Z axis.

In total, the dataset contains:
168 directions of arrival, 145 of which are unique (24 polar angles x 7 lateral angles)
225 measurement positions
8192 samples x 4 channels per IR

## COORDINATE SYSTEM:
A right-handed cartesian coordinate system is used.
The axes correspond to:
X+ forward
Y+ up
Z+ right
when taking the perspective of a human with the given right ear.

Angular coordinates are described in a polar-lateral system. 
Polar angles rotate around the Z axis, with 0 degrees = forward, 90 = up, 180 = backward, -90/270 = down. 
Polar angles were measured by rotating the turntable with the ear mounted on it. The loudspeaker and probe orientations were kept constant, so a correcting rotation of the XYZ velocity channels is required during preprocessing.
Lateral angles are found relative to the median plane, where -90 is left, 0 is in the median plane, and 90 is right. 

Loudspeaker 1 is located at 0 degrees lateral, 2 at 15 degrees lateral, etc.
Loudspeaker 7 is located at 90 degrees lateral, making its measurement redundant for all polar angles.


