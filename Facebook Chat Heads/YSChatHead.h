//
//  YSChatHead.h
//  facebook-chat-head
//
//  Created by YangShun on 1/3/14.
//  Copyright (c) 2014 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSChatHead;

#pragma mark - Delegate Definition
@protocol YSChatHeadDelegate <NSObject>

- (void)chatHeadPressed:(YSChatHead *)chatHead;

@end


#pragma mark - YSChatHead definition

@interface YSChatHead : UIView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@property (nonatomic, weak) id<YSChatHeadDelegate> delegate;

@end

