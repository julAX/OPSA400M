//
//  CargoOverViewController.m
//  OPS A400M
//
//  Created by richard david on 25/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "CargoOverViewController.h"


@interface CargoOverViewController (){
    Mission *mission;
    NSMutableDictionary *leg;
    Cargo * cargoForCell;
    NSInteger numberPallet;

}

@end

@implementation CargoOverViewController

@synthesize overViewTableView,totalWeight,palletNumber;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    mission.delegate = self;
    
    [overViewTableView setDelegate:self];
    [overViewTableView setDataSource:self];
    [self reloadTotals];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)activeLegDidChange:(NSInteger)legNumber
{
    leg = mission.activeLeg;
    [self.overViewTableView reloadData];
    [self reloadTotals];
    
}

-(void) reloadTotals{
    [Cargo reloadBenefListWithMission:mission];
    self.title=[@"Cargo Overview for leg " stringByAppendingString: @(mission.activeLegIndex + 1).description];
    self.palletNumber.text= (leg[@"numberOfPallet"])?leg[@"numberOfPallet"]:@"0";
    self.totalWeight.text= [(leg[@"TotalWeight"])?leg[@"TotalWeight"] : @"0" stringByAppendingString:@" Kg"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark tableview delegate

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CargoOverViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CargoOverviewCell" forIndexPath:indexPath];
    if(indexPath.row == 9)
    {
        cell.type.text = @"Bulk";
        cell.poids.text = [(leg[@"bulkWeight"])? leg[@"bulkWeight"] : @"0" stringByAppendingString:@" Kg"];
    }
    else if (indexPath.row == 10)
    {
        cell.type.text = @"Pax";
        cell.poids.text = (leg[@"numberOfPax"])? leg[@"numberOfPax"] : @"0";
    }
    else
    {
    
        NSEnumerator * cargoEnumerator = [leg[@"cargoList"] objectEnumerator];
        NSInteger i=0;
        for(i=0; i<=indexPath.row;i++){
            cargoForCell = [cargoEnumerator nextObject];
        
            while (cargoForCell && cargoForCell.type != freight && cargoForCell.type != roulant) {
                cargoForCell = [cargoEnumerator nextObject];
            }
        
        }
        cell.cargo = cargoForCell;
    
        if(cell.cargo){
            cell.benef.text = cell.cargo.be;
            cell.type.text = (cell.cargo.type == freight)? @"Pallet":@"Wheeled";
            cell.poids.text = [cell.cargo.weight stringByAppendingString:@" Kg"];
        }
        else{
            cell.benef.text = @"";
            cell.type.text = @"";
            cell.poids.text = @"";
        }
    }
    
    if (cell == nil) {
        cell = [[CargoOverViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"CargoOverviewCell" ];
    }
    
    
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 11;
    }
    else
        return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


@end
