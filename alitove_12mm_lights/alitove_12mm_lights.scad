/*

inverted laptop mount

y = front/back
x = left/right

*/
include <../BOSL2/std.scad>

$fn=50;

hole_diameter = 12; // 12mm hole width
section_width = 53;
section_height = 50;
center_radius = 80;
wall_depth = 3;
epsilon = 0.01;

angle = 360/10;
fwd(center_radius) wall_section();
rot(angle*1, cp=[0,0,0]) fwd(center_radius) wall_section();
//rot(angle*2, cp=[0,0,0]) fwd(center_radius) wall_section();
//rot(angle*3, cp=[0,0,0]) fwd(center_radius) wall_section();
//rot(angle*4, cp=[0,0,0]) fwd(center_radius) wall_section();
//rot(angle*5, cp=[0,0,0]) fwd(center_radius) wall_section();
//rot(angle*6, cp=[0,0,0]) fwd(center_radius) wall_section();
//rot(angle*7, cp=[0,0,0]) fwd(center_radius) wall_section();
//rot(angle*8, cp=[0,0,0]) fwd(center_radius) wall_section();
//rot(angle*9, cp=[0,0,0]) fwd(center_radius) wall_section();

module wall_section() {
    hole_in_wall(section_width,wall_depth,section_height);
}

module hole_in_wall(width, depth, height) {
    difference() {
        snapfit_wall(width, depth, height);
        ycyl(depth*1.5, hole_diameter);
    }
}

module snapfit_wall(width, depth, height) {
        cuboid([width, depth, height]) 
        position(TOP+FRONT)
            #cuboid([width+2*epsilon, depth*0.51, depth+epsilon], anchor=TOP+FRONT); 

}




base_depth = 130;
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

module nothing() {
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
}