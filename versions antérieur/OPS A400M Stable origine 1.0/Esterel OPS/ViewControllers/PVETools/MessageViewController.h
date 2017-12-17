//
//  MessageViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 31/01/2014.
//
//

#import <UIKit/UIKit.h>

#import "MyTextField.h"

@class TimeTextField;

@interface MessageViewController : UITableViewController <MyTextFieldDelegate, UITextViewDelegate, UITextFieldDelegate>

- (IBAction)typeChange:(UISegmentedControl*)sender;
- (IBAction)copyInfos:(id)sender;
- (IBAction)copyDest:(id)sender;
- (IBAction)transmisChange:(UISegmentedControl*)sender;

@property (weak, nonatomic) NSMutableDictionary *message;
@property NSInteger messageNumber;

@property (strong, nonatomic) IBOutlet UIButton *destButton;
@property (strong, nonatomic) IBOutlet UIButton *copButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *typeMessage;
@property (strong, nonatomic) IBOutlet UISegmentedControl *chargementStandard;
@property (strong, nonatomic) IBOutlet MyTextField *frequence;
@property (strong, nonatomic) IBOutlet MyTextField *indicatifE;
@property (strong, nonatomic) IBOutlet MyTextField *indicatifR;
@property (strong, nonatomic) IBOutlet MyTextField *priorite;
@property (strong, nonatomic) IBOutlet TimeTextField *heure;
@property (strong, nonatomic) IBOutlet MyTextField *destinataires;
@property (strong, nonatomic) IBOutlet TimeTextField *heureEstAtr;
@property (strong, nonatomic) IBOutlet MyTextField *nbPalettes;
@property (strong, nonatomic) IBOutlet MyTextField *chargePal;
@property (strong, nonatomic) IBOutlet MyTextField *roulant;
@property (strong, nonatomic) IBOutlet MyTextField *vrac;


@property (strong, nonatomic) IBOutlet MyTextField *longitude;
@property (strong, nonatomic) IBOutlet MyTextField *latitude;
@property (strong, nonatomic) IBOutlet MyTextField *nouvLong;
@property (strong, nonatomic) IBOutlet MyTextField *nouvLat;
@property (strong, nonatomic) IBOutlet TimeTextField *arrEst;
@property (strong, nonatomic) IBOutlet TimeTextField *qrx;
@property (strong, nonatomic) IBOutlet MyTextField *infos;
@property (strong, nonatomic) IBOutlet UISegmentedControl *transmis;

@property (strong, nonatomic) IBOutlet UILabel *nouvPosLabel;

@end
