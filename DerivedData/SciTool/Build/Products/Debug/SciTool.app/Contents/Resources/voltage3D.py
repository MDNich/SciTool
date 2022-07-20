import matplotlib.pyplot as plt
import math
import numpy as np
import plotly.graph_objects as go
import plotly.express as px




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


def drawGraph(pathToSave,chargeXarr,chargeYarr,chargeQarr,windowLBoundX,windowLBoundY,windowUBoundX,windowUBoundY,steps,coulombCt):
    #plt.ion()
    charges = [chargeXarr,chargeYarr,chargeQarr]
    print(charges)
    fig, ax = plt.subplots()
    coulombCt1 = coulombCt
    #ax = plt.axes(projection='3d')

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
            #print("x: " + str(j) + " y: " + str(k) + " d: " + str(calculateDist(charges[0][0],j,charges[1][0],k)))
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
    
    fig = go.Figure(data=[go.Scatter3d(
    x=xs,
    y=ys,
    z=volt,
    mode='markers',
    marker=dict(
        size=12,
        color=volt,                # set color to an array/list of desired values
        colorscale='Viridis',   # choose a colorscale
        opacity=0.8
    )
    )])

    # tight layout
    fig.update_layout(margin=dict(l=0, r=0, b=0, t=0))    
    fig.write_html(str(pathToSave) + "result.html") #Modifiy the html file
    #fig.show()
    # open test.html in browser.


    volt = []
    xs = []
    x2s = []
    ys = []
    y2s = []
    volt2d = [[]]


