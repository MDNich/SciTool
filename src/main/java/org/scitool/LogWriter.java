package org.scitool;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Calendar;
import java.util.Date;

public class LogWriter {
    File logfile;
    String pathToFile;
    FileWriter writer;

    public LogWriter(File logfile) {
        this.logfile = logfile;
        pathToFile = logfile.getAbsolutePath();
        try {
            writer = new FileWriter(logfile);
            System.out.println("Fetched logfile internal.");
            writer.write("Log init.\n");
            System.out.println("Wrote init.");
            writer.close();
        } catch (IOException e) {
            System.out.println("Failed internal logfetch.");
            //throw new RuntimeException(e);
        }
    }

    public void debug(String text) {
        log("[DBG] " + text);
    }
    public void error(String text) {
        log("[ERR] " + text);
    }
    public void log(String text) {
        Calendar c1 = Calendar.getInstance();
        Date dateOne = c1.getTime();
        try {
            Files.write(Paths.get(pathToFile), (dateOne.toString() + ": " + text + "\n").getBytes(), StandardOpenOption.APPEND);
        } catch (IOException e) {
            System.err.println("Cannot write to logfile.");
            throw new RuntimeException(e);
        }
    }
}
