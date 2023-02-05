package org.scitool.equipotential;

import java.awt.*;

public class Charge {

    double q;

    Point loc;

    public Charge(double q, Point loc) {
        this.q = q;
        this.loc = new Point(loc);
    }

    public Point getLoc() {
        return new Point(loc);
    }

    public double getChargeValue() {
        return q;
    }
}
