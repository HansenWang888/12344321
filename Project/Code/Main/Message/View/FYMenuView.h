

#import <UIKit/UIKit.h>
#import "FYMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYMenuView : UIView

- (void)dismissMenu:(BOOL)animated;
- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
                  menu:(FYMenu *)menu
             menuItems:(NSArray *)menuItems;

@end

NS_ASSUME_NONNULL_END
