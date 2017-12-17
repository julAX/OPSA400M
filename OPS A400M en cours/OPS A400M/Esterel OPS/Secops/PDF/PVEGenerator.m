//
//  PVEGenerator.m
//  OPS A400M
//
//  Created by richard david on 21/03/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "PVEGenerator.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "OMAGenerator.h"
#import "NDHTMLtoPDF.h"
#import "TimeTools.h"
#import "Mission.h"
#import "TimeTools.h"
#import "AirportsData.h"

#define fPaperSizeA4 CGSizeMake(841.8, 595.2)
#define fPaperSizeA4portrait CGSizeMake( 595.2, 841.8)


@interface PVEGenerator(){
    
    UIWebView *myWebView;
    
    Mission *mission;
    NSMutableArray *legs;
    
    
}
@end


@implementation PVEGenerator

-(id)initWithMission:(Mission*)m{
    self = [self init];
    
    mission = m;
    legs = mission.legs;
    
    
    myWebView = [[UIWebView alloc] init];
    myWebView.delegate = self;
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"PVE" withExtension:@"html"]]];
    
    
    return self;
    
}

- (void)printPDF
{
    NSString *html = [myWebView stringByEvaluatingJavaScriptFromString:
                      @"document.documentElement.innerHTML"];
    self.PDFCreator = [NDHTMLtoPDF createPDFWithHTML:html baseURL:[[NSBundle mainBundle] resourceURL] pathForPDF:[[[@"~/Documents/PVE_" stringByAppendingString: mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath] pageSize:fPaperSizeA4portrait margins:UIEdgeInsetsMake(10, 5, 10, 5) successBlock:^(NDHTMLtoPDF *htmlToPDF) {
        
        NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
        
        NSLog(@"%@",result);
        
        [self.delegate pvePdfDidFinishLoading:htmlToPDF.PDFpath];
        
    } errorBlock:^(NDHTMLtoPDF *htmlToPDF) {
        NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
        NSLog(@"%@",result);
    }];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadWithData:webView];
    [self printPDF];
}


-(void)loadWithData:(UIWebView*)webView{
    NSInteger i;
    NSInteger j;
    NSString *arrayMes = [[NSString alloc] init];
    NSString *arrayRep = [[NSString alloc] init];

    
    [[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:[NSString stringWithFormat:@"setCaption('%@','%@','%@','%@','%@','%@');", mission.root[@"MissionNumber"],[mission cdbForLeg:0], [TimeTools stringFromDate:mission.legs.firstObject[@"OffBlocksTime"]], mission.legs.firstObject[@"CallSign"], [mission route], mission.root[@"Reseau"]]];
    
    for(i = 0; i < legs.count; i++)
    {
        [[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:[NSString stringWithFormat:@"addLeg();"]];
        
        
        [[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:[NSString stringWithFormat:@"addMessages(%lu);", (unsigned long)((NSArray*)legs[i][@"Message"]).count]];
    }
    
    arrayMes = @"[";
    for(i = 0; i< legs.count; i++)
    {
        for(j = 0; j<((NSArray*)legs[i][@"Message"]).count; j++)
        {
            arrayMes = [arrayMes stringByAppendingFormat:@"'%@'", [[legs[i][@"Message"][j][@"contenu"] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]];
            if(j < ((NSArray*)legs[i][@"Message"]).count - 1 || i < legs.count -1)
                arrayMes = [arrayMes stringByAppendingString:@","];
        }
        
    }
    arrayMes = [arrayMes stringByAppendingString:@"]"];
    
    arrayRep = @"[";
    for(i = 0; i< legs.count; i++)
    {
        for(j = 0; j<((NSArray*)legs[i][@"Message"]).count; j++)
        {
            arrayRep = [arrayRep stringByAppendingFormat:@"'%@'", [[legs[i][@"Message"][j][@"reponse"] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]];

            if(j < ((NSArray*)legs[i][@"Message"]).count - 1 || i < legs.count -1)
                arrayRep = [arrayRep stringByAppendingString:@","];
        }
    }
    arrayRep = [arrayRep stringByAppendingString:@"]"];
    
    NSString* query = [[NSString alloc]initWithFormat:@"fillMessages(%@,%@);", arrayMes, arrayRep];
    NSLog(@"%@",query);
    [[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:query];
    //[[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:@"fillMessages(['(null)','','','','','','test \r chier',''],['(null)','','','','','','blop','']);"];
    
}


@end
