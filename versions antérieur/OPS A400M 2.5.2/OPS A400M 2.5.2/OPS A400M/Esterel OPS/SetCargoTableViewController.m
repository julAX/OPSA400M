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
    UITextField *activeTextField;
    QuickTextViewController *quickText;
    UIPopoverController *popover;
    
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

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear : animated];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    BenefAndDropTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    cell.benefTextField.delegate=self;
    
    
    
    UITableView *legsView= ((UITableViewController*)self.splitViewController.viewControllers.firstObject.childViewControllers.firstObject).tableView;
    for (int i=0;i<= mission.legs.count;i++){
        NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell * cell = [legsView cellForRowAtIndexPath:path];
        cell.userInteractionEnabled = NO;
    }

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section<3){
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        BenefAndDropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"benefAndDrop" forIndexPath:indexPath];
        
        cell.benefTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        if(currentCargo.be){
            cell.benefTextField.text=currentCargo.be;
        }
        if(currentCargo.drop){
            [cell.dropSwitch setOn:YES];
        }

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
            [cell.buttonArrival setTag: (indexPath.row - 1)];
            [cell.buttonDeparture setTag: (indexPath.row - 1)];
            
            
            if([currentCargo.numArrnumDep[0] integerValue]>=0 && [currentCargo.numArrnumDep[0] integerValue]==indexPath.row - 1){
                [cell.buttonDeparture setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            if([currentCargo.numArrnumDep[1] integerValue]>=0 && [currentCargo.numArrnumDep[1] integerValue]==indexPath.row - 1){
                [cell.buttonArrival setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            
            return cell;
        
        }
    }
    else{
        EnterWeightTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"enterWeight" forIndexPath:indexPath];
        if(currentCargo.type == pax){
            [cell.enterWeight setTitle: @"Set Pax number and weight" forState:UIControlStateNormal ];
        }
        else {
            [cell.enterWeight setTitle: @"Set weight" forState:UIControlStateNormal ];
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
    [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: 0 inSection:0]].backgroundColor = [UIColor whiteColor];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    BenefAndDropTableViewCell *cell = [myTableView cellForRowAtIndexPath: path];
    currentCargo.be=cell.benefTextField.text;

}


- (IBAction)droppingSwitch:(id)sender {
    currentCargo.drop=[sender isOn];
}

- (IBAction)buttonDepartureAirport:(id)sender {
    NSInteger indexRow = [sender tag];
    
    if([currentCargo.numArrnumDep[0] integerValue] == -1){
        currentCargo.numArrnumDep[0]=[NSNumber numberWithInteger:indexRow];
    }

    
    currentCargo.departure=[sender currentTitle];
    NSInteger longueurListe = airportList.count;
    
    
    
    
    
    for (NSInteger j = 1; j<longueurListe; j++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:(NSInteger)j inSection:1];
        AirportTableViewCell * currentCell = (AirportTableViewCell*)[myTableView cellForRowAtIndexPath:path];
        [currentCell.buttonDeparture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //[myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    currentCargo.numArrnumDep[0]=[NSNumber numberWithInteger:indexRow];
    [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    NSLog(@"Tout va bien depart");
    
    if([currentCargo.numArrnumDep[0] integerValue]>[currentCargo.numArrnumDep[1]integerValue]){
        
        
        for (NSInteger j = 1; j<longueurListe; j++){
            NSIndexPath *path = [NSIndexPath indexPathForRow:(NSInteger)j inSection:1];
            AirportTableViewCell * currentCell = (AirportTableViewCell*)[myTableView cellForRowAtIndexPath:path];
            
            [currentCell.buttonArrival setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //[myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:(NSInteger)indexRow +1 inSection:1];
        AirportTableViewCell * currentCell = (AirportTableViewCell*)[myTableView cellForRowAtIndexPath:path];
        
        currentCargo.numArrnumDep[1]=[NSNumber numberWithInteger:indexRow];
        [currentCell.buttonArrival setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        currentCargo.arrival=currentCell.buttonArrival.currentTitle;
        
    }
    
}

- (IBAction)buttonArrivalAirport:(id)sender {
    
    NSInteger indexRow = [sender tag];
    
    if([currentCargo.numArrnumDep[1] integerValue] == -1){
        currentCargo.numArrnumDep[1]=[NSNumber numberWithInteger:indexRow];
    }
    
    
    currentCargo.arrival=[sender currentTitle];
    NSInteger longueurListe = airportList.count;
    
    
    
    
    for (NSInteger j = 1; j<longueurListe; j++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:(NSInteger)j inSection:1];
        AirportTableViewCell * currentCell = (AirportTableViewCell*)[myTableView cellForRowAtIndexPath:path];
        
        [currentCell.buttonArrival setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    currentCargo.numArrnumDep[1]=[NSNumber numberWithInteger:indexRow];
    [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    NSLog(@"Tout va bien arrivé");
    
    if([currentCargo.numArrnumDep[0] integerValue]>[currentCargo.numArrnumDep[1]integerValue] || [currentCargo.numArrnumDep[0] integerValue]==-1){
       

        for (NSInteger j = 1; j<longueurListe; j++){
            NSIndexPath *path = [NSIndexPath indexPathForRow:(NSInteger)j inSection:1];
            AirportTableViewCell * currentCell = (AirportTableViewCell*)[myTableView cellForRowAtIndexPath:path];

            [currentCell.buttonDeparture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:(NSInteger)(indexRow +1) inSection:1];
        AirportTableViewCell * currentCell = (AirportTableViewCell*)[myTableView cellForRowAtIndexPath:path];
        
        currentCargo.numArrnumDep[0]=[NSNumber numberWithInteger:indexRow];
        [currentCell.buttonDeparture setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        currentCargo.departure=currentCell.buttonDeparture.currentTitle;
        
    }
}




- (IBAction)enterWeightButton:(id)sender {

 
    if(currentCargo.be.length!=0 && currentCargo.arrival && currentCargo.departure){

        if([currentCargo.numArrnumDep[0] integerValue] <= [currentCargo.numArrnumDep[1]integerValue]){
            [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: 0 inSection:0]].backgroundColor = [UIColor whiteColor];
            if(currentCargo.type==pax){
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"4002"];
                [self.navigationController pushViewController:pushVC animated:YES];
            }
            else{
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"4003"];
                [self.navigationController pushViewController:pushVC animated:YES];
            }
        }
        else{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Impossible !"
                                                  message:@"Selected arrival is before selected departure !"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                           style:UIAlertActionStyleCancel
                                           handler:nil];
            
        
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];

            /*[myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: ([currentCargo.numArrnumDep[1] integerValue] + 1) inSection:0]].backgroundColor = [UIColor redColor];
            [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: ([currentCargo.numArrnumDep[0] integerValue] + 1) inSection:0]].backgroundColor = [UIColor redColor];
             */
        
        }
    }
    else{
        


        [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: 0 inSection:0]].backgroundColor = [UIColor redColor];
    }
}

- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear:animated];
    if(self.isMovingFromParentViewController){
        if(!currentCargo.be || !currentCargo.weight || !currentCargo.arrival || !currentCargo.departure){
            [currentCargo destroy];
        }
    }
    
    [super viewWillDisappear:animated];
    UITableView *legsView= ((UITableViewController*)self.splitViewController.viewControllers.firstObject.childViewControllers.firstObject).tableView;
    for (int i=0;i<=mission.legs.count;i++){
        NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell * cell = [legsView cellForRowAtIndexPath:path];
        cell.userInteractionEnabled = YES;
    }
}


# pragma mark - TextField delegate

//Faire apparaître les popovers pour Aircraft, Unit, CTM, Be et Na

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    activeTextField = textField;

    if (!quickText)
        quickText = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickText"];
    
    quickText.myDelegate = self;
    [quickText setValues: @[beList] pref:nil sub:nil];
    
    if (!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:quickText];
    popover.delegate = self;
    [popover presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


# pragma mark - QuickTextDelegate

- (void)quickTextDidSelectString:(NSString *)string
{
    activeTextField.text = string;
    [activeTextField resignFirstResponder];
    
}


# pragma mark - PopoverDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [activeTextField resignFirstResponder];
}

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    if (popover == popoverController)
    {
        *rect = activeTextField.frame;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField*)textField {
    if (popover.isPopoverVisible)
        [popover dismissPopoverAnimated:YES];
    return YES;
}

@end
