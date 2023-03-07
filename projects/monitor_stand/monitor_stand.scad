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
OVERALL_W = 550.0;  // Only needed for assembly demo
TOP_THICKNESS = 20.0;  // Only needed for assembly demo

// Calculations to work out slant distance
x_cross = OVERALL_D - 2*(LEG_W + 2*THICKNESS);
y_cross = OVERALL_H - 2*BASE_THICKNESS;
x_1 = LEG_W + 2*THICKNESS;
// Need to solve x_cross * tan(theta) = y_cross - x_1 / cos(theta)
// Can solve this with a little trig:
A = sqrt(x_cross*x_cross + y_cross*y_cross);
alpha = asin(y_cross / A);
theta = alpha - asin(x_1 / A);

echo("Theta: ", theta);

module bottom_connector(include_angle) {
    difference() {
        roundedcube([LEG_W + 2*THICKNESS, LEG_W + 2*THICKNESS,
            BASE_THICKNESS + SLEEVE], radius=FOOT_RADIUS)
        translate([0, 0, FOOT_RADIUS]);
        
        translate([THICKNESS, THICKNESS, BASE_THICKNESS])
        cube([LEG_W, LEG_W, SLEEVE + EPS]);
    }
    
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

module single_side_assembly() {
    color("black", 1.0)
    union() {
        bottom_connector(include_angle=true);
        
        translate([0, 0, OVERALL_H])
        rotate([180, 0, 90])
        top_connector(include_angle=false);
        
        translate([OVERALL_D - x_1, 0, 0])
        bottom_connector(include_angle=false);
        
        translate([OVERALL_D, 0, OVERALL_H])
        rotate([180, 0, 180])
        top_connector(include_angle=true);
    }
    
    // Steel pieces
    color("black", 1.0)
    union() {
        leg1_h = OVERALL_H - 2*BASE_THICKNESS;
        echo("Vertical leg length: ", leg1_h);
        
        translate([THICKNESS, THICKNESS, BASE_THICKNESS])
        cube([LEG_W, LEG_W, leg1_h]);
        translate([OVERALL_D - LEG_W - THICKNESS, THICKNESS, BASE_THICKNESS])
        cube([LEG_W, LEG_W, leg1_h]);
        
        leg2_h = x_cross / cos(theta);
        echo("Diagonal leg length: ", leg2_h);
        
        translate([x_1 - FOOT_RADIUS, THICKNESS, BASE_THICKNESS + THICKNESS*cos(theta)])
        rotate([0, -theta, 0])
        multmatrix(m = [ [1, 0, tan(theta), 0],
                         [0, 1, 0, 0],
                         [0, 0, 1, 0]]) {
            cube([leg2_h, LEG_W, LEG_W]);
        }
    }
}

module assembly_demo() {
    single_side_assembly();
    
    translate([OVERALL_D, OVERALL_W, 0])
    rotate([0, 0, 180])
    single_side_assembly();
    
    color("saddlebrown", 1.0)
    translate([0, 0, OVERALL_H])
    cube([OVERALL_D, OVERALL_W, TOP_THICKNESS]);
}

assembly_demo();

//top_connector(include_angle=true);
