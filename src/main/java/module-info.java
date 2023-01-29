module org.scitool.scitool {
    requires javafx.controls;
    requires javafx.fxml;

    requires org.controlsfx.controls;
    requires org.kordamp.ikonli.javafx;
    requires java.desktop;
    requires nsmenufx;
    requires jfa;
    //requires de.jangassen;

    opens org.scitool to javafx.fxml;
    exports org.scitool;
}