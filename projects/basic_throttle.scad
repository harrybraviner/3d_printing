use <list-comprehension-demos/sweep.scad>
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>

$fn=64;

l_z = 140.0;
l_x = 80.0;
l_y = 65.0;
twist=10.0;
expansion=0.35;
expansion_frac=1.2;
expansion_x_bias = 0.7;
expansion_y_bias = 0.8;
end_cap_z = 20.0;

// Scaling to make an elliptical shape
scaling_trans_1 = scaling([1.0, (l_y/l_x), 1.0]);
// Scaling to make the expansion
function scaling_trans_2(z) = let(c=expansion*(1.0 - cos(expansion_frac*90.0*z/l_z))/(1.0 - cos(expansion_frac*90.0))) translation([expansion_x_bias*0.5*c*l_x, expansion_y_bias*0.5*c*l_y, 0.0]) * scaling([1.0 + c, 1.0 + c, 1.0]);

function total_body_trans(z) = translation([0.0, 0.0, z])*rotation([0.0, 0.0, twist*z/l_z]) * scaling_trans_2(z) * scaling_trans_1;

c1 = circle(r=l_x/2.0);
path_trans = [for (z=[0:1.0:l_z]) total_body_trans(z)];

// Sweep out the throttle body
sweep(c1, path_trans);

// Path to make the end-cap
path_trans_end_cap = [for (z=[0:1.0:end_cap_z]) total_body_trans(l_z+z) * scaling([cos(asin(z/end_cap_z)), cos(asin(z/end_cap_z)), 1.0])];
sweep(c1, path_trans_end_cap);

// Path for the left-cap
path_trans_left_cap = [for (z=[0:1.0:end_cap_z]) total_body_trans(0-z) * scaling([cos(asin(z/end_cap_z)), cos(asin(z/end_cap_z)), 1.0])];
sweep(c1, path_trans_left_cap);
