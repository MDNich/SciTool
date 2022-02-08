import matplotlib.pyplot as plt
import math
import numpy as np





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
		tempv = 9*10**(-1)*chargesQ[i]/calculateDist(chargesx[i],pointx,chargesy[i],pointy)
		v+=tempv
	return v;


def drawGraph(pathToSave):
    charges = [[0,.5],[0,.5],[5,-5]]

    #ax = plt.axes(projection='3d')

    volt = []
    xs = []
    x2s = []
    ys = []
    y2s = []
    volt2d = [[]]

    xlist = np.linspace(-.5,1.5,60)
    ylist = np.linspace(-.5,1.5,60)

    for j in xlist:
        for k in ylist:
            print("x: " + str(j) + " y: " + str(k) + " d: " + str(calculateDist(charges[0][0],j,charges[1][0],k)))
            thisVolt = potential(charges,[j,k])
            if(thisVolt == 0):
                continue
            xs.append(j)
            ys.append(k)
            volt.append(thisVolt)
            volt2d[len(volt2d)-1].append(thisVolt)
            #print("x: " + str(j) + " y: " + str(k) + " v: " + str(volt))
        volt2d.append([])
    volt2d.remove(volt2d[len(volt2d)-1])
    print(volt2d)
    #ax.scatter3D(xs,ys,volt,c=volt)
    plt.scatter(xs,ys,c=volt)
    cs = plt.contour(ylist,xlist,volt2d,levels=200,cmap="hsv")
    plt.clabel(cs,inline=1,fontsize=8,inline_spacing=2)
    #ax.scatter3D(charges[0],charges[1],0,c=charges[2],marker="X")
    plt.savefig(str(pathToSave) + "result.png")

