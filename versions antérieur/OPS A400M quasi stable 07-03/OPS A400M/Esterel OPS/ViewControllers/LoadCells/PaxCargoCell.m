//
//  PaxCargoCell.m
//  Esterel-Alpha
//
//  Created by utilisateur on 15/01/2014.
//
//

#import "PaxCargoCell.h"

#import "NumberTextField.h"

/*
 COMMENTS X15
 
 Classe de cellule (et non pas de tableview) indispensable pour connecter des outlets dans une tableView dynamic !
 
 c'est la cellule type qu'on voit dans le loadViewcontroller. On gère l'affichage qui s'y fait dynamiquement.
 
 */

@interface PaxCargoCell ()
{
    NSString *pref;
    NSMutableDictionary *paxCargo;
    
}
@end

@implementation PaxCargoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSArray *views = @[_originTextField, _inTextField, _alreadyOnBoardLabel, _totalLabel, _droppedTextField, _outTextField];
    
    for (UIView *view in views) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1./views.count constant:0.]];
    }
    
    self.originTextField.myDelegate = self;
    self.inTextField.myDelegate = self;
    self.outTextField.myDelegate = self;
    self.droppedTextField.myDelegate = self;
}

- (void)resetCell
{
    paxCargo = nil;
    pref = @"";
    
    self.originTextField.enabled = false;
    self.inTextField.enabled = false;
    self.outTextField.enabled = false;
    self.droppedTextField.enabled = false;
    
    UIColor *textFieldColor = [UIColor darkTextColor];
    
    [self.originTextField setTextColor:textFieldColor];
    [self.inTextField setTextColor:textFieldColor];
    [self.outTextField setTextColor:textFieldColor];
    [self.droppedTextField setTextColor:textFieldColor];
    self.originTextField.text = @"From";
    self.inTextField.text = @"In";
    self.alreadyOnBoardLabel.text = @"Already On Board";
    self.totalLabel.text = @"Total On Board";
    self.outTextField.text = @"Out";
    self.droppedTextField.text = @"Dropped";
}


- (void) initWithPaxCargo:(NSMutableDictionary*)dict pax:(bool)pax editable:(bool)editable
{
    pref = (pax) ? @"Pax" : @"Cargo";
    paxCargo = dict;
    
    //Modif X2015 : on enlève editable qu'on remplace par false pour que ce soit seulement de l'affichage
    
    self.originTextField.enabled = false; /* a la place de editable (idem en dessous) */
    self.inTextField.enabled = false;
    self.outTextField.enabled = false;
    self.droppedTextField.enabled = false;
    
    UIColor *textFieldColor = (false /* a la place de editable*/) ? [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] : [UIColor darkTextColor];
    
    [self.originTextField setTextColor:textFieldColor];
    [self.inTextField setTextColor:textFieldColor];
    [self.outTextField setTextColor:textFieldColor];
    [self.droppedTextField setTextColor:textFieldColor];
    
    [self reloadLabels];
}

-(void)myTextFieldDidEndEditing:(UITextField *)textField
{
    NSString *key = @"";
    
    switch (textField.tag) {
        case 201 : if (![textField.text isEqualToString:paxCargo[@"Name"]])
            [self.delegate paxCargoCell:self NameDidChange:textField.text];
            
            key = @"Name";
            break;
        case 202: key = [pref stringByAppendingString:@"In"];
            break;
        case 205: key = [pref stringByAppendingString:@"Dropped"];
            break;
        case 206: key = [pref stringByAppendingString:@"Out"];
            break;
    }
    
    paxCargo[key] = textField.text;
    
    [self.delegate paxCargoCellDidChange:self];
}


- (void)reloadLabels
{
    self.originTextField.text = paxCargo[@"Name"];
    self.inTextField.text = paxCargo[[pref stringByAppendingString:@"In"]];
    self.outTextField.text = paxCargo[[pref stringByAppendingString:@"Out"]];
    self.droppedTextField.text = paxCargo [[pref stringByAppendingString:@"Dropped"]];
    
    NSString *onBoard = paxCargo[[pref stringByAppendingString:@"OnBoard"]];
    
    self.alreadyOnBoardLabel.text = onBoard;
    self.totalLabel.text = @(onBoard.integerValue + self.inTextField.text.integerValue).description;
}

@end
