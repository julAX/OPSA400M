//
//  DerocCell.h
//  Esterel-Alpha
//
//  Created by utilisateur on 22/01/2014.
//
//

#import <UIKit/UIKit.h>

#import "MyTextField.h"

@interface DerogCell : UITableViewCell <MyTextFieldDelegate>

- (void)initWithDerog:(NSMutableDictionary*)dict;


@property (strong, nonatomic) IBOutlet MyTextField *nature;
@property (strong, nonatomic) IBOutlet MyTextField *commentaires;
@property (strong, nonatomic) IBOutlet MyTextField *numero;
@property (strong, nonatomic) IBOutlet MyTextField *ordonnateur;

@end
