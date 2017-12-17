//
//  LegsSelectionView.m
//  Esterel OPS
//
//  Created by utilisateur on 01/04/2014.
//  Copyright (c) 2014 Esterel. All rights reserved.
//

#import "LegsSelectionView.h"

#import "Mission.h"


/*COMMENTS X15 
 Ca ca servait dans la vue Sicops qu'on a décidé d'enlever. Voir le storyboard. Ca rajoutais un complement d'équipage dans les legs sélectionnée 
 
 */


@interface LegsSelectionView()

@property (weak, nonatomic) NSArray *legs;

@end


@implementation LegsSelectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.allowsMultipleSelection = YES;
}


- (void)setMission:(Mission *)mission
{
    _mission = mission;
    _legs = mission.legs;
    
    _selectedLegs = [NSMutableDictionary dictionaryWithCapacity:_legs.count];
    
    [self reloadData];
}



# pragma mark - CollectionView delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *leg = _legs[indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:239./255. green:239./255. blue:244./255. alpha:1.];
    
    if (!cell.selectedBackgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:cell.frame];
        view.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.25];
        
        cell.selectedBackgroundView = view;
    }
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    
    label.text = [NSString stringWithFormat:@"Leg %ld\n%@ - %@", (long)(indexPath.row + 1), leg[@"DepartureAirport"], leg[@"ArrivalAirport"]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _legs.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedLegs[@(indexPath.row).description] = _legs[indexPath.row];
    
    [self.selectionDelegate selectionDidChange:_selectedLegs];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_selectedLegs removeObjectForKey:@(indexPath.row).description];
    
    [self.selectionDelegate selectionDidChange:_selectedLegs];
}


@end
