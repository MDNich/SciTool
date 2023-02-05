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
import org.jfree.chart.block.BlockBorder;
import org.jfree.chart.fx.ChartViewer;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYItemRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.chart.ui.HorizontalAlignment;
import org.jfree.data.xy.DefaultXYDataset;
import org.jfree.data.xy.XYDataset;
import org.jfree.data.xy.XYSeries;
import org.scitool.LogWriter;
import org.scitool.util.math.np;
import static org.scitool.SciTool.logger;
import java.awt.*;
import java.io.File;
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

    /**
     * Creates a dataset, consisting of two series of monthly data.
     *
     * @return the dataset.
     */
    private static JFreeChart createDatasetAndChart() {

        DefaultXYDataset v = new DefaultXYDataset();

        XYSeries v1 = new XYSeries("Voltage");

        double[] xcoords = np.linspace(-1,1,11);
        double[] ycoords = np.linspace(-1,1,11);
        double[][] xymeshed = np.meshgrid2d(xcoords,ycoords);
        logger.log(Arrays.deepToString(xymeshed));
        //double[] xmeshed = xymeshed[0];
        //double[] ymeshed = xymeshed[1];
        //assert xmeshed.length == ymeshed.length;
        //for (int i = 0; i < xmeshed.length; i++) {
        //    v1.add(xmeshed[i],ymeshed[i]);
        //}


        DefaultXYDataset dataset = new DefaultXYDataset();
        dataset.addSeries("Voltage",xymeshed);


        JFreeChart chart = ChartFactory.createScatterPlot(
                "Equipotential Lines",
                null,
                null,
                dataset
        );

        String fontName = "SF Pro Display";
        chart.getTitle().setFont(new Font(fontName, Font.BOLD, 18));
        //chart.addSubtitle(new TextTitle("Source: http://www.ico.org/historical/2010-19/PDF/HIST-PRICES.pdf",
        //         new Font(fontName, Font.PLAIN, 14)));

        XYPlot plot = (XYPlot) chart.getPlot();
        plot.setDomainPannable(true);
        plot.setRangePannable(true);
        plot.setDomainCrosshairVisible(true);
        plot.setRangeCrosshairVisible(true);
        plot.getDomainAxis().setLowerMargin(0.0);
        plot.getDomainAxis().setLabelFont(new Font(fontName, Font.BOLD, 14));
        plot.getDomainAxis().setTickLabelFont(new Font(fontName, Font.PLAIN, 12));
        plot.getRangeAxis().setLabelFont(new Font(fontName, Font.BOLD, 14));
        plot.getRangeAxis().setTickLabelFont(new Font(fontName, Font.PLAIN, 12));
        chart.getLegend().setItemFont(new Font(fontName, Font.PLAIN, 14));
        chart.getLegend().setFrame(BlockBorder.NONE);
        chart.getLegend().setHorizontalAlignment(HorizontalAlignment.CENTER);
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



        JFreeChart chart = createDatasetAndChart();
        ChartViewer viewer = new ChartViewer(chart);
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
        launch(args);
    }
  
}

