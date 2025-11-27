//
//  UIMotionWindow.h
//  Chat
//
//  Created by minidam on 11/01/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIWindowMotionEventDelegate.h"
#import "UIWindowTouchesEventDelegate.h"

@interface UIEventWindow : UIWindow {
@private
	id<UIWindowMotionEventDelegate> motionEventDelegate_;
	id<UIWindowTouchesEventDelegate> touchesEventDelegate_;
}

@property(assign) id<UIWindowMotionEventDelegate> motionEventDelegate;
@property(assign) id<UIWindowTouchesEventDelegate> touchesEventDelegate;

@end
