#----------------------------------------------------------------------
#
#  Filename       : GrowthRatePlot.py
#  Author         : Ryan Moll
#  Date Modified  : October 22, 2017
#  Purpose        : Creates a color plot of growth rate magnitudes
#                   based on solutions to the quartic dispersion
#                   relation for rotating double-diffusive convection
#
#----------------------------------------------------------------------

import numpy as np
from numpy import pi
import matplotlib.pyplot as plt

Pr = 0.1
tau = 0.1
Rm1 = 1.25
Ta = 10
theta = 0.0*pi

Lx = 100
Ly = 100
Lz = 100

l1 = 2*pi/Lx
k1 = 2*pi/Lz

maxModeX = 13.0
maxModeZ = 9.0
dn = 0.2
m = 0

numModeX = 2*int(maxModeX/dn)-1
numModeZ = 2*int(maxModeZ/dn)-1
numTot = numModeX*numModeZ
lamTemp = np.zeros(numTot)

index = 0
for nz in np.arange(-maxModeZ+dn,maxModeZ,dn):
    for nx in np.arange(-maxModeX+dn,maxModeX,dn):
        l = nx*l1
        #m = ny*m1
        k = nz*k1

        Kappa2 = l*l + m*m + k*k
        H2 = l*l + m*m
        chi = pow(m*np.sin(theta) + k*np.cos(theta),2)*pow(Pr,2)*Ta

        a = Kappa2
        b = (tau + 2*Pr +1)*pow(Kappa2,2)
        c = (chi + Pr*H2*(Rm1-1)) + (tau + 2*Pr*(tau+1) + pow(Pr,2))*pow(Kappa2,3)
        d = (chi*(1+tau) + Pr*H2*(Rm1*(1+Pr) - Pr - tau))*Kappa2 + (2*Pr*tau + pow(Pr,2)*(tau+1))*pow(Kappa2,4)
        e = (chi*tau + pow(Pr,2)*H2*(Rm1-tau))*pow(Kappa2,2) + pow(Pr,2)*tau*pow(Kappa2,5)

        maxRoot = 0
        coeff = [a,b,c,d,e]
        if nx != 0:
            maxRoot = max(np.roots(coeff).real)

        if maxRoot < 0:
            maxRoot = 0

        lamTemp[index] = maxRoot
        index = index + 1

lam = lamTemp.reshape(numModeZ,numModeX)
fig = plt.figure()
test = plt.imshow(lam,interpolation='bilinear',extent=[-maxModeX+dn,maxModeX-dn,-maxModeZ+dn,maxModeZ-dn])
plt.colorbar()
plt.xlabel('Horizontal Wavenumber')
plt.ylabel('Vertical Wavenumber')
fig.savefig('test.jpg')
plt.show()
