//
//  ChooseDerogViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 23/01/2014.
//
//

#import <UIKit/UIKit.h>

@protocol ChooseDerogDelegate <NSObject>

- (void)chooseDerogDidChoose:(NSMutableDictionary*)derog;

@end


@interface ChooseDerogViewController : UITableViewController

@property id<ChooseDerogDelegate> delegate;

@end
