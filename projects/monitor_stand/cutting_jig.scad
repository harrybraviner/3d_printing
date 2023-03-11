include <monitor_stand.scad>

x_outer = LEG_W + 2*THICKNESS;

module cutting_jig() {
    difference() {
        difference() {
            cube([x_outer, x_outer, x_outer]);
            translate([-EPS, THICKNESS, THICKNESS])
            cube([x_outer + 2*EPS, LEG_W, LEG_W]);
        }
        
        translate([x_outer, 0, -EPS])
        rotate([0, 0, theta])
        cube([x_outer*sin(theta) + EPS, x_outer/cos(theta) + EPS, x_outer+2*EPS]);
    }
    
    translate([-x_outer + EPS, 0, x_outer-THICKNESS])
    cube([x_outer, x_outer, THICKNESS]);
}

module cutting_jig_basic() {
    difference() {
        cube([x_outer*.5, x_outer, x_outer]);
        translate([-EPS, THICKNESS, THICKNESS])
        cube([x_outer*.5 + 2*EPS, LEG_W, LEG_W]);
    }
    
    translate([-x_outer + EPS, 0, x_outer-THICKNESS])
    cube([x_outer, x_outer, THICKNESS]);
}

rotate([0, 90, 0])
translate([-x_outer*cos(theta), 0, 0])
rotate([0, 0, -theta])
cutting_jig();

translate([x_outer, 2.2*x_outer, 0])
rotate([0, 90, 180])
translate([-x_outer*.5, 0, 0])
cutting_jig_basic();