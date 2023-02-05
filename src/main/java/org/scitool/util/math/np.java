package org.scitool.util.math;

import java.util.Arrays;

public class np { // making fun of numpy lol
    public static double[] linspace(double min, double max, int points) {
        double[] d = new double[points];
        double dx = max-min;
        dx /= points-1;
        System.out.println("Proceeding with interval from " + min + " to " + max + " with " + points + " steps, resulting in an interval of " + dx);
        for (int i = 0; i < points; i++){
            d[i] = min + i * dx;
        }
        //System.out.println("Resulting array:");
        //System.out.println(Arrays.toString(d));
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
        System.out.println();
        return new double[][]{xnew, ynew};
    }

    public static double max(double[] x) {
        double xmax = 0;
        for (int i = 0; i < x.length; i++) {
            if (x[i] > xmax) {
                xmax = x[i];
            }
        }
        return xmax;
    }

    public static double min(double[] x) {
        double xmin = 0;
        for (int i = 0; i < x.length; i++) {
            if (x[i] < xmin) {
                xmin = x[i];
            }
        }
        return xmin;
    }

    public static double[] normalize(double[] x) {
        return normalize(x,1);
    }


    public static double[] removeNanInfs(double[] x) {
        double[] xnew = new double[x.length];
        int j = 0;
        for (int i = 0; i < x.length; i++) {
            if(((x[i]) == Double.POSITIVE_INFINITY) || (Double.isNaN(Math.abs(x[i])))) {
                System.out.println("Skipping point due to positive infinity or NaN");
                continue;
            }
            else if(x[i] == Double.NEGATIVE_INFINITY) {
                System.out.println("Skipping point due to negative infinity");
                continue;
            }
            else {
                xnew[j] = x[i];
                j++;
            }
        }
        double[] xnew2 = new double[j];
        for (int i = 0; i < j; i++) {
            xnew2[i] = xnew[i];
        }
        return xnew2;
    }

    public static double[] normalize(double[] x, double max) {
        //System.out.println("Normalizing array " + Arrays.toString(x));

        double[] xnew = new double[x.length];
        double xmax = np.max(removeNanInfs(x));
        double xmin = np.min(removeNanInfs(x));
        System.out.println("Normalizing array with max " + xmax + " min " + xmin + " to " + max);
        for (int i = 0; i < x.length; i++) {
            if(((x[i]) == Double.POSITIVE_INFINITY) || (Double.isNaN(Math.abs(x[i])))) {
                System.out.println("Skipping point due to positive infinity or NaN");
                xnew[i] = max;
                continue;
            }
            else if(x[i] == Double.NEGATIVE_INFINITY) {
                System.out.println("Skipping point due to negative infinity");
                xnew[i] = 0;
                continue;
            }
            xnew[i] = max*(x[i]-xmin)/(xmax-xmin);
        }
        return xnew;
    }




    public static double[] gaussBlur_1 (double[] source, int w, int h, double r) {
        double[] result = new double[source.length];
        var rs = (int) Math.ceil(r * 2.57);     // significant radius
        for(var i=0; i<h; i++) {
            for(var j=0; j<w; j++) {
                double val = 0, wsum = 0;
                for(int iy = i-rs; iy<i+rs+1; iy++)
                    for(int ix = j-rs; ix<j+rs+1; ix++) {
                        int x = Math.min(w-1, Math.max(0, ix));
                        int y = Math.min(h-1, Math.max(0, iy));
                        double dsq = (ix-j)*(ix-j)+(iy-i)*(iy-i);
                        double wght = Math.exp( -dsq / (2*r*r) ) / (Math.PI*2*r*r);
                        val += source[y*w+x] * wght;  wsum += wght;
                    }
                result[i*w+j] = Math.round(val/wsum);
            }
        }
        return result;
    }

}
