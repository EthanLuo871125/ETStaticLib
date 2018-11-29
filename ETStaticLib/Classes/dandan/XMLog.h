//
//  XMLog.h
//  XMAudioUnit
//
//  Created by Ethan on 2018/7/24.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XMLog(format, ...) [XMALog debugLog:format, ## __VA_ARGS__]

@interface XMALog : NSObject
+ (void)openLog;
+ (void)closeLog;
+ (void)debugLog:(NSString *)format, ...;
@end
