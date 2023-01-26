package org.scitool;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Modality;
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

    Stage stageMain = null;

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
        stage.setResizable(false);
        stage.show();
        stageMain = stage;
        logger.log("Show scene succeeded.");
    }

    public void launchAboutModal() {
        FXMLLoader fxmlLoader = new FXMLLoader(SciTool.class.getResource("about-view.fxml"));
        Scene scene = null;
        try {
            scene = new Scene(fxmlLoader.load());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Stage newWindow = new Stage();
        newWindow.setTitle("About");
        newWindow.setScene(scene);

        // Specifies the modality for new window.
        newWindow.initModality(Modality.WINDOW_MODAL);

    }

    public void stop() throws Exception {
        super.stop();
        logger.log("End of app.");
    }

    public static void main(String[] args) {
        launch();
    }

}