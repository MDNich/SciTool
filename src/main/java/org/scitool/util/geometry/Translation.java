package org.scitool.util.geometry;

public class Translation extends Transformation {

    int dx,dy;

    public Translation(int dx, int dy){
        this.dx = dx;
        this.dy = dy;
    }
    @Override
    public int applyToX(int currentX) {
        return currentX+dx;
    }

    @Override
    public int applyToY(int currentY) {
        return currentY+dy;
    }
}
