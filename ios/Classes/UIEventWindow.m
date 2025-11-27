//
//  UIMotionWindow.m
//  Chat
//
//  Created by minidam on 11/01/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIEventWindow.h"

@implementation UIEventWindow

@synthesize motionEventDelegate=motionEventDelegate_;
@synthesize touchesEventDelegate=touchesEventDelegate_;

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
	[super motionBegan: motion withEvent: event];
	if([self.motionEventDelegate respondsToSelector: @selector(window:motionBegan:withEvent:)]){
		[self.motionEventDelegate window: self motionBegan: motion withEvent: event];
	}
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
	[super motionCancelled: motion withEvent: event];
	if([self.motionEventDelegate respondsToSelector: @selector(window:motionCancelled:withEvent:)]){
		[self.motionEventDelegate window: self motionCancelled: motion withEvent: event];
	}
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
	[super motionEnded: motion withEvent: event];
	if([self.motionEventDelegate respondsToSelector: @selector(window:motionEnded:withEvent:)]){
		[self.motionEventDelegate window: self motionEnded: motion withEvent: event];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan: touches withEvent: event];
	if([self.touchesEventDelegate respondsToSelector: @selector(window:touchesBegan:withEvent:)]){
		[self.touchesEventDelegate window: self touchesBegan: touches withEvent: event];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesCancelled: touches withEvent: event];
	if([self.touchesEventDelegate respondsToSelector: @selector(window:touchesCancelled:withEvent:)]){
		[self.touchesEventDelegate window: self touchesCancelled: touches withEvent: event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded: touches withEvent: event];
	if([self.touchesEventDelegate respondsToSelector: @selector(window:touchesEnded:withEvent:)]){
		[self.touchesEventDelegate window: self touchesEnded: touches withEvent: event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	//[super touchesMoved: touches withEvent: event];
	if([self.touchesEventDelegate respondsToSelector: @selector(window:touchesMoved:withEvent:)]){
		[self.touchesEventDelegate window: self touchesMoved: touches withEvent: event];
	}
}

-(void)dealloc{
	self.motionEventDelegate = nil;
	self.touchesEventDelegate = nil;
	[super dealloc];
}

@end
