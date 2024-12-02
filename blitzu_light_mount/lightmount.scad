/*

Light mounting

    h=17mm
  --------
  ########  | d=2.4mm
  ---##  |
2.0  ##  | l=3.3mm 
=e   ##  |
     
     --
     w=12.26mm
     

wall = 2mm      
gap = 0.2mm
     
   mh=h+(wall+gap)*2 mm
------------|
  ########  | md= d+(wall+gap)*2
     ##  ---|
     ##   me=(e-gap)+wall
     ##  |ml = l-gap
     
     --
     w=12.26mm
*/
include <../BOSL2/std.scad>


h = 17;
d = 2.4;
e = 2.0;
l = 3.3;
w = 12.26;

$fn = 50;

color("maroon", 0.3) cuboid([20,20,20], anchor=BOT, rounding=1);

// inner nail

color("red",0.7) {
    translate([0,0,-d]) {
    cube([h,h,d]);
    translate([(h-w)/2,(h-w)/2,-d])
    cube([w,w,l]);
}
}

// new plan, create cube, extrude, delete 
// insides

gap = 0.2;
wall = 2;
mh = h+2*(wall+gap);
md = d+2*(wall+gap);
me = e-gap+wall;
ml = l-gap;

moff1=(mh-h)/2;

// mount
color("green", 0.4) {
    
    // top
    translate([-moff1,-moff1,gap])
    cube([mh,mh,wall]);

    // side wall
    translate([-moff1,-moff1,gap-md+wall])
    cube([mh,wall,md]);
    
    // inside edge
    translate([-moff1,-moff1,-md+wall+gap])
    cube([mh,me,wall]);

}



