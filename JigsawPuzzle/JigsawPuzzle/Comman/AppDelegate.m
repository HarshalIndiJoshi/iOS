//
//  AppDelegate.m
//  JigsawPuzzle
//
//  Created by Raviraj Indi on 17/01/13.
//
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs objectForKey:@"PuzzlePicture"] == nil) {
        [prefs setBool:FALSE forKey:@"Refresh"];
        if (IDIOM == IPAD) {
            [prefs setInteger:100 forKey:@"PuzzlePicture"];
        }
        else
            [prefs setInteger:0 forKey:@"PuzzlePicture"];
        [prefs setInteger:33 forKey:@"Level"];
        [prefs setBool:TRUE forKey:@"ShowGrid"];
        [prefs setBool:FALSE forKey:@"AutoMove"];
        [prefs setBool:FALSE forKey:@"ShowHoles"];
        [prefs setBool:TRUE forKey:@"Vibrate"];
        [prefs setBool:TRUE forKey:@"SoundOn"];
        [prefs synchronize];
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
}

@end
