/**
Copyright 2023 - Harry Joseph Braviner
For permission to use please contact me by e-mail.

Purpose of this module is to allow fast parametric creation
of basic boxes. Useful for e.g. button-boxes for flight
simulators.
*/

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
}

box_base(w=10.0, l=15.0, d=5.0, r_corner=2.0,
    d_bolt=6.0, d_nut=7.5, h_nut=3.5,
    wall_thickness=1.0);
