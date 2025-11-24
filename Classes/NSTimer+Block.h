//
//  NSTimer+Block.h
//  MasterMind
//
//  Created by minidam on 11/07/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (Block)

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
									 block:(void(^)(NSTimer*))block
								   repeats:(BOOL)repeats;

+ (NSTimer*)timerWithTimeInterval:(NSTimeInterval)seconds
							block: (void(^)(NSTimer*))block
						  repeats:(BOOL)repeats;


@end
