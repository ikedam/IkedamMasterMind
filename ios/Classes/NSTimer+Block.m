//
//  NSTimer+Block.m
//  MasterMind
//
//  Created by minidam on 11/07/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSTimer+Block.h"

@interface NSTimer ()

+ (void)timerFireMethod:(NSTimer*)theTimer;

@end


@implementation NSTimer (Block)

+ (void)timerFireMethod:(NSTimer*)theTimer{
	void(^block)(NSTimer*) = [theTimer userInfo];
	if(block != nil){
		(block)(theTimer);
	}
}

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
									 block:(void(^)(NSTimer*))block
								   repeats:(BOOL)repeats{
	return [self scheduledTimerWithTimeInterval: seconds
										 target: self
									   selector: @selector(timerFireMethod:)
									   userInfo: [[block copy] autorelease]
										repeats: repeats
			];
}

+ (NSTimer*)timerWithTimeInterval:(NSTimeInterval)seconds
							block: (void(^)(NSTimer*))block
						  repeats:(BOOL)repeats{
	return [self timerWithTimeInterval: seconds
								target: self
							  selector: @selector(timerFireMethod:)
							  userInfo: [[block copy] autorelease]
							   repeats: repeats
			];
}

@end
