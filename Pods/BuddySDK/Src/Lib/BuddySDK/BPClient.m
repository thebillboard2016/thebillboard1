#import "BPClient.h"
#import "BPServiceController.h"
#import "BPRestProvider.h"
#import "BuddyDevice.h"
#import "BPAppSettings.h"
#import "BPCrashManager.h"
#import "NSDate+JSON.h"
#import "BPAFURLRequestSerialization.h"
#import "CryptoTools.h"
#import "BPUser.h"
#import "BPFile.h"
#import "JAGPropertyConverter+BPJSONConverter.h"
#import "NSError+BuddyError.h"

#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>

#define BuddyServiceURL @"BuddyServiceURL"
#define BuddyDefaultURL @"https://api.buddyplatform.com"

#define HiddenArgumentCount 2

@interface BPClient()<BPRestProvider>

@property (nonatomic, strong) BPServiceController *service;
@property (nonatomic, strong) BPAppSettings *appSettings;
@property (nonatomic, strong) NSString *sharedSecret;
@property (nonatomic, strong) BPCrashManager *crashManager;
@property (nonatomic, strong) NSMutableArray *queuedRequests;

- (void)recordMetricCore:(NSString*)key parameters:(NSDictionary*)parameters callback:(BuddyMetricCallback)callback;
- (REST_ServiceResponse) handleResponse:(Class) clazz callback:(RESTCallback)callback;
-(NSString*) generateServerSig;

@end

@implementation BPClient

@synthesize currentUser = _currentUser;
@synthesize connectivityLevel = _connectivityLevel;
@synthesize lastLocation = _lastLocation;

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _lastLocation = nil;
    }
    return self;
}

- (BPUser *)currentUser
{
    if(!_currentUser)
    {
        [self raiseNeedsLoginError];
    }
    return _currentUser;
}

-(void) setCurrentUser:(BPUser *)currentUser
{
    _currentUser = currentUser;
}

- (void)resetOnLogout
{
    [self.appSettings clearUser];
    self.currentUser=nil;
}

-(void)setupWithApp:(NSString *)appID
             appKey:(NSString *)appKey
            options:(NSDictionary *)options
           delegate:(id<BPClientDelegate>) delegate
{
    
#if DEBUG
    NSString *serviceUrl = [[NSBundle bundleForClass:[self class]] infoDictionary][BuddyServiceURL];
#else
    NSString *serviceUrl = [[NSBundle mainBundle] infoDictionary][BuddyServiceURL];
#endif

    serviceUrl = serviceUrl ? : BuddyDefaultURL;
    
    if (options[@"instanceName"]) {
        _appSettings = [[BPAppSettings alloc] initWithAppId:appID andKey:appKey initialURL:serviceUrl prefix:options[@"instanceName"]];
    } else {
        _appSettings = [[BPAppSettings alloc] initWithAppId:appID andKey:appKey initialURL:serviceUrl];
    }
    
    _sharedSecret = options[@"sharedSecret"];
    
    _service = [[BPServiceController alloc] initWithAppSettings:_appSettings andSecret:_sharedSecret];
    
    _appSettings.appKey = appKey;
    _appSettings.appID = appID;
    
    _appSettings.deviceTag = options[@"deviceTag"];
    _appSettings.deviceUniqueId = options[@"deviceUniqueId"];
    
    _crashManager = [[BPCrashManager alloc] initWithRestProvider:self];
    
    _connectivityLevel = [_service getConnectivityLevel];
    
    // Check for OS update, and report.
    [self updateOSVersion];
}

- (void)createUser:(NSString*) userName
          password:(NSString*) password
         firstName:(NSString*) firstName
          lastName:(NSString*) lastName
             email:(NSString*) email
       dateOfBirth:(NSDate*) dateOfBirth
            gender:(NSString*) gender
               tag:(NSString*) tag
          callback:(BuddyObjectCallback)callback;
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if(userName)
    {
        params[@"username"] = userName;
    }
    
    if(password)
    {
        params[@"password"] = password;
    }
    
    if(firstName)
    {
        params[@"firstname"] = firstName;
    }
    
    if(lastName)
    {
        params[@"lastname"] = lastName;
    }
    
    if(email)
    {
        params[@"email"]= email;
    }
    
    if(dateOfBirth)
    {
        params[@"dateofbirth"]=dateOfBirth;
    }
    
    if(gender)
    {
        params[@"gender"]=gender;
    }
    
    if(tag)
    {
        params[@"tag"] = tag;
    }
    
    [self POST:@"/users" parameters:params class:[NSDictionary class] callback:^(id obj, NSError *error) {
        if(error)
        {
            callback ? callback(nil,error) : nil;
            return;
        }
        
        self.currentUser = [BPUser new];
        [[JAGPropertyConverter bp_converter] setPropertiesOf:self.currentUser fromDictionary:obj];
        self.appSettings.userToken = [obj objectForKey:@"accessToken"];
        callback ? callback(self.currentUser,nil) : nil;
    }];
}

#pragma mark - Login

-(void)loginWorker:(NSString *)username password:(NSString *)password success:(BuddyObjectCallback) callback
{
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password};
    [self POST:@"users/login" parameters:parameters class:[NSDictionary class] callback:^(id json,NSError *error) {
        callback ? callback(json, error) : nil;
    }];
}

-(void)socialLoginWorker:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback
{
    NSDictionary *parameters = @{@"identityProviderName": provider,
                                 @"identityId": providerId,
                                 @"identityAccessToken": token};
    
    [self POST:@"users/login/social" parameters:parameters class:[NSDictionary class] callback:^(id json,NSError *error) {
        callback ? callback(json, error) : nil;
    }];
}

- (void)loginUser:(NSString *)username password:(NSString *)password callback:(BuddyObjectCallback)callback
{
    [self loginWorker:username password:password success:^(id obj, NSError *error) {
        
        if(error) {
            callback ? callback(nil, error) : nil;
            return;
        }
        
        self.currentUser = [BPUser new];
        [[JAGPropertyConverter bp_converter] setPropertiesOf:self.currentUser fromDictionary:obj];
        self.appSettings.userToken = [obj objectForKey:@"accessToken"];
        
        callback ? callback(self.currentUser,nil) : nil;
        
    }];
}

- (void)socialLogin:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback;
{
    [self socialLoginWorker:provider providerId:providerId token:token success:^(id obj, NSError *error) {
        
        if (error) {
            callback ? callback(nil, error) : nil;
            return;
        }
        
        BPUser *user = [BPUser new];
        [[JAGPropertyConverter bp_converter] setPropertiesOf:user fromDictionary:obj];
        
        NSDictionary *dict = (NSDictionary*)obj;
        
        self.appSettings.userToken = [dict objectForKey:@"accessToken"];
        
        callback ? callback(user,nil) : nil;
        
    }];
}

- (void)logoutUser:(BuddyCompletionCallback)callback
{
    NSString *resource = @"users/me/logout";
    
    [self POST:resource parameters:nil class:[NSDictionary class] callback:^(id json, NSError *error) {
        if (!error) {
            [self resetOnLogout];
        }
        
        callback ? callback(error) : nil;
    }];
}

-(void) registerPushTokenWithData:(NSData *)token callback:(BuddyObjectCallback)callback{
    NSString* rawDeviceTokenHex = [[token description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [self registerPushToken:[rawDeviceTokenHex stringByReplacingOccurrencesOfString:@" " withString:@""] callback:callback];
}

-(void) registerPushToken:(NSString *)token callback:(BuddyObjectCallback)callback
{
    self.appSettings.devicePushToken = token;
    NSString *resource = @"devices/current";
    [self PATCH:resource parameters:@{@"pushToken": token} class:[NSDictionary class] callback:^(id json, NSError *error) {
        callback ? callback(json,error) : nil;
    }];
}

-(void) notifyPushRecieved:(NSDictionary *)data {
    UILocalNotification * notification = [data objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notification){
        NSString *bId = [notification valueForKey:@"_bId"];
        [self POST:[NSString stringWithFormat:@"/noftifications/recieved/%@", bId] parameters:nil class:nil callback:nil];
    }
}

-(void) updateOSVersion
{
    // Grab the current version.
    NSString *currentVersion = [BuddyDevice osVersion];
    
    // New version? Inform Buddy.
    if (![currentVersion isEqualToString:self.appSettings.osVersion]) {
        [self PATCH:@"devices/current" parameters:@{@"OSVersion": currentVersion} class:[NSDictionary class] callback:^(id obj, NSError *error) {
            
            if (!error) {
                // update new version only on successful callback.
                self.appSettings.osVersion = currentVersion;
            } else {
                // Try again next time. Not worth reporting up.
            }
        }];
    }
}

#pragma mark - BPRestProvider

- (void)GET:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        if(clazz ==[BPFile class])
        {
            [self.service REST_GET_FILE:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
        }
        else
        {
            [self.service REST_GET:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
        }
    }];
}

- (void)POST:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        // We check if any of the parameters are files or not, and separate files from non-files.
        NSMutableDictionary *nonFiles = [NSMutableDictionary new];
        NSMutableDictionary *files =[NSMutableDictionary new];
        
        for(NSString *name in [parameters allKeys]){
            id object = [parameters objectForKey:name];
            if([object isKindOfClass:[BPFile class]])
            {
                [files setObject:object forKey:name];
            }
            else
            {
                [nonFiles setObject:object forKey:name];
            }
        }
        
        if([files count]>0)
        {
            // We have some files
            [self.service REST_MULTIPART_POST:servicePath parameters:[self convertDictionaryForUpload:nonFiles] data:files callback:[self handleResponse:clazz callback:callback]];
        }
        else
        {
            [self.service REST_POST:servicePath parameters:[self convertDictionaryForUpload:nonFiles] callback:[self handleResponse:clazz callback: callback]];
        }

    }];
}

- (void)PATCH:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        [self.service REST_PATCH:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
    }];
}

- (void)PUT:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        [self.service REST_PUT:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
    }];
}

- (void)DELETE:(NSString *)servicePath parameters:(NSDictionary *)parameters class:(Class)clazz callback:(RESTCallback)callback
{
    [self checkDeviceToken:^{
        [self.service REST_DELETE:servicePath parameters:[self convertDictionaryForUpload:parameters] callback:[self handleResponse:clazz callback:callback]];
    }];
}

-(NSString*) generateServerSig
{
    NSString *stringToSign = [NSString stringWithFormat:@"%@\n",self.appSettings.appKey];
    if(!stringToSign)
    {
        return nil;
    }
    return [CryptoTools hmac256ForKey:self.sharedSecret andData:stringToSign];
}

// Data struct to keep track of requests waiting on device token.
- (void)checkDeviceToken:(void(^)())method
{
    [method copy];
    
    if (!self.queuedRequests) {
        self.queuedRequests = [NSMutableArray array];
    }
    
    if ([self.appSettings.deviceToken length] > 0) {
        method();
    } else {
        @synchronized (self) {
            if ([self.queuedRequests count] > 0) {
                [self.queuedRequests addObject:method];
                return;
            }
            else {
                [self.queuedRequests addObject:method];
                
                NSDictionary *getTokenParams = @{
                                                 @"appId": BOXNIL(self.appSettings.appID),
                                                 @"appKey": BOXNIL(self.appSettings.appKey),
                                                 @"Platform": @"iOS",
                                                 @"UniqueId": BOXNIL(self.appSettings.deviceUniqueId ?: [BuddyDevice identifier]),
                                                 @"Model": BOXNIL([BuddyDevice deviceModel]),
                                                 @"OSVersion": BOXNIL([BuddyDevice osVersion]),
                                                 @"DeviceToken": BOXNIL(self.appSettings.devicePushToken),
                                                 @"AppVersion": BOXNIL(self.appSettings.appVersion),
                                                 @"Tag": BOXNIL(self.appSettings.deviceTag)
                                                 };
                
                
                [self.service REST_POST:@"devices" parameters:getTokenParams callback:[self handleResponse:[NSDictionary class] callback:^(id json, NSError *error) {
                    
                    if(self.sharedSecret) {
                        if(!json[@"serverSignature"]) {
                            self.appSettings.deviceToken = nil;
                            return ;
                        }
                        NSString *serverSig = [self generateServerSig];
                        if(! [serverSig isEqualToString:json[@"serverSignature"]])
                        {
                            self.appSettings.deviceToken = nil;
                            return ;
                        }
                    }
                    // Grab the potentially different base url.
                    if (json[@"accessToken"] && ![json[@"accessToken"] isEqualToString:self.appSettings.token]) {
                        self.appSettings.deviceToken = json[@"accessToken"];
                        
                        // We have a device token. Start monitoring for crashes.
                        [self.crashManager startReporting:self.appSettings.deviceToken];
                    }
                    
                    for (void(^block)() in self.queuedRequests) {
                        block();
                    }
                    
                    [self.queuedRequests removeAllObjects];
                }]];
            }
        }
    }
}


#pragma mark - Response Handlers

- (REST_ServiceResponse) handleResponse:(Class) clazz callback:(RESTCallback)callback
{
    return ^(NSInteger responseCode, NSDictionary *responseHeaders, id response, NSError *error) {
        NSLog (@"Framework: handleResponse");
        
        NSError *buddyError;
        
        id result = response;
        
        // Is it a JSON response (as opposed to raw bytes)?
        if(result && [result isKindOfClass:[NSDictionary class]]) {
            
            // Grab the result
            result = response[@"result"] ?: result;
            
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                // Grab the access token
                if (result[@"serviceRoot"]) {
                    self.appSettings.serviceUrl = result[@"serviceRoot"];
                }
            }
        }
        
        result = result ?: [NSDictionary new];
        id responseObject = nil;
        
        switch (responseCode) {
            case 200:
            case 201:
                responseObject = result;
                break;
            default:
                buddyError = [NSError bp_buildError:responseCode result:result];
                break;
        }
        if([buddyError noInternet]) {
            [self setConnectivityLevel:BPConnectivityNone];
        }
        if([buddyError needsLogin]) {
            [self.appSettings clearUser];
            [self raiseNeedsLoginError];
        }
        if([buddyError credentialsInvalid]) {
            [self.appSettings clear];
        }
        if (buddyError) {
            [self raiseAPIError:buddyError];
        }
        
        if(clazz == [BPFile class])
        {
            // NOTE: Should we check if responseObject is not a dict here ?
            BPFile *file = [BPFile new];
            file.fileData =response;
            file.contentType = [responseHeaders objectForKey:@"Content-Type"];
            if(file.contentType==nil)
            {
                file.contentType = @"application/octet-stream";
            }
            callback(file,buddyError);
            return;
        }
        
        if(![result isKindOfClass:[NSDictionary class]])
        {
            // If result is not a dictionary then we just pass it back to the caller as we cannot convert that.
            callback(responseObject, buddyError);
            return;
        }
        else if(clazz == [NSDictionary class] && ([result isKindOfClass:[NSDictionary class]]) )
        {
            // If caller wants a dictionary, we can shortcut and just give it to them
            callback(responseObject, buddyError);
            return;
        }
        else
        {
            // Try to convert to what the caller wants.
            id returnObj = [[clazz alloc] init];
            [[JAGPropertyConverter bp_converter] setPropertiesOf:returnObj fromDictionary:result];
            callback(returnObj, buddyError);
            return;
        }
    };
}


- (void)setConnectivityLevel:(BPConnectivityLevel)level
{
    if (_connectivityLevel == level) {
        return;
    }
    
    [self raiseConnectivityChanged:level];
    
    if (level == BPConnectivityNone) {
        [self checkConnectivity:1];
    }
    
    _connectivityLevel = level;
}


- (void)checkConnectivity:(int)retryCount
{
    const int retryCapInMilliseconds = 30*1000;
    const int retryBaseInMilliseconds = 500;
    
    // http://www.awsarchitectureblog.com/2015/03/backoff.html
    int intervalToWait = arc4random_uniform(MIN(retryCapInMilliseconds, retryBaseInMilliseconds *
                                                (int) (pow(2, retryCount) - 1)));
    
    dispatch_time_t delay = dispatch_time(0, (int64_t) (intervalToWait * NSEC_PER_MSEC));
    
    NSLog(@"Retry: Delaying retry for %d milliseconds...", intervalToWait);
    dispatch_after(delay, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        NSLog(@"Retry: Ping");
        [self GET:@"/service/ping" parameters:[NSDictionary new] class: [NSString class]
                    callback:^(id obj, NSError *error) {
                        
                        if (error == nil)
                        {
                            NSLog(@"Retry: Pong successful!");
                            [self setConnectivityLevel:[_service getConnectivityLevel]];
                        }
                        else
                        {
                            NSLog(@"Retry: Pong retry %d...", retryCount);
                            [self checkConnectivity:retryCount + (retryCount < 21 ? 1 : 0)];
                        }
                    }];
    });
}

- (void)raiseUserChangedTo:(BPUser *)user from:(BPUser *)from
{
    [self tryRaiseDelegate:@selector(userChangedTo:from:) withArguments:BOXNIL(user), BOXNIL(from), nil];
}

- (void)raiseConnectivityChanged:(BPConnectivityLevel)level
{
    [self tryRaiseDelegate:@selector(connectivityChanged:) withArguments:@(level), nil];
}

- (void)raiseNeedsLoginError
{
    [self tryRaiseDelegate:@selector(authorizationNeedsUserLogin) withArguments:nil];
}

- (void)raiseAPIError:(NSError *)error
{
    [self tryRaiseDelegate:@selector(apiErrorOccurred:) withArguments:error, nil];
}

- (void)tryRaiseDelegate:(SEL)selector withArguments:(id)firstArgument, ...
{
    va_list args;
    va_start(args, firstArgument);
    NSMutableArray *argList = [NSMutableArray array];
    for (id arg = firstArgument; arg != nil; arg = va_arg(args, id))
    {
        [argList addObject:arg];
    }
    va_end(args);
    
    id<UIApplicationDelegate> app = [[UIApplication sharedApplication] delegate];
    id target = nil;
    if (!self.delegate) {// If no delegate, see if we've implemented delegate methods on the AppDelegate.
        target = app;
    } else { // Try the delegate
        target = self.delegate;
    }
    
    SuppressPerformSelectorLeakWarning(
                                       
       if ([target respondsToSelector:selector]) {
           
           if ([argList count] >= 2) {
               [target performSelector:selector withObject:UNBOXNIL(argList[0]) withObject:UNBOXNIL(argList[1])];
           } else if ([argList count] == 1) {
               [target performSelector:selector withObject:UNBOXNIL(argList[0])];
           } else {
               [target performSelector:selector];
           }
       }
   );
}

- (NSDictionary*) convertDictionaryForUpload:(NSDictionary*)dictionary
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // Convert any params that don't serialize cleanly
    for (NSString *name in [dictionary allKeys])
    {
        id val = [dictionary objectForKey:name];
        
        if([[val class] isSubclassOfClass:[NSDate class]])
        {
            val = [val bp_serializeDateToJson];
        }
        else if([[val class] isSubclassOfClass:[BPCoordinate class]])
        {
            val = [val stringValue];
        }
        else if([[val class] isSubclassOfClass:[BPCoordinateRange class]])
        {
            val = [val stringValue];
        }
        else if([[val class] isSubclassOfClass:[BPSize class]])
        {
            val = [val stringValue];
        }
        else if([[val class] isSubclassOfClass:[CLLocation class]])
        {
            CLLocation *loc = (CLLocation*)val;
            val = [NSString stringWithFormat:@"%.4f,%.4f",loc.coordinate.latitude, loc.coordinate.longitude ];
        }
        if (val) {
            parameters[name] = val;
        }
    }

    // Inject location if needed
    if (!parameters[@"location"] && self.lastLocation!=nil)
    {
        [parameters setObject:BOXNIL([self.lastLocation stringValue]) forKey:@"location"];
    }
    
    return parameters;
}

#pragma mark - Metrics

- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value callback:(BuddyCompletionCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"metrics/events/%@", key];
    NSDictionary *parameters = @{@"value": BOXNIL(value)};
    
    [self POST:resource parameters:parameters class:[NSDictionary class] callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds callback:(BuddyMetricCallback)callback
{
    
    NSDictionary *parameters = @{@"value": BOXNIL(value),
                                 @"timeoutInSeconds": @(seconds)};
    [self recordMetricCore:key parameters:parameters callback:callback];
}

- (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds timestamp:(NSDate*)timestamp callback:(BuddyMetricCallback)callback
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:BOXNIL(value) forKey:@"value"];
    if(seconds>0)
    {
        [parameters setObject:@(seconds) forKey:@"timeoutInSeconds"];
    }
    if(timestamp)
    {
        [parameters setObject:[timestamp bp_serializeDateToJson ] forKey:@"timestamp"];
    }
  
    [self recordMetricCore:key parameters:parameters callback:callback];
}

- (void)recordMetricCore:(NSString*)key parameters:(NSDictionary*)parameters callback:(BuddyMetricCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"metrics/events/%@", key];
    [self POST:resource parameters:parameters class:[NSDictionary class] callback:^(id json, NSError *error) {
        BPMetricCompletionHandler *completionHandler;
        if (!error) {
            completionHandler = [[BPMetricCompletionHandler alloc] initWithMetricId:json[@"id"] andClient:self];
        }
        callback ? callback(completionHandler, error) : nil;
    }];
}

-(void)sendApplicationMessage:(SEL)selector withArguments:(NSArray*)args
{
    UIApplication* app = [UIApplication sharedApplication];
    if([app respondsToSelector:selector]){
        NSMethodSignature* messageSig = [UIApplication methodSignatureForSelector:selector];
        NSInvocation* invoke = [NSInvocation invocationWithMethodSignature: messageSig];
        [invoke setSelector:selector];
        [invoke setTarget:app];
        if([args count] != ([messageSig numberOfArguments] - HiddenArgumentCount)){
            return;
        }
       
        for ( int currentArgIndex = 0;currentArgIndex < [args count]; currentArgIndex++){
            [invoke setArgument:(void*)[args objectAtIndex:currentArgIndex] atIndex:currentArgIndex];
        }
        [invoke invoke];
    }
}

@end

