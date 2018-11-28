///#begin zh-cn
/**
 *  @brief  Log模块
 *  @since  v2.4.10.1
 */
///#end
///#begin en
///#end

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define QV_FREE_SAFELY(__POINTER) { if(__POINTER) { free(__POINTER); __POINTER = NULL; } }

#define QV_VERSION_DEPRECATED(_info) __attribute__((deprecated(_info)))

@interface QVLogManage : NSObject
//是否启动，缺省:NO
@property(nonatomic, assign) BOOL enable;
@property(nonatomic, assign) BOOL devEnable;

//获取句柄
+ (QVLogManage *)share;

//打印Log
- (void)log:(NSString *)format, ...;

- (void)logDev:(NSString *)format, ...;

@end
