//
//  Ball.h
//  MasterMind
//
//  Created by minidam on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Ball : NSObject {
@private
	CALayer* layer_;
	CGRect initRect_;
	NSInteger index_;
	CGPoint initPosition_;
	NSInteger holeIndex_;
}

@property(retain,readonly) CALayer* layer;
@property(assign,readonly) CGRect initRect;
@property(assign,readonly) NSInteger index;
@property(readonly) CGRect touchRect;
@property(readonly) CGRect initFitRect;
@property(assign) CGPoint position;
@property(assign, readonly) CGPoint initPosition;
@property(assign) NSInteger holeIndex;

+(id)ballWithIndex: (NSInteger)index
		imageNamed: (NSString*)imageName
		   centerX: (NSInteger)centerX
		   centerY: (NSInteger)centerY;

@end
