/**
 * IsoCell.java
 *
 * Mike Markowski mike.ab3ap@gmail.com Apr 22, 2013
 *
 * v0.1 2013-04-22.  Initial release, Apr 22, 2013
 * v0.2 2013-11-12.  Bug fix.  Corrected start of subpath in firstSideCCW().
 * v0.3 2021-05-12.  Bug fix.  Corrected case 11 start of subpath in
 *                   firstSideCCW() to return TOP, not RIGHT.
 *                   Thanks to Giovanni Martino!
 *
 * Copyright 2013 Michael Markowski
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */

package org.scitool;

import java.awt.geom.Point2D;

/**
 * IsoCell is used to describe properties of data cells, in particular,
 * indicating whether neighbors are above or below a threshold value. Other
 * methods also help the caller follow isolines from cell to cell in a
 * counter-clockwise manner. That is useful when converting the isolines to
 * GeneralPaths.
 */
public class IsoCell {

    public enum side {

        LEFT, RIGHT, TOP, BOTTOM, NONE
    };
    boolean flipped;
    int neighborInfo;
    double left, right, top, bottom;

    public IsoCell() {
        flipped = false;
    }

    /**
     * Determine is this cell is one of tow ambiguous cases in Marching Squares
     * and, if so, whether or not it must be "flipped" to the other case.
     *
     * @return Indication whether this cell is or isn't flipped.
     */
    public boolean isFlipped() {
        return flipped;
    }

    /**
     * Indicate whether an ambiguous cell, i.e., neighbor value of 5 or 10,
     * should be treated as, respectively, 5 or 10, or 10 or 5. Please read up
     * on the Marching Squares algorithm if the preceding appears meaningless.
     * :-)
     *
     * @param flipped indicate whether cell is or isn't flipped from 5/10 to
     * 10/5.
     */
    public void setFlipped(boolean flipped) {
        this.flipped = flipped;
    }

    /**
     * Retrieve the neighbor info of this cell. Each of its neighbors is given a
     * value of 1, 2, 4 or 8 depending on whether or not each is above or below
     * a threshold. These values are the foundation of the Marching Squares
     * algorithm.
     *
     * @return
     */
    public int getNeighborInfo() {
        return neighborInfo;
    }

    /**
     * Save the status of this cell's 4 adjacent neighbors and whether or not
     * ecah is above or below a threshold. It is a 4-bit integer ranging from 0
     * through 15.
     *
     * @param neighborInfo
     */
    public void setNeighborInfo(int neighborInfo) {
        this.neighborInfo = neighborInfo;
    }

    /**
     * After Marching Squares determines what kind of crossings go through each
     * cell, this method can be used to save linearly interpolated values that
     * more closely follow data values. So rather than using cell crossing
     * values of, e.g., (0.5, 0), plotting is better if the data indicated, say,
     * (0.83, 0) should be used.
     *
     * @param cellSide which side crossing is wanted.
     * @return crossing based on data and normalized to [0, 1].
     */
    public Point2D normalizedPointCCW(side cellSide) {
        switch (cellSide) {
            case BOTTOM:
                return new Point2D.Double(bottom, 0);
            case LEFT:
                return new Point2D.Double(0, left);
            case RIGHT:
                return new Point2D.Double(1, right);
            case TOP:
                return new Point2D.Double(top, 1);
            default:
                return null;
        }
    }

    /**
     * Depending on this cell's neighbor info, which is an integer in [0, 15],
     * this method determines the first side that would used in a counter-
     * clockwise traversal of an isoline.
     *
     * @param prev previous side, used only for ambiguous cases of 5 and 10.
     * @return side to start with in a CCW traversal.
     */
    public side firstSideCCW(side prev) {

        switch (neighborInfo) {
            case 1:
            case 3:
            case 7:
                return side.LEFT;
            case 2:
            case 6:
            case 14:
                return side.BOTTOM;
            case 4:
            case 12:
            case 13:
                return side.RIGHT;
            case 8:
            case 9:
            case 11:
                return side.TOP;
            case 5:
                switch (prev) {
                    case LEFT:
                        return side.RIGHT;
                    case RIGHT:
                        return side.LEFT;
                    default:
                        System.out.println(getClass()
                                + ".firstSideCCW: case 5!");
                        System.exit(1);
                }
            case 10:
                switch (prev) {
                    case BOTTOM:
                        return side.TOP;
                    case TOP:
                        return side.BOTTOM;
                    default:
                        System.out.println(getClass()
                                + ".firstSideCCW: case 10!");
                        System.exit(1);
                }
            default:
                System.out.println(getClass() + ".firstSideCCW: default!");
                System.exit(1);
        }
        return null;
    }

    /**
     * Depending on this cell's neighbor info, which is an integer in [0, 15],
     * this method determines the second side of a cell that would used in a
     * counter-clockwise traversal of an isoline.
     *
     * @param prev previous side, used only for ambiguous cases of 5 and 10.
     * @return side to finish with in a call during a CCW traversal.
     */
    public side secondSideCCW(side prev) {

        switch (neighborInfo) {
            case 8:
            case 12:
            case 14:
                return side.LEFT;
            case 1:
            case 9:
            case 13:
                return side.BOTTOM;
            case 2:
            case 3:
            case 11:
                return side.RIGHT;
            case 4:
            case 6:
            case 7:
                return side.TOP;
            case 5:
                switch (prev) {
                    case LEFT: // Normal case 5.
                        return flipped ? side.BOTTOM : side.TOP;
                    case RIGHT: // Normal case 5.
                        return flipped ? side.TOP : side.BOTTOM;
                    default:
                        System.out.println(getClass()
                                + ".secondSideCCW: case 5!");
                        System.exit(1);
                }
            case 10:
                switch (prev) {
                    case BOTTOM: // Normal case 10
                        return flipped ? side.RIGHT : side.LEFT;
                    case TOP: // Normal case 10
                        return flipped ? side.LEFT : side.RIGHT;
                    default:
                        System.out.println(getClass()
                                + ".secondSideCCW: case 10!");
                        System.exit(1);
                }
            default:
                System.out.println(getClass()
                        + ".secondSideCCW: shouldn't be here!  Neighborinfo = "
                        + neighborInfo);
                System.exit(1);
                return side.NONE;
        }
    }

    /**
     * Find the next cell to use in a CCW traversal of an isoline.
     *
     * @param prev previous side, used only for ambiguous cases of 5 and 10.
     * @return next cell to use in a CCW traversal.
     */
    public side nextCellCCW(side prev) {
        return secondSideCCW(prev);
    }

    /**
     * Clear neighbor info in this cell. When building up shapes, it is possible
     * to have disjoint isoshapes and holes in them. An easy way to build up a
     * new shape from neighborInfo is to build sub-paths for one isoline at a
     * time. As the shape is built up, it is necessary to erase the line
     * afterward so that subsequent searches for isolines will not loop
     * infinitely.
     *
     * @param prev
     */
    public void clearIso(side prev) {
        switch (neighborInfo) {
            case 0:
            case 5:
            case 10:
            case 15:
                break;
            default:
                neighborInfo = 15;
        }
    }

    /**
     * @return Get interpolated crossing on left edge of cell.
     */
    public double getLeft() {
        return left;
    }

    /**
     * @param left Set interpolated crossing on left edge of cell.
     */
    public void setLeft(double left) {
        this.left = left;
    }

    /**
     * @return Get interpolated crossing on right edge of cell.
     */
    public double getRight() {
        return right;
    }

    /**
     * @param right Set interpolated crossing on right edge of cell.
     */
    public void setRight(double right) {
        this.right = right;
    }

    /**
     * @return Get interpolated crossing on top edge of cell.
     */
    public double getTop() {
        return top;
    }

    /**
     * @param top Set interpolated crossing on top edge of cell.
     */
    public void setTop(double top) {
        this.top = top;
    }

    /**
     * @return Get interpolated crossing on bottom edge of cell.
     */
    public double getBottom() {
        return bottom;
    }

    /**
     * @param bottom Set interpolated crossing on bottom edge of cell.
     */
    public void setBottom(double bottom) {
        this.bottom = bottom;
    }
}
