package org.scitool.util.colormaps;

public abstract class Colormap {

    public String getName() {
        return this.getClass().getSimpleName();
    }
    public abstract float getRed(double i);

    public abstract float getGreen(double i);

    public abstract float getBlue(double i);
}
