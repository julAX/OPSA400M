//
//  CargoTableViewCell.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CargoTableViewController.h"

@interface CargoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeOfCargo;
@property (strong, nonatomic) IBOutlet UILabel *departureAirport;
@property (strong, nonatomic) IBOutlet UILabel *arrivalAirport;
@property (strong, nonatomic) IBOutlet UILabel *weight;
@property Cargo *cargoForCell;

@property (strong, nonatomic) IBOutlet UILabel *be;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;

@property (strong, nonatomic) IBOutlet UITextField *commentField;

- (IBAction)commentCommit:(id)sender;

@end
