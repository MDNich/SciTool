package com.astroDevEnterprises.SciTool;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Splash {
    public JButton continueButton;
    public JProgressBar progressBar1;
    public JPanel panelMain;

    public Splash() {

        continueButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                Main.switchToHome();
            }
        });
    }
}
