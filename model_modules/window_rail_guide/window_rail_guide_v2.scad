EPS = 0.1;
WALL_THICKNESS = 1.8;
GAP_THICKNESS = 3.3;
BACK_TO_TIP = 26.5;
HOLES_TO_TIP = 21.5;
HOLES_SPACING = 9.9;
HOLES_D = 4.65;
WIDTH=19.1;

outer_radius = WALL_THICKNESS + 0.5*GAP_THICKNESS;

difference() {
    union() {
        // Upper surface
        translate([-.5*WIDTH, 0, WALL_THICKNESS + GAP_THICKNESS])
        cube([WIDTH, BACK_TO_TIP - outer_radius + EPS, WALL_THICKNESS]);
        
        // Lower surface
        translate([-.5*WIDTH, 0, 0])
        cube([WIDTH, BACK_TO_TIP - outer_radius + EPS, WALL_THICKNESS]);
        
        // End
        translate([-.5*WIDTH, BACK_TO_TIP - outer_radius, outer_radius])
        rotate([0, 90, 0])
        difference() {
            cylinder(r=.5*GAP_THICKNESS + WALL_THICKNESS, h=WIDTH, $fn=20);
            union() {
                translate([-.5*GAP_THICKNESS - WALL_THICKNESS, -.5*GAP_THICKNESS - WALL_THICKNESS, -EPS])
                cube([GAP_THICKNESS + 2.*WALL_THICKNESS, .5*GAP_THICKNESS + WALL_THICKNESS + EPS, WIDTH + 2*EPS]);
                translate([0, 0, -EPS])
                cylinder(r=.5*GAP_THICKNESS, h=WIDTH+2*EPS, $fn=20);
            }
        }
    }
    // Holes
    union() {
        translate([-.5*HOLES_SPACING, BACK_TO_TIP - HOLES_TO_TIP, -EPS])
        cylinder(r=.5*HOLES_D, h=2*outer_radius + 2*EPS, $fn=20);
        translate([+.5*HOLES_SPACING, BACK_TO_TIP - HOLES_TO_TIP, -EPS])
        cylinder(r=.5*HOLES_D, h=2*outer_radius + 2*EPS, $fn=20);
    }
}