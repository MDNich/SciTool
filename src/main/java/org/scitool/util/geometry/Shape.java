package org.scitool.util.geometry;

public abstract class Shape {
    public abstract String getName();

    public abstract Point[] getOutline(double thickness);

    public abstract Point[] getFilledShape(double thickness);

    public abstract Point[] getInterior(double thickness);
}
