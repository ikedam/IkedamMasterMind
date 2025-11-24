//
//  MotionDelegate.h
//  Omikuji2
//
//  Created by minidam on 11/01/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import<UIKit/UIKit.h>

@protocol UIWindowMotionEventDelegate<NSObject>
@optional
- (void)window:(UIWindow*)window motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (void)window:(UIWindow*)window motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (void)window:(UIWindow*)window motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;


@end
