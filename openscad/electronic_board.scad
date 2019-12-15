board_height=1.5;
hole=3;
size=2;

module elecboard(width,deep,security=0) {
    difference() {
        translate([0,0,board_height/2]) cube([width+2*security,deep+2*security,board_height],true);
        translate([width/2-2*hole,deep/2-2*hole,0]) cylinder(board_height,d=hole,$fn=16);
        translate([width/2-2*hole,-deep/2+2*hole,0]) cylinder(board_height,d=hole,$fn=16);
        translate([-width/2+2*hole,deep/2-2*hole,0]) cylinder(board_height,d=hole,$fn=16);
        translate([-width/2+2*hole,-deep/2+2*hole,0]) cylinder(board_height,d=hole,$fn=16);
    }
}

module entretoises(width,deep,height, security=0) {
    difference() {
        union() {
            translate([width/2-2*hole,deep/2-2*hole,0]) cylinder(height,d=hole+2*size,$fn=16);
            translate([width/2-2*hole,-deep/2+2*hole,0]) cylinder(height,d=hole+2*size,$fn=16);
            translate([-width/2+2*hole,deep/2-2*hole,0]) cylinder(height,d=hole+2*size,$fn=16);
            translate([-width/2+2*hole,-deep/2+2*hole,0]) cylinder(height,d=hole+2*size,$fn=16);
        }
        translate([width/2-2*hole,deep/2-2*hole,0]) cylinder(height,d=hole+2*security,$fn=16);
        translate([width/2-2*hole,-deep/2+2*hole,0]) cylinder(height,d=hole+2*security,$fn=16);
        translate([-width/2+2*hole,deep/2-2*hole,0]) cylinder(height,d=hole+2*security,$fn=16);
        translate([-width/2+2*hole,-deep/2+2*hole,0]) cylinder(height,d=hole+2*security,$fn=16);
    }
}


module board_screw(width,deep,height, security=0) {
    translate([width/2-2*hole,deep/2-2*hole,0]) cylinder(height,d=hole+2*security,$fn=16);
    translate([width/2-2*hole,-deep/2+2*hole,0]) cylinder(height,d=hole+2*security,$fn=16);
    translate([-width/2+2*hole,deep/2-2*hole,0]) cylinder(height,d=hole+2*security,$fn=16);
    translate([-width/2+2*hole,-deep/2+2*hole,0]) cylinder(height,d=hole+2*security,$fn=16);
}
module esp8266() {
    width=48;
    deep=26;
    height=20;
    translate([0,0,height/2]) cube([width,deep,height],true);
}

module dac() {
    width=29;
    deep=18;
    height=20;
    translate([0,0,height/2]) cube([width,deep,height],true);
}

module shift_register() {
    width=29;
    deep=35;
    height=20;
    translate([0,0,height/2]) cube([width,deep,height],true);
}


module board_esp8266(width,deep,security=0) {
    elecboard(width,deep,security);
    translate([-(width-48)/2+4*hole,0,board_height]) esp8266();
}


module board_dac(width,deep,security=0) {
    elecboard(width,deep,security);
    translate([(width-29)/2-4*hole,0,board_height]) dac();
    translate([(-width+35)/2+4*hole,0,board_height]) dac();
}

module boards(width,deep,security=0.2) {
    translate([0,0,25]) board_esp8266(width,deep);
    translate([0,0,board_height]) entretoises(width,deep,25,security);
    board_dac(width,deep);
}

boards(90,45);