/**
Copyright 2023 - Harry Joseph Braviner
For permission to use please contact me by e-mail.

Creates filleted cylinders for smooth blending into flat surfaces.
*/

EPS=0.001;
$fn=32;

module filleted_cylinder(
    r,
    h,
    x1,
    x2,
    angle=180,
) {
    // Create the fillet
    module fillet() {
        theta = acos((x2 - r)/r);  // Angle from y-axis of point where fillet is tangent to cylinder
        r2 = ((1 + cos(theta))*r - x1) / (1 - cos(theta));  // Radius of the cylinder the fillet will be made from
        translate([(r+r2)*sin(theta), r + (r+r2)*cos(theta), 0.5*h])
        difference() {
            cylinder(r=r2+2*r+EPS, h=h, center=true);
            union() {
                cylinder(r=r2, h=h+2*EPS, center=true);
                
                translate([0.0, -0.5*(r2 + 2*r) -0.5*EPS - r2 - EPS, 0.0])
                cube([2*(2*r+r2)+2*EPS, r2 + 2*r + 2*EPS, h+2*EPS], center=true);
                
                translate([0.5*(r2 + 2*r + EPS), 0.0, 0.0])
                cube([r2 + 2*r + EPS, 2*(2*r+r2) + 2*EPS, h+2*EPS], center=true);
                
                translate([-0.5*(r2 + 2*r + EPS) - (r+r2)*sin(theta), 0.0, 0.0])
                cube([r2 + 2*r + EPS, 2*(2*r+r2) + 2*EPS, h+2*EPS], center=true);
                
                rotate([0.0, 0.0, -90 - theta])
                translate([0.0, -0.5*(r2 + 2*r + 2*EPS), 0.0])
                cube([2*(2*r+r2)+2*EPS, r2 + 2*r + 2*EPS, h+2*EPS], center=true);
            }
        }
    }
    
    cylinder(r=r, h=h, center=true);

    translate([0.0, -r, -0.5*h])
    fillet();

    rotate([0.0, 0.0, -180 + angle])
    translate([0.0, -r, -0.5*h])
    mirror([1.0, 0.0, 0.0])
    fillet();
}

// Demo

// Cylinder on a flat part
translate([0.0, -0.5*10.0, 0.0])
cube([45.0, 10.0, 2.0], center=true);
translate([0.0, 10.0 - 3.0, 0.0])
filleted_cylinder(r=10.0, h=2.0, x1 = 3.0, x2=12.0, angle=180);

//Cylinder in a 90 degree corner
translate([100.0, 0.0, 0.0]) {
    translate([0.25*60.0 - 0.5*10.0, -0.5*10.0, 0.0])
    cube([0.5*60.0 + 10.0, 10.0, 2.0], center=true);
    
    rotate([0.0, 0.0, -90.0])
    translate([-0.25*60.0 + 0.5*10.0, -0.5*10.0, 0.0])
    cube([0.5*60.0 + 10.0, 10.0, 2.0], center=true);
    
    translate([10.0 - 3.0, 10.0 - 3.0, 0.0])
    filleted_cylinder(r=10.0, h=2.0, x1 = 3.0, x2=12.0, angle=90);
}