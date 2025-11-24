//
//  Minidam.m
//  MasterMind
//
//  Created by minidam on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Minidam.h"
#import "CALayer+Image.h"

@interface Minidam ();

@property(retain,readwrite) CALayer* layer;
@property(retain,readwrite) CALayer* sitLayer;	// 座っている
@property(retain,readwrite) CALayer* standLayer;	// 立っている
@property(retain,readwrite) CALayer* spellLayer;	// 唱えている

-(CALayer*)layerOfState: (enum MinidamState)state;

@end;

@implementation Minidam

@synthesize layer=layer_;
@synthesize sitLayer=sitLayer_;
@synthesize standLayer=standLayer_;
@synthesize spellLayer=spellLayer_;
@synthesize state=state_;

-(id)init{
	if((self = [super init]) != nil){
		self.layer = [CALayer layer];
		
		self.sitLayer = [CALayer layerImageNamed: @"minidam_sit.png"];
		self.sitLayer.hidden = YES;
		self.sitLayer.anchorPoint = CGPointMake(0.5, 1.0);
		self.sitLayer.position = CGPointMake(0, 0);
		[self.layer addSublayer: self.sitLayer];
		
		self.standLayer = [CALayer layerImageNamed: @"minidam_stand.png"];
		self.standLayer.hidden = YES;
		self.standLayer.anchorPoint = CGPointMake(0.5, 1.0);
		self.standLayer.position = CGPointMake(-1, 0);
		[self.layer addSublayer: self.standLayer];
		
		self.spellLayer = [CALayer layerImageNamed: @"minidam_spell.png"];
		self.spellLayer.hidden = YES;
		self.spellLayer.anchorPoint = CGPointMake(0.5, 1.0);
		self.spellLayer.position = CGPointMake(2.5, 0);
		[self.layer addSublayer: self.spellLayer];
		
	}
	return self;
}

-(void)dealloc{
	[self.layer removeFromSuperlayer];
	self.layer = nil;
	self.sitLayer = nil;
	self.standLayer = nil;
	self.spellLayer = nil;
	[super dealloc];
}

-(void)tick{
}

-(void)setState:(enum MinidamState)state{
	enum MinidamState oldState = state_;
	if(state_ == state){
		return;
	}
	state_ = state;
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
	[self layerOfState: state].hidden = NO;
	[self layerOfState: oldState].hidden = YES;
	[CATransaction commit];
}

-(CALayer*)layerOfState: (enum MinidamState)state{
	switch(state){
		case kMinidamStateSit:
			return self.sitLayer;
		case kMinidamStateStand:
			return self.standLayer;
		case kMinidamStateSpell:
			return self.spellLayer;
	}
	
	return [CALayer layer];
}


@end
