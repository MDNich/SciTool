/**
 * MarchingSquares.java
 *
 * Mike Markowski     mike.ab3ap@gmail.com
 * Apr 22, 2013
 *
 * v0.1 Initial release, Apr 22, 2013
 *
 * Copyright 2013 Michael Markowski
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.scitool;

import java.awt.geom.GeneralPath;
import java.awt.geom.Point2D;


/**
 * Algorithm taken from: http://en.wikipedia.org/wiki/Marching_squares . See
 * that web page for a thorough description and helpful illustrations. In short,
 * however, Marching Squares takes a 2d array of numbers and generates isolines
 * for specified values.
 *
 * <p>The data array generally contains measurements of a natural phenomenon, so
 * that adjacent numbers have some relation to each other. For example, they
 * might be terrain elevations, RF power from a transmitter, snow fall amounts,
 * and so on.
 *
 * <p>Given a threshold, a copy of the data is made where each value is changed
 * to 0 or 1 depending if the measurement is below or above it. The algorithm
 * described below is applied one time for each isoline wanted. Each isoline is
 * converted to Java GeneralPath instances, which are Shapes supporting holes
 * and disconnected regions.
 *
 * <p>NOTE: data is first padded with a new row at top and another at bottom, as
 * well as a new first and last column. The new rows and columns are set to one
 * less than the smallest data value. This ensures that all isos will be closed
 * polygons. All generated GeneralPaths can then be easily filled and drawn.
 *
 * <p>Taken from the Wikipedia page:
 *
 * <p>Basic Algorithm
 *
 * <p>Here are the steps of the algorithm:
 *
 * <p>Apply a threshold to the 2D field to make a binary image containing:
 *
 * <p>1 where the data value is above the isovalue<br>
 * 0 where the data value is below the isovalue
 *
 * <p>Every 2x2 block of pixels in the binary image forms a contouring cell, so
 * the whole image is represented by a grid of such cells (shown in green in the
 * picture below). Note that this contouring grid is one cell smaller in each
 * direction than the original 2D field.
 *
 * <p>For each cell in the contouring grid:
 *
 * <p>1. Compose the 4 bits at the corners of the cell to build a binary index:
 * walk around the cell in a clockwise direction appending the bit to the index,
 * using bitwise OR and left-shift, from most significant bit at the top left,
 * to least significant bit at the bottom left. The resulting 4-bit index can
 * have 16 possible values in the range 0-15
 *
 * <p>2. Use the cell index to access a pre-built lookup table with 16 entries
 * listing the edges needed to represent the cell (shown in the lower right part
 * of the picture below).
 *
 * <p>3. Apply linear interpolation between the original field data values to
 * find the exact position of the contour line along the edges of the cell.
 */
public class MarchingSquares {

    /**
     * Coordinates within this distance of each other are considered identical.
     * This affects whether new segments are or are not created in an iso
     * shape GeneralPath, in particular whether or not to generate a call
     * to lineTo().
     */
    private final double epsilon = 1e-10;

    /**
     * Typically, mkIsos() is the only method in this class that programs will
     * call.  The caller supplies a 2d array of doubles representing some
     * set of measured data.  Additionally, a 1d array of values is passed
     * whose contents are thresholds corresponding to desired islines.
     * The method returns a 1d array of GeneralPaths representing those
     * isolines.  The GeneralPaths may contain disjoint polygons as well as
     * holes.
     *
     * <p>Sample call:
     * <pre>
     * MarchingSquares marchingSquares = new MarchingSquares();
     * GenersalPath[] isolines = marchingSquares.mkIsos(data_mW, levels);
     * </pre>
     * and the isolines can then be filled or drawn as desired.
     *
     * @param data measured data to use for isoline generation.
     * @param levels thresholds to use as iso levels.
     * @return return an array of iso GeneralPaths. Each array element
     * corresponds to the same threshold in the 'levels' input array.
     */
    public GeneralPath[] mkIsos(double[][] data, double[] levels) {
        // Pad data to guarantee iso GeneralPaths will be closed shapes.
        double dataP[][] = padData(data, levels);
        GeneralPath[] isos = new GeneralPath[levels.length];
        for (int i = 0; i < levels.length; i++) {
            // Create contour for this level using Marching Squares algorithm.
            IsoCell[][] contour = mkContour(dataP, levels[i]);
            // Convert contour to GeneralPath.
            isos[i] = mkIso(contour, dataP, levels[i]);
        }
        return isos;
    }

    /**
     * Mainly for debugging, this can be called to have ascii art contours
     * printed for the data.
     *
     * @param data measured data to use for isoline generation.
     * @param levels thresholds to use as iso levels.
     * @return return a string of ascii art corresponding to Marching Squares
     * generation if isolines.
     */
    public String asciiPrintContours(double[][] data, double[] levels) {
        String s = "";
        // Pad data to guarantee iso GeneralPaths will be closed shapes.
        double dataP[][] = padData(data, levels);
        for (int i = 0; i < levels.length; i++) {
            // Create contour for this level using Marching Squares algorithm.
            s += asciiContourPrint(mkContour(dataP, levels[i]));
            s += "\n";
        }
        return s;
    }

    /**
     * Create neighbor info for a single threshold. Neighbor info indicates
     * which of the 4 surrounding data values are above or below the threshold.
     *
     * @param data measured data to use for isoline generation.
     * @param level threshold to use as iso levels.
     * @return return an array of iso GeneralPaths. Each array element
     * corresponds to the same threshold in the 'levels' input array.
     */
    private IsoCell[][] mkContour(double[][] data, double level) {

        // Pad data to guarantee iso GeneralPaths will be closed shapes.
        int numRows = data.length;
        int numCols = data[0].length;

        // Create array indicating iso cell neighbor info.
        IsoCell[][] contours = new IsoCell[numRows - 1][numCols - 1];
        for (int r = 0; r < numRows - 1; r++) {
            for (int c = 0; c < numCols - 1; c++) {
                // Determine if neighbors are above or below threshold.
                int ll = data[r][c] > level ? 0 : 1;
                int lr = data[r][c + 1] > level ? 0 : 2;
                int ur = data[r + 1][c + 1] > level ? 0 : 4;
                int ul = data[r + 1][c] > level ? 0 : 8;
                int nInfo = ll | lr | ur | ul;
                boolean isFlipped = false;
                // Deal with ambiguous cases.
                if (nInfo == 5 || nInfo == 10) {
                    // Calculate average of 4 surrounding values.
                    double center = (data[r][c] + data[r][c + 1]
                            + data[r + 1][c + 1] + data[r + 1][c]) / 4;
                    if (nInfo == 5 && center < level) {
                        isFlipped = true;
                    } else if (nInfo == 10 && center < level) {
                        isFlipped = true;
                    }
                }

                // Store neighbor info as one number.
                contours[r][c] = new IsoCell();
                contours[r][c].setFlipped(isFlipped);
                contours[r][c].setNeighborInfo(nInfo);
            }
        }
        return contours;
    }

    /**
     * Build up a Shape corresponding to the isoline, and erase isoline at same
     * time. Erasing isoline is important because it is expected that this
     * method will be called repeatedly until no more isolines exist for a given
     * threshold.
     *
     * @param isoData info indicating which adjacent neighbors are above or
     * below threshold.
     * @param data measured data.
     * @param threshold this isoline's threshold value.
     * @return GeneralPath, possibly with disjoint areas and holes,
     * representing isolines.  Shape is guaranteed closed and can be filled.
     */
    private GeneralPath mkIso(IsoCell[][] isoData, double data[][],
            double threshold) {

        int numRows = isoData.length;
        int numCols = isoData[0].length;

        int r, c;
        for (r = 0; r < numRows; r++) {
            for (c = 0; c < numCols; c++) {
                interpolateCrossing(isoData, data, r, c, threshold);
            }
        }

        GeneralPath isoPath = new GeneralPath(GeneralPath.WIND_EVEN_ODD);
        for (r = 0; r < numRows; r++) {
            for (c = 0; c < numCols; c++) {
                if (isoData[r][c].getNeighborInfo() != 0
                        && isoData[r][c].getNeighborInfo() != 5
                        && isoData[r][c].getNeighborInfo() != 10
                        && isoData[r][c].getNeighborInfo() != 15) {
                    isoSubpath(isoData, r, c, isoPath);
                }
            }
        }
        return isoPath;
    }

    /**
     * A given iso level can be made up of multiple disconnected regions and
     * each region can have multiple holes. Both regions and holes are captured
     * as individual iso subpaths. An existing GeneralPath is passed to this
     * method so that a new subpath, which is a collection of one moveTo and
     * multiple lineTo calls, can be added to it.
     *
     * @param isoData info indicating which adjacent neighbors are above or
     * below threshold.
     * @param r row in isoData to start new sub-path.
     * @param c column is isoData to start new sub-path.
     * @param iso existing GeneralPath to which sub-path will be added.
     */
    private void isoSubpath(IsoCell[][] isoData, int r, int c, GeneralPath iso) {

        // Found an iso line at [r][c], so start there.
        IsoCell.side prevSide = IsoCell.side.NONE;

        IsoCell start = isoData[r][c];
        Point2D pt = start.normalizedPointCCW(start.firstSideCCW(prevSide));
        double x = c + pt.getX();
        double y = r + pt.getY();
        iso.moveTo(x, y);
        pt = start.normalizedPointCCW(start.secondSideCCW(prevSide));
        double xPrev = c + pt.getX();
        double yPrev = r + pt.getY();
        if (Math.abs(x - xPrev) > epsilon && Math.abs(y - yPrev) > epsilon) {
            iso.lineTo(x, y);
        }
        prevSide = start.nextCellCCW(prevSide);
        switch (prevSide) {
            case BOTTOM:
                r -= 1;
                break;
            case LEFT:
                c -= 1;
                break;
            case RIGHT:
                c += 1;
                break;
            case TOP:
                r += 1;
        }
        start.clearIso(prevSide); // Erase this isoline.

        IsoCell curCell = isoData[r][c];
        while (curCell != start) {
            pt = curCell.normalizedPointCCW(curCell.secondSideCCW(prevSide));
            x = c + pt.getX();
            y = r + pt.getY();
            if (Math.abs(x - xPrev) > epsilon && Math.abs(y - yPrev) > epsilon) {
                iso.lineTo(x, y);
            }
            xPrev = x;
            yPrev = y;
            prevSide = curCell.nextCellCCW(prevSide);
            switch (prevSide) {
                case BOTTOM:
                    r -= 1;
                    break;
                case LEFT:
                    c -= 1;
                    break;
                case RIGHT:
                    c += 1;
                    break;
                case TOP:
                    r += 1;
            }
            curCell.clearIso(prevSide); // Erase this isoline.
            curCell = isoData[r][c];
        }
        iso.closePath();
    }

    /**
     * Surround data with values less than any in the data to guarantee Marching
     * Squares will find complete polygons and not march off the edge of the
     * data area.
     *
     * @param data 2d data array to be padded
     * @return array which is a copy of input padded with top/bottom rows and
     * left/right columns of values 1 less than smallest value in array.
     */
    private double[][] padData(double[][] data, double[] levels) {

        int rows = data.length;
        int cols = data[0].length;

        // superMin is a value guaranteed to never be included in any isoline.
        // The idea is to surround the data with low values, forcing polygon
        // sides to be created.
        double superMin = levels[0];
        for (int i = 1; i < levels.length; i++) {
            superMin = Math.min(superMin, levels[i]);
        }
        superMin--;

        double[][] padded = new double[rows + 2][cols + 2];
        for (int i = 0; i < cols + 2; i++) {
            padded[0][i] = superMin;
            padded[rows + 1][i] = superMin;
        }
        for (int i = 0; i < rows + 2; i++) {
            padded[i][0] = superMin;
            padded[i][cols + 1] = superMin;
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                padded[i + 1][j + 1] = data[i][j];
            }
        }
        return padded;
    }

    public double ovalOfCassini(double x, double y) {
        return ovalOfCassini(x, y, 0.48, 0.5);
    }

    /**
     * If desired, points of the isos can be drawn using the smooth ovals of
     * Cassini.
     *
     * @param x
     * @param y
     * @param a
     * @param b
     * @return
     */
    public double ovalOfCassini(double x, double y, double a, double b) {
        return (x * x + y * y + a * a)
                * (x * x + y * y + a * a)
                - 4 * a * a * x * x
                - b * b * b * b;
    }

    /**
     * Once Marching Squares has determined the kinds of lines crossing a cell,
     * this method uses linear interpolation to make the crossings more
     * representative of the data.
     *
     * @param isoData array of values of 0-15 indicating contour type.
     * @param data original data needed for linear interpolation.
     * @param r current row index.
     * @param c current column index.
     * @param threshold threshold for this iso level.
     */
    private void interpolateCrossing(IsoCell[][] isoData, double[][] data,
            int r, int c, double threshold) {

        double a, b;

        IsoCell cell = isoData[r][c];
        double ll = data[r][c];
        double lr = data[r][c + 1];
        double ul = data[r + 1][c];
        double ur = data[r + 1][c + 1];

        // Left side of iso cell.
        switch (cell.getNeighborInfo()) {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
            case 14:
                a = ll;
                b = ul;
                cell.setLeft((threshold - a) / (b - a)); // frac from LL
                break;
            default:
                break;
        }

        // Bottom side of iso cell.
        switch (cell.getNeighborInfo()) {
            case 1:
            case 2:
            case 5:
            case 6:
            case 9:
            case 10:
            case 13:
            case 14:
                a = ll;
                b = lr;
                cell.setBottom((threshold - a) / (b - a)); // frac from LL
                break;
            default:
                break;
        }

        // Top side of iso cell.
        switch (cell.getNeighborInfo()) {
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
                a = ul;
                b = ur;
                cell.setTop((threshold - a) / (b - a)); // frac from UL
                break;
            default:
                break;
        }

        // Right side of iso cell.
        switch (cell.getNeighborInfo()) {
            case 2:
            case 3:
            case 4:
            case 5:
            case 10:
            case 11:
            case 12:
            case 13:
                a = lr;
                b = ur;
                cell.setRight((threshold - a) / (b - a)); // frac from LR
                break;
            default:
                break;
        }
    }

    /**
     * Mainly for debugging, print an ascii version of this contour.
     *
     * @param a array of contour neighbor values.
     * @return string roughly representing contour in 'a'.
     */
    private String asciiContourPrint(IsoCell[][] a) {
        String s = "";
        int rows = a.length;
        int cols = a[0].length;
        for (int j = 0; j < cols; j++) {
            s += "===";
        }
        s += "\n";
        for (int i = rows - 1; i >= 0; i--) {
            for (int j = 0; j < cols; j++) {
                switch (a[i][j].getNeighborInfo()) {
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                        s += "xxx";
                        break;
                    case 4:
                        s += "x\\ ";
                        break;
                    case 5:
                        if (a[i][j].isFlipped()) {
                            s += "x\\ ";
                            break;
                        }
                    case 7:
                        s += "x/ ";
                        break;
                    case 6:
                        s += "x| ";
                        break;
                    case 8:
                        s += " /x";
                        break;
                    case 9:
                        s += " |x";
                        break;
                    case 10:
                        if (a[i][j].isFlipped()) {
                            s += " /x";
                            break;
                        }
                    case 11:
                        s += " \\x";
                        break;
                    default:
                        s += "   ";
                }
            }
            s += "\n";

            for (int j = 0; j < cols; j++) {
                switch (a[i][j].getNeighborInfo()) {
                    case 0:
                        s += "xxx";
                        break;
                    case 1:
                        s += "\\xx";
                        break;
                    case 2:
                        s += "xx/";
                        break;
                    case 3:
                    case 12:
                        s += "---";
                        break;
                    case 4:
                        s += "xx\\";
                        break;
                    case 5:
                        if (a[i][j].isFlipped()) {
                            s += "\\x\\";
                        } else {
                            s += "/ /";
                        }
                        break;
                    case 6:
                        s += "x| ";
                        break;
                    case 7:
                        s += "/  ";
                        break;
                    case 8:
                        s += "/xx";
                        break;
                    case 9:
                        s += " |x";
                        break;
                    case 10:
                        if (a[i][j].isFlipped()) {
                            s += "/x/";
                        } else {
                            s += "\\ \\";
                        }
                        break;
                    case 11:
                        s += "  \\";
                        break;
                    case 13:
                        s += "  /";
                        break;
                    case 14:
                        s += "\\  ";
                        break;
                    case 15:
                        s += "   ";
                }
            }
            s += "\n";

            for (int j = 0; j < cols; j++) {
                switch (a[i][j].getNeighborInfo()) {
                    case 0:
                    case 4:
                    case 8:
                    case 12:
                        s += "xxx";
                        break;
                    case 1:
                        s += " \\x";
                        break;
                    case 2:
                        s += "x/ ";
                        break;
                    case 3:
                    case 7:
                    case 11:
                    case 15:
                        s += "   ";
                        break;
                    case 5:
                        if (a[i][j].isFlipped()) {
                            s += " \\x";
                        } else {
                            s += " /x";
                        }
                        break;
                    case 6:
                        s += "x| ";
                        break;
                    case 9:
                        s += " |x";
                        break;
                    case 10:
                        if (a[i][j].isFlipped()) {
                            s += "x/ ";
                            break;
                        }
                    case 14:
                        s += "x\\ ";
                        break;
                    case 13:
                        s += " /x";
                        break;
                }
            }
            s += "\n";
        }
        for (int j = 0; j < cols; j++) {
            s += "===";
        }
        s += "\n";
        return s;
    }
}
