use <monitor_stand.scad>

bottom_connector(include_angle=false);
translate([25, 27, 0])
rotate([0, 0, 90])
bottom_connector(include_angle=true);
translate([27, 0, 0])
top_connector(include_angle=false);
translate([80, 100, 0])
rotate([0, 0, 180])
top_connector(include_angle=true);
