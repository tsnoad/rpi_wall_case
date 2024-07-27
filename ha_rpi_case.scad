/*
 * Raspberry Pi Wall Mount case
 * Licenced under CC BY-NC-SA 4.0
 * By: TSnoad
 * https://github.com/tsnoad/rpi_wall_case
 * https://hackaday.io/project/197028-raspberry-pi-wall-panel
 */

$fn = 18; //rendering resolution

m3_v_r = (3+0.5-0.1)/2; //radius of m3 bolts, including clearance

casecrn_rad = 20; //radius of the corners of the case

case_proj = 35; //how far does the case stick out
case_tilt = -5; //how tilted is the case

faceplate_thk = 2; //how thick is the facplate


//assembled();

/*components = [
    "ha_rpi_case_mk2_frame",
    "ha_rpi_case_mk2_shell",
    "ha_rpi_case_mk2_cameramount_p1",
    "ha_rpi_case_mk2_cameramount_p2",
    "ha_rpi_case_mk2_sensormount",
    "ha_rpi_case_mk2_face",
];*/

printable(/*components*/);


module printable(components=[]) {
    *frame();
    *translate([0,200,0]) walls();
    
    *rotate([0,180,0]) translate([0,200+50,12-(3+0.6+1)]) camera_plate();
    *translate([0,200+50+30,12-(3+0.6+1)]) camera_plate2();
    *translate([0,200+50+30+185,6.2]) sensor_plate();
    
    *trans_tilt() faceplate();
    //echo(search(components, "ha_rpi_case_mk2_frame"));
}

module assembled() {
    frame();
    *walls();
    
    *trans_tilt() camera_plate();
    *trans_tilt() camera_plate2();
    *trans_tilt() sensor_plate();
    
    *trans_tilt() faceplate();
    
    //placeholder components
    *union() {
        trans_tilt() rotate([0,0,0]) screen_co();
        translate([0,0,8]) poe_co();
        trans_tilt() camera_pos() camera_co();
        rasp_trans() rotate([0,0,-90]) translate([-56/2,-85/2,4+2.8]) {
            translate([0,85-20,0]) cube([56,20,17.4]);
            cube([56,85,5]);
        }
    }
}

/*
$vpr = [90-7.5, 0, 30];
$vpt = [0, -25, -12.5];
$vpd = 650;
$t=1;

rotate([90,0,0]) union() {
    drop_assmb(1) import("/Users/tsnoad/Desktop/3d Parts/Homeassistant Case/ha_rpi_case_mk2_frame.stl");
    
    
    drop_assmb(3) trans_tilt() import("/Users/tsnoad/Desktop/3d Parts/Homeassistant Case/ha_rpi_case_mk2_cameramount_p1.stl");
    drop_assmb(4) trans_tilt() import("/Users/tsnoad/Desktop/3d Parts/Homeassistant Case/ha_rpi_case_mk2_cameramount_p2.stl");
    
     
    drop_assmb(2) import("/Users/tsnoad/Desktop/3d Parts/Homeassistant Case/ha_rpi_case_mk2_shell.stl");
    
    drop_assmb(5) trans_tilt() import("/Users/tsnoad/Desktop/3d Parts/Homeassistant Case/ha_rpi_case_mk2_sensormount.stl");
    
    *drop_assmb(6) trans_tilt() import("/Users/tsnoad/Desktop/3d Parts/Homeassistant Case/ha_rpi_case_mk2_face.stl");
}

module drop_assmb(num) {
    translate([0,0,500*pow(min(0,$t-(num+3)/(6+3)),2)]) children();
}
*/




module frame() difference() {
    union() {
        base();
        bosses();
    }
    
    base_co();
    
    poe_pos() translate([0,0,8+0.01]) poe_co();
    
    trans_tilt() presence_sensor_pos() translate([0,0,0.01]) presence_sensor_co();
}


module bosses() difference() {
    union() {
        trans_tilt() intersection() {
            union() {
                camera_boss();
                sensor_boss();
            }
            
            *hull() {
                crns_case(true,casecrn_rad);
            }
            
            
            trans_untilt() linear_extrude(height=50) projection(cut=true) {
                trans_tilt() hull() {
                    crns_case(true,casecrn_rad-2.4-0.4);
                }
            }
        }
        trans_tilt() corner_bosses();
        
        poe_boss();
    }
    
    
    trans_tilt() {
        translate([0,0,0.01]) {
            screen_co();
            hull() for(ix=[-(164.9/2),(164.9/2)]) for(iy=[-124.27/2,124.27/2]) translate([ix,iy,-(1.6+6.2)]) cylinder(r=0.5,10);
        }
        
        camera_pos() translate([0,0,0.01]) camera_co();
        
        translate([0,0,-(6.2)]) {
            for(ix=[-80,80]) for(iy=[-85]) translate([ix,iy,0]) screw_co(8,1.2,4);
            for(ix=[30]) for(iy=[-85]) translate([ix,iy,0]) screw_co(8,1.2,6.2);
        }
    }
    
    translate([0,0,-200]) cylinder(r=200,h=200);
}

module sensor_plate() difference() {
    union() {
        translate([0,0,-(6.2)]) {
            hull() for(ix=[-25,70]) for(iy=[-85-10,-85+10]) translate([ix,iy,0]) cylinder(r=5,h=6.2);
                
            hull() {
                for(ix=[-75,75]) for(iy=[-85-10,-85+10]) translate([ix,iy,0]) cylinder(r=5,h=4);
                for(ix=[-80,80]) for(iy=[-85]) translate([ix,iy,0]) cylinder(r=7.5,h=4);
            }
        }
            
        touch_sensor_pos() translate([0,0,-0.2]) {
            hull() for(ix=[-11/2,11/2]) for(iy=[-11/2,-11/2+15]) translate([ix,iy,-5]) cylinder(r=0.5+2.4,h=5-0.4);
        }
    }
    
    translate([0,0,0.01])  touch_sensor_pos() touch_sensor_co();
    
    presence_sensor_pos() translate([0,0,-0.01]) presence_sensor_co();
    
    
    translate([0,0,-(6.2)]) {
        for(ix=[-80,80]) for(iy=[-85]) translate([ix,iy,0]) screw_co(8,1.2,4);
        for(ix=[30]) for(iy=[-85]) translate([ix,iy,0]) screw_co(8,1.2,6.2);
    }
}

module walls() {
    difference() {
        trans_tilt() {
            intersection() {
                hull() crns_case(true,casecrn_rad);
                hull() crns_case() translate([0,0,-100]) cylinder(r1=casecrn_rad-0.8+100,r2=casecrn_rad-0.8,h=100);
            }
            
            //bulge for screen cables
            hull() for(iz=[0,-(22+6.2)]) for(iy=[-124.27/2+70,124.27/2-17]) {
                translate([(164.9/2)+12+0.5-10,iy,iz]) {
                    sphere(r=10+1.6);
                    translate([-10,0,-10]) sphere(r=10+1.6);
                }
            }
        }
        //cut off top
        trans_tilt() cylinder(r=200,h=200);
        //cut out body
        trans_tilt() {
            hull() crns_case(true,casecrn_rad-2.4);
            
            //bulge for screen cables
            hull() for(iz=[0,-(22+6.2)]) for(iy=[-124.27/2+70,124.27/2-17]) {
                translate([(164.9/2)+12+0.5-10,iy,iz]) {
                    sphere(r=10);
                    translate([-10,0,-10]) sphere(r=10);
                }
            }
        }
        //cut out bottom
        translate([0,0,-200+1]) cylinder(r=200,h=200);
        
        //trans_tilt() translate([0,0,0.01]) screen_co();
        
        *rasp_cab_co(true);
        
        
        //ventilation holes
        *for(ixm=[0,1]) mirror([ixm,0,0]) hull() for(ix=[40,55]) translate([ix,70,4+2.5]) rotate([-90,0,0]) cylinder_oh(2.5,50);
    }
    
    intersection() {
        trans_tilt() hull() crns_case(true,casecrn_rad);
        
        wall_attach_pos() difference() {
            hull() for(ix=[0,20]) translate([ix,0,1]) {
                cylinder(r=5+0.25+2.4+0.25-0.25,h=-1+4+4+2-0.75);
                translate([0,0,0.25]) {
                    cylinder(r=5+0.25+2.4+0.25-0.75,h=-1+4+4+2-0.25);
                    cylinder(r=5+0.25+2.4+0.25,h=-1+4+4+2-0.25-0.75);
                }
            }
            translate([0,0,8]) screw_co(8,2+0.4,50);
            
            cylinder(r=5+0.25,h=4+4);
            
            hull() {
                cylinder(r=5+0.25+0.25,h=1);
                cylinder(r=5+0.25,h=1+0.25);
            }
            
            translate([-1.75,-1.75,0]) cube([2*1.75,2*1.75,8+0.4]);
            translate([-sqrt(pow(5+0.25,2)-pow(1.75,2)),-1.75,0]) cube([2*sqrt(pow(5+0.25,2)-pow(m3_v_r,2)),2*1.75,8+0.2]);
        }
    }
}

module wall_attach_pos() {
    for(ixm=[0,1]) mirror([ixm,0,0]) {
        for(iy=(ixm==0?[-32.5]:[-40,35])) translate([82.5,iy,0]) {
            children();
        }
    }
}

  
        

module camera_plate() difference() {
    camera_pos() translate([0,0,1]) difference() {
        hull() for(ix=[-(17.5-5),(17.5-5)]) for(iy=[-5,10]) translate([ix,iy,0]) cylinder(r=5,h=3+0.6);
            
        translate([0,0,-1]) camera_co();
    }
    screen_co();
    
    camera_pos() translate([0,0,1]) for(ix=[-(17.5),(17.5)]) translate([ix,0,-1]) cylinder(r=5+0.25,h=100);
    
    //translate([0,0,-200]) cylinder(r=200,h=200);
}
  

module camera_plate2() intersection() {
    pcb_m = 0.5;
    
    camera_pos() translate([0,0,1]) difference() {
        translate([0,0,3+0.6]) {
            hull() for(ix=[-20,20]) for(iy=[-5,10]) translate([ix,iy,0]) cylinder(r=5,h=4);
                
            for(iz=[-(-12+1+3+0.6)+faceplate_thk]) hull() for(ix=[0,1]) mirror([ix,0,0]) for(iy=[0,1]) mirror([0,iy,0]) {
                translate([(iz)*tan(62.2/2)+4-2,(iz)*tan(48.4/2)+4-2,0]) {
                    cylinder(r=2+pcb_m+4-0.4,h=iz);
                    cylinder(r=2+pcb_m+4,h=iz-0.4);
                }
            }
        }
        
        translate([0,0,3+0.6]) {   
            hull() for(iz=[-(-12+1+3+0.6)+faceplate_thk-0.6,-(-12+1+3+0.6)+faceplate_thk]) for(ix=[0,1]) mirror([ix,0,0]) for(iy=[0,1]) mirror([0,iy,0]) {
                translate([(iz)*tan(62.2/2)+4-2,(iz)*tan(48.4/2)+4-2,iz]) {
                    cylinder(r=2+pcb_m,h=10);
                }
            }
        }
            
        translate([0,0,-1-0.01]) camera_co();
    }
    
    camera_pos() translate([0,0,1]) {
        translate([0,0,3+0.6]) {
            hull() for(ix=[-20,20]) for(iy=[-5,12.5]) translate([ix,iy,0]) cylinder(r1=5,r2=5+20*tan(25),h=20);
        }
    }
    //screen_co();
    
    //translate([0,0,-200]) cylinder(r=200,h=200);
}


//screen mounting bosses
module corner_bosses() {
    intersection() {
        for(ixm=[0,1]) mirror([ixm,0,0]) for(iym=[0,1]) mirror([0,iym,0]) {
            hull() for(ib=[0,5]) intersection() {
                translate([156.9/2,114.96/2,0]) {
                    translate([0,0,-100-(6.2)]) {
                        for(ix=[-5,5]) for(iy=[0,30]) translate([ix,iy,0]) {
                            if (ix == -5 && iy == 0) {
                                translate([5,0,0]) cylinder(r=5+ib,h=100);
                                translate([0,5,0]) cylinder(r=5+ib,h=100);
                            } else if (ix == -5 && iy == 30) {
                                translate([5,0,0]) cylinder(r=5+ib,h=100);
                                translate([0,-5,0]) cylinder(r=5+ib,h=100);
                            } else {
                                cylinder(r=5+ib,h=100);
                            }
                        }
                    }
                }
                mirror([0,iym,0]) trans_untilt() translate([-200,-200,-100]) cube([400,400,100+4+(5-ib)]);
            }
            translate([156.9/2,114.96/2,0]) {
                translate([0,0,-100-(6.2)]) {
                    hull() for(ix=[-5,5]) for(iy=[0,30]) translate([ix,iy,0]) {
                        if (ix == -5 && iy == 0) {
                            translate([5,0,0]) cylinder(r=5,h=100);
                            translate([0,5,0]) cylinder(r=5,h=100);
                        } else if (ix == -5 && iy == 30) {
                            translate([5,0,0]) cylinder(r=5,h=100);
                            translate([0,-5,0]) cylinder(r=5,h=100);
                        } else {
                            cylinder(r=5,h=100);
                        }
                    }
                }
            }
        }
        
        trans_untilt() linear_extrude(height=50) projection(cut=true) {
            trans_tilt() hull() {
                crns_case(true,casecrn_rad-2.4-0.4);
            }
        }
    }
    
    for(ixm=[0,1]) mirror([ixm,0,0]) hull() {
        translate([0,0,-5-(6.2)]) {
            for(ix=[80,80-2.5]) for(iy=[-85,-85+10]) {
                for(iz=[0,-7.5]) {
                    translate([ix+iz*tan(30)*cos(45),iy-iz*tan(30)*sin(45),iz]) cylinder(r=5,h=5);
                }
            }
        }
    }
}

module camera_boss() {
    difference() {
        union() {
            hull() for(ix=[-20,20]) for(iy=[65-10,65+5]) translate([ix,iy,-100-12+1]) cylinder(r=5,h=100+(3+0.6)-0.4);
                
            hull() for(ib=[0,5]) intersection() {
                for(ix=[-20,20]) for(iy=[65-10,65+5]) translate([ix,iy,-100-12+1]) cylinder(r=5+ib,h=100+(3+0.6)-0.4);
                trans_untilt() translate([-200,0,-100]) cube([400,200,100+4+(5-ib)]);
            }
        }
            
        camera_pos() translate([0,0,1]) difference() {
            hull() for(ix=[-(17.5-5),(17.5-5)]) for(iy=[-20,12.5]) translate([ix,iy,0]) cylinder(r=5+0.4,h=50);
        }
    }
    
    camera_pos() translate([0,0,-100+1]) {
        for(ix=[-(17.5),(17.5)]) translate([ix,0,0]) cylinder(r=5,h=100+(3+0.6)-0.4);
    }
}

module sensor_boss() {
    hull() {
        for(ix=[-5,0]) for(iy=[0,7.5]) translate([30+ix,-85+iy,-100-(6.2)]) cylinder(r=5,h=100);
        for(ix=[-7.5*tan(45)-5]) for(iy=[7.5]) translate([30+ix,-85+iy,-100-(6.2)]) cylinder(r=5,h=100);
    }
        
    hull() for(ib=[0,5]) intersection() {
        union() {
        for(ix=[-5,0]) for(iy=[0,7.5]) translate([30+ix,-85+iy,-100-(6.2)]) cylinder(r=5+ib,h=100);
        for(ix=[-7.5*tan(45)-5]) for(iy=[7.5]) translate([30+ix,-85+iy,-100-(6.2)]) cylinder(r=5+ib,h=100);
        }
        
        trans_untilt() translate([-200,-200,-100]) cube([400,400,100+4+(5-ib)]);
    }
}


module touch_sensor_pos() {
    for(ix2=[-17.5,17.5]) translate([ix2,-85,faceplate_thk-0.4]) children();
}

//datum is top of pcb
module touch_sensor_co(not_faceplate=true) {
    hull() for(ix=[-11/2,11/2]) for(iy=[-11/2,-11/2+15]) translate([ix,iy,-1]) cylinder(r=0.5,h=1);
    
    hull() for(ix=[-(11/2-0.75),(11/2-0.75)]) for(iy=[-(11/2-0.75),-11/2+15-1.5]) translate([ix,iy,-1-4]) cylinder(r=0.5,h=1+4);
    
   hull() for(ix=[-3.75,3.75]) for(iy=[-11/2+15-5,-11/2+15+20]) translate([ix,iy,-1-4]) cylinder(r=0.5,h=1+4-faceplate_thk+0.4);
       
   if(not_faceplate) {
       hull() for(ix=[-3.75,3.75]) for(iy=[-11/2+15-5,-11/2+15+2.4+0.5]) translate([ix,iy,-1-4]) cylinder(r=0.5,h=4+1);
           
   //faceplate
   } else {
        hull() for(ix=[-11/2,11/2]) for(iy=[-11/2,-11/2+15]) translate([ix,iy,-1-4]) cylinder(r=0.5+2.5+0.25,h=1+4-0.4);
   }
}

module presence_sensor_pos() {
    translate([55,-85,-6.2+1.2+2.4]) children();
}

//datum is top of pcb
module presence_sensor_co() {
    co_h = 6.2-1.2-2.4;
    
    hull() for(ix=[-22/2,22/2]) for(iy=[-16/2,16/2]) translate([ix,iy,-1.2]) cylinder(r=0.5,h=co_h+1.2);
        
    translate([0,0,-10+0.01]) {
        hull() {
            for(ix=[-(22/2-0.25-2.5),(22/2-0.25-2.5)]) for(iy=[-(16/2-0.25),(16/2-0.25)]) translate([ix,iy,0]) cylinder(r=0.5,h=10);
            for(ix=[-(22/2-0.25),(22/2-0.25)]) for(iy=[-(16/2-0.25-2.5),(16/2-0.25-2.5)]) translate([ix,iy,0]) cylinder(r=0.5,h=10);
        }
        
        hull() for(ix=[-5,5]) for(iy=[16/2,16/2+2]) translate([ix+sign(ix)*(iy==16/2?2:0),iy,0]) cylinder(r=0.5,h=10+co_h);
    }
        
    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([22/2+1.6+1.25,1.5,0]) {
        translate([0,0,-1.2]) cylinder(r=1.25,h=co_h+1.2);
    }
    for(ix=[0,1]) mirror([ix,0,0]) translate([22/2+1.6+1.25,1.5,0]) {
        translate([0,0,-8]) cylinder(r=1.25,h=10);
    }
    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([22/2+1.6+1.25,1.5,0]) {
        translate([0,0,-8]) cylinder(r=1.75,h=8-2.4-1.2);
        translate([0,0,-8-1.75]) cylinder(r=0.01,h=8-2.4-1.2);
    }
    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([22/2+1.6+1.25,1.5,0]) {
        translate([0,0,-8]) cylinder(r=1.25,h=10);
    }
    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([22/2+1.6+1.25,1.5,0]) {
        cylinder(r=5,h=co_h);
    }
    
    hull() for(ix=[-22/2,22/2]) for(iy=[-16/2,16/2]) translate([ix,iy,0]) {
        cylinder(r1=0.5,r2=0.5+co_h,h=co_h);
        translate([0,0,co_h]) {
            cylinder(r=0.5+co_h-0.4,h=faceplate_thk-0.4);
            cylinder(r=0.5+co_h,h=faceplate_thk-0.4-0.4);
        }
    }
}
          
module foo() difference() {
    *trans_tilt() {
        hull() mirror_xy([164.9/2,124.27/2,-(1.6+6.2)]) cylinder(r=0.8,20);
        hull() mirror_xy([164.9/2,107/2,-(7+1.6+6.2)]) cylinder(r=0.8,20);
    }
}



module base() {
    difference() {
        union() {
            *difference() {
                trans_tilt() hull() {
                    crns_case(true,casecrn_rad);
                }
                translate([0,0,4]) cylinder(r=200,h=200);
                translate([0,0,-200]) cylinder(r=200,h=200);
            }
            
            linear_extrude(height=4) projection(cut=true) {
                trans_tilt() hull() {
                    crns_case(true,casecrn_rad-2.4-0.4);
                }
            }
            translate([0,-30+(30+5)/2,0]) for(ixm=[0,1]) mirror([ixm,0,0]) {
                mnt_x = 85;
                translate([mnt_x,0,0]) cylinder(r=2+2.4,h=4);
            }
            
            
            //raspberry pi mount
            rasp_trans() rasp_mnt() {
                cylinder(r=1.25+1.6,h=4+2.8);
                hull() {
                    cylinder(r=1.25+1.6,h=4+2);
                    cylinder(r=1.25+1.6+2,h=4);
                }
            }
        }
        
        rasp_trans() translate([0,0,-1]) rasp_mnt() {
            cylinder(r=1.25,h=20);
        }
        
        *rasp_cab_co();
        
        //vent ramps    
        for(ixm=[0,1]) mirror([ixm,0,0]) translate([46.25,71.25,0.2]) mk2_vent_co(25);
        mirror([0,1,0]) translate([-27.5,87.5,0.2]) mk2_vent_co(50);
        
        
        //mounting holes and alignment markers
        translate([0,-30+(30+5)/2,0]) for(ixm=[0,1]) mirror([ixm,0,0]) {
            mnt_x = 85;
            
            rotate([0,0,-5]) rotate_extrude(angle=2*5,$fn=$fn*16) translate([mnt_x-2,-1]) square([2*2,10]);
            for(ia=[-1,1]) rotate([0,0,5*ia]) translate([mnt_x,0,-1]) cylinder(r=2,h=10);
                
            for(ia=[-1,0,1]) rotate([0,0,5*ia]) translate([mnt_x,0,4-0.6]) hull() {
                for(ix=[0,-7.5]) translate([ix,0,0]) cylinder(r1=0,r2=1,h=1);
            }
            for(ia=[-0.5,0.5]) rotate([0,0,5*ia]) translate([mnt_x,0,4-0.6]) hull() {
                for(ix=[0,-5]) translate([ix,0,0]) cylinder(r1=0,r2=1,h=1);
            }
        }
        
        //cable port and cable tie holes
        translate([0,-7.5,-0.01]) {
            translate([0,7.5+(-30+(30+5)/2),0]) {
                hull() for(ix=[-4,4]) for(iy=[-2,7.5-2]) translate([ix,iy,0]) cylinder(r=3.75,h=50);
                hull() for(ix=[-4,4]) for(iy=[-2,7.5-2]) translate([ix,iy,0]) cylinder(r1=3.75+0.5,r2=3.75,h=0.5);
                hull() for(ix=[-4,4]) for(iy=[-2,7.5-2]) translate([ix,iy,4-0.5+2*0.01]) cylinder(r1=3.75,r2=3.75+0.5,h=0.5);
            }
            
            for(ix=[25,25+15]) {
                for(iy=[0,1]) mirror([0,iy,0]) translate([ix,2+1.2,0]) cylinder(r=2,h=50);
                    
                for(iy=[0,1]) mirror([0,iy,0]) hull() {
                    translate([ix-(2-0.5),2+1.2,0]) cylinder(r=0.5,h=2);
                    translate([ix+(2-0.5),2+1.2,0]) cylinder(r=0.5,h=2);
                
                    translate([ix-(2-0.5),2+1.2-(2-0.5),0]) cylinder(r=0.5,h=2);
                    translate([ix+(2-0.5),2+1.2-(2-0.5),0]) cylinder(r=0.5,h=2);
                }
                    
                hull() for(iy=[0,1]) mirror([0,iy,0]) translate([ix,2+1.2,0]) cylinder(r=2,h=2-0.2);
                hull() for(iy=[0,1]) mirror([0,iy,0]) translate([ix,2+1.2,0]) cylinder(r1=2+0.5,r2=2,h=0.5);
            }
        }
        
        //cutouts for attaching wall to base
        wall_attach_pos() {
            hull() for(ix=[0,20]) translate([ix,0,1]) {
                cylinder(r=5+0.25+2.4+0.5-0.25,h=50);
                translate([0,0,0.25]) cylinder(r=5+0.25+2.4+0.5,h=50);
            }
            translate([0,0,8]) screw_co(8,1.2,50);
        }
    }
    
    //studs for attaching wall to base
    wall_attach_pos() difference() {
        union() {
            hull() {
                cylinder(r=5-0.25-0.25,h=4+4);
                cylinder(r=5-0.25,h=4+4-0.25);
            }
            hull() {
                cylinder(r=5-0.25+0.25,h=1);
                cylinder(r=5-0.25,h=1+0.25);
            }
        }
        translate([0,0,8]) screw_co(8,1.2,50);
    }
        
    *intersection() {
        translate([0,-30+(30+5)/2,0]) for(ixm=[0,1]) mirror([ixm,0,0]) {
            mnt_x = 85;
            
            shrd_h = 4+5;
            
            difference() {
                union() {
                    rotate([0,0,-5]) rotate_extrude(angle=2*5,$fn=$fn*16) translate([mnt_x-7.5-(2+6.25+4),0]) square([7.5+2*(2+6.25+4)+20,shrd_h]);
                    
                    for(ia=[-1,1]) rotate([0,0,5*ia]) hull() {
                        translate([mnt_x-7.5,0,0]) cylinder(r=2+6.25+4,h=shrd_h);
                        translate([mnt_x+20,0,0]) cylinder(r=2+6.25+4,h=shrd_h);
                    }
                }
                    
                rotate([0,0,-5]) rotate_extrude(angle=2*5,$fn=$fn*16) translate([mnt_x-7.5-(2+6.25),-1]) square([7.5+2*(2+6.25),50]);
            
                for(ia=[-1,1]) rotate([0,0,5*ia]) hull() {
                    translate([mnt_x-7.5,0,-1]) cylinder(r=2+6.25,h=50);
                    translate([mnt_x,0,-1]) cylinder(r=2+6.25,h=50);
                }
            }
        }
        trans_tilt() hull() {
            crns_case(true,casecrn_rad);
        }
    }
}

module base_co() {
    //cutouts
    hull() for(ix=[-60,60]) for(iy=[5+14+5+5,40]) {
        translate([ix,iy,-1]) cylinder(r=5,h=50);
    }
    hull() for(ix=[-65+51.5+2*5,60]) for(iy=[5,40]) {
        translate([ix,iy,-1]) cylinder(r=5,h=50);
    }
    translate([-65+51.5+2*5-5,5+14+5,-1]) linear_extrude(height=50) difference() {
        translate([-5,-5]) square([2*5,2*5]);
        translate([-5,-5]) circle(r=5);
    }
    rasp_trans() rotate([0,0,-90]) translate([-56/2,-85/2,-10]) {
        hull() for(ix=[-10,10]) for(iy=[-50,20]) {
            translate([56/2+ix,(87.1-15)/2+iy,-1]) cylinder(r=5,h=50);
        }
        hull() for(ix=[-10,25]) for(iy=[50,65]) {
            translate([56/2+ix,(87.1-15)/2+iy,-1]) cylinder(r=5,h=50);
        }
    }
}


module mk2_vent_co(wid=10) rotate([0,0,90]) {
    rotate([90,0,0]) rotate_extrude(angle=90-atan((4-0.2)/10)) mk2_vent_co_cs(wid);
    translate([0,0,-10+0.01]) linear_extrude(height=10) mk2_vent_co_cs(wid);
    rotate([0,-(90-atan((4-0.2)/10)),0]) translate([0,0,-0.01]) linear_extrude(height=20) mk2_vent_co_cs(wid);
}

module mk2_vent_co_cs(wid) hull() {
    translate([2,wid/2]) circle(r=2);
    translate([2,-wid/2]) circle(r=2);
    
    translate([20,wid/2]) circle(r=2);
    translate([20,-wid/2]) circle(r=2);
}


//frontplate
module faceplate() union() {
    difference() {
        union() {
            hull() crns_case() {
                cylinder(r=casecrn_rad,h=faceplate_thk-1.2);
                cylinder(r=casecrn_rad-1.2,h=faceplate_thk);
            }
            crns_screws() hull() {
                cylinder(r=5+6.2,h=2);
                translate([0,0,-6.2]) cylinder(r=5,h=2+6.2);
            }
            
            *camera_pos() translate([0,0,0.2]) {
                hull() for(ix=[-10,10]) for(iy=[-5,10]) translate([ix,iy,1+3+0.6]) {
                    translate([0,0,0.5]) cylinder(r=5,h=-(-12+1+3+0.6)+2-0.2-0.5);
                    cylinder(r=5-0.5,h=-(-12+1+3+0.6)+2-0.2);
                }
            }
            *camera_pos() translate([0,0,12]) {
                hull() for(ix=[-10,10]) for(iy=[-5,10]) translate([ix,iy,0]) {
                    translate([0,0,-0.5]) cylinder(r=5,h=2+0.5);
                    cylinder(r=5+0.5,h=2);
                }
            }
                
            *translate([55,-85,-5]) hull() for(ix=[-15,15]) for(iy=[-10,10]) translate([ix,iy,0]) {
                translate([0,0,0.5]) cylinder(r=5,h=5+2-0.2-0.5);
                cylinder(r=5-0.5,h=5+2-0.2);
            }
            *translate([55,-85,0]) hull() for(ix=[-15,15]) for(iy=[-10,10]) translate([ix,iy,0]) {
                translate([0,0,-0.5]) cylinder(r=5,h=2+0.5);
                cylinder(r=5+0.5,h=2);
            }
        }
        
        screen_co();
        
        *camera_pos() translate([0,0,-0.01]) camera_co(0.5,false);
        
        pcb_m = 0.5;
        camera_pos() translate([0,0,12]) {
            for(iz=[-(-12+1+3+0.6)+faceplate_thk]) {
                hull() for(ix=[0,1]) mirror([ix,0,0]) for(iy=[0,1]) mirror([0,iy,0]) {
                    translate([(iz)*tan(62.2/2)+4-2,(iz)*tan(48.4/2)+4-2,-1]) {
                        cylinder(r=2+pcb_m+4+0.25,h=iz);
                        //cylinder(r=2+pcb_m+4,h=iz-0.4);
                    }
                }
                hull() for(ix=[0,1]) mirror([ix,0,0]) for(iy=[0,1]) mirror([0,iy,0]) {
                    translate([(iz)*tan(62.2/2)+4-2,(iz)*tan(48.4/2)+4-2,faceplate_thk]) {
                        translate([0,0,-0.4]) cylinder(r=2+pcb_m+4+0.25,h=iz);
                        cylinder(r=2+pcb_m+4+0.25+0.4,h=iz);
                    }
                }
            }
        }
        
        translate([0,0,-0.01])  touch_sensor_pos() touch_sensor_co(false);
        presence_sensor_pos() translate([0,0,-0.01]) presence_sensor_co();
        
        *for(ix2=[-17.5,17.5]) translate([ix2,-85,1.6-0.4]) {
            hull() for(ix=[-11/2,11/2]) for(iy=[-11/2,-11/2+15]) translate([ix,iy,-10]) cylinder(r=0.5+2.4+0.5,h=10);
        }
        *for(ix2=[-17.5,17.5]) translate([ix2,-85,1.6]) {
            hull() for(ix=[-11/2,11/2]) for(iy=[-11/2,-11/2+15]) translate([ix,iy,-10]) cylinder(r=0.5,h=10);
        }
        
        for(ix2=[-17.5,17.5]) translate([ix2,-85,2-0.4]) difference() {
            hull() for(iy=[-5,5]) for(ix=[-2.5,2.5]) translate([ix,iy,0]) {
                cylinder(r1=7.5+1,r2=7.5+1+5,h=5);
            }
            hull() for(iy=[-5,5]) for(ix=[-2.5,2.5]) translate([ix,iy,-0.01]) {
                cylinder(r1=7.5,r2=7.5-2,h=2);
            }
        }
        
        *translate([55,-85,-5-0.01]) {
            hull() for(iz=[0,5+2-0.4]) for(ix=[0,1]) mirror([ix,0,0]) for(iy=[0,1]) mirror([0,iy,0]) {
                translate([(iz)*tan(60/2)+22/2-2-1,(iz)*tan(60/2)+16/2-2-1,iz]) cylinder(r=2,h=0.01);
            }
            hull() for(ix=[0,1]) mirror([ix,0,0]) for(iy=[0,1]) mirror([0,iy,0]) {
                translate([22/2-2-1,16/2-2-1,-10]) cylinder(r=2+0.4,h=10+5);
            }
            
            hull() for(ix=[0,1]) mirror([ix,0,0]) translate([22/2+1.6+1.25,1.5,0]) {
                translate([0,0,-10]) cylinder(r=3,h=10+3);
            }
        }
        
        //translate([0,-200,-100]) cube([200,400,200]);
        //translate([-(156.9/2),-200-114.96/2,-100]) cube([200,400,200]);
    }
    
    
    
    difference() {
        hull() {
            crns_case(true,casecrn_rad-2.4-0.4);
        }
        hull() {
            crns_case(true,casecrn_rad-2.4-0.4-2.4);
        }
        translate([0,0,2]) cylinder(r=200,h=200);
        translate([0,0,-200-1.6]) cylinder(r=200,h=200);
    }
}

module crns_screws() {
    mirror_xy([156.9/2,114.96/2,0]) children();
}
module crns_viewport() {
    translate([-(3+5)/2+3,-(12+4)/2+12,0]) mirror_xy([(164.9-3-5)/2,(107-12-4)/2,0]) children();
}
module crns_case(case_shape=false, sphere_r=casecrn_rad) {
    pcb_w = 164.9;
    pcb_h = 124.27;
    
    for(ix=[-(pcb_w/2-5),(pcb_w/2-5+0.75/*for cable clearance*/)]) {
        for(iy=[-(pcb_h/2+30),(pcb_h/2+5)]) {
            translate([ix,iy,0]) {
                if (case_shape) rotate([(iy>0?-1:1)*17.5-case_tilt,0,0]) {
                    sphere(r=sphere_r);
                    //translate([0,0,-100]) cylinder(r=sphere_r,h=100);
                    rotate([0,0,atan2(sign(iy),sign(ix))]) translate([-100,0,0]) rotate([-90,0,0]) rotate_extrude(angle=45,$fn=$fn*4) translate([100,0]) circle(r=sphere_r,$fn=$fn/4);
                } else {
                    children();
                }
            }
        }
    }
}

/*module case_spheres(sphere_r=casecrn_rad) {
    for(ix=[0,1]) mirror([ix,0,0]) {
        for(iy=[-(124.27/2+20),(124.27/2-5)]) {
            translate([164.9/2-5,iy,0]) {
                sphere(r=sphere_r);
                translate([0,0,-100]) cylinder(r=sphere_r,h=100);
            }
        }
    }
    
    //crns_case() sphere(r=sphere_r);
    //crns_case() translate([5,5,-75]) sphere(r=sphere_r-20);
    
    //casecrn_trans_array = [106/2-5,68/2+20,0];
    //translate([0,0,-sqrt(pow(casecrn_trans_array[0],2)+pow(casecrn_trans_array[1],2))/tan(22.5)]) sphere(r=sphere_r);
}*/


module rasp_trans() {
    translate([-5,25-65,0]) children();
}
            
module rasp_mnt() rotate([0,0,-90]) translate([-56/2,-85/2,0]) {
    translate([3.5,3.5,0]) children();
    translate([3.5,3.5+58,0]) children();
    translate([3.5+49,3.5+58,0]) children();
    translate([3.5+49,3.5,0]) children();
}

module rasp_cab_co(wall_co=false) {
    rasp_trans() translate([-85/2+3.5+7.7,-45,0]) {
        if (wall_co) {
            hull() for(iz=[-10,4+2.5]) translate([0,0,iz]) rotate([90,0,0]) cylinder_oh(2.5,50);
                
            for(iz=[4+2.8+1.6+3.31/2]) translate([0,0,iz]) hull() rotate([90,0,0]) cylinder_oh((2.8+1.6+3.31/2),50);
        } else {
            hull() {
                translate([0,0,-10]) cylinder(r=2.5,h=50);
                translate([0,-50,-10]) cylinder(r=2.5,h=50);
            }
            hull() {
                translate([0,0,-10]) cylinder(r=2.5,h=50);
                rotate([0,0,30]) translate([17.5,0,-10]) cylinder(r=2.5,h=50);
            }
            rotate([0,0,30]) translate([17.5,0,-10]) cylinder(r=7.5,h=50);
        }
    }
}

module trans_tilt() {
    translate([0,0,case_proj]) rotate([case_tilt,0,0]) children();
}

module trans_untilt() {
    rotate([-case_tilt,0,0]) translate([0,0,-case_proj]) children();
}


module mirror_xy(trans_vec=[0,0,0]) {
    for(ix=[0,1]) mirror([ix,0,0]) {
        for(iy=[0,1]) mirror([0,iy,0]) {
            translate(trans_vec) children();
        }
    }
}

//camera mount test
*union() {
    difference() {
        hull() for(ix=[-20,20]) for(iy=[-20,20]) translate([ix,iy,0]) cylinder(r=5,h=20);
            
        rotate([5,0,0]) translate([0,0,10]) {
            cylinder(r=50,h=50);
            translate([0,0,-1+0.01]) camera_co();
        }
    }
        
        
    //rotate([5,0,0]) translate([0,0,10]) 
    rotate([180,0,0]) translate([-55,0,-(3+0.6)]) difference() {
        hull() for(ix=[-20,20]) for(iy=[-20,20]) translate([ix,iy,0]) cylinder(r=5,h=3+0.6);
            
        translate([0,0,-1]) camera_co();
    }
    
    //rotate([5,0,0]) translate([0,0,10]) 
    rotate([180,0,0]) translate([55,0,-(3+0.6)+1-5]) difference() {
        translate([0,0,3+0.6]) hull() for(ix=[-20,20]) for(iy=[-20,20]) translate([ix,iy,-1]) cylinder(r=5+0.8+1.6,h=5);
            
        translate([0,0,3+0.6]) hull() for(ix=[-20,20]) for(iy=[-20,20]) translate([ix,iy,-10]) cylinder(r=5+0.8,h=10);
            
        translate([0,0,-1]) camera_co();
    }
}

module screen_co(pcb_m=0.5) {
    //pcb
    hull() for(ix=[(164.9/2),(164.9/2-8)]) for(iy=[-124.27/2,124.27/2]) translate([ix,iy,-(1.6+6.2)]) cylinder(r=pcb_m,1.6);
    mirror([1,0,0]) hull() for(ix=[(164.9/2),(164.9/2-8)]) for(iy=[-124.27/2,124.27/2]) translate([ix,iy,-(1.6+6.2)]) cylinder(r=pcb_m,1.6);
    hull() for(ix=[(164.9/2),-(164.9/2)]) for(iy=[-107/2,107/2]) translate([ix,iy,-(1.6+6.2)]) cylinder(r=pcb_m,1.6);
    
    //screen co
    hull() for(ix=[(164.9/2),-(164.9/2)]) for(iy=[-124.27/2+10,124.27/2-10.5]) translate([ix,iy,-(1.6+6.2)]) cylinder(r=pcb_m,1.6+6.2);
        
    //bottom components
    hull() for(ix=[(164.9/2),(164.9/2)-12]) for(iy=[-107/2+53,107/2-9]) translate([ix,iy,-(7+1.6+6.2)]) cylinder(r=pcb_m,7+1.6);
    hull() for(ix=[-(164.9/2),(164.9/2)]) for(iy=[-107/2+20,107/2-8]) translate([ix,iy,-(3+1.6+6.2)]) cylinder(r=pcb_m,3+1.6);
        
    //plug clearance
    hull() for(ix=[(164.9/2)+12,(164.9/2)]) for(iy=[-124.27/2+70,124.27/2-17]) translate([ix,iy,-(22+6.2)]) cylinder(r=pcb_m,22);
    
    //viewport
    hull() for(ix=[-(164.9/2)+3,(164.9/2)-6]) for(iy=[-124.27/2+23.5,124.27/2-14]) translate([ix,iy,-1]) cylinder(r=pcb_m,20);
    hull() for(ix=[-(164.9/2)+3,(164.9/2)-6]) for(iy=[-124.27/2+23.5,124.27/2-14]) translate([ix,iy,0.4]) cylinder(r1=pcb_m,r2=pcb_m+20,20);

    //screws
    for(ix=[-(156.9/2),(156.9/2)]) for(iy=[-114.96/2,114.96/2]) translate([ix,iy,-(6.2)-1.6]) {
        screw_co(8,1.6+1.2,1.6+6.2+faceplate_thk);
    }
}


module screw_co(screw_len=8,h2,h3) {
    h1 = 0; //transition from 1.25 to 1.75
    //h2 = //screw head
    //h3 = //bevel for head cutout
    
    translate([0,0,h2]) hull() {
        translate([0,0,-8]) cylinder(r=1.25,8);
        translate([0,0,-8-1.25]) cylinder(r=0.01,8);
    }
    translate([0,0,h1]) hull() {
        translate([0,0,0]) cylinder(r=1.25+0.5,20);
        translate([0,0,-0.5]) cylinder(r=1.25,20);
    }
    translate([0,0,h2]) {
        translate([0,0,0]) cylinder(r=1.75,20);
        
        cylinder(r=3,20);
        translate([-1.75,-1.75,-0.4]) cube([2*1.75,2*1.75,20]);
        translate([-sqrt(pow(3,2)-pow(1.75,2)),-1.75,-0.2]) cube([2*sqrt(pow(3,2)-pow(m3_v_r,2)),2*1.75,20]);
    }
    translate([0,0,h3]) {
        hull() translate([0,0,0]) {
            translate([0,0,0]) cylinder(r=3+0.6,20);
            translate([0,0,-0.6]) cylinder(r=3,20);
        }
    }
}

module camera_pos() {
    translate([0,65,-12]) children();
}

module camera_co(pcb_m=0.5,include_screws=true) {
    //pcb
    hull() for(ix=[-12.5,12.5]) for(iy=[-9.5,14.5]) translate([ix,iy,0]) cylinder(r=pcb_m,h=1);
        
    //top components
    hull() for(ix=[0,12.5-3]) for(iy=[14.5-5,14.5]) translate([ix,iy,0]) cylinder(r=pcb_m,h=1+pcb_m);
        
    //bottom components
    hull() for(ix=[-(12.5-3),(12.5-3)]) for(iy=[-9.5,14.5]) translate([ix,iy,-1.6]) cylinder(r=pcb_m,h=1.6+1);
        
    //cable port
    hull() for(ix=[-(12.5-1),(12.5-1)]) for(iy=[-9.5-50,-9.5+8]) translate([ix,iy,-2.4]) cylinder(r=pcb_m,h=2.4+1);
        
    //camera body
    hull() for(ix=[-4,4]) for(iy=[-4,4]) translate([ix,iy,0]) cylinder(r=pcb_m,h=1+3);
        
    //camera cable
    hull() for(ix=[-4,4]) for(iy=[-4,14.5]) translate([ix,iy,0]) cylinder(r=pcb_m,h=1+1.4);
        
    //camera lens
    cylinder(r=8/2+pcb_m,h=1+3+5);
    
    
            
    /*translate([0,0,1+3+3]) hull() {
        sphere(r=5);
        for(ix=[-62.2/2,62.2/2]) rotate([0,ix,0]) for(iy=[-48.4/2,48.4/2]) rotate([iy,0,0]) cylinder(r=5,h=20);
    }*/
    
    translate([0,0,1+3+0.6]) {
        for(iz=[0:0.8:10]) hull() for(ix=[0,1]) mirror([ix,0,0]) for(iy=[0,1]) mirror([0,iy,0]) {
            translate([(iz)*tan(62.2/2)+4-2,(iz)*tan(48.4/2)+4-2,iz]) {
                cylinder(r=2+pcb_m,h=10);
                //if(iz>0) translate([-0.8*tan(62.2/2),-0.8*tan(48.4/2),-0.8+0.4]) cylinder(r=2+pcb_m,h=10);
            }
        }
    }
    
    if (include_screws) {
        /*for(ix=[-17.5,17.5]) translate([ix,0,1]) {
            hull() {
                translate([0,0,-8]) cylinder(r=1.25,8+0.01);
                translate([0,0,-8-1.25]) cylinder(r=0.01,8);
            }
        }
        
        
        for(ix=[-17.5,17.5]) translate([ix,0,1]) {
            hull() {
                translate([0,0,0]) cylinder(r=1.25+0.5,2);
                translate([0,0,-0.5]) cylinder(r=1.25,2);
            }
            
            translate([0,0,-0.01]) cylinder(r=1.75,h=20);
                
            translate([0,0,1]) cylinder(r=3,h=20);
            translate([-1.75,-1.75,1-0.4]) cube([2*1.75,2*1.75,20]);
            translate([-sqrt(pow(3,2)-pow(1.75,2)),-1.75,1-0.2]) cube([2*sqrt(pow(3,2)-pow(m3_v_r,2)),2*1.75,20]);
        }*/
        for(ix=[-17.5,17.5]) translate([ix,0,1-0.01]) {
            //cylinder(r=5+0.25,h=3+0.6+2*0.01);
            translate([0,0,3+0.6]) screw_co(8,1.2,50);
        }
    }
}

module poe_pos() {
    translate([-65,5,0]) children();
}

module poe_boss() {
    poe_pos() hull() for(ix=[0,51.5]) for(iy=[0,14]) translate([ix,iy,0]) cylinder(r=5,8);
    poe_pos() hull() for(ix=[0,51.5]) for(iy=[-7.5,14]) translate([ix,iy,0]) cylinder(r=5,8);
}

module poe_co(pcb_m=0.5) {
    difference() {
        hull() for(ix=[0,51.5]) for(iy=[0,14]) translate([ix,iy,-1.6-2.4]) cylinder(r=pcb_m,1.6+2.4);
            
        hull() for(ix=[-5,4.2-1.6]) for(iy=[2.3+1.6,9.9-1.6]) translate([ix,iy,-10-1.6]) cylinder(r=1.6,h=10);
            
        hull() for(ix=[15.6+1.6,35.7-1.6]) for(iy=[14-1.2+1.6]) translate([ix,iy,-10-1.6]) cylinder(r=1.6,h=10);
            
        hull() for(ix=[30+1.6,33.8-1.6]) for(iy=[-5,3.2-1.6]) translate([ix,iy,-10-1.6]) cylinder(r=1.6,h=10);
    }
    
    for(iy=[-1.75,14+1.75]) translate([37,iy,-25]) cylinder(r=1.25,h=50);
    hull() for(iy=[-1.75,14+1.75]) translate([37,iy,-4]) cylinder(r=1.75,h=4);
        
    //transformer
    hull() for(ix=[11.7,11.7+13.6]) for(iy=[0,14]) translate([ix,iy,-1.6]) cylinder(r=pcb_m,13.5);
        
    //semiconductor
    hull() for(ix=[17,17+6]) for(iy=[0,6.4]) translate([ix,iy,-4]) cylinder(r=pcb_m,4);
       
    //vent co
    hull() {
        for(ix=[11.7,11.7+13.6]) for(iy=[0,14+20]) translate([ix,iy,-(4+4-0.6)]) cylinder(r=pcb_m,(4+4-0.6));
        for(ix=[11.7,11.7+13.6]) for(iy=[-7.5-5+2.5,14+20]) translate([ix,iy,-4]) cylinder(r=pcb_m,4);
    }
    hull() for(ix=[11.7,11.7+13.6]) for(iy=[-7.5-5,14+20]) translate([ix,iy,-4]) cylinder(r=pcb_m,4);
        
    for(ix=[11.7,11.7+13.6]) translate([ix+(ix==11.7?-1:1)*pcb_m,-7.5-5,-4]) linear_extrude(height=4) difference() {
        translate([-1,-1]) square([2*1,2*1]);
        translate([(ix==11.7?-1:1),1]) circle(r=1);
    }
        
    //pins
    hull() for(ix=[0,1.4+2.5*2.54]) for(iy=[14,14-(1.4+0.5*2.54)]) translate([ix,iy,-4]) cylinder(r=pcb_m,4);
        
    hull() for(ix=[51.5,51.5-(1.8+3.5*2.54)]) for(iy=[14,14-(1.4+0.5*2.54)]) translate([ix,iy,-4]) cylinder(r=pcb_m,4);
}


module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}