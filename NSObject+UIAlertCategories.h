//
//  NSObject+UIAlertCategories.h
//
//  Created by Leon on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface NSObject (UIAlertCategories)

- (void)showAlertMessage:(NSString *)msg;
- (void)showAlertMessage:(NSString *)msg dismissAfterDelay:(NSTimeInterval)delay;

@end
