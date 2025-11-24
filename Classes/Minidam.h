//
//  Minidam.h
//  MasterMind
//
//  Created by minidam on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

enum MinidamState{
	kMinidmStateUnknown,
	kMinidamStateSit,	// 座っている
	kMinidamStateStand,	// たっている
	kMinidamStateSpell,	// 唱えている
};

@interface Minidam : NSObject {
@private
	CALayer* layer_;
	
	CALayer* sitLayer_;
	CALayer* standLayer_;
	CALayer* spellLayer_;
	
	enum MinidamState state_;
}

@property(retain,readonly) CALayer* layer;
@property(assign) enum MinidamState state;

-(void)tick;

@end
