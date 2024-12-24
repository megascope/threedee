/*

circular light mount of alitove 12mm lights
https://alitove.com/products/alitove-ws2811-12mm-diffused-digital-rgb-led-pixel-module

y = front/back
x = left/right

https://openscad.org/cheatsheet/
https://github.com/BelfrySCAD/BOSL2/wiki/CheatSheet

* disable
! show only
# highlight / debug
% transparent / background 

*/
include <../BOSL2/std.scad>

// globals
$fn=50;
EPSILON = 0.01;
TOLERANCE = 0.2; // cutout tolerance
SIDES =10;
ANGLE = 360/SIDES;

hole_diameter = 12; // 12mm hole width
section_width = 52;
section_height = 50;
center_radius = 80;
wall_depth = 3;


/*
If we want the flat side of a N sided polygon to be R units from the center,
also known as the inradius, we need to calculate the circumradius r using:
r=R/(cos(PI/N​))

in radians, since openscad uses degrees:
r=R/(cos(180/N​))

*/


module walls(width, depth, height) {
    // hull together all the walls then carve out the central polyhedron cylinder  
    difference() { 
        hull() 
            for (i = [0:1:SIDES]) {
                rot(ANGLE*i, cp=[0,0,0])
                    back(center_radius)
                        cuboid([width, depth, height], anchor=FRONT);
        };
        // center carveout
        cyl(r=center_radius/(cos(180/SIDES)), h=height+2*EPSILON, $fn=10);
        // add the tab cutouts at the bottom
        for (i = [0:1:SIDES]) down(height/2) 
            back(center_radius) 
                cuboid([TOLERANCE+depth*2, TOLERANCE+depth/2, TOLERANCE+depth], anchor=FRONT+BOTTOM);    
    }
    // add the tab at the top for the next section
    for (i = [0:1:SIDES]) {
        rot(ANGLE*i, cp=[0,0,0])
            up(height/2) 
                back(center_radius) 
                    cuboid([depth*2, depth/2, depth], anchor=FRONT+BOTTOM);
    }
    
    
}

module holes(depth, diameter) {
    for (i = [0:1:SIDES]) {
        rot(ANGLE*i, cp=[0,0,0]) back(center_radius-depth/2) ycyl(depth*2, hole_diameter, anchor=FRONT);
    }
}


// main wall with holes, to have the snap edges carved out of
module wallthing()
difference() {
    walls(section_width,wall_depth,section_height);
    holes(wall_depth, hole_diameter);
}


wallthing();