#import "Buddy.h"
#import "Buddy+Private.h"
#import "BPClient.h"

@implementation Buddy

static NSMutableDictionary *clients;

static BPClient* currentClient;

+(id<BuddyClientProtocol>)currentClient{
    return currentClient;
}

+(BPClient*) currentClientObject
{
    return currentClient;
}

+ (BPUser *)user
{
    return [[self currentClientObject] currentUser];
}

+ (void) setUser:(BPUser *)user
{
    [[self currentClientObject] setCurrentUser:user];
}

+ (BPCoordinate *)lastLocation
{
    return [[self currentClientObject] lastLocation];
}

+ (void) setLastLocation:(BPCoordinate *)lastLocation
{
    [[self currentClientObject] setLastLocation:lastLocation];
}

+(void)initialize{
    clients = [[NSMutableDictionary alloc] init];
}

+ (void)setClientDelegate:(id<BPClientDelegate>)delegate
{
    currentClient.delegate = delegate;
}

+ (id<BuddyClientProtocol>)init:(NSString *)appID
            appKey:(NSString *)appKey
{
    return [self init:appID appKey:appKey autoRecordDeviceInfo:NO
               instanceName:nil];
}


+ (id<BuddyClientProtocol>)init:(NSString *)appID
                  appKey:(NSString *)appKey
    autoRecordDeviceInfo:(BOOL)autoRecordDeviceInfo
            instanceName:(NSString *)instanceName
{
    NSMutableDictionary *defaultOptions = [@{@"autoRecordDeviceInfo": @(autoRecordDeviceInfo)} mutableCopy];
    
    if(instanceName != nil)
    {
        [defaultOptions setObject:instanceName forKey:@"instanceName"];
    }
    return [self init:appID
                      appKey:appKey
                 withOptions:defaultOptions];
}

+ (id<BuddyClientProtocol>) init:(NSString *)appID
            appKey:(NSString *)appKey
            withOptions:(NSDictionary *)options
{
    NSString *clientKey = [NSString stringWithFormat:@"%@%@", appID, options[@"instanceName"]];
    
    
    if ([clients objectForKey:clientKey]) {
        currentClient = [clients objectForKey:clientKey];
        return currentClient;
    } else {
        BPClient* client = [[BPClient alloc] init];
        [client setupWithApp:appID appKey:appKey options:options delegate:nil];
        
        [clients setValue:client forKey:clientKey];
        currentClient = client;
        
        return client;
    }
}

#pragma mark User


+ (void)createUser:(NSString*) userName
          password:(NSString*) password
         firstName:(NSString*) firstName
          lastName:(NSString*) lastName
             email:(NSString*) email
       dateOfBirth:(NSDate*) dateOfBirth
            gender:(NSString*) gender
               tag:(NSString*) tag
          callback:(BuddyObjectCallback)callback
{
    [currentClient createUser:userName
                               password:password
                              firstName:firstName
                               lastName:lastName
                                  email:email
                            dateOfBirth:dateOfBirth
                                 gender:gender
                                    tag:tag
                               callback:callback];
}


+ (void)loginUser:(NSString *)username password:(NSString *)password callback:(BuddyObjectCallback)callback
{
    [currentClient loginUser:username password:password callback:callback];
}


+ (void)socialLogin:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback;
{
    [currentClient socialLogin:provider providerId:providerId token:token success:callback];
}

+ (void)logoutUser:(BuddyCompletionCallback)callback
{
    [currentClient logoutUser:callback];
}

+ (void)recordNotificationReceived:(UIApplication *)application withDictionary:(NSDictionary *)userInfo{
    if(UIApplicationStateActive != application.applicationState
       && [userInfo valueForKey:@"_bId"] != nil){
        NSString* path = [NSString stringWithFormat:@"/notifications/received/%@",
                          [userInfo valueForKey:@"_bId"]];
        [currentClient POST:path parameters:nil class:[NSDictionary class] callback:^(id object, NSError* error){
            NSLog(@"notification activate recorded");
        }];
    }
}

+(void) recordNotificationReceived:(UIApplication *)application withNotification:(UILocalNotification *)notification {
    if(UIApplicationStateActive != application.applicationState
       && [notification.userInfo valueForKey:@"_bId"]){
        NSString* path = [NSString stringWithFormat:@"/notifications/received/%@",
                          [notification.userInfo valueForKey:@"_bId"]];
        [currentClient POST:path parameters:nil class:[NSDictionary class]  callback:^(id object, NSError* error){
            NSLog(@"notification activate recorded");
        }];
    }
    
}


+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value callback:(BuddyCompletionCallback)callback
{
    [currentClient recordMetric:key andValue:value callback:callback];
}

+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds callback:(BuddyMetricCallback)callback
{
    [currentClient recordMetric:key andValue:value timeout:seconds callback:callback];
}

+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds timestamp:(NSDate*)timestamp callback:(BuddyMetricCallback)callback
{
    [currentClient recordMetric:key andValue:value timeout:seconds timestamp:timestamp callback:callback];
}

#pragma mark - REST

+ (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [currentClient GET:servicePath parameters:parameters class:clazz callback:callback];
}

+ (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [currentClient POST:servicePath parameters:parameters class:clazz callback:callback];
}

+ (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [currentClient PATCH:servicePath parameters:parameters class:clazz callback:callback];
}

+ (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [currentClient PUT:servicePath parameters:parameters class:clazz callback:callback];
}

+ (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [currentClient DELETE:servicePath parameters:parameters class:clazz callback:callback];
}


@end
