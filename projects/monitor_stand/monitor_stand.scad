include <roundedcube.scad>;

EPS = 0.01;
LEG_W = 19.40;  // Include any extra clearance desired.
THICKNESS = 3.0; // Used for most walls
BASE_THICKNESS = 5.0;
SLEEVE = 35.0;
FOOT_RADIUS = 2.0;
SPANNER_L = 45.0;

OVERALL_H = 155.0; // Height from bottom of supports to top
OVERALL_D = 232.0; // Depth from front to back

// Calculations to work out slant distance
x_cross = OVERALL_D - 2*(LEG_W + 2*THICKNESS);
y_cross = OVERALL_H - 2*BASE_THICKNESS;
x_1 = LEG_W + 2*THICKNESS;
// Need to solve x_cross * tan(theta) = y_cross - x_1 / cos(theta)
// Can solve this with a little trig:
A = sqrt(x_cross^2 + y_cross^2);
alpha = asin(y_cross / A);
theta = alpha - asin(x_1 / A);

echo("Theta: ", theta);

module simple_foot() {
    difference() {
        roundedcube([LEG_W + 2*THICKNESS, LEG_W + 2*THICKNESS,
            BASE_THICKNESS + SLEEVE], radius=FOOT_RADIUS)
        translate([0, 0, FOOT_RADIUS]);
        
        translate([THICKNESS, THICKNESS, BASE_THICKNESS])
        cube([LEG_W, LEG_W, SLEEVE + EPS]);
    }
}

module top_connector(include_angle) {
    difference() {
        roundedcube([LEG_W + 2*THICKNESS, LEG_W + 2*THICKNESS,
            BASE_THICKNESS + SLEEVE], radius=FOOT_RADIUS,
            apply_to="zmax");

        translate([THICKNESS, THICKNESS, BASE_THICKNESS])
        cube([LEG_W, LEG_W, SLEEVE + EPS]);
    }
    // Segments that screw holes will go into ('spanners')
    translate([LEG_W + 2*THICKNESS - 2*FOOT_RADIUS, 0, 0])
    roundedcube([SPANNER_L + 2*FOOT_RADIUS, LEG_W + 2*THICKNESS, BASE_THICKNESS], radius=FOOT_RADIUS, apply_to="zmax");
    
    translate([0, LEG_W + 2*THICKNESS - 2*FOOT_RADIUS, 0])
    roundedcube([ LEG_W + 2*THICKNESS, SPANNER_L + 2*FOOT_RADIUS, BASE_THICKNESS], radius=FOOT_RADIUS, apply_to="zmax");
    
    if (include_angle) {
        // Sleeve length for angled piece
        s2 = (SLEEVE - cos(theta) * x_1) / sin(theta);
        
        difference() {
            translate([+x_1, 0, BASE_THICKNESS])
            rotate([0, 90 - theta, 0])
            translate([-x_1, 0, 0])
            difference() {
                roundedcube([LEG_W + 2*THICKNESS, LEG_W + 2*THICKNESS,
                    s2], radius=FOOT_RADIUS,
                    apply_to="zmax");

                translate([THICKNESS, THICKNESS, 0])
                cube([LEG_W, LEG_W, SLEEVE + EPS]);
            }
            translate([0, -EPS, 0])
            cube([x_1 - FOOT_RADIUS, x_1, SLEEVE+BASE_THICKNESS]);
        }
    }
}

top_connector(include_angle=true);
