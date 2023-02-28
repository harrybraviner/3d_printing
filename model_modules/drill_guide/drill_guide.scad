WIDTH=15.0;
LENGTH=50.0;
EPS=0.01;
TEXT_DEPTH=1.0;

HOLE_NAMES = ["1/4\"", "3/16\"", "1/8\"", "1/16\""];
HOLE_SIZES = [(1/4)*25.4, (3/16)*25.4, (1/8)*25.4, (1/16)*25.4];
HOLE_EXTRA = 0.1;

TOP_SURFACE_Z = 0.75*WIDTH;

module base() {
    translate([0, 0, -0.1*WIDTH])
    difference() {
        cube([WIDTH, LENGTH, WIDTH*.85]);
        
        union() {
            rotate([0, 45.0, 0])
            translate([0, -EPS, 0])
            cube([WIDTH/sqrt(2.0), LENGTH+2*EPS, WIDTH/sqrt(2.0)]);
            
            translate([-EPS, -EPS, -EPS])
            cube([WIDTH+2*EPS, LENGTH+2*EPS, 0.1*WIDTH+EPS]);
        }
    }
}

module holes() {
    for (i = [0:len(HOLE_SIZES)-1]) {
        hole_y = LENGTH*(i+1)/(len(HOLE_SIZES) + 1);
        translate([WIDTH/2, hole_y, -EPS])
        cylinder(r=HOLE_EXTRA + HOLE_SIZES[i]/2, h=TOP_SURFACE_Z + 2*EPS, $fn=20);
        
        translate([0.95*WIDTH, hole_y-HOLE_SIZES[i]*0.5, TOP_SURFACE_Z - TEXT_DEPTH])
        linear_extrude(TEXT_DEPTH + EPS)
        rotate([0, 0, 90])
        text(HOLE_NAMES[i], size=2.5);
    }
}

difference() {
    base();
    holes();
}
