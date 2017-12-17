//
//  CargoTableViewCell.m
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import "CargoTableViewCell.h"

@interface CargoTableViewCell(){
}

@end



@implementation CargoTableViewCell

@synthesize arrivalAirport,departureAirport,weight,typeOfCargo, cargoForCell, be;

- (void)awakeFromNib
{
    [super awakeFromNib];
}






- (IBAction)commentCommit:(id)sender {
    cargoForCell.comment = ((UITextField*)sender).text;
}
@end
