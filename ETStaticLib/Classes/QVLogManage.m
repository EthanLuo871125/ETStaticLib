//
//  UMLogManage.m
//  HKSUMEyeCloudLIb
//
//  Created by apple on 16/8/6.
//
//

#import "QVLogManage.h"


static QVLogManage *_share;

@interface QVLogManage(){

}
@property(nonatomic, strong) NSFileHandle *logFileHandle;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@end
@implementation QVLogManage

+ (QVLogManage *)share{
    if (!_share) {
        _share = [[QVLogManage alloc] init];
        _share.enable = NO;
        _share.devEnable = getLogEnableState();
    }
    return _share;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _logFileHandle = nil;
        [self setupLogFileHandle];
    }
    return self;
}

static BOOL getLogEnableState() {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSNumber *enable = [userDefault objectForKey:@"QVSDK_LOG"];
    if (enable) {
        NSLog(@"QV LOG 日志开启 = %d", enable.boolValue);
        return enable.boolValue;
    }
    else {
        NSLog(@"QV LOG 日志开启 = %d", NO);
        return NO;
    }
}

- (void)log:(NSString *)format, ...{
    if (_enable) {
        va_list ap;
        va_start (ap, format);
        
        NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
        
        va_end (ap);
        NSLog(@"[QUVII]%@",body);
        
        NSString *tempWrite = [NSString stringWithFormat:@"%@ [QUVII]%@\n",[_dateFormatter stringFromDate:[NSDate date]],body];
        [self.logFileHandle seekToEndOfFile];
        [self.logFileHandle writeData:[tempWrite dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void)logDev:(NSString *)format, ...{
    if (_devEnable) {
        va_list ap;
        va_start (ap, format);
        
        NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
        
        va_end (ap);
        NSLog(@"[QUVII]%@",body);
        
        NSString *tempWrite = [NSString stringWithFormat:@"[QUVII]%@\n",body];
        [self.logFileHandle seekToEndOfFile];
        [self.logFileHandle writeData:[tempWrite dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void)setupLogFileHandle{
    if (self.logFileHandle) {
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"QvLog"];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss-SSS"];
    NSString *currentDate = [_dateFormatter stringFromDate:[NSDate date]];
    
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"QUVII%@.log",currentDate]];
    [self createDirectoryAtPath:logFilePath];
    self.logFileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
}


- (void)createDirectoryAtPath:(NSString *)aFilePath{
    if (aFilePath && ![[NSFileManager defaultManager] fileExistsAtPath:aFilePath]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:[aFilePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] createFileAtPath:aFilePath contents:[NSData dataWithBytes:"" length:0] attributes:nil];
    }
}

- (void)dealloc{
    if (_logFileHandle) {
        [_logFileHandle closeFile];
    }
}
@end
