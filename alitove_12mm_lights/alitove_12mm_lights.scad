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
section_width = 25;
section_height = 25;
center_radius = 50;
wall_depth = 2;
end_depth = 1;
end_height = 5; // bottom and lid


/*
If we want the flat side of a N sided polygon to be R units from the center,
also known as the inradius, we need to calculate the circumradius r using:
r=R/(cos(PI/N​))

in radians, since openscad uses degrees:
r=R/(cos(180/N​))

*/

module block(radius, width, depth, height) {
    hull() 
        for (i = [0:1:SIDES]) {
            rot(ANGLE*i, cp=[0,0,0])
                back(radius)
                    cuboid([width, depth, height], anchor=FRONT);
    };
}

module cutout(radius, height) {
    cyl(r=radius/(cos(180/SIDES)), h=height+2*EPSILON, $fn=SIDES);
}

module tab_cutouts(radius, depth, height) {
    for (i = [0:1:SIDES]) down(EPSILON+height/2) 
            rot(ANGLE*i, cp=[0,0,0]) back(radius-EPSILON) 
                cuboid([TOLERANCE+depth*2, TOLERANCE+depth/2, TOLERANCE+depth], anchor=FRONT+BOTTOM);      
}

module tab_flanges(radius, depth, height) {
    for (i = [0:1:SIDES]) {
        rot(ANGLE*i, cp=[0,0,0])
            up(height/2) 
                back(radius) 
                    cuboid([depth*2, depth/2, depth], anchor=FRONT+BOTTOM);
    }
}

module walls(radius, width, depth, height) {
    // hull together all the walls then carve out the central polyhedron cylinder  
    difference() { 
        block(radius, width, depth, height);
        // center carveout
        cutout(radius, height);
        // add the tab cutouts at the bottom
        tab_cutouts(radius, depth, height);
    }
    // add the tab at the top for the next section
    tab_flanges(radius, depth, height);

}

module holes(radius, depth, diameter) {
    for (i = [0:1:SIDES]) {
        rot(ANGLE*i, cp=[0,0,0]) back(radius-depth/2) ycyl(depth*2, d=hole_diameter, anchor=FRONT);
    }
}


// main wall with holes, to have the snap edges carved out of
module wallsection()
difference() {
    walls(center_radius, section_width,wall_depth, section_height);
    holes(center_radius, wall_depth, hole_diameter);
}

module lidsection() {
    difference() {
        block(center_radius, section_width,wall_depth, end_height);
        down(end_depth) cutout(center_radius, end_height);
        tab_cutouts(center_radius, wall_depth, end_height);
    }
}

module bottomsection() {
    difference() { 
        block(center_radius, section_width, wall_depth, end_height);
        up(end_depth) cutout(center_radius, end_height);
        // create cable access hole
        rot(ANGLE*0.5, cp=[0,0,0])
            up(end_depth)
                back(center_radius-wall_depth/2) 
                    cuboid([section_width/3,wall_depth*3,end_height], anchor=FRONT, rounding=1);
        
    }
    tab_flanges(center_radius, wall_depth, end_height);
    
}

//wallsection();
up(section_height*2) lidsection();
//down(section_height*2) bottomsection();
