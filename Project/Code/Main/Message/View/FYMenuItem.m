

#import "FYMenuItem.h"

@implementation FYMenuItem

+ (instancetype)itemWithImage:(UIImage *)image
                        title:(NSString *)title
                       action:(void (^)(FYMenuItem *item))action;
{
    return [[FYMenuItem alloc] init:title
                              image:image
                             action:(void (^)(FYMenuItem *item))action];
}
- (instancetype) init:(NSString *) title
      image:(UIImage *) image
     action:(void (^)(FYMenuItem *item))action
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _action = action;
    }
    return self;
}

- (void)clickMenuItem
{
    if (self.action) {
        self.action(self);
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end

