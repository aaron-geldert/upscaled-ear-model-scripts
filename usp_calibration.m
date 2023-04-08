function [Hp, Hx, Hy, Hz, freq] = usp_calibration(fs, nfft, doPlot)
% USP_CALIBRATION models the USP pressure and velocity transfer functions
% over a frequency vector (Hz).
% Created by: Aaron Geldert
% Last modified: 14 Dec 2022

if nargin < 3
    doPlot = 0;
end

% Load model params of the microflown UR 901637
% as calibrated by Microflown in Nov 2019
USP.Sp1kHz=		54.4;
USP.fc1p=		1;
USP.fc2p=		13;
USP.fc3p=		22335;
USP.C1p=		2;
USP.C2p=		13;
USP.C3p=		29950;
USP.pRef=       52.1; % calibrated with GRAS

USP.x.Su250Hz=	15.8;
USP.x.fc1u=		49;
USP.x.fc2u=		542;
USP.x.fc3u=		5520;
USP.x.fc4u=		150;
USP.x.C1u=		34;
USP.x.C2u=		515;
USP.x.C3u=		17260;
USP.x.C4u=		150;

USP.y.Su250Hz=	15.6;
USP.y.fc1u=		54;
USP.y.fc2u=		550;
USP.y.fc3u=		5045;
USP.y.fc4u=		140;
USP.y.C1u=		38;
USP.y.C2u=		520;
USP.y.C3u=		13200;
USP.y.C4u=		140;

USP.z.Su250Hz=	13.2;
USP.z.fc1u=		32;
USP.z.fc2u=		400;
USP.z.fc3u=		5340;
USP.z.fc4u=		50;
USP.z.C1u=		16;
USP.z.C2u=		400;
USP.z.C3u=		9645;
USP.z.C4u=		50;

% Pressure sensitivity, in mV/Pa
pSens= @(f, Sp1kHz, fc1p, fc2p, fc3p) Sp1kHz.*sqrt(1+(f./fc3p).^2) ./ (sqrt(1+(fc1p./f).^2) .* sqrt(1+(fc2p./f).^2));

% Pressure phase, in degrees
pPhsd= @(f, C1p, C2p, C3p) atand(C1p./f)+atand(C2p./f)+atand(f./C3p);

% Particle velocity sensitivity, in mV/Pa*
uSens= @(f, Su250Hz, fc1u, fc2u, fc3u, fc4u) 1000*Su250Hz./...
    (343*1.2*sqrt(1+(fc1u./f).^2).*sqrt(1+(f./fc2u).^2).*sqrt(1+(f./fc3u).^2).*sqrt(1+(fc4u./f).^2));
% Velocity phase, in degrees
uPhsd= @(f, C1u, C2u, C3u, C4u) atand(C1u./f)-atand(f./C2u)-atand(f./C3u)+atand(C4u./f) + 180;

% Lets plot these bad boys
freq = linspace(0,fs, nfft+1);
freq = freq(1:end-1).';

% the range where the calibration was not measured
undefFreq = freq<10 | freq>20e3; 

% the magnitudes all peak around 30 dB; lets scale it down??
% gain = 10^(-30/20);
gain = 1;

pMag = gain*pSens(freq, USP.Sp1kHz, USP.fc1p, USP.fc2p, USP.fc3p);
pPhs = deg2rad(pPhsd(freq, USP.C1p, USP.C2p, USP.C3p));
xMag = gain*uSens(freq, USP.x.Su250Hz, USP.x.fc1u, USP.x.fc2u, USP.x.fc3u, USP.x.fc4u);
xPhs = deg2rad(uPhsd(freq, USP.x.C1u, USP.x.C2u, USP.x.C3u, USP.x.C4u));
yMag = gain*uSens(freq, USP.y.Su250Hz, USP.y.fc1u, USP.y.fc2u, USP.y.fc3u, USP.y.fc4u);
yPhs = deg2rad(uPhsd(freq, USP.y.C1u, USP.y.C2u, USP.y.C3u, USP.y.C4u));
zMag = gain*uSens(freq, USP.z.Su250Hz, USP.z.fc1u, USP.z.fc2u, USP.z.fc3u, USP.z.fc4u);
zPhs = deg2rad(uPhsd(freq, USP.z.C1u, USP.z.C2u, USP.z.C3u, USP.z.C4u));

% normalize
pMag = pMag./max(pMag);
xMag = xMag./max(xMag);
yMag = yMag./max(yMag);
zMag = zMag./max(zMag);

% magnitude 1, phase 0 for the other freqs
% pMag(undefFreq) = 100;
% xMag(undefFreq) = 100;
% yMag(undefFreq) = 100;
% zMag(undefFreq) = 100;
% pPhs(undefFreq) = 0;
% xPhs(undefFreq) = 0;
% yPhs(undefFreq) = 0;
% zPhs(undefFreq) = 0;

% This should match the stuff from the calibration excel
if doPlot ~= 0
    figure(); 
    tiledlayout(4,1); nexttile;
    yyaxis left; semilogx(freq,db(pMag)); xlim([10 10e3]); 
    yyaxis right; semilogx(freq, pPhs); ylim([0 1.2]); nexttile;
    yyaxis left; semilogx(freq,db(xMag)); xlim([10 10e3]); 
    yyaxis right; semilogx(freq, xPhs); ylim([0 7]);  nexttile;
    yyaxis left; semilogx(freq,db(yMag)); xlim([10 10e3]); 
    yyaxis right; semilogx(freq, yPhs); ylim([0 7]); nexttile;
    yyaxis left; semilogx(freq,db(zMag)); xlim([10 10e3]); 
    yyaxis right; semilogx(freq, zPhs); ylim([0 7]);
end

Hp = abs(pMag).*exp(1i*pPhs);
Hx = abs(xMag).*exp(1i*xPhs);
Hy = abs(yMag).*exp(1i*yPhs);
Hz = abs(zMag).*exp(1i*zPhs);

% mirror the response above Nyquist
Hp = defineFreqsAboveNyq(Hp);
Hx = defineFreqsAboveNyq(Hx);
Hy = defineFreqsAboveNyq(Hy);
Hz = defineFreqsAboveNyq(Hz);

end