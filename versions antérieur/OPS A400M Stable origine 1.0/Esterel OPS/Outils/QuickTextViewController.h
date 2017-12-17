//
//  QuickTextViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 19/12/13.
//
//

#import <UIKit/UIKit.h>


@protocol QuickTextDelegate <NSObject>

- (void)quickTextDidSelectString:(NSString*)string;

@end


@interface QuickTextViewController : UITableViewController

- (void)setValues:(NSArray *)values pref:(NSArray*)prefixes sub:(NSArray*)subtitles;
- (void)reloadDataForEntry:(NSString*)text;

@property id<QuickTextDelegate> myDelegate;

@end
