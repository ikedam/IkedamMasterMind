//
//  Hole.m
//  MasterMind
//
//  Created by minidam on 11/07/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Hole.h"
#import "Constants.h"

@interface Hole ()

@property(assign,readwrite) NSInteger index;
@property(assign,readwrite) CGPoint position;
@property(assign) CGRect rect;

-(id)initWithIndex: (NSInteger)index
		   centerX: (NSInteger)centerX
		   centerY: (NSInteger)centerY;

@end

@implementation Hole

@synthesize index=index_;
@synthesize position=position_;
@synthesize rect=rect_;
@synthesize ballIndex=ballIndex_;

+(id)holeWithIndex: (NSInteger)index
		   centerX: (NSInteger)centerX
		   centerY: (NSInteger)centerY{
	Hole* obj = [[[self alloc] initWithIndex: index
									 centerX: centerX
									 centerY: centerY]
				 autorelease];
	return obj;
}

-(id)initWithIndex: (NSInteger)index
		   centerX: (NSInteger)centerX
		   centerY: (NSInteger)centerY{
	if((self = [self init]) != nil){
		self.index = index;
		self.rect = CGRectMake(
							   centerX - kHoleWideh / 2,
							   centerY - kHoleHeight / 2,
							   kHoleWideh,
							   kHoleHeight
							   );
		self.position = CGPointMake(centerX, centerY);
		self.ballIndex = -1;
	}
	return self;
}

- (void)reset{
	self.ballIndex = -1;
}

- (CGRect)fitRect{
	return self.rect;
}

@end
