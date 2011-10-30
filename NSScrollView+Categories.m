//
//  NSScrollView+Categories.m
//  QWeiboClient
//
//  Created by  on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSScrollView+Categories.h"

@implementation NSScrollView (NSScrollView_Categories)

- (void)scrollToTop
{
    NSPoint newScrollOrigin;
    
    // assume that the scrollview is an existing variable
    if ([self.documentView isFlipped]) {
        newScrollOrigin=NSMakePoint(0.0,0.0);
    } else {
        newScrollOrigin=NSMakePoint(0.0,NSMaxY([self.documentView frame])
                                    -NSHeight(self.contentView.bounds));
    }
    
    [self.documentView scrollPoint:newScrollOrigin];
}

- (void)scrollToBottom
{
    NSPoint newScrollOrigin;
    
    // assume that the scrollview is an existing variable
    if ([self.documentView isFlipped]) {
        newScrollOrigin=NSMakePoint(0.0,NSMaxY([self.documentView frame])
                                    -NSHeight(self.contentView.bounds));
    } else {
        newScrollOrigin=NSMakePoint(0.0,0.0);
    }
    
    [self.documentView scrollPoint:newScrollOrigin];
}

@end
