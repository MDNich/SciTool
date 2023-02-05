package org.scitool.util.colormaps;

public class YellowGreenBlue extends Colormap {

    public YellowGreenBlue() {

    }


    @Override
    public float getRed(double i) {
        float i2 = (float) i;
        //System.out.println("Returning red value " + 1*Math.pow(i2,2) + " for input i= " + i2);
        return (float) Math.min(Math.pow(i2,2),1);
    }

    @Override
    public float getGreen(double i) {
        float i2 = (float) i;
        //System.out.println("Returning green value " + 1*Math.pow(i,.5) + " for input i= " + i);
        return (float) Math.min(Math.pow(i2,.5),1);
    }

    @Override
    public float getBlue(double i) {
        float i2 = (float) i;
        //System.out.println("Returning blue value " + (-i+1) + " for input i= " + i);
        return (float) Math.min((-i+1),1);
    }
}
