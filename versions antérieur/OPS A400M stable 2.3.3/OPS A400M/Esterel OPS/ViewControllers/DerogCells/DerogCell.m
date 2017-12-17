//
//  DerocCell.m
//  Esterel-Alpha
//
//  Created by utilisateur on 22/01/2014.
//
//

#import "DerogCell.h"

@interface DerogCell ()
{
    NSMutableDictionary *derog;
}

@end


@implementation DerogCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nature.myDelegate = self;
    self.commentaires.myDelegate = self;
    self.numero.myDelegate = self;
    self.ordonnateur.myDelegate = self;
    
    NSLayoutConstraint *constrain = [NSLayoutConstraint constraintWithItem:self.nature
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:0
                                                                    toItem:self.commentaires
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:.5
                                                                  constant:0];
    [self.contentView addConstraint:constrain];
    
}

- (void)initWithDerog:(NSMutableDictionary *)dict
{
    derog = dict;
    
    self.nature.text = derog[@"Nature"];
    self.commentaires.text = derog[@"Commentaires"];
    self.numero.text = derog[@"Numero"];
    self.ordonnateur.text = derog[@"Ordonnateur"];
}


# pragma mark - MyTextField delegate

-(void)myTextFieldDidEndEditing:(UITextField *)textField
{
    NSString *key = @"";
    
    switch (textField.tag) {
        case 501: key = @"Nature";
            break;
        case 502: key = @"Commentaires";
            break;
        case 503: key = @"Numéro";
            break;
        case 504: key = @"Ordonnateur";
            break;
    }
    
    derog[key] = textField.text;
}


@end
