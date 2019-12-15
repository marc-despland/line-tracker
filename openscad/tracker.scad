tracker_depth=9;
tracker_width=78;
tracker_height=1.5;
tracker_core_width=78-tracker_depth;
tracker_connector_depth=18-tracker_depth;
tracker_connector_width=29;
tracker_connector_hole=1.4;
tracker_hole_x=tracker_connector_depth+1.75;
tracker_hole_y=tracker_connector_depth-5.8;
sensor_width=5;
sensor_depth=6.5;
sensor_height=6.5;
sensor_distance=16;

function sensorHeight() = tracker_height + sensor_height;

module tracker_board(security=0) {    
    translate([(tracker_core_width-(tracker_connector_width+tracker_connector_depth))/2,tracker_depth,0]){
        difference() {
            translate([-security,0,0]) cube([tracker_connector_width+tracker_connector_depth+2*security,tracker_connector_depth+security,tracker_height+security]);
            translate([0,tracker_depth,0]){
                cylinder(tracker_height+security,d=2*(tracker_depth-security));
            }
            translate([tracker_connector_width+tracker_connector_depth,tracker_depth,0]){
                cylinder(tracker_height+security,d=2*(tracker_depth-security));
            }
        }
    }
    translate([-security,-security,0]) cube([tracker_core_width+2*security,tracker_depth+2*security,tracker_height+security]);
    translate([0,tracker_depth/2,0]){
        cylinder(tracker_height+security,d=(tracker_depth+2*security));
    }
    translate([tracker_core_width,tracker_depth/2,0]){
        cylinder(tracker_height+security,d=tracker_depth+2*security);
    }
}

module sensor(security=0) {
    translate([-security, -security, -security]) cube([sensor_width+2*security,sensor_depth+2*security,sensor_height+security]);
}

module tracker(security=0) {
    translate([-(tracker_width/2), -tracker_depth/2,-tracker_height-sensor_height]) {
        translate([tracker_depth/2,0,sensor_height]) tracker_board(security);
        for(i=[0:4]) translate([(tracker_depth/2)+sensor_distance*i,(tracker_depth-sensor_depth)/2,0]) sensor(security);
    }
}


module mark() {
    linear_extrude(height = 2) {
        polygon([[0,0],[10,0],[5,10]]);
    }
}

module tracker_mask(security=0) {
    border=2;
    height=12;
    difference() {
        cube([(tracker_width-tracker_depth+2*sensor_distance)+2*border,sensor_distance*2+2*border,sensor_height+tracker_height+height]);
        translate([border,border,0]){
            cube([(tracker_width-tracker_depth+2*sensor_distance),sensor_distance*2,sensor_height+border+height]);
        }
    }
    translate([border,border,height]){
        difference() {
            translate([0,0,sensor_height-border]){
                cube([tracker_width-tracker_depth+2*sensor_distance,sensor_distance*2,tracker_height+border]);
            }
            translate([sensor_distance-(tracker_depth/2),(2*sensor_distance-tracker_depth)/2,0]){
                resize([tracker_width+2*security,0,0], auto=true) tracker();
            }
        }
    }
    for(i=[0:4]) {
        translate([border+sensor_distance+(i*(sensor_distance))-(10-sensor_width)/2,sensor_distance*2+2*border,0]){
            echo(border+sensor_distance+(i*(sensor_distance))-(10-sensor_width)/2);
            mark();
        }
    }
    for(i=[0:4]) {
        translate([border+sensor_distance+(i*(sensor_distance))+10-(10-sensor_width)/2,0,0]){
            rotate([0,0,180]) mark();
        }
    }
    translate([0,border+sensor_distance-5,0]){
        rotate([0,0,90]) mark();
    }
     translate([tracker_width-tracker_depth+2*sensor_distance+2*border,border+sensor_distance+5,0]){
        rotate([0,0,-90]) mark();
    }
   
}

//rotate([180,0,0]) tracker_mask();

difference() {
    tracker(0.2);
    tracker(0);
}