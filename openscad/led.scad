use <../libraries/roundcube.scad>


module led(width) {
    difference() {
        rondcube(2, width, width, width);
        translate([width/2,width/2,0]) cylinder(width/2+4, d=5.1, $fn=32); //led
        translate([width/2,width/2,0]) cylinder(width/2-3, d=7.5, $fn=32); //led
    }
}

led(20);