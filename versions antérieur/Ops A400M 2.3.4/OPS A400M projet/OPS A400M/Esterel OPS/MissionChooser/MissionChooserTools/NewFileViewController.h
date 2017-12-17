//
//  NewFileViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 29/01/2014.
//
//

#import <UIKit/UIKit.h>

@protocol NewFileDelegate <NSObject>

- (void)newFileViewDidCancel;
- (void)newFileViewDidValidate:(NSString*)name;

@end


@interface NewFileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *fileName;
@property id<NewFileDelegate> delegate;

@end
