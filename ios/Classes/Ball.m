//
//  Ball.m
//  MasterMind
//
//  Created by minidam on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#import "CALayer+Image.h"
#import "Constants.h"

@interface Ball ()

@property(retain,readwrite) CALayer* layer;
@property(assign,readwrite) CGRect initRect;
@property(assign,readwrite) NSInteger index;
@property(assign,readwrite) CGPoint initPosition;

-(id)initWithIndex: (NSInteger)index
		imageNamed: (NSString*)imageName
		   centerX: (NSInteger)centerX
		   centerY: (NSInteger)centerY;
	
@end

@implementation Ball

@synthesize layer=layer_;
@synthesize initRect=initRect_;
@synthesize index=index_;
@synthesize initPosition=initPosition_;
@synthesize holeIndex=holeIndex_;

+(id)ballWithIndex: (NSInteger)index
		imageNamed: (NSString*)imageName
		   centerX: (NSInteger)centerX
		   centerY: (NSInteger)centerY{
	Ball* obj = [[[self alloc] initWithIndex: index
								  imageNamed: imageName
									 centerX: centerX
									 centerY: centerY]
				 autorelease];
	return obj;
}

-(id)initWithIndex: (NSInteger)index
		imageNamed: (NSString*)imageName
		   centerX: (NSInteger)centerX
		   centerY: (NSInteger)centerY{
	if((self = [self init]) != nil){
		self.index = index;
		self.layer = [CALayer layerImageNamed: imageName];
		self.layer.position = CGPointMake(centerX, centerY);
		self.initRect = CGRectMake(
								   centerX - self.layer.frame.size.width / 2,
								   centerY - self.layer.frame.size.height / 2,
								   self.layer.frame.size.width,
								   self.layer.frame.size.height
								   );
		self.initPosition = CGPointMake(centerX, centerY);
		self.holeIndex = -1;
	}
	return self;
}

-(void)dealloc{
	self.layer = nil;
	[super dealloc];
}

-(CGRect)touchRect{
	return self.layer.frame;
}

-(CGRect)initFitRect{
	return self.initRect;
}

-(CGPoint)position{
	return self.layer.position;
}

-(void)setPosition: (CGPoint)position{
	self.layer.position = position;
}

@end
