//
//  PersonnelViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 13/02/2014.
//
//

#import "PersonnelViewController.h"

#import "Mission.h"

#define CELL_WIDTH 70.


@interface PersonnelViewController () {
    
    IBOutlet UILabel *name;
    IBOutlet UISwitch *state;
    IBOutlet UITextView *comments;
    
    IBOutlet UIScrollView *scrollView;
    
    NSArray *colors;
    
    NSMutableDictionary *pers;
    NSString *persName;
}


@end

@implementation PersonnelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    colors = @[[UIColor whiteColor], [UIColor colorWithRed:245./255. green:245./255. blue:249./255. alpha:1.]];
}


- (void)setCrew:(NSDictionary *)crewMember inMission:(Mission *)mission
{    
    persName = crewMember[@"Name"];
    
    NSMutableDictionary *personnels = mission.root[@"SECOPS"][@"Personnel"], *presence = crewMember[@"Presence"];
    
    if (!personnels[persName])
        personnels[persName] = [NSMutableDictionary dictionaryWithCapacity:2];
    
    pers = personnels[persName];
    
    name.text = persName;
    [state setOn:[pers[@"Vu"] isEqualToString:@"Y"]];
    comments.text = pers[@"Commentaires"];
    
    for (UIView* subview in scrollView.subviews)
        [subview removeFromSuperview];
    
    NSDictionary *origCrewMember;
    NSArray *originalCrewMembers;
    NSString *str;
    
    CGRect rect = CGRectMake(0., 0., CELL_WIDTH, scrollView.frame.size.height/3);
    
    for (str in @[@"Leg", @"Final", @"Original"])
    {
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = str;
        label.backgroundColor = colors[0];
        
        [scrollView addSubview:label];
        
        rect.origin.y += rect.size.height;
    }
    
    rect.origin.x = CELL_WIDTH;
    
    NSInteger legIndex = 1;
    
    for (NSDictionary *leg in mission.legs)
    {
        UIColor *color = colors[legIndex%2];
        
        rect.origin.y = 0.;
        
        
        for (NSUInteger i = 0; i< 3; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = color;
            
            switch (i) {
                case 0: label.text = [NSString stringWithFormat:@"Leg %ld", (long)legIndex];
                    break;
                case 1: str = presence[@(legIndex-1).description];
                    label.text = str;
                    break;
                case 2:
                    if ((originalCrewMembers = leg[@"OriginalCrewMember"]))
                    {
                        if ((origCrewMember = [Mission crewMemberArray:originalCrewMembers contains:persName]))
                            label.text = [NSString stringWithFormat:@"%@ %@", origCrewMember[@"Function"], origCrewMember[@"Position"]];
                        else
                            label.text = @"";
                    }
                    else
                        label.text = str;
            }
            
            [scrollView addSubview:label];
            
            rect.origin.y += rect.size.height;
        }
        
        rect.origin.x += CELL_WIDTH;
        
        legIndex ++;
    }

    scrollView.contentSize = CGSizeMake(legIndex * CELL_WIDTH, 0.);
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    pers[@"Commentaires"] = comments.text;
}


- (IBAction)stateChanged:(UISwitch *)sender
{
    pers[@"Vu"] = (sender.isOn) ? @"Y" : @"N";
}


@end
