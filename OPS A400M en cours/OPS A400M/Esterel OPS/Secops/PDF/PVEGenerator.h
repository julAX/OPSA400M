//
//  PVEGenerator.h
//  OPS A400M
//
//  Created by richard david on 21/03/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NDHTMLtoPDF, Mission;

@protocol PVEDelegate <NSObject>

- (void)pvePdfDidFinishLoading:(NSString*)pdfPath;

@end

@interface PVEGenerator : NSObject <UIWebViewDelegate>

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;

@property id<PVEDelegate> delegate;

- (id)initWithMission:(Mission*)mission;

@end
