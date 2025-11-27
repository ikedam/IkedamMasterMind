//
//  Hole.h
//  MasterMind
//
//  Created by minidam on 11/07/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Hole : NSObject {
@private
	CGRect rect_;
	CGPoint position_;
	NSInteger index_;
	NSInteger ballIndex_;
}

@property(assign,readonly) NSInteger index;
@property(readonly) CGPoint position;
@property(readonly) CGRect fitRect;
@property(assign) NSInteger ballIndex;

+(id)holeWithIndex: (NSInteger)index
		   centerX: (NSInteger)centerX
		   centerY: (NSInteger)centerY;
-(void)reset;

@end
