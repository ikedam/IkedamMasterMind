//
//  Ikedam.m
//  MasterMind
//
//  Created by minidam on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ikedam.h"
#import "CALayer+Image.h"

@interface Ikedam ();

@property(retain,readwrite) CALayer* layer;
@property(assign) NSInteger frame;
@property(assign) NSInteger maxFrame;
@property(retain) CALayer* left1Layer;
@property(retain) CALayer* left2Layer;
@property(retain) CALayer* left3Layer;
@property(retain) CALayer* right1Layer;
@property(retain) CALayer* right2Layer;
@property(retain) CALayer* right3Layer;
@property(retain) CALayer* up1Layer;
@property(retain) CALayer* up2Layer;
@property(retain) CALayer* up3Layer;
@property(retain) CALayer* down1Layer;
@property(retain) CALayer* down2Layer;
@property(retain) CALayer* down3Layer;

-(CALayer*)layerOfFrame: (NSInteger)frame state: (enum IkedamState)state;

@end;


@implementation Ikedam

@synthesize layer=layer_;
@synthesize state=state_;
@synthesize frame=frame_;
@synthesize maxFrame=maxFrame_;
@synthesize left1Layer=left1Layer_;
@synthesize left2Layer=left2Layer_;
@synthesize left3Layer=left3Layer_;
@synthesize right1Layer=right1Layer_;
@synthesize right2Layer=right2Layer_;
@synthesize right3Layer=right3Layer_;
@synthesize up1Layer=up1Layer_;
@synthesize up2Layer=up2Layer_;
@synthesize up3Layer=up3Layer_;
@synthesize down1Layer=down1Layer_;
@synthesize down2Layer=down2Layer_;
@synthesize down3Layer=down3Layer_;

-(id)init{
	if((self = [super init]) != nil){
		self.layer = [CALayer layer];
		
		self.left1Layer = [CALayer layerImageNamed: @"ikedam_l1.png"];
		self.left1Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.left1Layer.position = CGPointMake(0, 0);
		self.left1Layer.hidden = YES;
		[self.layer addSublayer: self.left1Layer];
		
		self.left2Layer = [CALayer layerImageNamed: @"ikedam_l2.png"];
		self.left2Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.left2Layer.position = CGPointMake(0, 0);
		self.left2Layer.hidden = YES;
		[self.layer addSublayer: self.left2Layer];
		
		self.left3Layer = [CALayer layerImageNamed: @"ikedam_l3.png"];
		self.left3Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.left3Layer.position = CGPointMake(0, 0);
		self.left3Layer.hidden = YES;
		[self.layer addSublayer: self.left3Layer];
		
		self.right1Layer = [CALayer layerImageNamed: @"ikedam_r1.png"];
		self.right1Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.right1Layer.position = CGPointMake(0, 0);
		self.right1Layer.hidden = YES;
		[self.layer addSublayer: self.right1Layer];
		
		self.right2Layer = [CALayer layerImageNamed: @"ikedam_r2.png"];
		self.right2Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.right2Layer.position = CGPointMake(0, 0);
		self.right2Layer.hidden = YES;
		[self.layer addSublayer: self.right2Layer];
		
		self.right3Layer = [CALayer layerImageNamed: @"ikedam_r3.png"];
		self.right3Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.right3Layer.position = CGPointMake(0, 0);
		self.right3Layer.hidden = YES;
		[self.layer addSublayer: self.right3Layer];
		
		self.up1Layer = [CALayer layerImageNamed: @"ikedam_u1.png"];
		self.up1Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.up1Layer.position = CGPointMake(0.5, 0);
		self.up1Layer.hidden = YES;
		[self.layer addSublayer: self.up1Layer];
		
		self.up2Layer = [CALayer layerImageNamed: @"ikedam_u2.png"];
		self.up2Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.up2Layer.position = CGPointMake(-0.5, 0);
		self.up2Layer.hidden = YES;
		[self.layer addSublayer: self.up2Layer];
		
		self.up3Layer = [CALayer layerImageNamed: @"ikedam_u3.png"];
		self.up3Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.up3Layer.position = CGPointMake(0, 0);
		self.up3Layer.hidden = YES;
		[self.layer addSublayer: self.up3Layer];
		
		self.down1Layer = [CALayer layerImageNamed: @"ikedam_d1.png"];
		self.down1Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.down1Layer.position = CGPointMake(0, 0);
		self.down1Layer.hidden = YES;
		[self.layer addSublayer: self.down1Layer];
		
		self.down2Layer = [CALayer layerImageNamed: @"ikedam_d2.png"];
		self.down2Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.down2Layer.position = CGPointMake(0, 0);
		self.down2Layer.hidden = YES;
		[self.layer addSublayer: self.down2Layer];
		
		self.down3Layer = [CALayer layerImageNamed: @"ikedam_d3.png"];
		self.down3Layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.down3Layer.position = CGPointMake(0, 0);
		self.down3Layer.hidden = YES;
		[self.layer addSublayer: self.down3Layer];
	}
	return self;
}

-(void)dealloc{
	[self.layer removeFromSuperlayer];
	self.layer = nil;
	self.left1Layer = nil;
	self.left2Layer = nil;
	self.left3Layer = nil;
	self.right1Layer = nil;
	self.right2Layer = nil;
	self.right3Layer = nil;
	self.up1Layer = nil;
	self.up2Layer = nil;
	self.up3Layer = nil;
	self.down1Layer = nil;
	self.down2Layer = nil;
	self.down3Layer = nil;
	[super dealloc];
}

-(void)setState:(enum IkedamState)state{
	enum IkedamState oldState = state_;
	NSInteger oldFrame = frame_;
	if(state_ == state){
		return;
	}
	state_ = state;
	switch(state){
		case kIkedamStateLeft:
		case kIkedamStateRight:
		case kIkedamStateUp:
			self.maxFrame = 4;
			self.frame = 0;
			break;
		case kIkedamStateDownToRight:
		case kIkedamStateDownToLeft:
			self.maxFrame = 1;
			self.frame = 0;
			break;
	}
	if(self.frame >= self.maxFrame){
		self.frame = 0;
	}
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
	[self layerOfFrame: self.frame state: state].hidden = NO;
	[self layerOfFrame: oldFrame state: oldState].hidden = YES;
	[CATransaction commit];
}

-(void)setFrame:(NSInteger)frame{
	NSInteger oldFrame = frame_;
	if(frame_ == frame){
		return;
	}
	if(frame >= self.maxFrame){
		frame = 0;
	}
	frame_ = frame;
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
	[self layerOfFrame: frame_ state: self.state].hidden = NO;
	[self layerOfFrame: oldFrame state: self.state].hidden = YES;
	[CATransaction commit];
}

-(void)tick{
	self.frame += 1;
}

-(CALayer*)layerOfFrame: (NSInteger)frame state: (enum IkedamState)state{
	switch(state){
		case kIkedamStateLeft:
		{
			switch(frame){
				case 0:
					return self.left1Layer;
				case 1:
				case 3:
					return self.left2Layer;
				case 2:
					return self.left3Layer;
					
			}
		}
		case kIkedamStateRight:
		{
			switch(frame){
				case 0:
					return self.right1Layer;
				case 1:
				case 3:
					return self.right2Layer;
				case 2:
					return self.right3Layer;
					
			}
		}
		case kIkedamStateUp:
		{
			switch(frame){
				case 1:
				case 3:
					return self.up2Layer;
				case 0:
					return self.up1Layer;
				case 2:
					return self.up3Layer;
					
			}
		}
		case kIkedamStateDownToLeft:
		case kIkedamStateDownToRight:
			return self.down2Layer;
	}
	
	return [CALayer layer];
}


@end
