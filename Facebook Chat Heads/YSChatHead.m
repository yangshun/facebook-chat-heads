//
//  YSChatHead.m
//  facebook-chat-head
//
//  Created by YangShun on 1/3/14.
//  Copyright (c) 2014 YangShun. All rights reserved.
//

#import "YSChatHead.h"
#import <QuartzCore/QuartzCore.h>

#define CHAT_HEAD_SIZE 80.f
#define CHAT_HEAD_HORIZONTAL_DIST_FROM_EDGE 30.f
#define ENDING_VELOCITY 2000.f
#define CHAT_HEAD_MINIMUM_VERTICAL_DIST_FROM_EDGE 100.f

@implementation YSChatHead {
    UIPanGestureRecognizer *panGesture;
    CGPoint panningStartPoint;
}

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, CHAT_HEAD_SIZE, CHAT_HEAD_SIZE);
    self = [super initWithFrame:frame];
    if (self) {
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:panGesture];

        self.layer.cornerRadius = CHAT_HEAD_SIZE/2;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5.0f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3f;
        self.layer.frame = CGRectMake(0, 0, CHAT_HEAD_SIZE, CHAT_HEAD_SIZE);
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = self.layer.frame;
        imageLayer.contents = (id)[UIImage imageNamed:@"thumbnail.png"].CGImage;
        imageLayer.cornerRadius = CHAT_HEAD_SIZE/2;
        imageLayer.masksToBounds = YES;
        [self.layer addSublayer:imageLayer];
        
        self.center = CGPointMake(CHAT_HEAD_HORIZONTAL_DIST_FROM_EDGE, 300.f);
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)drag:(UIPanGestureRecognizer*)pan {

    if (!pan || pan.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [pan locationInView:self.superview];
        CGPoint velocity = [pan velocityInView:self.superview];
        CGFloat velocityMagnitude = sqrt(pow(velocity.x, 2) * pow(velocity.y,2));
        
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat finalX = CHAT_HEAD_HORIZONTAL_DIST_FROM_EDGE; // defaults to left side
        CGFloat finalY = location.y;
        
        bool flung = velocityMagnitude > ENDING_VELOCITY;
        
        if ((location.x > screenWidth/2 && velocity.x > -ENDING_VELOCITY) ||
            (location.x <= screenWidth/2 && velocity.x > ENDING_VELOCITY)) {
            // right side of screen
            finalX = screenWidth - CHAT_HEAD_HORIZONTAL_DIST_FROM_EDGE;
        }
        
        CGFloat horizontalVelocity = abs(velocity.x);
        CGFloat animationDuration = flung ? MIN(0.3, abs(finalX - location.x)/horizontalVelocity) : 0.3f;
        
        if (flung) {
            finalY += velocity.y * animationDuration;
            if (finalY < CHAT_HEAD_HORIZONTAL_DIST_FROM_EDGE) {
                finalY = CHAT_HEAD_HORIZONTAL_DIST_FROM_EDGE;
            } else if (finalY > screenHeight - CHAT_HEAD_MINIMUM_VERTICAL_DIST_FROM_EDGE) {
                finalY = screenHeight - CHAT_HEAD_MINIMUM_VERTICAL_DIST_FROM_EDGE;
            }
        }
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.center = CGPointMake(finalX, finalY);
                         }
                         completion:^(BOOL finished) {
                         }];
        return;
    }
    
    CGPoint translation = [pan translationInView:self.superview];
    panningStartPoint = self.center;
    self.center = CGPointMake(panningStartPoint.x + translation.x,
                              panningStartPoint.y + translation.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.superview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
