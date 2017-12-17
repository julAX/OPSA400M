//
//  BenefAndDropTableViewCell.m
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import "BenefAndDropTableViewCell.h"




@implementation BenefAndDropTableViewCell

@synthesize benefTextField;



- (NSString*) getText{
    return benefTextField.text;
}

- (BOOL) getSwitch{
    return [_dropSwitch isOn];
}




@end
