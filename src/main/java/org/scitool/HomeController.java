package org.scitool;

import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;

public class HomeController {
    @FXML
    private Button exploreTools;
    @FXML
    private Button Equipot2D;
    @FXML
    private Button aboutButton;
    @FXML
    private Button creditsButton;

    @FXML
    private Button websiteButton;

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
    }
    @FXML
    protected void runCredits() {
        SciTool.logger.log("Home: Credits Called");
    }

    @FXML
    protected void runWebsite() {
        SciTool.logger.log("Home: Website Called");
    }
}