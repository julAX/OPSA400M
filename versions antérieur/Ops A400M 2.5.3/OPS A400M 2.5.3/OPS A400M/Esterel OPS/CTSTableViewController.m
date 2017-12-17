//
//  CTSTableViewController.m
//  OPS A400M
//
//  Created by richard david on 26/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "CTSTableViewController.h"


/*
 
 COMMENT X15
 
 Classe de TableViewController:
 
 Gere le controller de crew tick sheet!
 utilise les deux classes de cellules précédentes dans la liste pour creer dynamiquement le tableau (dans la methode (- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath ) héritée directement de UITableViewController (c'est pour ca qu'elle est pas redéclarée dans le .h
 
 On a mis <MissionDelegate> dans le .h et (- (void)activeLegDidChange:(NSInteger)legNumber ) ici pour que la vue s'actualise directement quand on change de leg. Bien sur il faut remplir la méthode au cas par cas dans chaque classe qui l'utilise. Ne pas oublier (mission.delegate=self;) dans le viewDidLoad de manière générale.
 
 */


@interface CTSTableViewController (){
    Mission * mission;
    NSMutableDictionary *leg;
    NSInteger activeCTS;
    UIPopoverController *popover;
    NSMutableArray * indicCTS;
    BOOL ok;
    
}

@end

@implementation CTSTableViewController

- (void)activeLegDidChange:(NSInteger)legNumber
{
    ok=YES;
    [self writeInLeg];
    leg = mission.activeLeg;
    activeCTS = [leg[@"activeCTS"] integerValue];
    self.title = [NSString stringWithFormat:@"Crew tick sheet N°%ld for leg %ld",(long) activeCTS + 1, (long)mission.activeLegIndex + 1 ];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    CTSNumberTableViewCell * cell = [self.tableView cellForRowAtIndexPath:path];
    cell.logbookNumber.text = leg[@"CrewTickSheets"][activeCTS][0];
    indicCTS = leg[@"Indicators"][@"CrewTickSheet"];
    [self.tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    ok=YES;
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    mission.delegate=self;
    activeCTS = [leg[@"activeCTS"] integerValue];
    indicCTS = leg[@"Indicators"][@"CrewTickSheet"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}




-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==1)
        return 3;
    else if (section==2)
        return 9;
    else if( section==0)
        return 1;
    else
        return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for(NSInteger i =1; i<5;i++){
        if(((NSArray*)leg[@"CrewTickSheets"][activeCTS][i]).count==9)
            [leg[@"CrewTickSheets"][activeCTS][i] addObject:@"0"];
    }
    
    
    if(indexPath.section==1){
        if(indexPath.row!=0){
            
            if(indexPath.row==1){
                CTSTimeTableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier: @"CTSTimeCell" forIndexPath:indexPath];
                
                [cell.engine1 setText: (![leg[@"CrewTickSheets"][activeCTS][1][0][0] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][1][0][0]: @""];
                [cell.engine2 setText: (![leg[@"CrewTickSheets"][activeCTS][2][0][0] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][2][0][0]: @""];
                [cell.engine3 setText: (![leg[@"CrewTickSheets"][activeCTS][3][0][0] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][3][0][0]: @""];
                [cell.engine4 setText: (![leg[@"CrewTickSheets"][activeCTS][4][0][0] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][4][0][0]: @""];
                cell.plus1.value = [leg[@"CrewTickSheets"][activeCTS][1][0][0] integerValue] ;
                cell.plus2.value = [leg[@"CrewTickSheets"][activeCTS][2][0][0] integerValue] ;
                cell.plus3.value = [leg[@"CrewTickSheets"][activeCTS][3][0][0] integerValue] ;
                cell.plus4.value = [leg[@"CrewTickSheets"][activeCTS][4][0][0] integerValue] ;
                
                cell.lineName.text=@"1.1) Ground Ops + Time";
                cell.legende=@"Every ground operation from ENG start to shut down (no lift off, no take off)";
                
                //ajoputer les times
                
                cell.time1.myDelegate=self;
                cell.time2.myDelegate=self;
                cell.time3.myDelegate=self;
                cell.time4.myDelegate=self;
                
                cell.time1.tag=0;
                cell.time2.tag=1;
                cell.time3.tag=2;
                cell.time4.tag=3;
                
                cell.time1.emptyIfZero=YES;
                cell.time2.emptyIfZero=YES;
                cell.time3.emptyIfZero=YES;
                cell.time4.emptyIfZero=YES;
                
                [cell.time1 setTime:leg[@"CrewTickSheets"][activeCTS][1][0][1]];
                [cell.time2 setTime:leg[@"CrewTickSheets"][activeCTS][2][0][1]];
                [cell.time3 setTime:leg[@"CrewTickSheets"][activeCTS][3][0][1]];
                [cell.time4 setTime:leg[@"CrewTickSheets"][activeCTS][4][0][1]];
                
                UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
                [greyCell setBackgroundColor:[UIColor clearColor]];
                cell.selectedBackgroundView = greyCell;
                
                return cell;
                
                
                
                
            }
            
            else{
                CTSTableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier: @"CTSCell" forIndexPath:indexPath];
                
                [cell.engine1 setText: (![leg[@"CrewTickSheets"][activeCTS][1][1] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][1][1] : @""];
                [cell.engine2 setText: (![leg[@"CrewTickSheets"][activeCTS][2][1] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][2][1] : @""];
                [cell.engine3 setText: (![leg[@"CrewTickSheets"][activeCTS][3][1] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][3][1] : @""];
                [cell.engine4 setText: (![leg[@"CrewTickSheets"][activeCTS][4][1] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][4][1] : @""];
                cell.plus1.value = [leg[@"CrewTickSheets"][activeCTS][1][1] integerValue] ;
                cell.plus2.value = [leg[@"CrewTickSheets"][activeCTS][2][1] integerValue] ;
                cell.plus3.value = [leg[@"CrewTickSheets"][activeCTS][3][1] integerValue] ;
                cell.plus4.value = [leg[@"CrewTickSheets"][activeCTS][4][1] integerValue] ;
                
                cell.lineName.text=@"1.2) Flight Ops";
                cell.legende=@"Every flight operation from ENG start to shut down (at least one lift off achieved and RTO included)";
                
                UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
                [greyCell setBackgroundColor:[UIColor clearColor]];
                cell.selectedBackgroundView = greyCell;
                
                return cell;
                
                
            }
            
        }
        else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"engine" forIndexPath:indexPath];
            
            UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
            [greyCell setBackgroundColor:[UIColor clearColor]];
            cell.selectedBackgroundView = greyCell;
            
            return cell;
        }
        
    }
    else if (indexPath.section==2) {
        
        if(indexPath.row!=3 && indexPath.row!=7 && indexPath.row!=8 && indexPath.row!=6){
            
            CTSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CTSCell" forIndexPath:indexPath];
            //        [cell.engine1 setText: leg[@"Engine"][1][indexPath.row +2]];
            //        [cell.engine2 setText: leg[@"Engine"][2][indexPath.row +2]];
            //        [cell.engine3 setText: leg[@"Engine"][3][indexPath.row +2]];
            //        [cell.engine4 setText: leg[@"Engine"][4][indexPath.row +2]];
            
            [cell.engine1 setText: (![leg[@"CrewTickSheets"][activeCTS][1][indexPath.row + 2] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][1][indexPath.row + 2] : @""];
            [cell.engine2 setText: (![leg[@"CrewTickSheets"][activeCTS][2][indexPath.row + 2] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][2][indexPath.row + 2] : @""];
            [cell.engine3 setText: (![leg[@"CrewTickSheets"][activeCTS][3][indexPath.row + 2] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][3][indexPath.row + 2] : @""];
            [cell.engine4 setText: (![leg[@"CrewTickSheets"][activeCTS][4][indexPath.row + 2] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][4][indexPath.row + 2] : @""];
            
            
            cell.plus1.value = [leg[@"CrewTickSheets"][activeCTS][1][indexPath.row + 2] integerValue] ;
            cell.plus2.value = [leg[@"CrewTickSheets"][activeCTS][2][indexPath.row + 2] integerValue] ;
            cell.plus3.value = [leg[@"CrewTickSheets"][activeCTS][3][indexPath.row + 2] integerValue] ;
            cell.plus4.value = [leg[@"CrewTickSheets"][activeCTS][4][indexPath.row + 2] integerValue] ;
            
            cell.legende=@"nil";
            switch (indexPath.row) {
                    
                case 0:
                    cell.lineName.text=@"2.1) GI/FI to TOGA";
                    
                    break;
                case 1:
                    cell.lineName.text=@"2.2) GI/FI to MCT/MCL/DTO";
                    
                    break;
                case 2:
                    cell.lineName.text=@"2.3) NP redline event ( >= 864.0 rpm )";
                    
                    break;
                case 4:
                    cell.lineName.text=@"2.5) Aborted Engine Starts";
                    
                    break;
                case 5:
                    cell.lineName.text=@"2.6a) High Power Shutdown on ground or in flight";
                    
                    break;
                case 7:
                    cell.lineName.text=@"3) heure desert";
                    
                    break;
                default:
                    break;
            }
            
            UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
            [greyCell setBackgroundColor:[UIColor clearColor]];
            cell.selectedBackgroundView = greyCell;
            
            return cell;
        }
        
        else if (indexPath.row==6){
            CTSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CTSCell2" forIndexPath:indexPath];

            
            [cell.engine1 setText: (![leg[@"CrewTickSheets"][activeCTS][1][indexPath.row + 2] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][1][indexPath.row + 2] : @""];
            [cell.engine2 setText: (![leg[@"CrewTickSheets"][activeCTS][2][indexPath.row + 2] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][2][indexPath.row + 2] : @""];
            [cell.engine3 setText: (![leg[@"CrewTickSheets"][activeCTS][3][indexPath.row + 2] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][3][indexPath.row + 2] : @""];
            [cell.engine4 setText: (![leg[@"CrewTickSheets"][activeCTS][4][indexPath.row + 2] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][4][indexPath.row + 2] : @""];
            
            
            cell.plus1.value = [leg[@"CrewTickSheets"][activeCTS][1][indexPath.row + 2] integerValue] ;
            cell.plus2.value = [leg[@"CrewTickSheets"][activeCTS][2][indexPath.row + 2] integerValue] ;
            cell.plus3.value = [leg[@"CrewTickSheets"][activeCTS][3][indexPath.row + 2] integerValue] ;
            cell.plus4.value = [leg[@"CrewTickSheets"][activeCTS][4][indexPath.row + 2] integerValue] ;
            
            cell.legende=@"nil";
            cell.lineName.text=@"2.6b) Hight Power re-start after windmill more than 30'' ";
            
            
            UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
            [greyCell setBackgroundColor:[UIColor clearColor]];
            cell.selectedBackgroundView = greyCell;
            
            return cell;
        
        }
        
        else if (indexPath.row==3){
            CTSTimeTableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier: @"CTSTimeCell" forIndexPath:indexPath];
            cell.legende=@"nil";
            cell.lineName.text=@"2.4) Relight after In Flight Shut Down + Time";
            
            [cell.engine1 setText: (![leg[@"CrewTickSheets"][activeCTS][1][5][0] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][1][5][0]: @""];
            [cell.engine2 setText: (![leg[@"CrewTickSheets"][activeCTS][2][5][0] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][2][5][0]: @""];
            [cell.engine3 setText: (![leg[@"CrewTickSheets"][activeCTS][3][5][0] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][3][5][0]: @""];
            [cell.engine4 setText: (![leg[@"CrewTickSheets"][activeCTS][4][5][0] isEqualToString: @"0"])? leg[@"CrewTickSheets"][activeCTS][4][5][0]: @""];
            
            
            cell.plus1.value = [leg[@"CrewTickSheets"][activeCTS][1][5][0] integerValue] ;
            cell.plus2.value = [leg[@"CrewTickSheets"][activeCTS][2][5][0] integerValue] ;
            cell.plus3.value = [leg[@"CrewTickSheets"][activeCTS][3][5][0] integerValue] ;
            cell.plus4.value = [leg[@"CrewTickSheets"][activeCTS][4][5][0] integerValue] ;
            
            
            
            cell.time1.tag=4;
            cell.time2.tag=5;
            cell.time3.tag=6;
            cell.time4.tag=7;
            
            cell.time1.myDelegate=self;
            cell.time2.myDelegate=self;
            cell.time3.myDelegate=self;
            cell.time4.myDelegate=self;
            
            cell.time1.emptyIfZero=YES;
            cell.time2.emptyIfZero=YES;
            cell.time3.emptyIfZero=YES;
            cell.time4.emptyIfZero=YES;
            
            
            [cell.time1 setTime:leg[@"CrewTickSheets"][activeCTS][1][5][1]];
            [cell.time2 setTime:leg[@"CrewTickSheets"][activeCTS][2][5][1]];
            [cell.time3 setTime:leg[@"CrewTickSheets"][activeCTS][3][5][1]];
            [cell.time4 setTime:leg[@"CrewTickSheets"][activeCTS][4][5][1]];
            
            UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
            [greyCell setBackgroundColor:transparant];
            cell.selectedBackgroundView = greyCell;
            
            return cell;
            
        }
        else if (indexPath.row==7){
            CTSTimeOnlyCell * cell = [tableView dequeueReusableCellWithIdentifier: @"CTSTimeOnlyCell" forIndexPath:indexPath];

            cell.time1.myDelegate=self;
            cell.time2.myDelegate=self;
            cell.time3.myDelegate=self;
            cell.time4.myDelegate=self;
            
            cell.time1.emptyIfZero=YES;
            cell.time2.emptyIfZero=YES;
            cell.time3.emptyIfZero=YES;
            cell.time4.emptyIfZero=YES;
            
            [cell.time1 setTime:leg[@"CrewTickSheets"][activeCTS][1][9]];
            [cell.time2 setTime:leg[@"CrewTickSheets"][activeCTS][2][9]];
            [cell.time3 setTime:leg[@"CrewTickSheets"][activeCTS][3][9]];
            [cell.time4 setTime:leg[@"CrewTickSheets"][activeCTS][4][9]];

            cell.time1.tag=8;
            cell.time2.tag=9;
            cell.time3.tag=10;
            cell.time4.tag=11;

            cell.legende=@"Any operations in visible airborne sand or dust, or any operations on unprepared runways, or sustained (10 hours or more) operations in an aera where sand and dust constitute the majority of ground cover";
            cell.lineName.text=@"3) Desert engine flight hours";

            UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
            [greyCell setBackgroundColor:[UIColor clearColor]];
            cell.selectedBackgroundView = greyCell;
            return cell;
        
        }
        else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"OkCell" forIndexPath:indexPath];
            return cell;
        }
    }
    else{
        CTSNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"numberCell" forIndexPath:indexPath];
        
        UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
        [greyCell setBackgroundColor:[UIColor clearColor]];
        cell.selectedBackgroundView = greyCell;
        
        return cell;
    
    }
}


- (void) myTextFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag<4){
        leg[@"CrewTickSheets"][activeCTS][(textField.tag +1)][0][1]=((TimeTextField*)textField).time;
    }
    else if (textField.tag<8 && textField.tag >3){
        leg[@"CrewTickSheets"][activeCTS][(textField.tag -3)][5][1]=((TimeTextField*)textField).time;
    }
    else{
        leg[@"CrewTickSheets"][activeCTS][(textField.tag -7)][9]=((TimeTextField*)textField).time;
    }
    
    [self writeInLeg];
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==1)
        return @"Operation occurences";
    else if (section==2)
        return @"additional event occurences";
    else
        return @"";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(!((indexPath.section==1 || indexPath.section== 0) && indexPath.row==0) && indexPath.row!=8){
        if(indexPath.row==7){
            CTSTimeOnlyCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(5,5, 300, 180)];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 190)];
            label.text= cell.legende;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 8;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            [view addSubview:label];
            UIViewController * legendeController = [[UIViewController alloc]init];
            legendeController.view=view;
            
            

            
            if(!([cell.legende isEqualToString: @"nil"])){
                popover = [[UIPopoverController alloc]initWithContentViewController:legendeController];
                popover.delegate = self;
                popover.backgroundColor=jone;
                [popover setPopoverContentSize: CGSizeMake(310, 190)];
                [popover presentPopoverFromRect:cell.frame inView:cell.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }

            
        }
        else{
            CTSTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(5,5, 300, 80)];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 90)];
            label.text= cell.legende;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 3;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            [view addSubview:label];
            UIViewController * legendeController = [[UIViewController alloc]init];
            legendeController.view=view;
            
            
            
            
            if(!([cell.legende isEqualToString: @"nil"])){
                popover = [[UIPopoverController alloc]initWithContentViewController:legendeController];
                popover.delegate = self;
                popover.backgroundColor=jone;
                [popover setPopoverContentSize: CGSizeMake(310, 90)];
                [popover presentPopoverFromRect:cell.frame inView:cell.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
    }
    
    else if(indexPath.row==8 && indexPath.section == 2){
        ok=YES;
        [self writeInLeg];
        
        if(ok){
            BOOL cestBon = YES;
            
            for(NSInteger i =0 ; i< ((NSArray*)leg[@"CrewTickSheets"]).count ; i++){
                if([leg[@"CrewTickSheets"][i][5] isEqualToString:@"1"])
                    cestBon=NO;
            }
            
            
            if([indicCTS[0] isEqualToString: @"1"] && cestBon)
                indicCTS[1]=@"1";
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    
    }
    
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row==0)
            return 40.0;
        else if (indexPath.row==1)
            return 100.0;
        else
            return 70.0;
    }
    else if(indexPath.section == 2){
        if(indexPath.row==3)
            return 100.0;
        else if (indexPath.row==6 || indexPath.row==8)
            return 80.0;
        else if(indexPath.row==7)
            return 50.0;
        else
            return 70.0;
    }
    else
        return 45.0;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self writeInLeg];
}


- (IBAction)changing:(id)sender {
    [self writeInLeg];
    
}

- (IBAction)logbookChanged:(id)sender {
    NSString *logbook = ((UITextField*)sender).text;
    leg[@"CrewTickSheets"][activeCTS][0]=logbook;

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [NSString stringWithFormat:@"Crew tick sheet N°%ld for leg %ld",(long) activeCTS + 1, (long)mission.activeLegIndex + 1 ];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    CTSNumberTableViewCell * cell = [self.tableView cellForRowAtIndexPath:path];
    cell.logbookNumber.text = leg[@"CrewTickSheets"][activeCTS][0];
    ok=YES;
    [self writeInLeg];
}

-(void) writeInLeg{
    
    BOOL yaRien = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    CTSTimeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *engine = @[cell.engine1,cell.engine2,cell.engine3,cell.engine4];
    NSArray *timeAbs = @[cell.time1,cell.time2,cell.time3,cell.time4];
    
    leg[@"CrewTickSheets"][activeCTS][5] = @"0";
    
    BOOL enCours = YES;
    
    
    for(int i=1; i<5;i++){
        leg[@"CrewTickSheets"][activeCTS][i][0][0] = ((UILabel*)engine[i-1]).text;
        if(![leg[@"CrewTickSheets"][activeCTS][i][0][0] isEqualToString:@""]){
            
            yaRien = NO;
            
            if([((NSDate*)leg[@"CrewTickSheets"][activeCTS][i][0][1]) timeIntervalSinceReferenceDate]==0){
                ((TimeTextField*)timeAbs[i-1]).backgroundColor = rouge;
                ((TimeTextField*)timeAbs[i-1]).placeholder = @"Time ?";
                
                ((UILabel*)engine[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                indicCTS[1]=@"0";
                indicCTS[0]=@"0";
                
                ok=NO;
                
                leg[@"CrewTickSheets"][activeCTS][5] = @"1";
                
                enCours=NO;
                
                
            }
            else{
                ((TimeTextField*)timeAbs[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                ((UILabel*)engine[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                ((TimeTextField*)timeAbs[i-1]).placeholder = nil;

            }
        }
        else{
            if(![((NSDate*)leg[@"CrewTickSheets"][activeCTS][i][0][1]) timeIntervalSinceReferenceDate]==0){
                ((UILabel*)engine[i-1]).backgroundColor = rouge;
                ((TimeTextField*)timeAbs[i-1]).placeholder = @"Time ?";

                ((TimeTextField*)timeAbs[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                indicCTS[1]=@"0";
                indicCTS[0]=@"0";
                ok=NO;
                enCours = NO;
                leg[@"CrewTickSheets"][activeCTS][5] = @"1";
                
            }
            else{
                ((UILabel*)engine[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                ((TimeTextField*)timeAbs[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                ((TimeTextField*)timeAbs[i-1]).placeholder = nil;

            }
        }
        
    }
    
    
    
    
    
    indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    engine = @[cell.engine1,cell.engine2,cell.engine3,cell.engine4];
    timeAbs = @[cell.time1,cell.time2,cell.time3,cell.time4];
    
    for(int i=1; i<5;i++){
        leg[@"CrewTickSheets"][activeCTS][i][5][0] = ((UILabel*)engine[i-1]).text;
        if(![leg[@"CrewTickSheets"][activeCTS][i][5][0] isEqualToString:@""]){
            yaRien = NO;
            
            if([((NSDate*)leg[@"CrewTickSheets"][activeCTS][i][5][1]) timeIntervalSinceReferenceDate]==0){
                ((TimeTextField*)timeAbs[i-1]).backgroundColor = rouge;
                ((TimeTextField*)timeAbs[i-1]).placeholder = @"Time ?";

                ((UILabel*)engine[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                indicCTS[1]=@"0";
                indicCTS[0]=@"0";
                enCours = NO;
                ok=NO;
                leg[@"CrewTickSheets"][activeCTS][5] = @"1";
            }
            else{
                ((TimeTextField*)timeAbs[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                ((UILabel*)engine[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                ((TimeTextField*)timeAbs[i-1]).placeholder = nil;
            }
        }
        else{
            if(![((NSDate*)leg[@"CrewTickSheets"][activeCTS][i][5][1]) timeIntervalSinceReferenceDate]==0){
                yaRien = NO;
                ((UILabel*)engine[i-1]).backgroundColor = rouge;
                ((TimeTextField*)timeAbs[i-1]).placeholder = @"Time ?";

                ((TimeTextField*)timeAbs[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                indicCTS[1]=@"0";
                indicCTS[0]=@"0";
                enCours = NO;
                ok=NO;
                leg[@"CrewTickSheets"][activeCTS][5] = @"1";
                
            }
            else{
                ((UILabel*)engine[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                ((TimeTextField*)timeAbs[i-1]).backgroundColor = (i==1 || i==3)? grisDuFond : transparant;
                ((TimeTextField*)timeAbs[i-1]).placeholder = nil;

            }
        }
        
    }
    
    if(enCours){
        indicCTS[0]=@"1";
    }
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    leg[@"CrewTickSheets"][activeCTS][1][1] = cell.engine1.text;
    leg[@"CrewTickSheets"][activeCTS][2][1] = cell.engine2.text;
    leg[@"CrewTickSheets"][activeCTS][3][1] = cell.engine3.text;
    leg[@"CrewTickSheets"][activeCTS][4][1] = cell.engine4.text;
    
    if(![cell.engine1.text isEqualToString:@""] || ![cell.engine2.text isEqualToString:@""] || ![cell.engine3.text isEqualToString:@""] || ![cell.engine4.text isEqualToString:@""])
        yaRien=NO;

    
    for(int i = 0; i<7 ; i++){
        if(i!=3){
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:2];
            CTSTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            if(![cell.engine1.text isEqualToString:@""] || ![cell.engine2.text isEqualToString:@""] || ![cell.engine3.text isEqualToString:@""] || ![cell.engine4.text isEqualToString:@""])
                yaRien=NO;
            
            leg[@"CrewTickSheets"][activeCTS][1][indexPath.row + 2] = cell.engine1.text;
            leg[@"CrewTickSheets"][activeCTS][2][indexPath.row + 2] = cell.engine2.text;
            leg[@"CrewTickSheets"][activeCTS][3][indexPath.row + 2] = cell.engine3.text;
            leg[@"CrewTickSheets"][activeCTS][4][indexPath.row + 2] = cell.engine4.text;
        }
        
    }
    
    if(yaRien){
        leg[@"CrewTickSheets"][activeCTS][5] = @"1";
    }
    
    else if(!yaRien && enCours && ok){
        leg[@"CrewTickSheets"][activeCTS][5] = @"0";
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



# pragma mark - PopoverDelegate






@end


