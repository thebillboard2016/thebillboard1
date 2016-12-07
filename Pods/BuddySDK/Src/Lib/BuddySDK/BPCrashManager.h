#import <Foundation/Foundation.h>
#import "BPRestProvider.h"
#import "Buddy.h"

@interface BPCrashManager : NSObject

- (instancetype)initWithRestProvider:(id<BPRestProvider>)restProvider;
- (void)startReporting:(NSString *)appId;

@end
