//
//  BallFitInfo.m
//  MasterMind
//
//  Created by minidam on 11/07/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BallFitInfo.h"


@implementation BallFitInfo

@synthesize state=state_;
@synthesize holeIndex=holeIndex_;

+(id)fitToNone{
	BallFitInfo* obj = [[[self alloc] init] autorelease];
	obj.state = kBallFitToNone; 
	return obj;
}

+(id)fitToSelf{
	BallFitInfo* obj = [[[self alloc] init] autorelease];
	obj.state = kBallFitToSelf; 
	return obj;
}

+(id)fitToHole: (NSInteger)holeIndex{
	BallFitInfo* obj = [[[self alloc] init] autorelease];
	obj.state = kBallFitToHole;
	obj.holeIndex = holeIndex;
	return obj;
}

-(BOOL)isEqual:(id)object{
	if(![object isKindOfClass: [BallFitInfo class]]){
		return NO;
	}
	BallFitInfo* target = (BallFitInfo*)object;
	if(self.state != target.state){
		return NO;
	}
	if(self.state == kBallFitToHole && self.holeIndex != target.holeIndex){
		return NO;
	}
	return YES;		 
}



@end
