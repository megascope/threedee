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
end_depth = 1; // floor or ceiling "wall"
end_height = 5; // bottom and lid

/*
https://www.amazon.com/Gledopto-Digital-Controller-DC5-24V-WS2812B
when removed from case PCB is 36x84mm
height is 20mm
*/
pcb_raise = 2; // raise PCB off floor
pcb_thickness = 1.57; // pcb thickness for clamps
pcb_height = 20 + pcb_raise;
pcb_width = 36;
pcb_length = 84;
box_height = 24;
box_width = 48;
box_length = 89;



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

module bottomsection_controller() {
    
    // total wall height at bottom, make room for controller
    height = box_height + end_depth;
    
    // cable access hole
    cable_width = section_width/3;
    cable_height = cable_width/2;
    
    difference() { 
        block(center_radius, section_width, wall_depth, height);
        up(end_depth) cutout(center_radius, height);
        // create cable access hole
        rot(ANGLE*1.5, cp=[0,0,0])
            down(height/2 - end_depth)
                back(center_radius-wall_depth/2) 
                    cuboid([cable_width,wall_depth*3,cable_height], anchor=FRONT+BOTTOM, rounding=1);
    }
    
    tab_flanges(center_radius, wall_depth, height); 
    
    down(height/2 - end_depth)
    all_box_guides();
}

module clamp(raise, thickness, clamp_size, clamp_wall)
{
    fwd(clamp_wall) cuboid([clamp_size, clamp_size, pcb_raise], anchor=FRONT+BOTTOM)
        position(FRONT+TOP)
        cuboid([clamp_size,clamp_wall,thickness], anchor=FRONT+BOTTOM)
        position(TOP)
        fwd(clamp_wall/2)
        wedge([clamp_size,clamp_wall*2,clamp_wall], anchor=FRONT+BOTTOM);
}

module pcb_clamp()
{
    clamp(pcb_raise, pcb_thickness, 4, 1);
}


module boxguide()
{
    clamp_size = 4;
    clamp_wall = 1;
    fwd(clamp_wall) cuboid([clamp_size,clamp_wall,clamp_wall*2], anchor=FRONT+BOTTOM);
}


module all_box_guides() {
    fwd(box_width/2) boxguide();
    back(box_width/2) yflip() boxguide();
    right(box_length/2) zrot(90) boxguide();
    left(box_length/2) zrot(270) boxguide();
}

module all_pcb_clamps() {
    fwd(pcb_width/2) pcb_clamp();
    back(pcb_width/2) yflip() pcb_clamp();
    right(pcb_length/2) zrot(90) pcb_clamp();
    left(pcb_length/2) zrot(270) pcb_clamp();
}

// draw the box or pcb to check
//down(9) cuboid([1,pcb_width,1]) cuboid([pcb_length,1,1]);
//down(0) cuboid([1,box_width,box_height]) cuboid([box_length,1,1]);

bottomsection_controller();

//wallsection();
//up(section_height*2) lidsection();
//down(section_height*2) bottomsection_controller();
