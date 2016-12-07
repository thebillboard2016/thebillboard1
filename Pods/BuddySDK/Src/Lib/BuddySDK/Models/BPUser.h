#import "BPModelBase.h"

@interface BPUser : BPModelBase

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSDate *dateOfBirth;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *profilePictureID;

@end
