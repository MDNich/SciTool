package org.scitool;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URL;

public class SciTool extends Application {

    public static File logFile = null;


    public static LogWriter logger = null;
    @Override
    public void start(Stage stage) throws IOException {
        try {
            URL iconURL = SciTool.class.getResource("Icon.png");
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
            Image image = new ImageIcon(iconURL).getImage();
            com.apple.eawt.Application.getApplication().setDockIconImage(image);
        } catch (Exception e) {
            System.out.println("Icon failed");
            logger.log("Icon failed.");

            // Won't work on Windows or Linux.
        }

        FXMLLoader fxmlLoader = new FXMLLoader(SciTool.class.getResource("home-view.fxml"));
        Scene scene = new Scene(fxmlLoader.load());//, 320, 240);
        stage.setTitle("Welcome!");
        stage.initStyle(StageStyle.DECORATED);
        stage.setScene(scene);
        stage.show();
        logger.log("Show scene succeeded.");
    }

    public static void main(String[] args) {
        launch();
    }

}