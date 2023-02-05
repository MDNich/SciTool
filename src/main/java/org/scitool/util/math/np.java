package org.scitool.util.math;

public class np { // making fun of numpy lol
    public static double[] linspace(double min, double max, int points) {
        double[] d = new double[points];
        for (int i = 0; i < points; i++){
            d[i] = min + i * (max - min) / (points - 1);
        }
        return d;
    }

    public static double[][] meshgrid2d(double[] x, double[] y) {
        double[] xnew = new double[x.length*y.length];
        double[] ynew = new double[x.length*y.length];
        for (int i = 0; i < x.length; i++) {
            int i2 = i*y.length;
            for (int j = 0; j < y.length; j++) {
                xnew[i2+j] = x[i];
                ynew[i2+j] = y[j];
            }
        }
        return new double[][]{xnew, ynew};
    }
}
