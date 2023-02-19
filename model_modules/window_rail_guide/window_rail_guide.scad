EPS = 0.01;

difference() {
    union() {
        // Main structural block
        translate([-38.0*.5, 3.3, 0.0])
        cube([38.0, (15.4 - 3.3), 8.2]);

        // Little tab at the back
        translate([-19.1*.5, 0.0, 3.4])
        cube([19.1, 3.3+EPS, 1.85]);
        
        R_END_OUTER = (0.5*3. + 1.8);
        // Top surface
        translate([-19.1*.5, 15.4-EPS, 8.2-1.8])
        cube([19.1, 15.8 - R_END_OUTER + 2*EPS, 1.8]);
        // Lower surface
        translate([-19.1*.5, 15.4-EPS + 15.8 - 5.3 - R_END_OUTER, 8.2-2.*1.8 - 3.])
        cube([19.1, 5.3 + 2*EPS, 1.8]);
        // Rounded end
        translate([-.5*19.1, 15.4 + 15.8 -R_END_OUTER, 8.2 - R_END_OUTER]) // FIXME
        rotate([0.0, 90.0, 0.0])
        difference() {
            cylinder(r=R_END_OUTER, h=19.1, $fn=20);
            union() {
                translate([-R_END_OUTER, -R_END_OUTER, -EPS])
                cube([2.*R_END_OUTER, R_END_OUTER + EPS, 19.1+2*EPS]);
                translate([0.0, 0.0, -EPS])
                cylinder(r=.5*3., h=19.1+2.*EPS, $fn=20);
            }
        }
    }
    union() {
        // Drill holes
        translate([4.05*.5 + 5.85*.5, 4.05*.5+10.2, -EPS])
        cylinder(r=4.05*.5, h=8.2+2.0*EPS, $fn=20);
        translate([-4.05*.5 - 5.85*.5, 4.05*.5+10.2, -EPS])
        cylinder(r=4.05*.5, h=8.2+2.0*EPS, $fn=20);
    }
}