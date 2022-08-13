package com.astroDevEnterprises.SciTool;

import javax.swing.*;

public class Home {
    private JPanel panel1;
    private JLabel label1;
    private JButton clickMeButton;
    private JTable table1;
    private JRadioButton radioButton1;
    private JComboBox comboBox1;
    private JPasswordField passwordField1;
    private JSlider slider1;
    private JSpinner spinner1;

    static Home appCopy;
    public Home()
    {
//        panelSmall = new JPanel();
        // welcomeLabel.setText("Welcome To My App!");
        // handlers etc.
    }

    public static void main(String[] args)
    {
        JFrame frame = new JFrame("Home");
        appCopy = new Home();
        showGUI(frame,10,10,500,500);
    }
    public static void showGUI(JFrame frame, int x, int y, int height, int width)
    {
        frame.setContentPane(appCopy.panel1);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setBounds(x,y,width,height);
        frame.setVisible(true);
    }

    private void createUIComponents() {
        // TODO: place custom component creation code here
    }
}
