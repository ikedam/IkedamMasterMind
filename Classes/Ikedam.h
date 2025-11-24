//
//  Ikedam.h
//  MasterMind
//
//  Created by minidam on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

enum IkedamState{
	kIkedamStateUnknown,
	kIkedamStateLeft, // 左
	kIkedamStateRight, // 右
	kIkedamStateUp,	// 上
	kIkedamStateDownToLeft,	// 下(動かない) 左に向かうところ
	kIkedamStateDownToRight,	// 下(動かない) 右に向かうところ
};

@interface Ikedam : NSObject {
@private
	CALayer* layer_;
	enum IkedamState state_;
	NSInteger frame_;
	NSInteger maxFrame_;
	
	CALayer* left1Layer_;
	CALayer* left2Layer_;
	CALayer* left3Layer_;
	CALayer* right1Layer_;
	CALayer* right2Layer_;
	CALayer* right3Layer_;
	CALayer* up1Layer_;
	CALayer* up2Layer_;
	CALayer* up3Layer_;
	CALayer* down1Layer_;
	CALayer* down2Layer_;
	CALayer* down3Layer_;
}

@property(retain,readonly) CALayer* layer;
@property(assign) enum IkedamState state;

-(void)tick;

@end
