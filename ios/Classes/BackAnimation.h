//
//  BackAnimation.h
//  MasterMind
//
//  Created by minidam on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Minidam.h"
#import "Ikedam.h"

enum BackAnimationState {
	kBackAnimationStateUnknown,
	// 開始アニメーション
	kBackAnimationStateOpening,
	kBackAnimationStateOpeningDone,
	kBackAnimationStateGame,
};

@interface BackAnimation : NSObject {
@private
	Minidam* minidam_;
	Ikedam* ikedam_;
	NSMutableArray* balls_;
	
	CALayer* layer_;
	
	void (^openingDone_)(void);
	
	enum BackAnimationState state_;
	NSInteger frame_;
	BOOL paused_;
	
	NSTimer* tickTimer_;
}

@property(copy) void(^openingDone)(void);

-(id)initWithLayer: (CALayer*)layer;
-(void)startOpeningAnimation;
-(void)startGameAnimation;
-(void)pause;
-(void)resume;

@end
