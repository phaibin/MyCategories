//
//  NSObject+UIAlertCategories.m
//
//  Created by Leon on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSObject+UIAlertCategories.h"



@implementation NSObject (UIAlertCategories)

- (void)showAlertMessage:(NSString *)msg
{
    [self showAlertMessage:msg dismissAfterDelay:1.5];
}

- (void)showAlertMessage:(NSString *)msg dismissAfterDelay:(NSTimeInterval)delay
{
    UIAlertView *_alertView = [[UIAlertView alloc] init];
    _alertView.tag = 7777777;
    [_alertView setDelegate:self];
    [_alertView setMessage:msg];
    [_alertView setNeedsLayout];
    [_alertView show];
    _alertView.frame = CGRectMake(0,205,320,90);
    [self performSelector:@selector(hideAlert:) withObject:_alertView afterDelay:delay];
    [_alertView release];
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (alertView.tag == 7777777) {
        UILabel *label = (UILabel *)[[alertView subviews] objectAtIndex:1];
        [label setFrame:CGRectMake(12, 10, 260, 48)];
    }
}

- (void)hideAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
