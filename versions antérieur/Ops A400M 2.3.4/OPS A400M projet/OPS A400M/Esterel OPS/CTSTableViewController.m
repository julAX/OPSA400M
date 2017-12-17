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

}

@end

@implementation CTSTableViewController

- (void)activeLegDidChange:(NSInteger)legNumber
{
    [self writeInLeg];
    leg = mission.activeLeg;
    [self.tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    mission.delegate=self;
    
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
    if(section==0)
        return 1;
    else if (section==1)
        return 3;
    else if (section==2)
        return 7;
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        CTSNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"NumberCell" forIndexPath:indexPath];
        cell.numberTextField.text = leg[@"Engine"][0];

        return cell;
    }
    else if(indexPath.section==1){
        if(indexPath.row!=0){
            CTSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CTSCell" forIndexPath:indexPath];
//            [cell.engine1 setText: leg[@"Engine"][1][indexPath.row - 1]];
//            [cell.engine2 setText: leg[@"Engine"][2][indexPath.row - 1]];
//            [cell.engine3 setText: leg[@"Engine"][3][indexPath.row - 1]];
//            [cell.engine4 setText: leg[@"Engine"][4][indexPath.row - 1]];
            [cell.engine1 setText: (![leg[@"Engine"][1][indexPath.row - 1] isEqualToString: @"0"])? leg[@"Engine"][1][indexPath.row - 1] : @""];
            [cell.engine2 setText: (![leg[@"Engine"][2][indexPath.row - 1] isEqualToString: @"0"])? leg[@"Engine"][2][indexPath.row - 1] : @""];
            [cell.engine3 setText: (![leg[@"Engine"][3][indexPath.row - 1] isEqualToString: @"0"])? leg[@"Engine"][3][indexPath.row - 1] : @""];
            [cell.engine4 setText: (![leg[@"Engine"][4][indexPath.row - 1] isEqualToString: @"0"])? leg[@"Engine"][4][indexPath.row - 1] : @""];
            cell.plus1.value = [leg[@"Engine"][1][indexPath.row - 1] integerValue] ;
            cell.plus2.value = [leg[@"Engine"][2][indexPath.row - 1] integerValue] ;
            cell.plus3.value = [leg[@"Engine"][3][indexPath.row - 1] integerValue] ;
            cell.plus4.value = [leg[@"Engine"][4][indexPath.row - 1] integerValue] ;
            
            switch (indexPath.row) {
                case 1:
                    cell.lineName.text=@"1.1) Ground Ops + Time";
                    
                    break;
                case 2:
                    cell.lineName.text=@"1.2) Flight Ops";
                    
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }
        else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"engine" forIndexPath:indexPath];
            return cell;
        }
        
    }
    else {
        CTSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CTSCell" forIndexPath:indexPath];
//        [cell.engine1 setText: leg[@"Engine"][1][indexPath.row +2]];
//        [cell.engine2 setText: leg[@"Engine"][2][indexPath.row +2]];
//        [cell.engine3 setText: leg[@"Engine"][3][indexPath.row +2]];
//        [cell.engine4 setText: leg[@"Engine"][4][indexPath.row +2]];
        
        [cell.engine1 setText: (![leg[@"Engine"][1][indexPath.row + 2] isEqualToString: @"0"])? leg[@"Engine"][1][indexPath.row + 2] : @""];
        [cell.engine2 setText: (![leg[@"Engine"][2][indexPath.row + 2] isEqualToString: @"0"])? leg[@"Engine"][2][indexPath.row + 2] : @""];
        [cell.engine3 setText: (![leg[@"Engine"][3][indexPath.row + 2] isEqualToString: @"0"])? leg[@"Engine"][3][indexPath.row + 2] : @""];
        [cell.engine4 setText: (![leg[@"Engine"][4][indexPath.row + 2] isEqualToString: @"0"])? leg[@"Engine"][4][indexPath.row + 2] : @""];
        
        
        cell.plus1.value = [leg[@"Engine"][1][indexPath.row + 2] integerValue] ;
        cell.plus2.value = [leg[@"Engine"][2][indexPath.row + 2] integerValue] ;
        cell.plus3.value = [leg[@"Engine"][3][indexPath.row + 2] integerValue] ;
        cell.plus4.value = [leg[@"Engine"][4][indexPath.row + 2] integerValue] ;
        
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
            case 3:
                cell.lineName.text=@"2.4) Relight after In Flight Shut Down + Time";
                
                break;
            case 4:
                cell.lineName.text=@"2.5) Aborted Engine Starts";
                
                break;
            case 5:
                cell.lineName.text=@"2.6a) High Power Shutdown on ground or in flight";
                
                break;
            case 6:
                cell.lineName.text=@"2.6b) Hight Power re-start after windmill more than 30'' ";
                
                break;
            default:
                break;
        }
        
        return cell;
    
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"N° de feuillet LOGBOOK ATL N°";
    }
    else if(section==1)
        return @"Operation occurences";
    else
        return @"additional event occurences";
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 70.0;
    else if(indexPath.section == 1){
        if(indexPath.row==0)
            return 40.0;
        else
            return 85.0;
    }
    else
        return 85.0;
    
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
    [self writeInLeg];
}


- (IBAction)changing:(id)sender {
    [self writeInLeg];

}

-(void) writeInLeg{
    
    for(int i = 1; i<=2 ; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        CTSTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        leg[@"Engine"][1][indexPath.row - 1] = cell.engine1.text;
        leg[@"Engine"][2][indexPath.row - 1] = cell.engine2.text;
        leg[@"Engine"][3][indexPath.row - 1] = cell.engine3.text;
        leg[@"Engine"][4][indexPath.row - 1] = cell.engine4.text;
    }
    for(int i = 0; i<=6 ; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:2];
        CTSTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        leg[@"Engine"][1][indexPath.row + 2] = cell.engine1.text;
        leg[@"Engine"][2][indexPath.row + 2] = cell.engine2.text;
        leg[@"Engine"][3][indexPath.row + 2] = cell.engine3.text;
        leg[@"Engine"][4][indexPath.row + 2] = cell.engine4.text;
    }
    
}

- (IBAction)numberEntered:(id)sender {
    if(!leg[@"Engine"][0]){
        leg[@"Engine"][0] = [[NSString alloc]init];
    }
    leg[@"Engine"][0]=[sender text];
    [self writeInLeg];

}

@end


