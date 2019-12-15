use <tracker.scad>
use <servo.scad>
use <bille.scad>
use <support_servo.scad>
use <electronic_board.scad>


chassis_deep=100;
chassis_height=5;
security=0.2;

module half_cylinder(height,d) {
    difference() {
        cylinder(height,d=d,$fn=32);
        translate([0,-d/2,0]) cube([d,d,height]);
    }
}


module ailette(width, deep, height,top_width, bottom_width) {
    difference() {
        cube([width,deep,height],true);
        translate([width/2,deep,-height/2]) rotate([90,0,0]) resize([(width-bottom_width)*2,0,0]) cylinder(2*deep, d=2*height);
        translate([-width/2+(width-top_width)/2,0,0]) {
            resize([(width-top_width),0,0]) {
                difference() {
                    #cube([height+1,2*deep,height],true);
                    translate([height/2,deep,-height/2]) rotate([90,0,0]) cylinder(2*deep, d=2*height);
                }
            }
        }

    }
}


module ailette_width(width, deep, height,top_width, bottom_width,end_height) {
    difference() {
        small_height=height-end_height;
        cube([width,deep,height],true);
        translate([width/2,deep,-height/2]) rotate([90,0,0]) resize([(width-bottom_width)*2,0,0]) cylinder(2*deep, d=2*small_height);
        
        translate([-width/2+(width-top_width)/2,0,0]) {
            resize([(width-top_width),0,0]) {
                difference() {
                    cube([height,2*deep,height],true);
                    translate([height/2,deep,-height/2]) rotate([90,0,0]) cylinder(2*deep, d=2*height);
                }
            }
        }

    }
}


module support_pile(support_height=15) {
    width=35;
    deep=70;
    height=10;
    size=2;
    translate([0,0,support_height]){
        difference() {
            translate([0,0,(height+size)/2]) cube([width+2*size, deep+2*size,height+size],true);
            translate([0,0,(height)/2+size]) cube([width, deep,height],true);
        }
    }
    translate([-10,deep/2,support_height/2]) ailette(width+2*size+20, 2*size, support_height,width+2*size, 40);
    translate([-10,0,support_height/2]) {
        difference() {
            cube([width+2*size+20,2*size,support_height],true);
            translate([width/2+size+10,size,-support_height/2]) rotate([90,0,0]) resize([2*(support_height+10),0,0]) cylinder(2*size, d=2*support_height);
            #translate([-(width+2*size+20)/2+10,0,0]) {
                cube([20,2*size,support_height],true);
            }

        }
    }
    translate([-10,-deep/2,support_height/2]) ailette(width+2*size+20, 2*size, support_height,width+2*size, 40);
    
}

module support_cube(height=15,with_hole=true) {
    cube_deep=10;
    diam=chassis_deep*2/3;
    border=3;
    difference() {
        union() {
            half_cylinder(height,d=diam);
            translate([0,-diam/2,0]) cube([cube_deep,diam,height]);
        }
        half_cylinder(height,d=diam-(border*2));
        translate([0,-diam/2+border,0]) cube([cube_deep-border,diam-(border*2),height]);
        //if (with_hole) translate([cube_deep-border,0,height/2]) rotate([0,90,0]) #cylinder(border,d=6);
        if (with_hole) translate([cube_deep-border,0,height/2]) rotate([0,90,0]) cube([border,10,6],true);
    }
}

module chapeau_cube() {
    height=4;
    cube_deep=10;
    diam=chassis_deep*2/3;
    border=3;
    base=15;
    difference() {
        union() {
            half_cylinder(height,d=diam);
            translate([0,-diam/2,0]) cube([cube_deep,diam,height]);
            translate([-(diam/2+cube_deep-base)/2,-8,height]) cube([base,base,height/2]);
        }
        translate([0,0,0]) support_cube(height=2,with_hole=false);
        translate([-(diam/2+cube_deep)/2+base,0,0]) cylinder(height*3/2,d=7);
    }
    
}


module chassis() {
    difference() {
        union() {
            translate([-chassis_deep/2,-chassis_deep/2,sensorHeight()+10-chassis_height]) {
                cube([chassis_deep,chassis_deep,chassis_height]);
                translate([chassis_deep,chassis_deep/2,0]) cylinder(chassis_height,d=chassis_deep);
                translate([0,chassis_deep/2,0]) cylinder(chassis_height,d=chassis_deep);
            }
            translate([chassis_deep*2/3,0,0]) bille_box(5,security);
            translate([-chassis_deep*2/3,0,0]) bille_box(5,security);
            
            translate([-10,-chassis_deep/2,5]) {
                difference() {
                    cube([20,chassis_deep,sensorHeight()+10-chassis_height-5]);
                    translate([2,2,0])cube([16,chassis_deep-4,sensorHeight()+10-chassis_height-5]);
                }
            }
        }
        #translate([0,-(chassis_deep/2),0]) support_servo_bas(chassis_height=sensorHeight()+10,security=0.2,mask_security=0,with_screw=true);
        #translate([0,(chassis_deep/2),0]) rotate([0,0,180])  support_servo_bas(chassis_height=sensorHeight()+10,security=0.2,mask_security=0,with_screw=true);
        #rotate([0,0,270]) translate([0,0,sensorHeight()+10]) tracker(security);
        #translate([10,0,sensorHeight()+10-chassis_height-5]) board_screw(90,45,50,security=security);
    }
    translate([-chassis_deep/2,0,sensorHeight()+10]) support_cube();
    translate([10,0,sensorHeight()+10]) entretoises(90,45,10,0.2);
    translate([80,0,sensorHeight()+10]) support_pile();
}

module chassis_haut() {
    ailette_height=40;
    ailette_bottom=supportWidth();
    ailette_width=supportWidth()+30;
    top_width=25;
    top_height=15;
    size=2;
    translate([0,-(chassis_deep/2),0]) {
        support_servo_haut(security=0.2,mask_security=0);
        translate([(supportWidth()/2+(ailette_width/2-ailette_bottom)),3,wheelRadius()+ailette_height/2+10]) rotate([0,0,0]) ailette_width(ailette_width,6,ailette_height,top_width,ailette_bottom,top_height);
    }
    translate([0,(chassis_deep/2),0]) rotate([0,0,180]) {
        support_servo_haut(security=0.2,mask_security=0);
        translate([-(supportWidth()/2+(ailette_width/2-ailette_bottom)),3,wheelRadius()+ailette_height/2+10]) rotate([0,0,180]) ailette_width(ailette_width,6,ailette_height,top_width,ailette_bottom,top_height);
    }
    translate([(supportWidth()/2+(ailette_width-ailette_bottom)-(top_width)/2),0,wheelRadius()+10+ailette_height-(top_height/2)]) {
        difference() {
            cube([top_width,chassis_deep,top_height],true);
            translate([0,0,size/2]) cube([top_width-4*size,chassis_deep-4*size,top_height-size],true);
            translate([0,0,(top_height-size)/2]) cube([top_width-2*size,chassis_deep-2*size,size],true);
            #translate([0,(chassis_deep-2*6-5)/2,-(top_height-size)/2]) cube([top_width-4*size,5,size],true);
            translate([0,-(chassis_deep-2*6-5)/2,-(top_height-size)/2]) cube([top_width-4*size,5,size],true);
        }
        //translate([0,0,5/2*size+10]) capot_led();
    }
}

module capot_led(size=2,top_width=25) {
    difference() {
        union(){
            translate([0,0,size+size/2])cube([top_width,chassis_deep,size],true);
            translate([0,0,size/2]) cube([top_width-2*size,chassis_deep-2*6,size],true);
        }
        leds(size=2,top_width=25,security=0.2,mask=true);
    }
}

module gyrophare(diam=10,height=14,security=0,mask=false) {
    difference() {
        cylinder(height, d=diam+2*security, $fn=32); //led
        if (!mask) {
            cylinder(height/2+4, d=5.1, $fn=32); //led
            cylinder(height/2-3, d=7.1, $fn=32); //led
        }
    }
}

module leds(size=2,top_width=25,security=0,mask=false) {
    difference() {
        translate([0,0,size/2]) cube([top_width-4*size,chassis_deep-2*(6+size),size],true);
        #gyrophare(security=security, mask=true);
        translate([0,chassis_deep/6,0]) gyrophare(security=security, mask=true);
        translate([0,chassis_deep*2/6,0]) gyrophare(security=security, mask=true);
        translate([0,-chassis_deep/6,0]) gyrophare(security=security, mask=true);
        translate([0,-chassis_deep*2/6,0]) gyrophare(security=security, mask=true);
    }
    #gyrophare(security=security, mask=mask);
    translate([0,chassis_deep/6,0]) gyrophare(security=security, mask=mask);
    translate([0,chassis_deep*2/6,0]) gyrophare(security=security, mask=mask);
    translate([0,-chassis_deep/6,0]) gyrophare(security=security, mask=mask);
    translate([0,-chassis_deep*2/6,0]) gyrophare(security=security, mask=mask);
}

//!ailette_width(50,2,20,25,30,10);
chassis_haut();
//!support_pile();

//! leds(mask=false);

color("DarkSlateGray",1.0) chassis();
color("LightGray",1.0) translate([10,0,sensorHeight()+10+10])  boards(90,45);
color("Orange",1.0) translate([0,-(chassis_deep/2),0]) {
    support_servo_bas(chassis_height=sensorHeight()+10,security=0.2,mask_security=0,with_screw=false);
    //support_servo_haut(security=0.2,mask_security=0);
}
color("Orange",1.0) translate([0,(chassis_deep/2),0]) rotate([0,0,180]) {
    support_servo_bas(chassis_height=sensorHeight()+10,security=0.2,mask_security=0,with_screw=false);
    //support_servo_haut(security=0.2,mask_security=0);
}
color("Orange",1.0)     translate([-chassis_deep/2,0,sensorHeight()+10+13]) chapeau_cube();


