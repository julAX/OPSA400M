//
//  CTSNumberTableViewCell.m
//  OPS A400M
//
//  Created by richard david on 26/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "CTSNumberTableViewCell.h"

/*
 COMMENTS X15
 
Classe de cellule (et non pas de tableview) indispensable pour connecter des outlets dans une tableView dynamic ! 

 Ici c'est juste pour pouvoir recuperer le numéro de logbook du crew tick shhet dans le CTSTableViewController.
 
 */

@implementation CTSNumberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)numberEntered:(id)sender {
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
