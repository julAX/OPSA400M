//
//  QuickTextRefEnt.m
//  Touraine OPS
//
//  Created by Delphine Vendryes on 03/03/2015.
//  Copyright (c) 2015 Esterel. All rights reserved.
//

#import "QuickTextRefEntViewController.h"

@interface QuickTextRefEntViewController ()
{
    NSArray *fullTab, *pref, *sub, *tab, *prefTab, *subTab;
}
@end


@implementation QuickTextRefEntViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)setValues:(NSArray *)values pref:(NSArray *)prefixes sub:(NSArray*)subtitles
{
    fullTab = values;
    pref = prefixes;
    sub = subtitles;
    
    tab = fullTab;
    prefTab = pref;
    subTab = sub;
}

- (void)reloadDataForEntry:(NSString *)text
{
    if ([text isEqualToString:@""])
    {
        tab = fullTab;
        prefTab = pref;
        subTab = sub;
    }
    else
    {
        NSMutableArray *tempTab = [NSMutableArray new], *tempPrefTab, *tempSubTab;
        
        if (pref)
        tempPrefTab = [NSMutableArray new];
        
        if (sub)
        tempSubTab = [NSMutableArray new];
        
        NSUInteger i = 0;
        
        for (NSString *curString in fullTab) {
            
            NSRange substringRange = [curString rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if (substringRange.location == 0)
            {
                [tempTab addObject:curString];
                
                if (pref)
                [tempPrefTab addObject:pref[i]];
                
                if (sub)
                [tempSubTab addObject:sub[i]];
            }
            else if (sub)
            {
                substringRange = [sub[i] rangeOfString:text options:NSCaseInsensitiveSearch];
                
                if (substringRange.location != NSNotFound)
                {
                    [tempTab addObject:curString];
                    
                    if (pref)
                    [tempPrefTab addObject:pref[i]];
                    
                    if (sub)
                    [tempSubTab addObject:sub[i]];
                }
            }
            
            i++;
        }
        
        tab = tempTab;
        prefTab = tempPrefTab;
        subTab = tempSubTab;
    }
    
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tab.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:((sub) ? @"SubCell" : @"Cell") forIndexPath:indexPath];
    
    cell.textLabel.text = (pref) ? [NSString stringWithFormat:@"%@ %@", [prefTab objectAtIndex:indexPath.row], [tab objectAtIndex:indexPath.row]] : [tab objectAtIndex:indexPath.row];
    
    if (sub)
    cell.detailTextLabel.text = subTab[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myDelegate quickTextDidSelectString:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}

@end
