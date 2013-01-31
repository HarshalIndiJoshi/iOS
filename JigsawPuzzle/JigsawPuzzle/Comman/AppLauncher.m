//
//  AppLauncher.m
//  JuiceMaker
//
//  Created by Harshal Joshi on 1/15/13.
//  Copyright (c) 2013 Rapidera. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kURL [NSURL URLWithString: @"http://iosapps.dexati.com/adserver/api/1/adservice/ios/startup?appname=&appversion=&osversion=&devid="] //2 http://api.kivaws.org/v1/loans/search.json?status=fundraising


#import "AppLauncher.h"
#import "UIDevice+IdentifierAddition.h"

@implementation AppLauncher

@synthesize url;

-(id)init
{
    //... to launch app store to view the application ...//
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
    
    dispatch_async(kBgQueue, ^{
        NSString *tempURL  = [kURL absoluteString];
        NSArray *chunks = [tempURL componentsSeparatedByString: @"&"];
        
        NSString *urlInParts = [chunks objectAtIndex:0];
        urlInParts = [urlInParts stringByAppendingFormat:@"%@&",prodName];
        
        urlInParts = [urlInParts stringByAppendingFormat:@"%@",[chunks objectAtIndex:1]];
        urlInParts = [urlInParts stringByAppendingFormat:@"%d&",APP_VERSION];//,
        
        urlInParts = [urlInParts stringByAppendingFormat:@"%@",[chunks objectAtIndex:2]];
        urlInParts = [urlInParts stringByAppendingString:[NSString stringWithFormat:@"%d&",OS_VERSION]];
        
        urlInParts = [urlInParts stringByAppendingFormat:@"%@",[chunks objectAtIndex:3]];
        urlInParts = [urlInParts stringByAppendingString:[NSString stringWithFormat:@"%@",[[UIDevice currentDevice] uniqueDeviceIdentifier]]];
        
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempURL]];
        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    return self;
}

#pragma mark -
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:kNilOptions
                                                           error:&error];
    NSString* title = [json objectForKey:@"title"]; //2
    
    NSString* desc = [json objectForKey:@"description"]; //2
    
    self.url = [json objectForKey:@"url"]; //2
    
    self.url = [self.url stringByReplacingOccurrencesOfString:@"itms" withString:@"itms-apps"];
    
    if (title && desc && self.url)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",title] message:[NSString stringWithFormat:@"%@",desc] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
    
}

#pragma mark - UIalerviewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
    }
}
@end
