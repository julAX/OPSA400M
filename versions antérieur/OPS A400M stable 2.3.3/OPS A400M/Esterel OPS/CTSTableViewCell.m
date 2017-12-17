//
//  CTSTableViewCell.m
//  OPS A400M
//
//  Created by richard david on 26/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "CTSTableViewCell.h"

/*
 COMMENTS X15
 
 Classe de cellule (et non pas de tableview) indispensable pour connecter des outlets dans une tableView dynamic !
 
 c'est la cellule type qu'on voit dans le CTSTableViewController. Tous les outlets et actions sont les même, on fait la difference de numéro de ligne dans le CTSTableViewController.
 
 */

@implementation CTSTableViewCell

@synthesize engine1,engine2,engine3,engine4,plus1,plus2,plus3,plus4;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)plus1:(UIStepper *)sender {
    switch ([sender tag]) {
        case 1:
            [self.engine1 setText: ([@(sender.value).description isEqualToString:@"0"])?@"":@(sender.value).description];
            break;
        case 2:
            [self.engine2 setText: ([@(sender.value).description isEqualToString:@"0"])?@"":@(sender.value).description];
            break;
        case 3:
            [self.engine3 setText: ([@(sender.value).description isEqualToString:@"0"])?@"":@(sender.value).description];
            break;
        case 4:
            [self.engine4 setText: ([@(sender.value).description isEqualToString:@"0"])?@"":@(sender.value).description];
            break;
        default:
            break;
    }
}
@end
