module org.scitool.scitool {
    requires javafx.controls;
    requires javafx.fxml;
    requires org.jfree.jfreechart;
    requires org.jfree.chart.fx;
    requires org.jfree.fxgraphics2d;
    requires org.controlsfx.controls;
    requires org.kordamp.ikonli.javafx;
    requires java.desktop;
    requires com.sun.jna.platform;
    requires java.logging;
    requires jfa;
    requires org.knowm.xchart;
    requires hipparchus.core;
    requires nsmenufx;
    opens org.scitool to javafx.fxml;
    exports org.scitool;
    exports org.scitool.equipotential to javafx.graphics;
}