//
//  BackAnimation.m
//  MasterMind
//
//  Created by minidam on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackAnimation.h"
#import "NSTimer+Block.h"
#import "CABlockedBasicAnimation.h"
#import "NSTimer+Block.h"
#import "CALayer+Image.h"
#import "CALayer+pause.h"

@interface BackAnimation ();

@property(retain) CALayer* layer;
@property(retain) Minidam* minidam;	// 背景のアニメーションするミニダム
@property(retain) Ikedam* ikedam;	// 背景のアニメーションするイケダム
@property(retain) NSMutableArray* balls;
@property(assign) enum BackAnimationState state;
@property(assign) NSInteger frame;
@property(assign) BOOL paused;
@property(retain) NSTimer* tickTimer;

-(void)tick;

@end

#define kIkedamAroundY 123
#define kIkedamInitY 283
#define kIkedamAroundWitdh 16*2
#define kBallInitY 24
#define kBallDestY 16
#define kBallStepY 2
#define kBallOutX 124
#define kBallInX 147

@implementation BackAnimation

@synthesize layer=layer_;
@synthesize minidam=minidam_;
@synthesize ikedam=ikedam_;
@synthesize balls=balls_;
@synthesize openingDone=openingDone_;
@synthesize state=state_;
@synthesize frame=frame_;
@synthesize paused=paused_;
@synthesize tickTimer=tickTimer_;

-(id)initWithLayer:(CALayer *)layer{
	if((self = [self init]) != nil){
		self.layer = layer;
		
		self.minidam = [[[Minidam alloc] init] autorelease];
		self.ikedam = [[[Ikedam alloc] init] autorelease];
		
		// 足下を基準にする
		self.minidam.layer.position = CGPointMake(160, 62);
		[self.layer addSublayer: self.minidam.layer];
		
		// 足下を基準にする
		self.ikedam.layer.position = CGPointMake(160, kIkedamInitY);		
		[self.layer addSublayer: self.ikedam.layer];
		
		self.balls = [NSMutableArray arrayWithCapacity: 4];
		for(NSInteger i = 0; i < 4; ++i){
			CALayer* ball = [CALayer layerImageNamed: @"ball.png"];
			ball.hidden = YES;
			[self.balls addObject: ball];
			[self.layer addSublayer: ball];
		}
		
		// 500msごとに起動するタイマー
		self.tickTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
														   block: ^(NSTimer* timer){
															   [self tick];
														   }
														 repeats: YES
						  ];
	}
	
	return self;
}

-(void)dealloc{
	self.tickTimer = nil;
	self.ikedam = nil;
	self.minidam = nil;
	self.balls = nil;
	self.layer = nil;
	self.openingDone = nil;
	[super dealloc];
}

-(void)setTickTimer:(NSTimer *)timer{
	if(tickTimer_ == timer){
		return;
	}
	[tickTimer_ invalidate];
	[tickTimer_ release];
	tickTimer_ = timer;
	[tickTimer_ retain];
}

-(void)setState:(enum BackAnimationState)state{
	//enum BackAnimationState oldState = state_;
	if(state_ == state){
		return;
	}
	state_ = state;
	switch(state){
		case kBackAnimationStateOpening:
		{
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
			self.minidam.state = kMinidamStateSit;
			// イケダムのアニメーションを削除
			[self.ikedam.layer removeAllAnimations];
			// イケダムを所定の位置に
			self.ikedam.layer.position = CGPointMake(160, kIkedamInitY);
			// イケダムの向きを上に
			self.ikedam.state = kIkedamStateUp;
			
			for(CALayer* layer in self.balls){
				layer.hidden = YES;
				layer.position = CGPointMake(160, kBallInitY);
			}
			
			self.frame = 0;
			
			[CATransaction commit];
		}
			break;
		case kBackAnimationStateGame:
		{
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
			self.minidam.state = kMinidamStateSit;
			// イケダムのアニメーションを削除
			[self.ikedam.layer removeAllAnimations];
			// イケダムを所定の位置に
			self.ikedam.layer.position = CGPointMake(160, kIkedamAroundY);
			// イケダムの向きを左に
			self.ikedam.state = kIkedamStateLeft;
			
			for(CALayer* layer in self.balls){
				layer.hidden = YES;
			}
			
			self.frame = 0;
			
			[CATransaction commit];
		}
			break;
	}
}

-(void)tick{
	if(self.paused){
		return;
	}
	switch(self.state){
		case kBackAnimationStateOpening:
		{
			switch(self.frame++){
				/*
				case 0:
				{
					// イケダムを上に移動
					float x = self.ikedam.layer.position.x;
					float y = self.ikedam.layer.position.y;
					self.ikedam.layer.position = CGPointMake(x, kIkedamAroundY);
					CABlockedBasicAnimation *animation = [CABlockedBasicAnimation animationWithKeyPath: @"position.y"];
					animation.duration = (y - kIkedamAroundY) / 16 / 2;
					animation.fromValue = [NSNumber numberWithFloat: y];
					animation.toValue = [NSNumber numberWithFloat: kIkedamAroundY];
					animation.didStop = ^(CAAnimation* animation, BOOL finished){
						if(finished && self.state == kBackAnimationStateOpening){
							self.frame = 2;
						}
					};
					[self.ikedam.layer addAnimation: animation forKey: @"ikedam_up"];
					self.frame = 1;
				}
					break;
				case 1:
					// イケダムが上に移動中
					[self.ikedam tick];
					break;
				 */
				case 0:
				{
					[self.ikedam tick];
					// イケダムを上に移動中1
					float x = self.ikedam.layer.position.x;
					float y = self.ikedam.layer.position.y;
					if(y <= kIkedamAroundY){
						self.frame = 10;
						break;
					}
					self.ikedam.layer.position = CGPointMake(x, y - 32);
					CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"position.y"];
					animation.duration = 1.0f;
					animation.fromValue = [NSNumber numberWithFloat: y];
					animation.toValue = [NSNumber numberWithFloat: y - 32];
					[self.ikedam.layer addAnimation: animation forKey: @"ikedam_up"];
				}
					break;
				case 1:
					// イケダムが上に移動中2
					[self.ikedam tick];
					self.frame = 0;
					break;
				case 10:
				case 11:
					// イケダムが上に到達
					// ミニダムの前にたたずむイケダム
					break;
				case 12:
					self.frame = 20;
					break;
				case 20:
					// 立ち上がるミニダム
					self.minidam.state = kMinidamStateStand;
					break;
				case 21:
					break;
				case 22:
					break;
				case 23:
					break;
				case 24:
					//呪文を唱えるミニダム
					self.minidam.state = kMinidamStateSpell;
					break;
				case 25:
					// 玉が出現
					// 透明状態で出現
					[CATransaction begin];
					[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
					for(CALayer* layer in self.balls){
						layer.opacity = 1.0;
						layer.hidden = NO;
					}
					[CATransaction commit];
					for(CALayer* layer in self.balls){
						{
							layer.opacity = 1;
							CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"opacity"];
							animation.duration = 0.5f;
							animation.fromValue = [NSNumber numberWithFloat: 0.0];
							animation.toValue = [NSNumber numberWithFloat: 1.0];
							[layer addAnimation: animation forKey: @"fadein"];
						}
						{
							CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
							animation.duration = 0.5f;
							animation.fromValue = [NSNumber numberWithFloat: 0.0];
							animation.toValue = [NSNumber numberWithFloat: 1.0];
							[layer addAnimation: animation forKey: @"scalein"];
						}
					}
					break;
				case 26:
					break;
				case 27:
					self.minidam.state = kMinidamStateStand;
					break;
				case 28:
					break;
				case 29:
					self.minidam.state = kMinidamStateSpell;
					self.frame = 30;
					break;
				case 30:
				{
					// 玉が移動
					CALayer* firstBall = [self.balls objectAtIndex: 0];
					float y = firstBall.position.y;
					if(y <= kBallDestY){
						self.frame = 31;
						break;
					}
					float dx[] = {
						-(float)(kBallOutX - 160) / (float)(kBallInitY - kBallDestY) * kBallStepY,
						-(float)(kBallInX  - 160) / (float)(kBallInitY - kBallDestY) * kBallStepY,
						 (float)(kBallInX  - 160) / (float)(kBallInitY - kBallDestY) * kBallStepY,
						 (float)(kBallOutX - 160) / (float)(kBallInitY - kBallDestY) * kBallStepY,
					};
					for(NSInteger i = 0; i < [self.balls count]; ++i){
						CALayer* layer = [self.balls objectAtIndex: i];
						float x = layer.position.x;
						layer.position = CGPointMake(x + dx[i], y - kBallStepY);
						CABlockedBasicAnimation *animation = [CABlockedBasicAnimation animationWithKeyPath: @"position"];
						animation.duration = 0.5f;
						animation.fromValue = [NSValue valueWithCGPoint: CGPointMake(x, y)];
						animation.toValue = [NSValue valueWithCGPoint: CGPointMake(x + dx[i], y - kBallStepY)];
						[layer addAnimation: animation forKey: @"ball_move"];
					}
					self.frame = 30;
					break;
				}
				case 31:
				case 32:
					break;
				case 33:
					// 玉が消える
					for(CALayer* layer in self.balls){
						{
							layer.opacity = 0;
							CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"opacity"];
							animation.duration = 0.5f;
							animation.fromValue = [NSNumber numberWithFloat: 1.0];
							animation.toValue = [NSNumber numberWithFloat: 0.0];
							[layer addAnimation: animation forKey: @"fadeout"];
						}
						{
							CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
							animation.duration = 0.5f;
							animation.fromValue = [NSNumber numberWithFloat: 1.0];
							animation.toValue = [NSNumber numberWithFloat: 0.0];
							[layer addAnimation: animation forKey: @"scaleout"];
						}
					}
					break;
				case 34:
					self.frame = 50;
					break;
				case 50:
					// ミニダム手を下ろす
					self.minidam.state = kMinidamStateStand;
					break;
				case 51:
					break;
				case 52:
					// ミニダム座る
					self.minidam.state = kMinidamStateSit;
					break;
				case 53:
					break;
				case 54:
					self.state = kBackAnimationStateOpeningDone;
					if(self.openingDone != nil){
						(self.openingDone)();
					}
					break;
			}
		}
			break;
		case kBackAnimationStateGame:
		{
			[self.minidam tick];
			[self.ikedam tick];
			if(self.frame == 0){
				self.frame = 1;
				switch(self.ikedam.state){
					case kIkedamStateLeft:
					{
						if(self.ikedam.layer.position.x <= 160 - kIkedamAroundWitdh){
							self.ikedam.state = kIkedamStateDownToRight;
							self.frame = 0;
							break;
						}
					}
					case kIkedamStateDownToLeft:
					{
						self.ikedam.state = kIkedamStateLeft;
						// 左に進む
						float x = self.ikedam.layer.position.x;
						float y = self.ikedam.layer.position.y;
						self.ikedam.layer.position = CGPointMake(x - 16, y);
						CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"position.x"];
						animation.duration = 1.0f;
						animation.fromValue = [NSNumber numberWithFloat: x];
						animation.toValue = [NSNumber numberWithFloat: x - 16];
						[self.ikedam.layer addAnimation: animation forKey: @"ikedam_left"];
					}
						break;
					case kIkedamStateRight:
					{
						if(self.ikedam.layer.position.x >= 160 + kIkedamAroundWitdh){
							self.ikedam.state = kIkedamStateDownToLeft;
							self.frame = 0;
							break;
						}
					}
					case kIkedamStateDownToRight:
					{
						self.ikedam.state = kIkedamStateRight;
						// 右に進む
						float x = self.ikedam.layer.position.x;
						float y = self.ikedam.layer.position.y;
						self.ikedam.layer.position = CGPointMake(x + 16, y);
						CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"position.x"];
						animation.duration = 1.0f;
						animation.fromValue = [NSNumber numberWithFloat: x];
						animation.toValue = [NSNumber numberWithFloat: x + 16];
						[self.ikedam.layer addAnimation: animation forKey: @"ikedam_right"];
					}
						break;
				}
			}else{
				self.frame = 0;
			}
		}
			break;
	}
}

-(void)startOpeningAnimation{
	self.state = kBackAnimationStateOpening;
	[self resume];
}

-(void)startGameAnimation{
	self.state = kBackAnimationStateGame;
	[self resume];
}


-(void)pause{
	if(self.paused){
		return;
	}
	self.paused = YES;
	
	[self.ikedam.layer pause: YES];
}

-(void)resume{
	if(!self.paused){
		return;
	}
	self.paused = NO;
	
	[self.ikedam.layer pause: NO];
}

@end
