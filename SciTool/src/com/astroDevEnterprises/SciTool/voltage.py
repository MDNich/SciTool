#!/bin/python3
import matplotlib.pyplot as plt
import math
import numpy as np
import os

coulombCt1 = 9E9

inputsList = sys.argv

if len(inputsList) != 13:
    print("Error in parameters, no execution.")
    exit(0)
drawGraph(inputsList[1],inputsList[2],inputsList[3],inputsList[4],inputsList[5],inputsList[6],inputsList[7],inputsList[8],inputsList[9],inputsList[10],inputsList[11],inputsList[12])

def calculateDist(x1,x2,y1,y2):
	deltaX = x2-x1
	deltaY = y2-y1
	dist = math.sqrt(deltaY**2+deltaX**2)
	return dist


def potential(charges,point):
	pointx = point[0]
	pointy = point[1]
	chargesx = charges[0]
	chargesy = charges[1]
	chargesQ = charges[2]
	v = 0
	for i in range(len(chargesx)):
		if(calculateDist(chargesx[i],pointx,chargesy[i],pointy) == 0):
			continue
		tempv = coulombCt1*chargesQ[i]*1E-9/calculateDist(chargesx[i],pointx,chargesy[i],pointy)
		v+=tempv
	return v


def drawGraph(pathToSave,chargeXarr,chargeYarr,chargeQarr,windowLBoundX,windowLBoundY,windowUBoundX,windowUBoundY,steps,countourprec,coulombCt,dpiInp):
    charges = [chargeXarr,chargeYarr,chargeQarr]
    print(charges)
    fig, ax = plt.subplots()
    coulombCt1 = coulombCt
    volt = []
    xs = []
    x2s = []
    ys = []
    y2s = []
    volt2d = [[]]
    xlist = np.linspace(windowLBoundX,windowUBoundX,steps)
    ylist = np.linspace(windowLBoundY,windowUBoundY,steps)
    for j in xlist:
        for k in ylist:
            thisVolt = potential(charges,[j,k])
            if(thisVolt == 0):
                continue
            xs.append(j)
            ys.append(k)
            volt.append(thisVolt)
            volt2d[len(volt2d)-1].append(thisVolt)
        volt2d.append([])
    volt2d.remove(volt2d[len(volt2d)-1])
    ax.scatter(ys,xs,c=volt)
    cs = ax.contour(ylist,xlist,volt2d,levels=countourprec,cmap="hsv")
    ax.clabel(cs,inline=1,fontsize=8,inline_spacing=2)
    if os.path.isfile(str(pathToSave) + "result.png"):
        os.remove(str(pathToSave) + "result.png")   # Opt.: os.system("rm "+strFile)
    fig.savefig(str(pathToSave) + "result.png",dpi=dpiInp)
    volt = []
    xs = []
    x2s = []
    ys = []
    y2s = []
    volt2d = [[]]