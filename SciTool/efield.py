#!/usr/local/python3

import matplotlib.pyplot as plt
import math
import numpy as np
import os

coulombCt1 = 9E9


# /var/folders/dl/t48fygys3vzbbm381q1cx2c00000gn/T/ [-5] [1] [1] -2.0 -2.0 2.0 2.0 20 9000000000.0 200.0


import argparse
import ast
print("[efield.py] STARTING PYTHON")
parser = argparse.ArgumentParser()
parser.add_argument("pathToSave",type=str)
parser.add_argument("chargeXarr",type=str)
parser.add_argument("chargeYarr",type=str)
parser.add_argument("chargeQarr",type=str)
parser.add_argument("windowLBoundX",type=float)
parser.add_argument("windowLBoundY",type=float)
parser.add_argument("windowUBoundX",type=float)
parser.add_argument("windowUBoundY",type=float)
parser.add_argument("steps",type=int)
parser.add_argument("coulombCt",type=float)
parser.add_argument("dpiInp",type=float)
args = parser.parse_args()

pathToSave_parsed = args.pathToSave.strip()
chargeXarr_parsed = ast.literal_eval(args.chargeXarr)
chargeYarr_parsed = ast.literal_eval(args.chargeYarr)
chargeQarr_parsed = ast.literal_eval(args.chargeQarr)


print("[efield.py] ARGUMENTS PARSED SUCCESSFULLY.")
print("[efield.py] STARTING GRAPH DRAWING...")

def calculateDist(x1,x2,y1,y2):
	deltaX = x2-x1
	deltaY = y2-y1
	dist = math.sqrt(deltaY**2+deltaX**2)
	return dist


def efield(charges,point):
	pointx = point[0]
	pointy = point[1]
	chargesx = charges[0]
	chargesy = charges[1]
	chargesQ = charges[2]
	ex = 0
	ey = 0
	for i in range(len(chargesx)):
		if(calculateDist(chargesx[i],pointx,chargesy[i],pointy) == 0):
			continue
		tmpEx = coulombCt1*chargesQ[i]*1e-9/(calculateDist(chargesx[i],pointx,chargesy[i],pointy))/(calculateDist(chargesx[i],pointx,chargesy[i],pointy))/(calculateDist(chargesx[i],pointx,chargesy[i],pointy))*(pointx-chargesx[i])
		tmpEy = coulombCt1*chargesQ[i]*1e-9/(calculateDist(chargesx[i],pointx,chargesy[i],pointy))/(calculateDist(chargesx[i],pointx,chargesy[i],pointy))/(calculateDist(chargesx[i],pointx,chargesy[i],pointy))*(pointy-chargesy[i])
		ex+=tmpEx
		ey+=tmpEy
	return ex,ey;


def drawGraph(pathToSave,chargeXarr,chargeYarr,chargeQarr,windowLBoundX,windowLBoundY,windowUBoundX,windowUBoundY,steps,coulombCt,dpiInp,isLogScale):
    #plt.ion()
    charges = [chargeXarr,chargeYarr,chargeQarr]
    print(charges)
    fig, ax = plt.subplots()
    coulombCt1 = coulombCt
    #ax = plt.axes(projection='3d')

    efieldX = []
    efieldY = []
    efieldMag = []
    xs = []
    x2s = []
    ys = []
    y2s = []
    ex2d = [[]]
    ey2d = [[]]

    xlist = np.linspace(windowLBoundX,windowUBoundX,steps)
    ylist = np.linspace(windowLBoundY,windowUBoundY,steps)

    for j in xlist:
        for k in ylist:
            #print("x: " + str(j) + " y: " + str(k) + " d: " + str(calculateDist(charges[0][0],j,charges[1][0],k)))
            exThis,eyThis = efield(charges,[j,k])
            if(exThis == 0) & (eyThis == 0):
                continue
            xs.append(j)
            ys.append(k)
            efieldX.append(exThis)
            efieldY.append(eyThis)
            efieldMag.append(np.sqrt(exThis**2 + eyThis**2))
            ex2d[len(ex2d)-1].append(exThis)
            ey2d[len(ey2d)-1].append(eyThis)
            #print("x: " + str(j) + " y: " + str(k) + " v: " + str(volt))
        ex2d.append([])
        ey2d.append([])
    ex2d.remove(ex2d[len(ex2d)-1])
    ey2d.remove(ey2d[len(ey2d)-1])
    #print(volt2d)
    #ax.scatter3D(xs,ys,volt,c=volt)
    xs = np.array(xs)
    ys = np.array(ys)
    #efieldX = xs*xs
    #efieldY = ys*ys*ys
    #efieldMag = np.sqrt(efieldX*efieldX+efieldY+efieldY)
    # ,efieldMag/efieldMag)#
    ax.quiver(xs,ys,np.divide(efieldX,efieldMag),np.divide(efieldY,efieldMag),np.log(np.sqrt(np.power(efieldX,2)+np.power(efieldY,2))))
    chargeXarr = np.array(chargeXarr)
    chargeYarr = np.array(chargeYarr)
    chargeQarr = np.array(chargeQarr)
    ax.scatter(chargeXarr[chargeQarr >= 0],chargeYarr[chargeQarr >= 0],c='red',marker="o",s=80)
    ax.scatter(chargeXarr[chargeQarr >= 0],chargeYarr[chargeQarr >= 0],c='white',marker="+",s=40)
    ax.scatter(chargeXarr[chargeQarr < 0],chargeYarr[chargeQarr < 0],c='blue',marker="o",s=80)
    ax.scatter(chargeXarr[chargeQarr < 0],chargeYarr[chargeQarr < 0],c='white',marker="_",s=40)
    #if(countourprec > 0):
    #    cs = ax.contour(ylist,xlist,volt2d,levels=countourprec,cmap="hsv")
    #    ax.clabel(cs,inline=1,fontsize=8,inline_spacing=2)
    #ax.scatter3D(charges[0],charges[1],0,c=charges[2],marker="X")
    if os.path.isfile(str(pathToSave) + "resultEfield.png"):
        print("removing")
        os.remove(str(pathToSave) + "resultEfield.png")   # Opt.: os.system("rm "+strFile)
        print("path: " + str(pathToSave) + "resultEfield.png")
    fig.savefig(str(pathToSave) + "resultEfield.png",dpi=dpiInp)
    #plt.close(fig)
    
    efieldX = [] 
    efieldY = []
    xs = []
    x2s = []
    ys = []
    y2s = []
    ex2d = [[]]
    ey2d = [[]]

drawGraph(pathToSave_parsed,chargeXarr_parsed,chargeYarr_parsed,chargeQarr_parsed,args.windowLBoundX,args.windowLBoundY,args.windowUBoundX,args.windowUBoundY,args.steps,args.coulombCt,args.dpiInp,False)


print("[efield.py] END.")
exit(0)

