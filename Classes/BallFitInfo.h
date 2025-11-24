//
//  BallFitInfo.h
//  MasterMind
//
//  Created by minidam on 11/07/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum BallFitState{
	kBallFitToNone, // どこにもフィットしていない
	kBallFitToSelf,	// 自分自身のスタート位置
	kBallFitToHole, // 回答穴にフィット(どの穴かは別のフィールドで定義)
};

@interface BallFitInfo : NSObject {
@private
	enum BallFitState state_;
	NSInteger holeIndex_;
}

@property(assign) enum BallFitState state;
@property(assign) NSInteger holeIndex;

+(id)fitToNone;
+(id)fitToSelf;
+(id)fitToHole: (NSInteger)holeIndex;


@end
