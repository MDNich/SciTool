package com.astroDevEnterprises.SciTool;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Home {
    public JButton electricPotentialGrapherButton;
    public JButton a3DElectricPotentialGrapherButton;
    public JPanel panelMain;
    private JScrollBar scrollBar1;

    public Home()
    {

        electricPotentialGrapherButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                Main.presentVoltageContour();
            }
        });
    }
}
