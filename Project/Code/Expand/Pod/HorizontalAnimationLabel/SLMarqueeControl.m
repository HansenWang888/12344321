//
//  SLMarqueeControl.m
//  SLMarqueeControl
//
//  Created by sl on 2018/10/24.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "SLMarqueeControl.h"

static CGFloat const kLabelOffset = 20.f;

@interface SLMarqueeControl ()
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, weak) UIView *hornContainer;
@property (nonatomic, weak) UIView *innerContainer;
@property (nonatomic, weak) UIButton *button;

@end

@implementation SLMarqueeControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil
         ];
        
        [self.marqueeLabel addObserver:self
                            forKeyPath:@"text"
                               options:NSKeyValueObservingOptionNew
                               context:nil
         ];
        
        [self.marqueeLabel addObserver:self
                            forKeyPath:@"attributedText"
                               options:NSKeyValueObservingOptionNew
                               context:nil
         ];
        
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [self startAnimation];
    }
    
    [super willMoveToWindow:newWindow];
}

+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}

#pragma mark - NSNotification
- (void)appBecomeActive:(NSNotification *)note {
    [self startAnimation];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self startAnimation];
}

#pragma mark - Private method
- (void)startAnimation {
    if (0 == CGRectGetWidth(self.bounds)
        || 0 == CGRectGetHeight(self.bounds)) {
        return;
    }
    
    [self.innerContainer.layer removeAnimationForKey:@"Marquee"];
    [self bringSubviewToFront:self.innerContainer];
    CGSize size = [self evaluateMarqueeLabelContentSize];
    
    for (UIView *view in self.innerContainer.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIView class]]&&
            view.tag ==200) {
            [view removeFromSuperview];
        }
    }
    
    CGRect rect = CGRectMake(0.f, 0.f, size.width + kLabelOffset, CGRectGetHeight(self.bounds));
    
    UIButton *label = [[UIButton alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    [label setTitle:self.marqueeLabel.titleLabel.text forState:UIControlStateNormal] ;
    [label setAttributedTitle:self.marqueeLabel.titleLabel.attributedText forState:UIControlStateNormal];
    [label addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.innerContainer addSubview:label];
    
    if (size.width > CGRectGetWidth(self.bounds)) {
        CGRect nextRect = rect;
        nextRect.origin.x = size.width + kLabelOffset;
        
        UIButton *nextLabel = [[UIButton alloc] initWithFrame:nextRect];
        nextLabel.backgroundColor = [UIColor clearColor];
        [nextLabel setTitle:self.marqueeLabel.titleLabel.text forState:UIControlStateNormal] ;
        [nextLabel setAttributedTitle:self.marqueeLabel.titleLabel.attributedText forState:UIControlStateNormal];
        [nextLabel addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.innerContainer addSubview:nextLabel];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.keyTimes = @[@0.f, @1.f];
        animation.duration = size.width / 50.f;
        animation.values = @[@0, @(-(size.width + kLabelOffset))];
        animation.repeatCount = INT16_MAX;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
        [self.innerContainer.layer addAnimation:animation forKey:@"Marquee"];
    } else {
        label.frame = self.bounds;
    }
    [self hornContainer];
}

- (void)richElementsInViewWithModel:(id)model actionBlock:(ActionBlock)block{
    self.block = block;
    [self.marqueeLabel setAttributedTitle:model forState:UIControlStateNormal] ;
    
}
-(void)clickAction:(UIButton*)btn{
    if (self.block) {
        self.block(btn);
    }
}
- (CGSize)evaluateMarqueeLabelContentSize {
    CGSize size = CGSizeZero;
    if (self.marqueeLabel && self.marqueeLabel.titleLabel.text.length > 0) {
        size = [self.marqueeLabel.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.marqueeLabel.titleLabel.font}];
    }
    
    return size;
}

#pragma mark - Getter
- (UIButton *)marqueeLabel {
    return self.button;
}

- (UIView *)innerContainer {
    if (!_innerContainer) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width - 50, self.bounds.size.height)];
//        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:view];
        _innerContainer = view;
    }
    
    return _innerContainer;
}

- (UIView *)hornContainer {
//    if (!_hornContainer) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, self.bounds.size.height)];
        view.tag = 200;
//        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
//        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:view];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
        iconView.backgroundColor = [UIColor whiteColor];
        iconView.frame = CGRectMake(0, 0, 45, self.bounds.size.height);
        iconView.contentMode = UIViewContentModeCenter;
        [view addSubview:iconView];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touying"]];
        shadowView.frame = CGRectMake(iconView.frame.size.width +iconView.frame.origin.x * 2 - 6, 8, 8, self.bounds.size.height - 16);
        shadowView.contentMode = UIViewContentModeCenter;
        [view addSubview:shadowView];
//        NSInteger startX = shadowView.frame.origin.x + shadowView.frame.size.width - 3;

        
        _hornContainer = view;
//    }
    
    return _hornContainer;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *label = [[UIButton alloc] init];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        _button = label;
    }
    
    return _button;
}

@end
