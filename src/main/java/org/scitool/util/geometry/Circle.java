package org.scitool.util.geometry;

import java.util.ArrayList;

public class Circle extends Shape{

    int centerX,centerY,radius;

    public Circle(int centerX, int centerY, int radius) {
        this.centerX = centerX;
        this.centerY = centerY;
        this.radius = radius;
    }
    @Override
    public String getName() {
        return "Circle";
    }

    @Override
    public Point[] getOutline(double thickness) {
        ArrayList<Point> pts = new ArrayList<>();
        for(double ii = centerX-radius; ii < centerX+radius+1; ii+=1) {
            int i = (int) ii;
            pts.add(new Point(i, (int) Math.round(Math.sqrt(radius*radius-i*i))));
            pts.add(new Point(i, -1 * (int) Math.round(Math.sqrt(radius*radius-i*i))));
            if(thickness > 1) {
                for (int j = 0; j < thickness; j++) {
                    for (int k = 0; k < thickness; k++) {
                        pts.add(new Point(k+i, j + (int) Math.round(Math.sqrt(radius * radius - i * i))));
                        pts.add(new Point(-k+i, j + (int) Math.round(Math.sqrt(radius * radius - i * i))));
                        pts.add(new Point(k+i, -j + (int) Math.round(Math.sqrt(radius * radius - i * i))));
                        pts.add(new Point(-k+i, -j + (int) Math.round(Math.sqrt(radius * radius - i * i))));

                        pts.add(new Point(k+i, j + -1* (int) Math.round(Math.sqrt(radius * radius - i * i))));
                        pts.add(new Point(-k+i, j + -1* (int) Math.round(Math.sqrt(radius * radius - i * i))));
                        pts.add(new Point(k+i, -j + -1* (int) Math.round(Math.sqrt(radius * radius - i * i))));
                        pts.add(new Point(-k+i, -j + -1* (int) Math.round(Math.sqrt(radius * radius - i * i))));
                    }

                }
            }
        }
        Point[] a = new Point[pts.size()];
        pts.toArray(a);
        return a;
    }

    @Override
    public Point[] getFilledShape(double thickness) {
        return new Point[]{};
    }

    @Override
    public Point[] getInterior(double thickness) {
        return new Point[]{};
    }
}
