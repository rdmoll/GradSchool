#----------------------------------------------------------------------
#
#  Filename       : GrowthRatePlot.py
#  Author         : Ryan Moll
#  Date Modified  : October 22, 2017
#  Purpose        : This solves the quartic dispersion relation
#                   for rotating double diffusive convection
#                   and prints out the max growth rate and the
#                   wavenumbers for which the max growth rate
#                   occurs
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
m1 = 2*pi/Ly
k1 = 2*pi/Lz

nx = 0
ny = 0
nz = 1

dn = 1.0
maxLam = 0
for nx in np.arange(dn,9,dn):
    for ny in np.arange(0,9,dn):
        for nz in np.arange(0,9,dn):
            l = nx*l1
            m = ny*m1
            k = nz*k1

            Kappa2 = l*l + m*m + k*k
            H2 = l*l + m*m
            chi = pow(m*np.sin(theta) + k*np.cos(theta),2)*pow(Pr,2)*Ta

            a = Kappa2
            b = (tau + 2*Pr +1)*pow(Kappa2,2)
            c = (chi + Pr*H2*(Rm1-1)) + (tau + 2*Pr*(tau+1) + pow(Pr,2))*pow(Kappa2,3)
            d = (chi*(1+tau) + Pr*H2*(Rm1*(1+Pr) - Pr - tau))*Kappa2 + (2*Pr*tau + pow(Pr,2)*(tau+1))*pow(Kappa2,4)
            e = (chi*tau + pow(Pr,2)*H2*(Rm1-tau))*pow(Kappa2,2) + pow(Pr,2)*tau*pow(Kappa2,5)

            coeff = [a,b,c,d,e]
            maxRoot = max(np.roots(coeff).real)
            if maxRoot > maxLam:
                maxLam = maxRoot
                maxNx = nx
                maxNy = ny
                maxNz = nz

print maxLam
print maxNx
print maxNy
print maxNz
