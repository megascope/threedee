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
  ########  | md= d+l+wall+(2*gap)
     ##     |
     ##     |
     ##     |
     
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






// create cube, delete 
// insides

eps = 0.01;
eps2=2*eps;
gap = 0.2;
gap2 = gap*2;
wall = 2;
mh = h+2*(wall+gap);
md = d+l+wall+gap+gap;
me = e-gap+wall;
ml = l-gap;


// width of insert deletion
dw = (mh-(w+gap2))/2; 

// * means do not render

// debug inner nail
*down(wall+gap) color("red",0.7) {
    cube([h,h,d], anchor=TOP)
    position(BOTTOM) cube([w,w,l], anchor=TOP);
}

// debug height step
*color("white", 1) { 
left(15) cube([1,1,wall], anchor=TOP)
position(BOTTOM) cube([1,1,gap], anchor=TOP+RIGHT)
position(BOTTOM) cube([1,1,d], anchor=TOP+RIGHT)
position(BOTTOM) cube([1,1,gap], anchor=TOP+RIGHT)
position(BOTTOM) cube([1,1,l], anchor=TOP+RIGHT)
    ;
}

// the mount
color("green", 0.5)
difference() {
cuboid([mh,mh,md], anchor=TOP, rounding=1);
down(wall) cube([h+gap2,h+gap2,d+gap2], anchor=TOP)
    cube([w+gap2,w+gap2,l*2], anchor=TOP);
down(wall) left(eps+mh/2) cube([eps2+dw,mh-2*wall, eps+md-wall], anchor=TOP+LEFT);
}

// stopper for the mount
color("darkgreen") left(mh/2-wall+gap2) down(wall) xrot(90) cyl(mh/2,0.5, rounding=0.3);

// mount base
color("blue", 0.5)
{
down(wall-eps) cuboid([mh,mh,wall*2], anchor=BOTTOM,rounding=1);
down(wall-eps) cuboid([mh*3/5,mh*2,wall*2], anchor=BOTTOM,rounding=1);
down(wall-eps) cuboid([mh*2,mh*3/5,wall*2], anchor=BOTTOM,rounding=1);
}
