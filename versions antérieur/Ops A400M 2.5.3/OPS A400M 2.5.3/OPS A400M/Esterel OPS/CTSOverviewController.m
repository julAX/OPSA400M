//
//  CTSOverviewController.m
//  OPS A400M
//
//  Created by richard david on 09/03/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "CTSOverviewController.h"
#import "CTSTableViewController.h"

@interface CTSOverviewController (){

    NSMutableArray * crewTickSheets, *CTSIndicators;
    Mission * mission;
    NSMutableDictionary * leg;
    NSInteger legNumber;
    bool cestbon;


}

@end

@implementation CTSOverviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    mission.delegate=self;
    crewTickSheets=leg[@"CrewTickSheets"];
    legNumber = mission.activeLegIndex;
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    cestbon = YES;
    mission.delegate=self;
    leg = mission.activeLeg;
    legNumber = mission.activeLegIndex;
    [self.tableView reloadData];
}

- (void)activeLegDidChange:(NSInteger)l
{
    leg = mission.activeLeg;
    crewTickSheets=leg[@"CrewTickSheets"];
    legNumber = l;

    [self.tableView reloadData];
}

-(UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    
    cell.tag = indexPath.row;
    

    
    if (indexPath.row==crewTickSheets.count){
        cell.textLabel.text = [NSString stringWithFormat:@"Add a Crew tick sheet for leg %ld",(long)legNumber +1];
    }
    
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"Crew Tick Sheet %ld - leg %ld",(long)(indexPath.row +1),(long)legNumber +1];

        NSMutableArray *CTS = leg[@"CrewTickSheets"][indexPath.row];
        
        if(CTS.count <= 5){
            [CTS addObject:@"0"];
        }
        
        if([CTS[5] isEqualToString : @"1" ]){
            cell.textLabel.textColor = rouge;
            leg[@"Indicators"][@"CrewTickSheet"][1] = @"0";
            leg[@"Indicators"][@"CrewTickSheet"][0] = @"0";
            cestbon = NO;
        }
        else
            cell.textLabel.textColor = [UIColor blackColor];
        
        if(!CTS[0])
            CTS[0] = @"";
        
        if([CTS[0] isEqualToString:@""])
            cell.detailTextLabel.text = @"Missing logbook number";
        else
            cell.detailTextLabel.text = nil;

        
    }
    
    
    return cell;

}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.;
}


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(cestbon){
        leg[@"Indicators"][@"CrewTickSheet"][0]=@"1";
    }

}

-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    BOOL cestBon = YES;
    for(int i = 0; i<crewTickSheets.count; i++){
        NSMutableArray *CTS = leg[@"CrewTickSheets"][i];
        if([CTS[5] isEqualToString:@"1"]){
            cestBon = NO;
        
        }
    }
    
    if(cestBon){
        leg[@"Indicators"][@"CrewTickSheet"][0] = @"1";
        leg[@"Indicators"][@"CrewTickSheet"][1] = @"1";
    }
    
    else{
        leg[@"Indicators"][@"CrewTickSheet"][0] = @"0";
        leg[@"Indicators"][@"CrewTickSheet"][1] = @"0";
    
    }

}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (crewTickSheets.count +1);
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row > 0 && indexPath.row<((NSArray*)leg[@"CrewTickSheets"]).count){
        return YES;
    }

    else return ((((NSArray*)leg[@"CrewTickSheets"]).count>1)?YES:NO);

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [leg[@"CrewTickSheets"] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


-(void) addCrewTickSheet{
    NSMutableArray * newCrewTickSheet = [[NSMutableArray alloc] initWithArray: [mission.crewTickSheetVierge mutableDeepCopy]];
    [leg[@"CrewTickSheets"] addObject:newCrewTickSheet];
    
    [self.tableView reloadData];

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==crewTickSheets.count){
        [self addCrewTickSheet];
        [self.tableView reloadData];
    }
    
    else{
        leg[@"Indicators"][@"CrewTickSheet"][0]=@"1";
        leg[@"activeCTS"]=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        CTSTableViewController * ctsController =  [self.storyboard instantiateViewControllerWithIdentifier: @"CTSTableView"];;
        [self.navigationController pushViewController:ctsController animated:YES];

    }


}

@end
