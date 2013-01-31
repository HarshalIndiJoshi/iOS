//
//  AppLauncher.h
//  JuiceMaker
//
//  Created by Harshal Joshi on 1/15/13.
//  Copyright (c) 2013 Rapidera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLauncher : NSObject<UIAlertViewDelegate>
{
    NSString *url;
}
@property (nonatomic, strong) NSString *url;

@end
