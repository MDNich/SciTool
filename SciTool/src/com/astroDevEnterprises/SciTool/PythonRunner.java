package com.astroDevEnterprises.SciTool;
import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

public class PythonRunner {

    String pathToPython = "/usr/local/bin/python3";

    public PythonRunner(String pathToPython)
    {
        this.pathToPython = pathToPython;
    }
    public PythonRunner()
    {
        this.pathToPython = "/usr/local/bin/python3";
    }
   public void runContourGivenInputs(Object[] inputs)
   {
       System.out.println(PythonRunner.class.getProtectionDomain().getCodeSource().getLocation());
       /*
       let arr = [PythonObject.StringLiteralType(dirPathSave),PythonObject.ArrayLiteralElement(ys),PythonObject.ArrayLiteralElement(xs),PythonObject.ArrayLiteralElement(qs),PythonObject.FloatLiteralType(Double(WindowLowerX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowLowerY.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperY.stringValue)!),PythonObject.IntegerLiteralType(Int(CounterNumber.stringValue)!),PythonObject.FloatLiteralType(Double(CoulombConstant.stringValue)!)] as [PythonConvertible]
        try engine.drawGraph.throwing.dynamicallyCall(withArguments: arr)
       */
       ArrayList pyInputs = new ArrayList();
       pyInputs.add(pathToPython);
       pyInputs.add("com/astroDevEnterprises/SciTool/voltage.py");
       for(int i = 0; i < inputs.length; i++)
       {
           pyInputs.add(inputs.toString());
       }
       ProcessBuilder pb = new ProcessBuilder(pyInputs);
       try {
           pb.directory(new File(PythonRunner.class.getProtectionDomain().getCodeSource().getLocation().toURI()));
       } catch (URISyntaxException e) {
           throw new RuntimeException(e);
       }
       try {
           Process p = pb.start();
       } catch (IOException e) {
           throw new RuntimeException(e);
       }
   }
}
