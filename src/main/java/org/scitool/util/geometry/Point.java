package org.scitool.util.geometry;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class Point {
    int x;
    int y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
    public int[] getCoordinates() {
        return new int[]{x,y};
    }

    public Point applyTransformation(Transformation t) {
        x = t.applyToX(x);
        y = t.applyToY(y);
        return this;
    }

    public int x() {return x;}
    public int y() {return y;}


}
