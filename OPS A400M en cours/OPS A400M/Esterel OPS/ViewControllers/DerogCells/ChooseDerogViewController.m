//
//  ChooseDerogViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 23/01/2014.
//
//

#import "ChooseDerogViewController.h"
#import "Mission.h"

@interface ChooseDerogViewController ()

@end

@implementation ChooseDerogViewController

static NSArray* derogs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!derogs)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ListeDerogs" ofType:@"plist"];
        derogs = [NSDictionary dictionaryWithContentsOfFile:path][@"Derog"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return derogs.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DerogCell" forIndexPath:indexPath];
    
    cell.textLabel.text = derogs[indexPath.row][@"Nature"];
    
    if (cell.textLabel.text.length == 0)
        cell.textLabel.text = @"Empty";
    
    cell.detailTextLabel.text = derogs[indexPath.row][@"Numero"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate chooseDerogDidChoose:[(NSDictionary*)derogs[indexPath.row] mutableDeepCopy]];
}


@end
