//
//  ViewController.m
//  Facebook Chat Heads
//
//  Created by YangShun on 1/3/14.
//  Copyright (c) 2014 YangShun. All rights reserved.
//

#import "ViewController.h"
#import "YSChatHead.h"

@interface ViewController () <YSChatHeadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    YSChatHead *chatHead = [[YSChatHead alloc] initWithFrame:CGRectMake(80, 80, 80, 80)
                                                       image:[UIImage imageNamed:@"thumbnail"]];
    chatHead.delegate = self;
    
    UIWindow *window = [[UIApplication sharedApplication] windows][0];
    window.windowLevel = UIWindowLevelAlert;
    
    [window addSubview:self.view];
    [window addSubview:chatHead];
    [window makeKeyAndVisible];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChatHead Delegate

- (void)chatHeadPressed:(YSChatHead *)chatHead
{
    NSLog(@"Chat Head Pressed: %@", chatHead);
}

@end
