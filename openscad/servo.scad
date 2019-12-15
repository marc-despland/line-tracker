
    box_width=22.5;
    box_depth=23.3;
    box_height=12;
    cylinder_depth=6;
    small_cylinder=3;
    cylinders_width=15;
    gear_radius=2.5;
    gear_height=3;
    fixation_depth=2.5;
    fixation_width=4.5;
    fixation_depth_position=5.5;
    vis_hole=1;
    screw_radius=0.5;
    screw_long=10;
    cable_radius=1.6;
    cable_depth=5.5;


    wheel_depth=8;
    wheel_height=6;
    wheel_radius=30;
    wheel_depth_int=4;
    wheel_gear=2;


function wheelRadius() = wheel_radius;


module servo(with_screw=false,with_cable=false,with_screw_hole=true,security=0) {        
    //big cylinder
    translate([box_width-box_height/2,0,box_height/2]){
        rotate([90,0,0]){
            #cylinder(cylinder_depth,d=box_height+2*security);
        }
    }
    //gear
    translate([box_width-box_height/2,-cylinder_depth,box_height/2]){
        rotate([90,0,0]){
            cylinder(gear_height,gear_radius,gear_radius);
        }
    }
    //small cylinder
    translate([box_width-(cylinders_width-small_cylinder),0,box_height/2]){
        rotate([90,0,0]){
            cylinder(cylinder_depth,d=small_cylinder+2*security,$fn=16);
        }
    }
    //box
    translate([-security,-security,0]) cube([box_width+2*security,box_depth+2*security,box_height+security]);
    
    //fixation droite
    translate([box_width,fixation_depth_position,0]){
        difference() {
            translate([-security,-security,0]) cube([fixation_width+2*security,fixation_depth+2*security,box_height+security]);
            if (with_screw_hole) {
                translate([fixation_width/2,fixation_depth,box_height/2]){
                    rotate([90,0,0]){
                        cylinder(fixation_depth,d=2*(vis_hole+security),$fn=12);
                    }
                }
            }
        }
        if (with_screw) {
            translate([fixation_width/2,screw_long,box_height/2]){
                rotate([90,0,0]){
                    #cylinder(screw_long,screw_radius,screw_radius,$fn=12);
                }
            }
        }
    }
    //fixation gauche
    translate([-fixation_width,fixation_depth_position,0]){
        difference() {
            translate([-security,-security,0]) cube([fixation_width+2*security,fixation_depth+2*security,box_height+security]);
            if (with_screw_hole) {
                translate([fixation_width/2,fixation_depth,box_height/2]){
                    rotate([90,0,0]){
                        cylinder(fixation_depth,d=2*(vis_hole+security),$fn=12);
                    }
                }
            }
        }
        if (with_screw) {
            translate([fixation_width/2,screw_long,box_height/2]){
                rotate([90,0,0]){
                    #cylinder(screw_long,screw_radius,screw_radius,$fn=12);
                }
            }
        }
    }
    if (with_cable) {
        translate([box_width,box_depth-cable_depth,box_height/2]){
            rotate([90,0,90]){
                cylinder(40,d=2*(cable_radius+security),$fn=12);
            }
        }
    }
}

module wheel() {    
    translate([0,0,wheel_radius]){
        rotate([90,0,0]){
            difference() {
                cylinder(wheel_depth,wheel_radius,wheel_radius);
                cylinder(wheel_depth,wheel_radius-wheel_height,wheel_radius-wheel_height);
            }
            translate([0,0,(wheel_depth-wheel_depth_int)/2]){
                cylinder(wheel_depth_int,wheel_radius-wheel_height,wheel_radius-wheel_height);
            }
        }
    }
}


module servo_wheel(with_screw=false,with_cable=false,with_screw_hole=true,security=0) {
    translate([0,-cylinder_depth,]){
        translate([-(box_width-box_height/2), (cylinder_depth+gear_height)-(wheel_depth-wheel_depth_int)/2-wheel_gear,wheel_radius-box_height/2]){
            servo(with_screw,with_cable,with_screw_hole,security=security);
        }

        wheel();
    }
}

servo_wheel(true,true,security=0.2);