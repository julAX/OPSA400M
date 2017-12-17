//
//  ViewController.h
//  Tabelau_secops
//
//  Created by Arnaud Gallant on 19/02/2014.
//

#import <UIKit/UIKit.h>
//#import <MessageUI/MessageUI.h>

@class NDHTMLtoPDF, Mission;

@protocol OMADelegate <NSObject>

- (void)omaPdfDidFinishLoading:(NSString*)pdfPath;

@end

@interface OMAGenerator : NSObject <UIWebViewDelegate>


//, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;
//@property (nonatomic, weak) NSArray *crewMembers;

@property id<OMADelegate> delegate;

- (id)initWithMission:(Mission*)mission;

//- (IBAction)cancel:(id)sender;
//- (IBAction)printPDF:(id)sender;

@end
