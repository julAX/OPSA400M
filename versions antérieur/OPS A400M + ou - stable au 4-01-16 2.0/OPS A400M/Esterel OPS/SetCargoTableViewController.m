//
//  SetCargoTableViewController.m
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import "SetCargoTableViewController.h"

@interface SetCargoTableViewController(){
    Mission *mission;
    NSMutableDictionary *leg;
    Cargo *currentCargo;
    NSArray * airportList;
    UITableView * myTableView;
}
@end

@implementation SetCargoTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    myTableView = self.tableView;

    
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    currentCargo = mission.currentCargo;
    
    airportList = [mission airportList];
    [self.tableView reloadData];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if(section==0){
        return 1;
    }
    
    else if(section==1){
        return ([mission airportList].count);
    }
    else{
        return 1;
    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        BenefAndDropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"benefAndDrop" forIndexPath:indexPath];
        
        /*CGSize size = [tableView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
         [cell sizeThatFits:size];*/
        return cell;
        
        
    }
    else if(indexPath.section==1){
        if(indexPath.row==0){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrivalAndDeparture" forIndexPath:indexPath];
            /*CGSize size = [tableView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
             [cell sizeThatFits:size];*/
            return cell;
        }
        else{
            
            AirportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listArrivalAndDeparture" forIndexPath:indexPath];
            //cell.buttonArrival.titleLabel.text=airportList[indexPath.row];
            //cell.buttonDeparture.titleLabel.text=airportList[indexPath.row-1];
            
            [cell.buttonDeparture setTitle: airportList[indexPath.row - 1] forState:UIControlStateNormal ];
            [cell.buttonArrival setTitle: airportList[indexPath.row] forState:UIControlStateNormal ];
            
            
            return cell;
        
        }
    }
    else{
        EnterWeightTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"enterWeight" forIndexPath:indexPath];
        if(currentCargo.type == pax){
            [cell.enterWeight setTitle: @"Set Pax Number" forState:UIControlStateNormal ];
        }
        else if(currentCargo.type == freight){
            [cell.enterWeight setTitle: @"Set Pallet weight" forState:UIControlStateNormal ];
        
        }
        else {
            [cell.enterWeight setTitle: @"Set Bulk weight" forState:UIControlStateNormal ];
        }
    
        return cell;
    }
}


 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     if(section==0)return @"Be code and dropping option";
     else if(section==1)return @"Choose Departure and arrival";
     else return @"";}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 80.;
    }
    else if(indexPath.section==1){
        if(indexPath.row==0) return 55.;
        else return 55.;
    }
    else{
        return 80;
    }
}

- (IBAction)getBe:(id)sender {
    //currentCargo.be=[sender textLabel].text;
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    BenefAndDropTableViewCell *cell = [myTableView cellForRowAtIndexPath: path];
    currentCargo.be=cell.benefTextField.text;

}


- (IBAction)droppingSwitch:(id)sender {
    currentCargo.drop=[sender isOn];
}

- (IBAction)buttonDepartureAirport:(id)sender {
    currentCargo.departure=[sender currentTitle];
    NSInteger longueurListe = airportList.count;

    for (NSInteger j = 1; j<longueurListe; j++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:(NSInteger)j inSection:1];
        AirportTableViewCell * currentCell = (AirportTableViewCell*)[myTableView cellForRowAtIndexPath:path];
        [currentCell.buttonDeparture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //[myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
}

- (IBAction)buttonArrivalAirport:(id)sender {
    currentCargo.arrival=[sender currentTitle];
    NSInteger longueurListe = airportList.count;

    for (NSInteger j = 1; j<longueurListe; j++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:(NSInteger)j inSection:1];
        AirportTableViewCell * currentCell = (AirportTableViewCell*)[myTableView cellForRowAtIndexPath:path];
        
        [currentCell.buttonArrival setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}




- (IBAction)enterWeightButton:(id)sender {

 
    if(currentCargo.be.length!=0){
        if(YES/*A changer of course pour mettre une condition logique arrivé après départ*/){
            if(currentCargo.type==pax){
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"4002"];
                [self.navigationController pushViewController:pushVC animated:YES];
            }
            else{
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"4003"];
                [self.navigationController pushViewController:pushVC animated:YES];
            }
        }
    }
    
}
@end
