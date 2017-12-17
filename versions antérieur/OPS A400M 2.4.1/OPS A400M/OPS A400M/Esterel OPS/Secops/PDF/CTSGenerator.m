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
    NSInteger j;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDateFormatter* hf = [[NSDateFormatter alloc]init];
    [hf setDateFormat:@"HH:mm"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    hf.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSString * ctsNumber = @"[";
    
    for (i=0; i<mission.legs.count - 1 ;i++){
        ctsNumber = [ctsNumber stringByAppendingString:[NSString stringWithFormat:@"%lu,",(unsigned long)((NSArray*)mission.legs[i][@"CrewTickSheets"]).count]];
    }
    
    ctsNumber = [ctsNumber stringByAppendingString:[NSString stringWithFormat:@"%lu]",(unsigned long)((NSArray*)mission.legs[mission.legs.count - 1][@"CrewTickSheets"]).count]];
    
    NSLog(ctsNumber);
    
    [[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:[NSString stringWithFormat:@"setLegConfig(%@)",ctsNumber]];
    int compteur =0;
    for (i=0; i<mission.legs.count;i++){
        for(j=0; j<((NSArray*)mission.legs[i][@"CrewTickSheets"]).count;j++){
            NSString *callSign = @"", *aircraft = [NSString stringWithFormat:@"'%@'",mission.root[@"Aircraft"]], *cdb = [NSString stringWithFormat:@"'%@'", [mission cdbForLeg:0]], *date = [df stringFromDate: mission.legs[i][@"OffBlocksTime"]], *atd = [hf stringFromDate:mission.legs[i][@"OffBlocksTime"]];
            
            NSMutableArray *CTS = [(NSMutableArray*)mission.legs[i][@"CrewTickSheets"][j] mutableDeepCopy];
            
            NSRange range;
            range.location=11;
            range.length=5;
            
            for(int k = 1;k<CTS.count;k++){
                if([CTS[k][0][0] isEqualToString:@""] || [CTS[k][0][0] isEqualToString:@"0"]){
                    CTS[k][0][1]=@"";
                    CTS[k][0][0]=@"";
                }
                else{
                    CTS[k][0][1]= (((NSDate*)CTS[k][0][1]).description.length == 0)? @"" :  [((NSDate*)CTS[k][0][1]).description substringWithRange:range];
                }
                
                if([CTS[k][5][0] isEqualToString:@""] || [CTS[k][5][0] isEqualToString:@"0"]){
                    CTS[k][5][1]=@"";
                    CTS[k][5][0]=@"";
                }
                else{
                    CTS[k][5][1]=(((NSDate*)CTS[k][5][1]).description.length == 0)? @"" :  [((NSDate*)CTS[k][5][1]).description substringWithRange:range];
                }
                
                if([CTS[k][9] timeIntervalSinceReferenceDate]==0){
                    CTS[k][9]=@"";
                }
                else{
                    CTS[k][9]=(((NSDate*)CTS[k][9]).description.length == 0)? @"" :  [((NSDate*)CTS[k][9]).description substringWithRange:range];
                }
            }
            
            NSString *engine1 = [((NSArray*)CTS[1]).description stringByReplacingOccurrencesOfString:@"(" withString:@"["];
            engine1 = [engine1 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
            NSString *engine2 = [((NSArray*)CTS[2]).description stringByReplacingOccurrencesOfString:@"(" withString:@"["];
            engine2 = [engine2 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
            NSString *engine3 = [((NSArray*)CTS[3]).description stringByReplacingOccurrencesOfString:@"(" withString:@"["];
            engine3 = [engine3 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
            NSString *engine4 = [((NSArray*)CTS[4]).description stringByReplacingOccurrencesOfString:@"(" withString:@"["];
            engine4 = [engine4 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
            

            [[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] evaluateScript:[NSString stringWithFormat:@"remplir(%@,%@,'%@','%@','%@','%@',%@,%@,%@,%@,%d)", aircraft,cdb,callSign,date,atd,@" ",engine1,engine2,engine3,engine4, (int)compteur]];
            compteur++;
        }
    }
}






@end
