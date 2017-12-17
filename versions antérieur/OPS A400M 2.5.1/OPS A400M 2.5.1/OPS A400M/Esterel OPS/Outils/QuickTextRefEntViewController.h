//
//  QuickTextRefEntViewController.h
//  A400M OPS
//
//  Created by Delphine Vendryes on 03/03/2015.
//  Copyright (c) 2015 Esterel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuickTextDelegate <NSObject>

- (void)quickTextDidSelectString:(NSString*)string;

@end


@interface QuickTextRefEntViewController : UITableViewController

- (void)setValues:(NSArray *)values pref:(NSArray*)prefixes sub:(NSArray*)subtitles;
- (void)reloadDataForEntry:(NSString*)text;

@property id<QuickTextDelegate> myDelegate;

@end
