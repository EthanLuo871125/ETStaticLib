//
//  XMLog.m
//  XMAudioUnit
//
//  Created by Ethan on 2018/7/24.
//  Copyright © 2018年 Ethan. All rights reserved.
//

#import "XMLog.h"

@implementation XMALog
static BOOL logEnbale = NO;
+ (void)openLog {
    logEnbale = YES;
}
+ (void)closeLog {
    logEnbale = NO;
}
+ (void)debugLog:(NSString *)format, ...{
    if (logEnbale) {
        va_list ap;
        va_start (ap, format);
        NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
        
        va_end (ap);
        NSLog(@"[->XM_AUDIO]<-]%@",body);
    } 
}
@end
