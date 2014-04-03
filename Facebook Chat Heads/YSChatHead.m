//
//  YSChatHead.m
//  facebook-chat-head
//
//  Created by YangShun on 1/3/14.
//  Copyright (c) 2014 YangShun. All rights reserved.
//

#import "YSChatHead.h"
#import <QuartzCore/QuartzCore.h>

#define CH_SIZE 80.f
#define CH_SHADOW_RADIUS 5.0f
#define CH_SHADOW_OPACITY 0.3f

#define CH_TOUCHDOWN_SCALE 0.9f
#define CH_TOUCHDOWN_SIZE 80.f
#define CH_TOUCHDOWN_ANIMATION_DURATION 0.1f

#define CH_HORIZONTAL_DIST_FROM_EDGE 30.f
#define CH_MINIMUM_VERTICAL_DIST_FROM_EDGE 100.f
#define CH_ENDING_VELOCITY_THRESHOLD 1000.f
#define CH_SNAPPING_ANIMATION_DURATION 0.3f

@implementation YSChatHead {
    UIPanGestureRecognizer *panGesture;
    UITapGestureRecognizer *tapGesture;
    CGPoint panningStartPoint;
    
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:nil];
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    frame = CGRectMake(0, 0, CH_SIZE, CH_SIZE);
    self = [super initWithFrame:frame];
    if (self) {
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(drag:)];
        [self addGestureRecognizer:panGesture];
        
        self.layer.cornerRadius = CH_SIZE/2;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = CH_SHADOW_RADIUS;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = CH_SHADOW_OPACITY;
        self.layer.frame = CGRectMake(0, 0, CH_SIZE, CH_SIZE);
        
        if (image) {
            [self addImage:image];
        } else {
            self.backgroundColor = [UIColor blackColor];
        }
        
        self.center = CGPointMake(CH_HORIZONTAL_DIST_FROM_EDGE, 300.f);
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)addImage:(UIImage *)image
{
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CH_SIZE, CH_SIZE)];
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = self.layer.frame;
    imageLayer.contents = (id)image.CGImage;
    imageLayer.cornerRadius = CH_SIZE/2;
    imageLayer.masksToBounds = YES;
    [imageView.layer addSublayer:imageLayer];
    
    [self addSubview:imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Shrinks the Chat Head upon touch down event
    [UIView animateWithDuration:CH_TOUCHDOWN_ANIMATION_DURATION
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(CH_TOUCHDOWN_SCALE,
                                                                     CH_TOUCHDOWN_SCALE);
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setOriginalSize];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatHeadPressed:)]) {
        [self.delegate chatHeadPressed:self];
    }
}

- (void)drag:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [pan locationInView:self.superview];
        CGPoint velocity = [pan velocityInView:self.superview];
        CGFloat velocityMagnitude = sqrt(pow(velocity.x, 2) * pow(velocity.y, 2));
        
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        // Final position is the left side of the screen by default.
        CGFloat finalX = CH_HORIZONTAL_DIST_FROM_EDGE;
        CGFloat finalY = location.y;
        
        bool flung = velocityMagnitude > CH_ENDING_VELOCITY_THRESHOLD;
        
        if ((location.x > screenWidth/2 && velocity.x > -CH_ENDING_VELOCITY_THRESHOLD) ||
            (location.x <= screenWidth/2 && velocity.x > CH_ENDING_VELOCITY_THRESHOLD)) {
            // Final position will be on the right side of screen.
            finalX = screenWidth - CH_HORIZONTAL_DIST_FROM_EDGE;
        }
        
        CGFloat horizontalVelocity = abs(velocity.x);
        // If flung, may duration may be faster than normal animation duration.
        CGFloat animationDuration = flung ? MIN(CH_SNAPPING_ANIMATION_DURATION,
                                                abs(finalX - location.x) / horizontalVelocity) : CH_SNAPPING_ANIMATION_DURATION;
        
        if (flung) {
            // Calculate final position of flung Chat Head.
            finalY += velocity.y * animationDuration;
        }
        
        if (finalY < CH_MINIMUM_VERTICAL_DIST_FROM_EDGE) {
            finalY = CH_MINIMUM_VERTICAL_DIST_FROM_EDGE;
        } else if (finalY > screenHeight - CH_MINIMUM_VERTICAL_DIST_FROM_EDGE) {
            finalY = screenHeight - CH_MINIMUM_VERTICAL_DIST_FROM_EDGE;
        }
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.center = CGPointMake(finalX, finalY);
                         }
                         completion:^(BOOL finished) {
                         }];
        [self setOriginalSize];
        return;
    }
    
    CGPoint translation = [pan translationInView:self.superview];
    panningStartPoint = self.center;
    self.center = CGPointMake(panningStartPoint.x + translation.x,
                              panningStartPoint.y + translation.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.superview];
}

- (void)setOriginalSize {
    self.transform = CGAffineTransformIdentity;
}

@end


