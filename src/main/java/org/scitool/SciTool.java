package org.scitool;

import de.jangassen.MenuToolkit;
import de.jangassen.jfa.appkit.NSAppearance;
import de.jangassen.jfa.appkit.NSApplication;
import de.jangassen.jfa.appkit.NSMenu;
import de.jangassen.jfa.foundation.Foundation;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.layout.Background;
import javafx.scene.layout.BorderPane;
import javafx.scene.paint.Color;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
//import de.jangassen.MenuToolkit;
import javafx.scene.control.MenuItem;
import javafx.stage.WindowEvent;
import org.controlsfx.control.action.Action;
import org.scitool.equipotential.Plotter;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.util.Locale;
import java.util.logging.Logger;


public class SciTool extends Application {


    public static Stage aboutWindowRef = null;
    public static Stage creditWindowRef = null;

    public static boolean isAboutWindowShowing = false;
    public static boolean isCreditWindowShowing = false;

    public static File logFile = null;

    public JMenuBar menuBar = null;

    static Stage stageMain = null;

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
        //tk.setApplicationMenu(tk.createDefaultApplicationMenu("SciTool"));



        /*final OsThemeDetector detector = OsThemeDetector.getDetector();
        detector.registerListener(isDark -> {
            Platform.runLater(() -> {
                if (isDark) {
                    logger.log("Dark Theme");
                    // The OS switched to a dark theme
                } else {
                    logger.log("Light Theme");

                    // The OS switched to a light theme
                }
            });
        });*/





        BorderPane border = new BorderPane();
        String os = System.getProperty("os.name");
        logger.log("Got OS " + os + " with version " + System.getProperty("os.version"));
        logger.log("Mac OS ? " + os.equals("Mac OS X"));
        if(os.equals("Mac OS X"))
        {
            MenuBar menuBar = new MenuBar();
            menuBar.useSystemMenuBarProperty().set(true);

            Menu main = new Menu("SciTool");
            MenuItem about = new MenuItem("About SciTool");
            MenuItem credits = new MenuItem("Credits");
            about.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent actionEvent) {
                    logger.log("About Menu Called from Menu Bar");
                    launchAboutModal();
                }
            });
            credits.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent actionEvent) {
                    logger.log("Credits Menu Called from Menu Bar");
                    launchCreditsModal();
                }
            });

            Menu help = new Menu("Help");
            main.getItems().add(about);
            main.getItems().add(credits);
            menuBar.getMenus().addAll(main, help);
            border.setTop(menuBar);


            String version = System.getProperty("os.version");
            String[] pieces = version.split("\\.");
            logger.log(pieces[0]);
            logger.log(pieces[1]);
            if (Integer.parseInt(pieces[0]) == 10) {
                if(Integer.parseInt(pieces[1]) < 14) {
                    logger.log("OS does not support dark mode, skipping.");
                }
                else {
                    NSApplication.sharedApplication().setAppearance(NSAppearance.appearanceNamed(NSAppearance.NSAppearanceName.NSAppearanceNameAqua));
                }
            }
            else {
                NSApplication.sharedApplication().setAppearance(NSAppearance.appearanceNamed(NSAppearance.NSAppearanceName.NSAppearanceNameAqua));
            }

        }


        FXMLLoader fxmlLoader = new FXMLLoader(SciTool.class.getResource("home-view.fxml"));
        Node fxmlOut = fxmlLoader.load();
        border.setCenter(fxmlOut);
        Scene scene = new Scene(border);//, 320, 240);
        stage.setTitle("Welcome!");
        stage.initStyle(StageStyle.DECORATED);
        //border.setBackground(Background.fill(new Color(0.2,0.2,0.21,1)));
        stage.setScene(scene);
        stage.setResizable(false);
        stage.show();
        stageMain = stage;
        System.setProperty( "apple.awt.application.name", "SciTool" );
        logger.log("Show scene succeeded.");

    }

    public static void closeHomeAndExplore() {
        stageMain.close();

        FXMLLoader fxmlLoader = new FXMLLoader(SciTool.class.getResource("launcher-view.fxml"));
        Scene scene = null;
        try {
            scene = new Scene(fxmlLoader.load());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Stage newWindow = new Stage();
        newWindow.setTitle("SciTool Launcher");
        newWindow.setScene(scene);
        logger.log("Scene set");
        newWindow.show();

    }

    public static void launchAboutModal() {
        if(isAboutWindowShowing) {
            logger.log("About window already showing");
            aboutWindowRef.hide();
            aboutWindowRef.show();
            return;
        }
        FXMLLoader fxmlLoader = new FXMLLoader(SciTool.class.getResource("about-view.fxml"));
        Scene scene = null;
        try {
            scene = new Scene(fxmlLoader.load());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Stage newWindow = new Stage();
        newWindow.setTitle("");
        newWindow.setScene(scene);
        logger.log("Scene set");

        // Specifies the modality for new window.
        newWindow.initModality(Modality.WINDOW_MODAL);
        newWindow.show();
        aboutWindowRef = newWindow;
        aboutWindowRef.setAlwaysOnTop(true);

        newWindow.setOnCloseRequest(new EventHandler<WindowEvent>() {
            @Override
            public void handle(WindowEvent event) {
                isAboutWindowShowing = false;
                logger.log("About window closing");
            }
        });
        isAboutWindowShowing = true;

    }

    public static void launchCreditsModal() {
        if(isCreditWindowShowing) {
            logger.log("Credits window already showing");
            creditWindowRef.hide();
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            creditWindowRef.show();
            return;
        }
        FXMLLoader fxmlLoader = new FXMLLoader(SciTool.class.getResource("credits-view.fxml"));
        Scene scene = null;
        try {
            scene = new Scene(fxmlLoader.load());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Stage newWindow = new Stage();
        newWindow.setTitle("");
        newWindow.setScene(scene);
        logger.log("Scene set");

        // Specifies the modality for new window.
        newWindow.initModality(Modality.WINDOW_MODAL);
        newWindow.show();
        creditWindowRef = newWindow;
        creditWindowRef.setAlwaysOnTop(true);

        newWindow.setOnCloseRequest(new EventHandler<WindowEvent>() {
            @Override
            public void handle(WindowEvent event) {
                isCreditWindowShowing = false;
                logger.log("Credit window closing");
            }
        });
        isCreditWindowShowing = true;

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