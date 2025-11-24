//
//  CALayer+pause.m
//  MasterMind
//
//  Created by minidam on 11/09/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CALayer+pause.h"


@implementation CALayer (pause)

-(void)pause: (BOOL)pause{
	if(pause){
		CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
		self.speed = 0.0;
		self.timeOffset = pausedTime;
	}else{
		CFTimeInterval pausedTime = [self timeOffset];
		self.speed = 1.0;
		self.timeOffset = 0.0;
		self.beginTime = 0.0;
		CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
		self.beginTime = timeSincePause;
	}
}

@end
