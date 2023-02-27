/* ===========================
 * TimeSeriesChartFXDemo1.java
 * ===========================
 *
 * Copyright 2014-2022 by David Gilbert. All rights reserved.
 *
 * https://github.com/jfree/jfree-fxdemos
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   - Neither the name of the Object Refinery Limited nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL OBJECT REFINERY LIMITED BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 */

package org.scitool.equipotential;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.stage.Stage;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.fx.ChartViewer;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.xy.DefaultXYDataset;
import org.jfree.data.xy.XYSeries;
import org.scitool.LogWriter;
import org.scitool.MarchingSquares;
import org.scitool.util.colormaps.Colormap;
import org.scitool.util.colormaps.RosySunset;
import org.scitool.util.colormaps.YellowGreenBlue;
import org.scitool.util.geometry.Circle;
import org.scitool.util.geometry.Point;
import org.scitool.util.geometry.Translation;
import org.scitool.util.math.np;

import javax.imageio.ImageIO;

import java.awt.*;
import java.awt.geom.GeneralPath;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * A demo showing the display of JFreeChart within a JavaFX application.
 *
 * The ChartCanvas code is based on: 
 * <a href="http://dlemmermann.wordpress.com/2014/04/10/javafx-tip-1-resizable-canvas/">http://dlemmermann.wordpress.com/2014/04/10/javafx-tip-1-resizable-canvas/</a>
 *
 */
public class EquipotentialPlotterTest extends Application {


    public static File logFile = null;
    public static LogWriter logger = null;



    public static final double COULOMB_CONSTANT = 9e9;

    private static double[] getVoltage(double[][] xyqdata, double[] xpoints, double[] ypoints) {

        double[] v = new double[xpoints.length];
        for (int j = 0; j < xpoints.length; j++) {
            double vtmp = 0;
            for (int i = 0; i < xyqdata[0].length; i++) {
                double xi = xyqdata[0][i];
                double yi = xyqdata[1][i];
                double qi = xyqdata[2][i];
                double r = Math.sqrt(Math.pow(xi-xpoints[j],2)+Math.pow(yi-ypoints[j],2));
                //System.out.println("r = " + r);
                //System.out.println("Voltage due to (" + xi + "," + yi + ") with charge " + qi + " is " + COULOMB_CONSTANT*qi/r);

                vtmp += COULOMB_CONSTANT*qi/r;
            }
            //System.out.println("Total voltage at (" + xpoints[j] + "," + ypoints[j] + ") is " + vtmp + " V");
            v[j] = vtmp;
        }
        return v;
    }





    public static Color[] interpolateColorsFromArray(double[] data, Colormap colormap) {
        Color[] colors = new Color[data.length];
        double[] newdata = np.normalize(data);
        System.out.println("Colormap: " + colormap.getName());
        for (int i = 0; i < data.length; i++) {
            //System.out.println("Color for index "+i+" and normalized input " + newdata[i] + " is [" + colormap.getRed(newdata[i]) + "," + colormap.getGreen(newdata[i]) + "," + colormap.getBlue(newdata[i]) + "]");
            try {
                colors[i] = new Color((float) colormap.getRed(newdata[i]), (float) colormap.getGreen(newdata[i]), (float) colormap.getBlue(newdata[i]));
            }
            catch(Exception e) {
                colors[i] = new Color((float)  Math.min(255,colormap.getRed(newdata[i])), (float)  Math.min(colormap.getGreen(newdata[i]),255), (float)  Math.min(colormap.getBlue(newdata[i]),255));
            }
        }
        return colors;
    }



    /**
     * Creates a dataset, consisting of two series of monthly data.
     *
     * @return the dataset.
     */
    private static JFreeChart createDatasetAndChart() {

        DefaultXYDataset v = new DefaultXYDataset();

        XYSeries v1 = new XYSeries("Voltage");

        int size = 1001;

        double[] xcoords = np.linspace(-1,1,size);
        double[] ycoords = np.linspace(-1,1,size);
        double[][] xymeshed = np.meshgrid2d(xcoords,ycoords);
        //logger.log(Arrays.deepToString(xymeshed));
        //double[] xmeshed = xymeshed[0];
        //double[] ymeshed = xymeshed[1];
        //assert xmeshed.length == ymeshed.length;
        //for (int i = 0; i < xmeshed.length; i++) {
        //    v1.add(xmeshed[i],ymeshed[i]);
        //}

        double[] qArr = new double[]{1.0,-1.0};
        double[] xArr = new double[]{-.5,.5};
        double[] yArr = new double[]{-.5,.5};

        double[] voltageMeshed = getVoltage(new double[][]{xArr,yArr,qArr},xymeshed[0],xymeshed[1]);

        //double[] voltageBlurred = np.gaussBlur_1(voltageMeshed, xcoords.length, ycoords.length,10);

        Color[] colors = interpolateColorsFromArray(voltageMeshed, new RosySunset());
        //Color[] colors = interpolateColorsFromArray(voltageBlurred, new RosySunset());

        double[][] normalizedNonMeshedData = new double[xcoords.length][ycoords.length];

        int xLength = xcoords.length;
        int yLength = ycoords.length;
        BufferedImage b = new BufferedImage(xLength, yLength, 3);



        for(int x = 0; x < xLength; x++) {
            for(int y = 0; y < yLength; y++) {
                b.setRGB(x, y, colors[x*yLength+y].getRGB());
                normalizedNonMeshedData[x][y] = RosySunset.getIfromRed(colors[x*yLength+y].getRed());
            }
        }

        Graphics g2d = b.getGraphics();
        Point a = new Point(-10,-10).applyTransformation(new Translation(b.getWidth()/2, b.getHeight()/2));
        Point c = new Point(10,10).applyTransformation(new Translation(b.getWidth()/2, b.getHeight()/2));
        g2d.drawLine(a.getCoordinates()[0],a.getCoordinates()[1],c.getCoordinates()[0],c.getCoordinates()[1]);
        //g2d.drawOval(b.getWidth()/2-50,b.getHeight()/2-25,100,50);


        Point[] d = new Circle(0,0,100).getOutline(1);
        g2d.setColor(new Color(0,0,0));
        for(int i = 0; i < d.length; i++) {
            d[i].applyTransformation(new Translation(b.getWidth()/2, b.getHeight()/2));
        }

        //
        for(int i = 0; i < d.length-2; i++) {
            System.out.println(d[i].x()+ " "+ d[i].y());
            System.out.println(d[i+2].x()+ " "+ d[i+2].y());
            g2d.drawLine(d[i].x(),d[i].y(),d[i+2].x(),d[i+2].y());
        }

        /*for(Point e : new Circle(0,0,10).getOutline(3)) {
            System.out.println("Drawing point at coordinates " + Arrays.toString(e.getCoordinates()));
            e.applyTransformation(new Translation(b.getWidth()/2, b.getHeight()/2));
            System.out.println(e.getCoordinates());
            b.setRGB(e.getCoordinates()[0],e.getCoordinates()[1],new Color(0,0,0).getRGB());
        }*/









        System.out.println("Init marching squares.");



        System.out.println("writing image to file");

        try {
            ImageIO.write(b, "png", new File("/tmp/imgtmp.png"));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        File file = new File("/tmp/imgtmp.png");
        Desktop desktop = Desktop.getDesktop();
        if(file.exists()) {
            try {
                desktop.open(file);
            } catch (IOException e) {
                System.out.println("hi");
            }
        }
        System.exit(0);


        /*MarchingSquares counterer = new MarchingSquares();

        double[] thresholds = new double[]{-1,-2,-3,0,1,2,3};
        // colorsNonMeshed

        GeneralPath[] isolines = counterer.mkIsos(normalizedNonMeshedData,thresholds);
        System.out.println("Isolines done.");

        AffineTransform xf = new AffineTransform();
        xf.translate(0, 0);
        xf.scale(1,1);
        xf.translate(-1, -1); // Because MxN data was padded to (M+2)x(N+2).
        Graphics2D g2 = b.createGraphics();
        System.out.println("graphics created done.");

        Colormap cmap2 = new YellowGreenBlue();
        for (int i = 0; i < isolines.length; i++) {
            isolines[i].transform(xf); // Permanent mapping to world coords.
            Shape iso = xf.createTransformedShape(isolines[i]); // Remapped every pan & zoom.
            g2.setColor(new Color(cmap2.getRed(((float) i )/(isolines.length-1)),cmap2.getGreen(((float) i )/(isolines.length-1)),cmap2.getBlue(((float) i )/(isolines.length-1))));
            g2.draw(iso); // Outline iso.
        }
        */







        DefaultXYDataset dataset = new DefaultXYDataset();
        dataset.addSeries("Voltage",xymeshed);


        JFreeChart chart = ChartFactory.createScatterPlot(
                "",
                null,
                null,
                dataset
        );
        chart.removeLegend();
        String fontName = "Palatino";
        chart.getTitle().setFont(new Font(fontName, Font.BOLD, 18));
        //chart.addSubtitle(new TextTitle("Source: http://www.ico.org/historical/2010-19/PDF/HIST-PRICES.pdf",
        //         new Font(fontName, Font.PLAIN, 14)));

        XYPlot plot = (XYPlot) chart.getPlot();
        //plot.setDomainPannable(true);
        //plot.setRangePannable(true);
        //plot.setDomainCrosshairVisible(true);
        //plot.setRangeCrosshairVisible(true);
        plot.getDomainAxis().setRange(-1,1);
        plot.getRangeAxis().setRange(-1,1);
        //plot.getDomainAxis().setLabelFont(new Font(fontName, Font.BOLD, 14));
        //plot.getDomainAxis().setTickLabelFont(new Font(fontName, Font.PLAIN, 12));
        //plot.getRangeAxis().setLabelFont(new Font(fontName, Font.BOLD, 14));
        //plot.getRangeAxis().setTickLabelFont(new Font(fontName, Font.PLAIN, 12));
        //chart.getLegend().setItemFont(new Font(fontName, Font.PLAIN, 14));
        //chart.getLegend().setFrame(BlockBorder.NONE);
        //chart.getLegend().setHorizontalAlignment(HorizontalAlignment.CENTER);
        XYLineAndShapeRenderer customRenderer = new XYLineAndShapeRenderer(false, true) {

            @Override
            public Paint getItemPaint(int row, int column) {
                //System.out.println("Setting color for row " + row + " and column " + column + " to " + colors[column].toString() + ".");
                return colors[column];
            }
        };
        double sizer = 4.0;
        double delta = sizer / 2.0;
        Shape shape = new Rectangle2D.Double(-delta, -delta, sizer, sizer);
        customRenderer.setSeriesShape(0, shape);
        plot.setRenderer(customRenderer);


        /*XYItemRenderer r = plot.getRenderer();
        if (r instanceof XYLineAndShapeRenderer) {
            XYLineAndShapeRenderer renderer = (XYLineAndShapeRenderer) r;
            renderer.setDefaultShapesVisible(false);
            renderer.setDrawSeriesLineAsPath(true);
            // set the default stroke for all series
            renderer.setAutoPopulateSeriesStroke(false);
            renderer.setDefaultStroke(new BasicStroke(3.0f));
            renderer.setSeriesPaint(0, new Color(1,0,0));
        }*/

        return chart;


    }

    @Override 
    public void start(Stage stage) {

        try {

            File newFile = new File("/tmp/log_scitool.txt"); // create, or fetch if previously created.
            if (newFile.delete()) {
                System.out.println("Deleted the old log file: " + newFile.getName());
            } else {
                System.out.println("Failed to delete the old log file.");
            }
            newFile = new File("/tmp/log_scitool.txt"); // create again
            System.out.println("Fetched resources.");
            logFile = newFile;
            logger = new LogWriter(logFile);
            System.out.println("Fetched logfile.");
            logger.log("Running Start Method.");
            //com.apple.eawt.Application.getApplication().setDockIconImage(image);

        } catch (Exception e) {
            System.out.println("Icon failed");
            logger.log("Start failed.");

            // Won't work on Windows or Linux.
        }




        //viewer.getCanvas().setRangeZoomable(false);
        //viewer.getCanvas().setDomainZoomable(false);
        //viewer.getCanvas().removeMouseHandler(viewer.getCanvas().getMouseHandler("zoom"));
        JFreeChart chart = createDatasetAndChart();
        ChartViewer viewer = new ChartViewer(chart);

        BufferedImage img = chart.createBufferedImage(2048,2048);
        try {
            ImageIO.write(img, "png", new File("/tmp/chart.png"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        File file = new File("/tmp/chart.png");
        Desktop desktop = Desktop.getDesktop();
        if(file.exists()) {
            try {
                desktop.open(file);
            } catch (IOException e) {
                System.out.println("hi");
            }
        }



        stage.setScene(new Scene(viewer));
        stage.setTitle("EquipotentialPlot2D");
        stage.setWidth(700);
        stage.setHeight(390);
        stage.show();
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        JFreeChart chart = createDatasetAndChart();

        BufferedImage img = chart.createBufferedImage(4096,4096,512,512,null);
        try {
            ImageIO.write(img, "png", new File("/tmp/chart.png"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        File file = new File("/tmp/chart.png");
        Desktop desktop = Desktop.getDesktop();
        if(file.exists()) {
            try {
                desktop.open(file);
            } catch (IOException e) {
                System.out.println("hi");
            }
        }
        System.exit(0);

        //launch(args);
    }
  
}

