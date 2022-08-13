package com.astroDevEnterprises.SciTool;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import static java.lang.Thread.sleep;

public class Main {
    static PythonRunner pyEngine;

    static JFrame app;
    static Splash splashObj;
    static Home homeObj;
    static voltageContour voltageContourObj;

    static Timer timer = null;

    public static void main(String[] args) {
        app = new JFrame("Splash");
        splashObj = new Splash();
        app.setContentPane(splashObj.panelMain);
        app.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        app.setSize(250, 200);
        splashObj.continueButton.setEnabled(false);
        app.setVisible(true);
        beginProgressBar();
        pyEngine = new PythonRunner();

    }
    public static void beginProgressBar()
    {
        timer = new Timer(20, new UpdateBarListener());
        app.setVisible(true);
        System.out.println("done1");
        timer.start();
        new Thread(()->{
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {

            }
            println("done2");
            splashObj.continueButton.setEnabled(true);

        }).start();


    }
    public static void switchToHome()
    {
        homeObj = new Home();
        app.setContentPane(homeObj.panelMain);
        app.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        app.setSize(500, 300);
        app.setVisible(true);
    }
    public static void presentVoltageContour()
    {
        voltageContourObj = new voltageContour();
        app.setContentPane(voltageContourObj.panelMain);
        app.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        app.setSize(700, 500);
        app.setVisible(true);
    }
    public static void updateVoltageContourImage()
    {
        /*
        let arr = [PythonObject.StringLiteralType(dirPathSave),PythonObject.ArrayLiteralElement(ys),PythonObject.ArrayLiteralElement(xs),PythonObject.ArrayLiteralElement(qs),PythonObject.FloatLiteralType(Double(WindowLowerX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowLowerY.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperY.stringValue)!),PythonObject.IntegerLiteralType(Int(CounterNumber.stringValue)!),PythonObject.FloatLiteralType(Double(CoulombConstant.stringValue)!)] as [PythonConvertible]
        try engine.drawGraph.throwing.dynamicallyCall(withArguments: arr)
        */
        pyEngine.runContourGivenInputs(getInputsFromSwingForContour());


        String tmpdir = System.getProperty("java.io.tmpdir");
        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(tmpdir + "/voltage.png"));
            ImageIcon icon = new ImageIcon(img);
            voltageContourObj.imageView.setIcon(icon);
        } catch (IOException e) {
           // throw new RuntimeException(e);
            println("File not found.");
        }
    }

    public static Object[] getInputsFromSwingForContour()
    {
        return new Object[]{};
    }





    public static void println(Object s)
    {
        System.out.println(s);
    }
    private static class UpdateBarListener implements ActionListener {

        @Override
        public void actionPerformed(ActionEvent e) {

            int val = splashObj.progressBar1.getValue();

            if (val >= 100) {

                timer.stop();
                return;
            }

            splashObj.progressBar1.setValue(++val);
        }
    }

}

