//
//  RenameViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 28/01/2014.
//
//

#import <UIKit/UIKit.h>

@protocol RenameViewControllerDelegate <NSObject>

- (void)renameViewDidCancel;
- (void)renameViewDidValidate:(NSString*)filename erase:(bool)erase;

@end


@interface RenameViewController : UIViewController <UITextFieldDelegate>

@property NSString *initialText;
@property id<RenameViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *fileName;
@property (strong, nonatomic) IBOutlet UISwitch *keepPrevious;
- (IBAction)cancel:(id)sender;
- (IBAction)okButton:(id)sender;

@end
