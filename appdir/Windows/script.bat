@ECHO OFF

JDK\jdk-19.0.2\bin\java  --module-path lib-windows-x86/ --add-modules javafx.controls,javafx.fxml,javafx.graphics,jfa -Djna.boot.library.path=lib-windows-x86/ -jar SciTool.jar

PAUSE