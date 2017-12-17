//
//  CTSGenerator.m
//  OPS A400M
//
//  Created by David Louis & Camus Amaury on 26/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "CTSGenerator.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "OMAGenerator.h"
#import "NDHTMLtoPDF.h"

#import "Mission.h"
#import "TimeTools.h"
#import "AirportsData.h"


#define fPaperSizeA4 CGSizeMake(841.8, 595.2)

/*
 COMMENT X15 : ajout X15
 
 Se charge de generer les crew ticks sheet avec le même principe que l'oma (voir les cts.js, cts.html et cts.css)
 
 */


@interface CTSGenerator(){
    
    UIWebView *myWebView;
    NSMutableArray *crewMembers;
    Mission *mission;
    NSMutableArray *legs;
    
    
}
@end

@implementation CTSGenerator


-(id)initWithMission:(Mission*)m{
    self = [self init];
    
    mission = m;
    legs = mission.legs;
    crewMembers = [mission loadCrewMembers];
    
    myWebView = [[UIWebView alloc] init];
    myWebView.delegate = self;
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"CTS" withExtension:@"html"]]];
    
    
    return self;
    
}


- (void)printPDF
{
    NSString *html = [myWebView stringByEvaluatingJavaScriptFromString:
                      @"document.documentElement.innerHTML"];
    self.PDFCreator = [NDHTMLtoPDF createPDFWithHTML:html baseURL:[[NSBundle mainBundle] resourceURL] pathForPDF:[[[@"~/Documents/CTS_" stringByAppendingString: mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath] pageSize:fPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5) successBlock:^(NDHTMLtoPDF *htmlToPDF) {
        
        NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
        
        NSLog(@"%@",result);
        
        [self.delegate ctsPdfDidFinishLoading:htmlToPDF.PDFpath];
        
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
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDateFormatter* hf = [[NSDateFormatter alloc]init];
    [hf setDateFormat:@"HH:mm"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    hf.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    [[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:[NSString stringWithFormat:@"setLegNumber(%lu)",(unsigned long)mission.legs.count]];
    
    for (i=0; i<mission.legs.count;i++){
        NSString *callSign = [NSString stringWithFormat:@"'%@'", mission.legs.firstObject[@"CallSign"]], *aircraft = [NSString stringWithFormat:@"'%@'",mission.root[@"Aircraft"]], *cdb = [NSString stringWithFormat:@"'%@'", [mission cdbForLeg:0]], *date = [df stringFromDate: mission.legs[i][@"OffBlocksTime"]], *atd = [hf stringFromDate:mission.legs[i][@"OffBlocksTime"]];
        
        
        NSString *engine1 = [(((NSMutableArray*)mission.legs[i][@"Engine"][1])).description stringByReplacingOccurrencesOfString:@"(" withString:@"["];
        engine1 = [engine1 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
        NSString *engine2 = [(((NSMutableArray*)mission.legs[i][@"Engine"][2])).description stringByReplacingOccurrencesOfString:@"(" withString:@"["];
        engine2 = [engine2 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
        NSString *engine3 = [(((NSMutableArray*)mission.legs[i][@"Engine"][3])).description stringByReplacingOccurrencesOfString:@"(" withString:@"["];
        engine3 = [engine3 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
        NSString *engine4 = [(((NSMutableArray*)mission.legs[i][@"Engine"][4])).description stringByReplacingOccurrencesOfString:@"(" withString:@"["];
        engine4 = [engine4 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
        

        
        [[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:[NSString stringWithFormat:@"remplir(%@,%@,%@,'%@','%@',%@,%@,%@,%@,%@,%lu)", aircraft,cdb,callSign,date,atd,(![mission.legs[i][@"Engine"][0] isEqualToString:@""])?mission.legs[i][@"Engine"][0]:@"''",engine1,engine2,engine3,engine4, (long)i]];
    }
}






@end
