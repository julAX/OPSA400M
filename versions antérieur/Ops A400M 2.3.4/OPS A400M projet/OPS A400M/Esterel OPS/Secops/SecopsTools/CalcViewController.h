//
//  CalcViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 12/02/2014.
//
//

#import <UIKit/UIKit.h>

#import "LegsSelectionView.h"

@class Mission;

@interface CalcViewController : UITableViewController <LegsSelectionDelegate>

@property (weak, nonatomic) Mission *mission;

@end
