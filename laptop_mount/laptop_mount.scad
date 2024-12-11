/*

inverted laptop mount

y = front/back
x = left/right

*/
include <../BOSL2/std.scad>

$fn=50;

base_depth = 150;
base_width = 20;
base_height = 2;

riser_height = 50;
riser_depth = 10;

module backstop(depth, width, height) {
    color("blue",0.5)
    fwd(depth/2)
    right(width/2)
    yrot(270)
    linear_extrude(width)
    round2d(1)
    right_triangle([depth,height]);
}

cuboid([base_width,base_depth, base_height], rounding=1)
position(FRONT+BOTTOM)
color("red", 0.5) cuboid([base_width, riser_depth, riser_height], anchor=BOTTOM+FRONT, rounding=1);


back((base_depth-riser_depth)/2)
backstop(riser_depth,base_width*9/10,riser_depth);

back((base_depth-riser_depth)/2 - riser_depth*2)
backstop(riser_depth,base_width*9/10,riser_depth);

back((base_depth-riser_depth)/2 - riser_depth*4)
backstop(riser_depth,base_width*9/10,riser_depth);

// create a little support for the riser
fwd(base_depth/2 - riser_depth*11/10)
backstop(riser_depth*2,base_width*9/10,riser_depth*2);