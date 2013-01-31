//
//  Constants.h
//  JigsawPuzzle
//
//  Created by Harshal Joshi on 1/23/13.
//
//

#ifndef JigsawPuzzle_Constants_h
#define JigsawPuzzle_Constants_h

#define MY_BANNER_UNIT_ID @""
#define APP_VERSION 1
#define OS_VERSION 6

#define SHOW_MORE_APPS_URL @"http://www.dexati.com/moblink/ios/more.html?source=juicemaker"
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad   /* iPad*/
#define IPHONE   UIUserInterfaceIdiomPhone /* iPhone, to include iPod touch */

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#endif
