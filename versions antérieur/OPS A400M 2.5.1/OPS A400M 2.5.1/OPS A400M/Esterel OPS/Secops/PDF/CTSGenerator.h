//
//  CTSGenerator.h
//  OPS A400M
//
//  Created by richard david on 26/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NDHTMLtoPDF, Mission;

@protocol CTSDelegate <NSObject>

- (void)ctsPdfDidFinishLoading:(NSString*)pdfPath;

@end

@interface CTSGenerator : NSObject <UIWebViewDelegate>

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;

@property id<CTSDelegate> delegate;

- (id)initWithMission:(Mission*)mission;


@end
