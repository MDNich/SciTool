module org.scitool.scitool {
    requires javafx.controls;
    requires javafx.fxml;

    requires org.controlsfx.controls;
    requires org.kordamp.ikonli.javafx;
    requires java.desktop;

    opens org.scitool to javafx.fxml;
    exports org.scitool;
}