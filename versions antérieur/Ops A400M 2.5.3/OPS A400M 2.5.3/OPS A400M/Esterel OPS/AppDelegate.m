//
//  AppDelegate.m
//  Esterel-Alpha
//
//  Created by utilisateur on 10/12/13.
//
//

#import "AppDelegate.h"
#import "SplitViewController.h"
#import "Mission.h"
#import "Parameters.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Ajout X15
    _mcManager = [[MCManager alloc] init];
    
    if(![[NSUserDefaults standardUserDefaults] floatForKey:@"fuelDensity"])
        [[NSUserDefaults standardUserDefaults] setFloat:d forKey:@"fuelDensity"];
    

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (url != nil && [url isFileURL]) {
        [(SplitViewController*)self.window.rootViewController handleURL:url];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [(Mission*)((SplitViewController*)self.window.rootViewController).mission save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [(Mission*)((SplitViewController*)self.window.rootViewController).mission save];
}

@end
