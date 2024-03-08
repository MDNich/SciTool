import numpy as np
import matplotlib.pyplot as plt
import matplotlib.backends.backend_pdf
from mpl_toolkits.axes_grid1 import make_axes_locatable 
import matplotlib.colors
from matplotlib import rcParams

rcParams['font.family'] = 'serif' 
rcParams['font.sans-serif'] = ['Computer Modern'] 
rcParams['text.usetex'] = True

import math
def ooM(number): # Order of Magnitude
    return math.floor(math.log(number, 10))

"""
Circuitul RC
      R
 ----^^^^-----
|            |
|      C     |
--E----||----

 
ÎNCĂRCAREA

Folosind legea lu Khirkhoff, unde E = emf, obținem că 

E - q/C - R*dq/dt = 0
=> dq/dt = E/R - q/RC
=> dq/dt =  - (q - EC)/RC
=> int(dq/(q-CE)) = -int(dt/RC)
=> -(q-CE)/CE = exp(-t/RC)
=> q = CE-CE*exp(-t/RC) // CE = Qmax
=> q(t) = Qmax(1-exp(-t/RC))
=> dq/dt = E/R*exp(-t/RC)

DESCĂRCAREA

Circuitul RC
      R
 ----^^^^-----
|            |
|      C     |
-------||----

Folosim legea lu Khirkhoff dar omitând termenul E = emf, pentru că n-ar exista o sursă de potențial în circuit.

-q/C - R*dq/dt = 0
=> dq/dt = -q/RC
=> int(dq/q) = -int(dt/RC)
=> ln(q) = -t/RC + D # D e constantă de integrare, Q0 = exp(D) = încărcarea inițială.
=> q(t) = Q0*exp(-t/RC)
=> dq/dt = -Q0/RC*exp(-t/RC)


"""

import argparse

parser = argparse.ArgumentParser(
                    prog='RC_Circuit_PlotPDF',
                    description='Programul acest plotează comportarea unei circuit RC, funcție de R, C, E, și V0.',
                    epilog='© MDNich')
parser.add_argument('R',type=float)   
parser.add_argument('C',type=float)   
parser.add_argument('E',type=float)   
parser.add_argument('V0',type=float)   
parser.add_argument('tmax',type=float)
parser.add_argument('filesave',type=str)   
args = parser.parse_args()

"""R = 8e5   # Ohms
C = 5e-6 # Farad
E = 12   # Volt
V0 = E  # Volt, assume is charged by previous move."""

R = args.R
C = args.C
E = args.E
V0 = args.V0
tMax = args.tmax
outPDF = args.filesave

#outPDF = "RCfig.pdf"


if (True): # can wrap with try/except if needed 
	matplotlib.rcParams['figure.figsize'] = (8.5 * 1, 11 * 2/3) 
	plt.rc('font', size=10) # controls default text size 
	plt.rc('axes', titlesize=10) # fontsize of the title 
	plt.rc('axes', labelsize=10) # fontsize of the x and y labels 
	plt.rc('xtick', labelsize=10) # fontsize of the x tick labels 
	plt.rc('ytick', labelsize=10) # fontsize of the y tick labels 
	plt.rc('legend', fontsize=10) # fontsize of the legend 
	with matplotlib.backends.backend_pdf.PdfPages(outPDF) as pdf:
		fig, axs = plt.subplots(nrows=2, ncols=1,sharex='col') # axs is an array of matplotlib.Axes objects if more than one subplot , otherwise just the one
		plt.subplots_adjust(left=0.1, bottom=0.07,
			right=0.9, top=0.95, wspace=0.2, hspace=0.2)
		print("init complete, beginning plotting...")

		# primul plot va despre încărcare

		# q(t) = CE(1-exp(-t/RC))
		# I(t) = dq/dt = E/R*exp(-t/RC)
		tau = R*C
		#tMax = 5*tau
		t = np.linspace(1e-9,tMax,1000)
		qChg = C*E*(1-np.exp(-t/R/C))
		Ichg = E/R*np.exp(-t/R/C)

		kx = axs[0]
		kx2 = kx.twinx()
		kx2.plot(t,Ichg,c='blue')
		kx.plot(t,Ichg,c='blue',label="Current in Circuit")
		kx.plot(t,Ichg,c='white',linewidth=3)
		kx.plot(t,qChg,c='purple',label="Charge on Capacitor")
		
		kx.hlines(C*E,0,tMax,color="purple",linestyle='dashed',label="Maximum Charge")
		kx2.hlines(E/R,0,tMax,color="blue",linestyle='dashed')
		kx.hlines(0,tMax,E/R,color="blue",linestyle='dashed',label="Maximum Current")
		kx.hlines(0,tMax,E/R,color="white",linewidth=3)

		#print(np.max(qChg))
		yMax1 = 9e-5/6e-5*np.max(qChg)
		yMax2 = 1.52e-5/1.5e-5*np.max(Ichg)
		kx.set_ylim(0,yMax1)
		kx.set_xlim(0,tMax)
		kx2.set_ylim(0,yMax2)

		kx2.set_ylabel("Current (A)",color='blue')
		kx.set_ylabel("Charge on Capacitor (C)",color='purple')
		ooMR = ooM(R)
		kx.set_title("Charging Capacitor: $R=" + str(np.round(R*(10**(-ooMR)),2)) + ("\cdot 10^{" + str(ooMR) + "}" if ooMR != 0 else "") + "~\Omega$, $C=" + str(np.round(C*1e6,2)) + "$ µF, $\mathcal{E}=" + str(np.round(E,2)) + "$ V")

		kx.legend(ncol=2)

		# descărcare

		# Q0 = C*V0
		# q(t) = Q0*exp(-t/RC)
		# dq/dt = -Q0/RC*exp(-t/RC)
		qChg = C*V0*np.exp(-t/R/C)
		Ichg = V0/R*np.exp(-t/R/C)
		kx = axs[1]
		kx2 = kx.twinx()
		kx2.plot(t,Ichg,c='blue')
		kx.plot(t,Ichg,c='blue',label="Current in Circuit")
		kx.plot(t,Ichg,c='white',linewidth=3)
		kx.plot(t,qChg,c='purple',label="Charge on Capacitor")
		
		kx.hlines(C*V0,0,tMax,color="purple",linestyle='dashed',label="Maximum Charge")
		kx2.hlines(V0/R,0,tMax,color="blue",linestyle='dashed')
		kx.hlines(0,tMax,E/R,color="blue",linestyle='dashed',label="Maximum Current")
		kx.hlines(0,tMax,E/R,color="white",linewidth=3)

		yMax1 = 9e-5/6e-5*np.max(qChg)
		yMax2 = 1.52e-5/1.5e-5*np.max(Ichg)
		kx.set_ylim(0,yMax1)
		kx.set_xlim(0,tMax)
		kx2.set_ylim(0,yMax2)

		kx2.set_ylabel("Current (A)",color='blue')
		kx.set_ylabel("Charge on Capacitor (C)",color='purple')
		kx.set_title("Charging Capacitor: $R=" + str(np.round(R*(10**(-ooMR)),2)) + ("\cdot 10^{" + str(ooMR) + "}" if ooMR != 0 else "") + "~\Omega$, $C=" + str(np.round(C*1e6,2)) + "$ µF, $V_0=" + str(np.round(V0,2)) + "$ V")
		kx.set_xlabel("Time (s)")
		kx.legend(ncol=2)


		print("Rendering and saving to PDF...")
		pdf.savefig(fig) 
		plt.close() 
		print("COMPLETELY done!") 
		exit(0)