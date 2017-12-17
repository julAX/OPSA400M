//
//  CrewData.h
//  Esterel-Alpha
//
//  Created by utilisateur on 21/01/2014.
//
//

#import <UIKit/UIKit.h>

@interface CrewData : UITableViewCell

+ (NSArray *)nameListe;
+ (NSArray *)gradeListe;

+ (void)updateDatabase:(NSString*)path;

@end
