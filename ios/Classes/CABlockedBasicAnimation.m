//
//  CABlockedBasicAnimation.m
//  MasterMind
//
//  Created by minidam on 11/09/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CABlockedBasicAnimation.h"


@implementation CABlockedBasicAnimation
@synthesize didStart=didStart_;
@synthesize didStop=didStop_;

-(id)init{
	if((self = [super init]) != nil){
		self.delegate = self;
	}
	return self;
}

-(void)dealloc{
	self.didStart = nil;
	self.didStop = nil;
	[super dealloc];
}

- (void)animationDidStart:(CAAnimation *)theAnimation{
	if(self.didStart != nil){
		(self.didStart)(theAnimation);
	}
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	if(self.didStop != nil){
		(self.didStop)(theAnimation, flag);
	}
}


@end
