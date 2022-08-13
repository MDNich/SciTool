package com.astroDevEnterprises.SciTool;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class voltageContour {
    public JPanel panelMain;
    public JTextField chargesX;
    public JLabel imageView;
    public JTextField chargesY;
    private JButton generateElectricPotentialContourButton;

    public voltageContour()
    {

        generateElectricPotentialContourButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                Main.updateVoltageContourImage();
            }
        });
    }
}
