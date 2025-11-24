//
//  CABlockedBasicAnimation.h
//  MasterMind
//
//  Created by minidam on 11/09/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface CABlockedBasicAnimation : CABasicAnimation {
@private
	void (^didStart_)(CAAnimation* theAnimation);
	void (^didStop_)(CAAnimation* theAnimation, BOOL finished);
}

@property(copy) void (^didStart)(CAAnimation* theAnimation);
@property(copy) void (^didStop)(CAAnimation* theAnimation, BOOL finished);


- (void)animationDidStart:(CAAnimation *)theAnimation;
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;

@end
