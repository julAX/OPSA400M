//
//  CommentDerogViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 22/01/2014.
//
//

#import "CommentDerogViewController.h"

#import "SplitViewController.h"
#import "DerogCell.h"

@interface CommentDerogViewController () {
    
    Mission *mission;
    NSInteger legNumber;
    NSMutableDictionary *leg;
    NSMutableArray *derogs;

    UITextView *comments;
    
    UIPopoverController *popover;
}

@end

@implementation CommentDerogViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = 30.;

    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, space, self.editButtonItem];
    
    ChooseDerogViewController *choose = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseDerog"];
    choose.delegate = self;
    
    popover = [[UIPopoverController alloc] initWithContentViewController:choose];
}


- (void)activeLegDidChange:(NSInteger)l
{
    legNumber = l;
    leg = mission.activeLeg;
    
    derogs = mission.root[@"Derog"];
    
    if (self.splitViewController.presentedViewController)
        [self.tableView reloadData];
    else
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mission = ((SplitViewController*)self.splitViewController).mission;
    mission.delegate = self;
    
    legNumber = mission.activeLegIndex;
    leg = mission.activeLeg;
    
    derogs = mission.root[@"Derog"];
}

# pragma mark - TextView delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    leg[@"Comments"] = comments.text;
}

- (IBAction)copyPrevious:(UIButton *)sender {
    
    NSMutableString *text = [comments.text mutableCopy];
    
    if (![text isEqualToString:@""])
        [text appendString:@"\n"];
    
    [text appendString:mission.legs[legNumber-1][@"Comments"]];
    
    comments.text = text;
    
    leg[@"Comments"] = comments.text;
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1) && (indexPath.row == derogs.count))
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [popover presentPopoverFromRect:[tableView cellForRowAtIndexPath:indexPath].frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ return (section == 0) ? [NSString stringWithFormat:@"Comments OMA (leg %ld)", (long)(legNumber + 1)] : @"Derog (global)"; }



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ return (indexPath.section == 0) ? 100. : 44; }
//{ return (indexPath.section == 0) ? 200. : -1.; }



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return (section == 0) ? 1 : (derogs.count + 1); }



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell" forIndexPath:indexPath];
        
        ((UIButton*)[cell viewWithTag:505]).enabled = (legNumber > 0);
        
        comments = (UITextView*)[cell viewWithTag:500];
        comments.text = leg[@"Comments"];
        
        return cell;
    }
    else
    {
        if (indexPath.row == (derogs.count))
            return [tableView dequeueReusableCellWithIdentifier:@"NewCell" forIndexPath:indexPath];
        
        DerogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DerogCell" forIndexPath:indexPath];
        
        [cell initWithDerog:derogs[indexPath.row]];
        
        return cell;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {return ((indexPath.section == 1) && (indexPath.row != derogs.count)); }


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [derogs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return [NSIndexPath indexPathForRow:((proposedDestinationIndexPath.row == derogs.count) ? (derogs.count - 1) : proposedDestinationIndexPath.row) inSection:1];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((indexPath.section != 0) && (indexPath.row != derogs.count));
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableDictionary *movingDerog = derogs[sourceIndexPath.row];
    [derogs removeObjectAtIndex:sourceIndexPath.row];
    [derogs insertObject:movingDerog atIndex:destinationIndexPath.row];
}



# pragma mark - ChooseDerog delegate

- (void)chooseDerogDidChoose:(NSMutableDictionary *)derog
{
    [popover dismissPopoverAnimated:YES];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:derogs.count inSection:1];
    
    [derogs addObject:derog];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

# pragma mark - Popover delegate

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    if (popover == popoverController)
    {
        *rect = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:derogs.count inSection:1]].frame;
    }
}


@end
