package org.scitool;

import de.jangassen.jfa.appkit.*;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.Pane;

import static org.scitool.SciTool.launchAboutModal;
import static org.scitool.SciTool.launchCreditsModal;

public class HomeController {

    @FXML
    public Pane backgroundPane;
    @FXML
    public Button exploreTools;
    @FXML
    public Button Equipot2D;
    @FXML
    public Button aboutButton;
    @FXML
    public Button creditsButton;

    @FXML
    public Button websiteButton;


    @FXML
    protected void runExploreTools() {

        SciTool.logger.log("Home: Explore Called");
    }
    @FXML
    protected void runEquipot2D() {
        SciTool.logger.log("Home: Equipot2D Called");
    }
    @FXML
    protected void runAbout() {
        SciTool.logger.log("Home: About Called");
        launchAboutModal();
    }
    @FXML
    protected void runCredits() {
        SciTool.logger.log("Home: Credits Called");
        launchCreditsModal();
    }

    @FXML
    protected void runWebsite() {
        SciTool.logger.log("Home: Website Called");
    }
}