//
//  ChoixCoefViewController.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewController.h"
#import "Mission.h"
#import "Parameters.h"
#import "PaveNumViewController.h"

@interface ChoixCoefViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *buttonOk;
@property (strong, nonatomic) IBOutlet UIButton *button10;
@property (strong, nonatomic) IBOutlet UIButton *button62;
@property (strong, nonatomic) IBOutlet UIButton *button35;
@property (strong, nonatomic) IBOutlet UIButton *button22;

- (IBAction)validateCoef:(id)sender;

- (IBAction)push10:(id)sender;
- (IBAction)push62:(id)sender;
- (IBAction)push35:(id)sender;
- (IBAction)push22:(id)sender;

@end
