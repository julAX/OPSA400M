//
//  PersonnelViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 13/02/2014.
//
//

#import <UIKit/UIKit.h>

@class Mission;

@interface PersonnelViewController : UIViewController <UITextViewDelegate>

- (void)setCrew:(NSDictionary *)crewMember inMission:(Mission *)mission;

@end
