//
//  History.m
//  MasterMind
//
//  Created by minidam on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "History.h"
#import "Constants.h"
#import "HistoryEntry.h"

@interface History ()

@property(retain) NSMutableArray* ballImageList;
@property(retain) NSMutableArray* historyList;
@property(retain) NSArray* ballImageNameList;
@property(retain) UIImage* hitFlagImage;
@property(retain) UIImage* blowFlagImage;

-(UIImage*)ballImage: (NSInteger)index;
-(void)drawHistoryEntry: (NSInteger)index;

@end

@implementation History

@synthesize ballImageNameList=ballImageNameList_;
@synthesize ballImageList=ballImageList_;
@synthesize historyList=historyList_;
@synthesize hitFlagImage=hitFlagImage_;
@synthesize blowFlagImage=blowFlagImage_;
@synthesize referenceLabel=referenceLabel_;
@synthesize digitalNumber=digitalNumber_;

- (void)setBallImageList:(NSMutableArray*)ballImageNameList{
	if(ballImageNameList_ != ballImageNameList){
		return;
	}
	[ballImageNameList_ release];
	ballImageNameList_ = ballImageNameList;
	[ballImageNameList_ retain];
	self.ballImageList = [NSMutableArray arrayWithCapacity: [ballImageNameList_ count]];
	for(int i = 0; i < [ballImageNameList_ count]; ++i){
		[self.ballImageList addObject: [NSNull null]];
	}
}

- (id)init{
	if((self = [super init]) != nil){
		self.historyList = [NSMutableArray arrayWithCapacity: 0];
		self.ballImageNameList = [NSArray arrayWithObjects:
								  @"ball_red.png",
								  @"ball_blue.png",
								  @"ball_green.png",
								  @"ball_yellow.png",
								  @"ball_pink.png",
								  @"ball_purple.png",
								  @"ball_black.png",
								  @"ball_aqua.png",
								  nil
								  ];
		self.hitFlagImage = [UIImage imageNamed: @"flag_black.png"];
		self.blowFlagImage = [UIImage imageNamed: @"flag_white.png"];
	}
	return self;
}

- (void)dealloc{
	self.ballImageList = nil;
	self.ballImageNameList = nil;
	self.historyList = nil;
	self.hitFlagImage = nil;
	self.blowFlagImage = nil;
	self.referenceLabel = nil;
	self.digitalNumber = nil;
	[super dealloc];
}

- (UIImage*)ballImage: (NSInteger)index{
	if(index < 0 || index >= [self.ballImageNameList count]){
		return nil;
	}
	if([self.ballImageList objectAtIndex: index] != nil){
		return [self.ballImageList objectAtIndex: index];
	}
	
	UIImage* image = [UIImage imageNamed: [self.ballImageNameList objectAtIndex: index]];
	[self.ballImageList replaceObjectAtIndex: index withObject: image];
	return image;
}


- (void)addHistory: (NSArray*)answer hits: (NSInteger)hits blows: (NSInteger)blows{
	HistoryEntry* entry = [[[HistoryEntry alloc] init] autorelease];
	entry.answer = answer;
	entry.hits = hits;
	entry.blows = blows;
	[self.historyList addObject: entry];
}

-(void)drawHistoryEntry: (NSInteger)index{
	CGFloat y = kHistoryEntryHeight * index + kHistoryEntryHeight / 2;
	
	// ターンの描画
	/*
	NSString* turn = [NSString stringWithFormat: @"%d", index + 1];
	UIFont* font = self.referenceLabel.font;
	CGSize size = [turn sizeWithFont: font];
	[turn drawAtPoint: CGPointMake(
								   self.referenceLabel.frame.origin.x
								   + self.referenceLabel.frame.size.width
								   - size.width,
								   y - size.height / 2
								   )
			 withFont: font
	 ];
	 */
	CGPoint drawPoint = CGPointMake(kTurnNumberX, y + kTurnNumberY);
	[self.digitalNumber drawValue: index + 1 atPoint: drawPoint];
	// 回答玉の描画	
	HistoryEntry* entry = [self.historyList objectAtIndex: index];
	for(NSInteger i = 0; i < [entry.answer count]; ++i){
		NSNumber* ballIndexNumber = [entry.answer objectAtIndex: i];
		NSInteger ballIndex = [ballIndexNumber integerValue];
		UIImage* image = [self ballImage: ballIndex];
		[image drawAtPoint: CGPointMake(
										kHistoryFirstBallX + kHistoryBallDistance * i - image.size.width / 2,
										y - image.size.height / 2
										)
		 ];
	}
	
	// 旗の描画
	NSInteger hits = entry.hits;
	NSInteger blows = entry.blows;
	for(NSInteger i = 0;; ++i){
		if(hits > 0){
			--hits;
			[self.hitFlagImage drawAtPoint: CGPointMake(
														kHistoryFirstFlagX + kHistoryFlagDistance * i - self.hitFlagImage.size.width / 2,
														y - self.hitFlagImage.size.height / 2
														)
			 ];
		}else if(blows > 0){
			--blows;
			[self.blowFlagImage drawAtPoint: CGPointMake(
														 kHistoryFirstFlagX + kHistoryFlagDistance * i - self.blowFlagImage.size.width / 2,
														 y - self.blowFlagImage.size.height / 2
														 )
			 ];
		}else{
			break;
		}
	}
}

- (UIImage*)getHistoryImage{
	NSInteger histories = [self.historyList count];
	if(histories == 0){
		return nil;
	}
	CGSize  size = CGSizeMake(kHistoryWidth, kHistoryEntryHeight * histories);
    UIGraphicsBeginImageContext(size);
	for(NSInteger i = 0; i < histories; ++i){
		[self drawHistoryEntry: i];
	}
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;	
}


@end
