//
//  CargoTableViewController.m
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//



#import "CargoTableViewController.h"
#import "CargoTableViewCell.h"



@interface CargoTableViewController(){
    Mission *mission;
    NSMutableDictionary *leg;
    NSEnumerator *cargoEnumerator;
    Cargo *cargoForCell;
    NSMutableArray *paxList,*pallet,*bulk,*wheeled,*autre;
    BOOL showOtherCargo;
}
@end

@implementation CargoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    mission.delegate=self;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //create long press gesture recognizer(gestureHandler will be triggered after gesture is detected)
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
    //adjust time interval(floating value CFTimeInterval in seconds)
    [longPressGesture setMinimumPressDuration:1.0];
    //add gesture to view you want to listen for it(note that if you want whole view to "listen" for gestures you should add gesture to self.view instead)
    [self.tableView addGestureRecognizer:longPressGesture];
    
    
    
    
    
}

-(void) activeLegDidChange:(NSInteger)legNumber{

    leg = mission.activeLeg;
    mission.delegate=self;
    [self actualiserIndicators];
    [self makeCargoList];

    [self.tableView reloadData];

}

-(void) actualiserIndicators{
    
    [mission indicatorsForLeg:mission.activeLegIndex];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    leg = mission.activeLeg;
    mission.delegate=self;
    [self actualiserIndicators];
    [self makeCargoList];
    self.tableView.tableFooterView.backgroundColor=grisFonce;

    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self actualiserIndicators];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void) gestureHandler : (UISwipeGestureRecognizer*) gesture {
    {
        if(UIGestureRecognizerStateBegan == gesture.state)
        {
            CGPoint location = [gesture locationInView:self.tableView];
            NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
            Cargo *carg = ((CargoTableViewCell*) [self.tableView cellForRowAtIndexPath:swipedIndexPath]).cargoForCell;
            
            if(carg.absurde == YES){
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Attention Cargo !"
                                                      message:@"Is this cargo valid ?"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:NSLocalizedString(@"NO", @"Cancel action")
                                               style:UIAlertActionStyleCancel
                                               handler:nil];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"YES", @"OK action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               carg.absurde = NO;
                                               [self.tableView reloadData];
                                               
                                           }];
                
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                
            }
        }
    }
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    
    NSArray *cargoLists = @[paxList,pallet,bulk,wheeled,autre];
    
    if(section==0){
        return 1;
    }
    else if (section!=5){
        return (((NSArray*)cargoLists[section-1]).count);
    }
    else{
        return (((SplitViewController* )self.splitViewController).showCargos)?(((NSArray*)cargoLists[section-1]).count +1):1;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section!=0){
        if(indexPath.section == 5 && indexPath.row==0){
            ((SplitViewController* )self.splitViewController).showCargos = !((SplitViewController* )self.splitViewController).showCargos;
            NSLog(@"%hhd",((SplitViewController* )self.splitViewController).showCargos);
            [self.tableView reloadData];
        }
        else{
            CargoTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            mission.currentCargo= cell.cargoForCell;
            SetCargoTableViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"4001"];
            [self.navigationController pushViewController:pushVC animated:YES];
        }
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section!=1 && section!=5){
        return @"";
    }
    else if(section==1){
        return [NSString stringWithFormat:@"Cargo in board during leg %d", (mission.activeLegIndex +1)];
    }
    else{
        return @"Cargo in board during the other legs";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section!=1 && section!=5){
        return 0.1;
    }
    
    else{
        return [super tableView:tableView heightForHeaderInSection:section];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section!=0 && section!=4){
        return 0.1;
    }
    
    else{
        return [super tableView:tableView heightForFooterInSection:section];
    }
    
    tableView.tableFooterView.backgroundColor=grisFonce;
    
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] init];
    return footerView;

}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 160.;
    }
    else{
        return 73.;
    }
}

-(void) makeCargoList{
    paxList = nil;
    pallet = nil;
    bulk = nil;
    wheeled = nil;
    autre = nil;
    
    
    paxList = [NSMutableArray array];
    pallet = [NSMutableArray array];
    bulk = [NSMutableArray array];
    wheeled = [NSMutableArray array];
    autre = [NSMutableArray array];
    
    [Cargo reloadBenefListWithMission:mission];
    
    NSEnumerator *enumerator = [mission.Instances objectEnumerator];
    Cargo * carg;
    
    
    while (carg = [enumerator nextObject]){
        if(![leg[@"cargoList"] containsObject:carg]){
            [autre addObject:carg];
        
        }
        else{
            [((carg.type== freight)? pallet : ((carg.type == vrac)? bulk : ((carg.type== roulant)? wheeled : paxList ))) addObject:carg];
        }
    
    }
    
    paxList = [self orderList:paxList];
    bulk    = [self orderList:bulk];
    pallet  = [self orderList:pallet];
    wheeled = [self orderList:wheeled];
    autre   = [self orderList:autre];
    

}

-(NSMutableArray*) orderList : (NSMutableArray*)list{
    NSMutableArray * result = [NSMutableArray array];
    for (NSInteger i =0; i<mission.legs.count;i++){
        Cargo * carg;
        for(carg in list){
            [carg initSetOfLegs];
            if([carg.numArrnumDep[0] integerValue] == i){
                [result addObject:carg];
            }
        }
    
    }
    
    if(result.count != list.count)
        NSLog(@"ERREUR DU TRI !!! ");
    
    return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    /*
     section 0 : pour ajouter
     section 1 : pax
     section 2 : pallet
     section 3 : bulk
     section 4 : wheeled
     section 5 : les elements qui sont pas dans la leg...
     
     
     */
    
    NSArray *cargoLists = @[paxList,pallet,bulk,wheeled,autre];
    
    if(indexPath.section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCargoCell" forIndexPath:indexPath];
        
        /*CGSize size = [tableView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
         [cell sizeThatFits:size];*/
        return cell;
        
        
    }
    
    else {
        if(indexPath.section==5 && indexPath.row==0){
            UITableViewCell * cell =[[UITableViewCell alloc]init];
            
            cell.textLabel.text = @"Hide / Show the items on other legs";
            cell.textLabel.textColor=[UIColor blueColor];
            
            return cell;
            
        }
        else{
            CargoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CargoCell" forIndexPath:indexPath];
            cargoForCell =  cargoLists[indexPath.section -1][((indexPath.section==5)?indexPath.row -1 : indexPath.row)];
            
            if(cargoForCell.type == pax){
                cell.weight.text = @(cargoForCell.nombrePax).description;
                cell.weightLabel.text = @"Number";
            }
            else{
                cell.weight.text = cargoForCell.weight;
                cell.weightLabel.text = @"Weight (kg)";
            }
            cell.departureAirport.text = cargoForCell.departure;
            cell.arrivalAirport.text = cargoForCell.arrival;
            cell.be.text = cargoForCell.be;
            cell.commentField.text = cargoForCell.comment;
            if(cargoForCell.absurde == NO)
                [cell.contentView setBackgroundColor: [UIColor whiteColor]];
            else{
                [cell.contentView setBackgroundColor: [UIColor redColor]];
            }
            
            
            switch (cargoForCell.type) {
                case vrac:
                    cell.typeOfCargo.text = @"Bulk";
                    break;
                case pax:
                    cell.typeOfCargo.text = @"Pax";
                    break;
                case freight:
                    cell.typeOfCargo.text = @"Pallet";
                    break;
                case roulant:
                    cell.typeOfCargo.text = @"Wheeled";
                    break;
                default:
                    cell.typeOfCargo.text = @"Undefined";
                    break;
            }
            [self refreshControl];
            cell.cargoForCell = cargoForCell;
            return cell;
        }
    }
    
    
    
    /*
    else {
        
        CargoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CargoCell" forIndexPath:indexPath];
        //CGSize size = [tableView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        //[cell sizeThatFits:size];
        cargoEnumerator = [mission.Instances objectEnumerator];
        NSInteger i=0;
        for(i=0; i<=indexPath.row;i++){
            cargoForCell = [cargoEnumerator nextObject];
            [cargoForCell initSetOfLegs];
            
        }
        
        
        cell.weight.text = cargoForCell.weight;
        cell.departureAirport.text = cargoForCell.departure;
        cell.arrivalAirport.text = cargoForCell.arrival;
        cell.be.text = cargoForCell.be;
        cell.commentField.text = cargoForCell.comment;
        if(cargoForCell.absurde == NO)
        [cell.contentView setBackgroundColor: [UIColor whiteColor]];
        else{
            [cell.contentView setBackgroundColor: [UIColor redColor]];
        }
        
        
        switch (cargoForCell.type) {
            case vrac:
            cell.typeOfCargo.text = @"Bulk";
            break;
            case pax:
            cell.typeOfCargo.text = @"Pax";
            break;
            case freight:
            cell.typeOfCargo.text = @"Pallet";
            break;
            case roulant:
            cell.typeOfCargo.text = @"Wheeled";
            break;
            default:
            cell.typeOfCargo.text = @"Undefined";
            break;
        }
        [self refreshControl];
        cell.cargoForCell = cargoForCell;
        return cell;
        
    }
    */
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return (indexPath.section)?YES : NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [((CargoTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).cargoForCell destroy];
        [self makeCargoList];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = grisFonce;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    header.contentView.backgroundColor = grisFonce;
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = grisFonce;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    header.contentView.backgroundColor = grisFonce;

}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    //la structure de NSSet empêche d'ordonner les Cargo d'ou le  NO dans tous les cas.
    return NO;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)newCargo:(id)sender {
    
    Cargo *newCargo = [[Cargo alloc] initWithMission:mission];
    //[mission.Instances addObject:newCargo];
    
    
    switch ([sender tag]) {
        case 1:
        newCargo.type = pax;
        break;
        case 2:
        newCargo.type = freight;
        break;
        case 3:
        newCargo.type = vrac;
        break;
        case 4:
        newCargo.type = roulant;
        break;
        default:
        break;
    }
    mission.currentCargo = (id)newCargo;
    
    SetCargoTableViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"4001"];
    [self.navigationController pushViewController:pushVC animated:YES];
    
    
}
@end
