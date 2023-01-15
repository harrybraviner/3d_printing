/**
Copyright 2023 - Harry Joseph Braviner
For permission to use please contact me by e-mail.

Purpose of this module is to allow fast parametric creation
of basic boxes. Useful for e.g. button-boxes for flight
simulators.
*/

use <filleted_cylinder.scad>

// Internal parameters
EPS = 0.001;  // Used to avoid zero-width surfaces
              // and touching-but-disconnected surfaces.

$fn=32;

module box_base(
    w, l, d,  // Exterior dimensions of the box
    r_corner,  // Rounding radius of the box corners
    d_bolt,  // Diameter of the bolts holding the top on
    d_nut,  // Flat-to-flat diameter of the nuts
    h_nut,  // Height of the nuts (plus and clearance)
    wall_thickness  // Wall thickness of the box and lid
) {
    // Submodule that we will use twice.
    // Once for the outer box shape, once for the inner
    // shape to be subtracted
    module rounded_box(w, l, d, r_corner) {
        r = r_corner;  // Save some typing
        if (r > 0.0) {
            linear_extrude(height=d, center=false)
            hull() {
                translate([r, r, 0])
                    circle(r=r);
                translate([w - r, r, 0])
                    circle(r=r);
                translate([r, l - r, 0])
                    circle(r=r);
                translate([w - r, l - r, 0])
                    circle(r=r);
            }
        } else {
            cube([w, l, d]);
        }
    }
    
    // Create the hollow box
    difference() {
        rounded_box(w, l, d, r_corner);
        translate([wall_thickness, wall_thickness, wall_thickness])
        rounded_box(w-2*wall_thickness, l-2*wall_thickness, d - wall_thickness + EPS, r_corner - wall_thickness);
    }
    
    // Create the corner holes
    for (right = [0, 1]) {
        for (top = [0, 1]) {
            x = right*w + (1-2*right)*r_bolt_outer;
            y = top*l + (1-2*top)*r_bolt_outer;
            translate([x, y, 0.5*d])
            mirror([right, top, 0.0])
            filleted_cylinder(r=r_bolt_outer, h=d,
                x1=wall_thickness, x2=2.0*wall_thickness,
                angle=90);
        }
    }
    // FIXME - bottom-left hold as a prototype first
    // Shaft to hold the hole
    r_bolt_outer = 0.5*d_bolt + wall_thickness;
    translate([r_bolt_outer, r_bolt_outer, 0.5*d])
    filleted_cylinder(r=r_bolt_outer, h=d,
        x1=wall_thickness, x2=2.0*wall_thickness,
        angle=90);
}

// Demonstration
box_base(w=50.0, l=50.0, d=25.0, r_corner=5.0,
    d_bolt=3.0, d_nut=7.5, h_nut=3.5,
    wall_thickness=4.0);
