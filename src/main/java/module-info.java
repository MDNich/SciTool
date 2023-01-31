module org.scitool.scitool {
    requires javafx.controls;
    requires javafx.fxml;

    requires org.controlsfx.controls;
    requires org.kordamp.ikonli.javafx;
    requires java.desktop;
    requires com.sun.jna.platform;
    requires java.logging;
    requires jfa;
    requires nsmenufx;
    opens org.scitool to javafx.fxml;
    exports org.scitool;
}