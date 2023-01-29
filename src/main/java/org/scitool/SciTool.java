package org.scitool;

import de.jangassen.MenuToolkit;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.layout.BorderPane;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
//import de.jangassen.MenuToolkit;
import javafx.scene.control.MenuItem;


import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.util.Locale;

public class SciTool extends Application {

    public static File logFile = null;

    public JMenuBar menuBar = null;

    Stage stageMain = null;

    public static LogWriter logger = null;
    @Override
    public void start(Stage stage) throws IOException {
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
        try {
            final Taskbar taskbar = Taskbar.getTaskbar();
            final Toolkit defaultToolkit = Toolkit.getDefaultToolkit();

            try {
                //set icon for mac os (and other systems which do support this method)
                String currentPath = new java.io.File(".").getCanonicalPath();
                logger.log("Current dir:" + currentPath);
                File tmp = new File(currentPath + "/Icon.png");
                Image image = ImageIO.read(tmp);// new ImageIcon(iconURL).getImage();
                //getClass().getResource()
                taskbar.setIconImage(image);
                menuBar = new JMenuBar();
            } catch (final UnsupportedOperationException e) {
                System.out.println("The os does not support: 'taskbar.setIconImage'");
            } catch (final SecurityException e) {
                System.out.println("There was a security exception for: 'taskbar.setIconImage'");
            }

        }
        catch (Exception e) {
            logger.log(e.toString());
            logger.log("Icon2 Failed.");
        }
        //MenuToolkit tk = MenuToolkit.toolkit(Locale.getDefault());
        //tk.setApplicationMenu(tk.createDefaultApplicationMenu("test"));

        MenuBar menuBar = new MenuBar();
        menuBar.useSystemMenuBarProperty().set(true);

        Menu menu = new Menu("SciTool");
        MenuItem item = new MenuItem("About SciTool");

        Menu help = new Menu("Help");
        menu.getItems().add(item);
        menuBar.getMenus().addAll(menu, help);



        FXMLLoader fxmlLoader = new FXMLLoader(SciTool.class.getResource("home-view.fxml"));
        Node fxmlOut = fxmlLoader.load();
        BorderPane border = new BorderPane();
        border.setTop(menuBar);
        border.setCenter(fxmlOut);
        Scene scene = new Scene(border);//, 320, 240);
        stage.setTitle("Welcome!");
        stage.initStyle(StageStyle.DECORATED);


        stage.setScene(scene);
        stage.setResizable(false);
        stage.show();
        stageMain = stage;
        System.setProperty( "apple.awt.application.name", "SciTool" );
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
        System.setProperty( "apple.laf.useScreenMenuBar", "true" );
        System.setProperty("apple.awt.application.name","true");


        Desktop desktop = Desktop.getDesktop();
        if( desktop.isSupported( Desktop.Action.APP_ABOUT ) ) {
            desktop.setAboutHandler( e -> {
                // show about dialog
            } );
        }
        if( desktop.isSupported( Desktop.Action.APP_PREFERENCES ) ) {
            desktop.setPreferencesHandler( e -> {
                // show preferences dialog
            } );
        }
        if( desktop.isSupported( Desktop.Action.APP_QUIT_HANDLER ) ) {
            desktop.setQuitHandler( (e, response) -> {
                boolean canQuit = true;// TODO
                if( canQuit )
                    response.performQuit();
                else
                    response.cancelQuit();
            } );
        }
        launch();
    }

}