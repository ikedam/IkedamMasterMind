//
//  ScorePageController.m
//  MasterMind
//
//  Created by minidam on 11/09/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScorePageController.h"
#import "Record.h"
#import "GlobalUtility.h"

@interface ScorePageController ();

+(NSArray*)smallNumImageList;
+(NSArray*)largeNumImageList;
-(void)updateBalls;

@property(retain) DigitalNumber* ballNumber;
@property(retain) DigitalNumber* gameNumber;
@property(retain) DigitalNumber* winNumber;
@property(retain) DigitalNumber* winRateIntNumber;
@property(retain) DigitalNumber* winRateFracNumber;
@property(retain) DigitalNumber* triesAvgIntNumber;
@property(retain) DigitalNumber* triesAvgFracNumber;
@property(retain) DigitalNumber* triesMaxNumber;
@property(retain) DigitalNumber* triesMinNumber;
@property(retain) DigitalNumber* elapsedAvgMinNumber;
@property(retain) DigitalNumber* elapsedAvgSecNumber;
@property(retain) DigitalNumber* elapsedMaxMinNumber;
@property(retain) DigitalNumber* elapsedMaxSecNumber;
@property(retain) DigitalNumber* elapsedMinMinNumber;
@property(retain) DigitalNumber* elapsedMinSecNumber;

@property(assign) NSInteger games;
@property(assign) NSInteger wins;
@property(assign) float triesAvg;
@property(assign) NSInteger triesMax;
@property(assign) NSInteger triesMin;
@property(assign) NSInteger elapsedAvg;
@property(assign) NSInteger elapsedMax;
@property(assign) NSInteger elapsedMin;

@end

@implementation ScorePageController

@synthesize view=view_;
@synthesize managedObjectContext=managedObjectContext_;
@synthesize balls=balls_;
@synthesize ballNumber=ballNumber_;
@synthesize gameNumber=gameNumber_;
@synthesize winNumber=winNumber_;
@synthesize winRateIntNumber=winRateIntNumber_;
@synthesize winRateFracNumber=winRateFracNumber_;
@synthesize triesAvgIntNumber=triesAvgIntNumber_;
@synthesize triesAvgFracNumber=triesAvgFracNumber_;
@synthesize triesMaxNumber=triesMaxNumber_;
@synthesize triesMinNumber=triesMinNumber_;
@synthesize elapsedAvgMinNumber=elapsedAvgMinNumber_;
@synthesize elapsedAvgSecNumber=elapsedAvgSecNumber_;
@synthesize elapsedMaxMinNumber=elapsedMaxMinNumber_;
@synthesize elapsedMaxSecNumber=elapsedMaxSecNumber_;
@synthesize elapsedMinMinNumber=elapsedMinMinNumber_;
@synthesize elapsedMinSecNumber=elapsedMinSecNumber_;

@synthesize games=games_;
@synthesize wins=wins_;
@synthesize triesAvg=triesAvg_;
@synthesize triesMax=triesMax_;
@synthesize triesMin=triesMin_;
@synthesize elapsedAvg=elapsedAvg_;
@synthesize elapsedMax=elapsedMax_;
@synthesize elapsedMin=elapsedMin_;

static NSMutableArray* smallNumImageList_ = nil;
static NSMutableArray* largeNumImageList_ = nil;

+(NSArray*)smallNumImageList{
	if(smallNumImageList_ != nil){
		return smallNumImageList_;
	}
	
	smallNumImageList_ = [[NSMutableArray arrayWithCapacity: 10] retain];
	for(int i = 0; i < 10; ++i){
		NSString* imageName = [NSString stringWithFormat: @"score_num_small%d", i];
		[smallNumImageList_ addObject: [UIImage imageNamed: imageName]];
	}
	return smallNumImageList_;
}

+(NSArray*)largeNumImageList{
	if(largeNumImageList_ != nil){
		return largeNumImageList_;
	}
	
	largeNumImageList_ = [[NSMutableArray arrayWithCapacity: 10] retain];
	for(int i = 0; i < 10; ++i){
		NSString* imageName = [NSString stringWithFormat: @"score_num_large%d", i];
		[largeNumImageList_ addObject: [UIImage imageNamed: imageName]];
	}
	return largeNumImageList_;
}

- (id)init{
	if((self = [super init]) != nil){
		[[NSBundle mainBundle] loadNibNamed: @"ScorePageController"
									  owner: self
									options: nil
		 ];
		
		// 玉の数
		self.ballNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController largeNumImageList]
														   width: 20
														  height: 30
															 gap: 0
														 figures: 1
													fillWithZero: NO
							] autorelease];
		[self.view.layer addSublayer: self.ballNumber.layer];
		self.ballNumber.layer.position = CGPointMake(90, 7);
		
		NSInteger fixX = 3;
		// 挑戦回数
		self.gameNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
														   width: 13
														  height: 20
															 gap: 0
														 figures: 3
													fillWithZero: NO
							] autorelease];
		[self.view.layer addSublayer: self.gameNumber.layer];
		self.gameNumber.layer.position = CGPointMake(210 + fixX, 72);
		
		// クリア回数
		self.winNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
														  width: 13
														 height: 20
															gap: 0
														figures: 3
												   fillWithZero: NO
						   ] autorelease];
		[self.view.layer addSublayer: self.winNumber.layer];
		self.winNumber.layer.position = CGPointMake(210 + fixX, 102);
		
		// 勝率(整数)
		self.winRateIntNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																 width: 13
																height: 20
																   gap: 0
															   figures: 3
														  fillWithZero: NO
								  ] autorelease];
		[self.view.layer addSublayer: self.winRateIntNumber.layer];
		self.winRateIntNumber.layer.position = CGPointMake(179 + fixX, 131);
		
		// 勝率(小数)
		self.winRateFracNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																  width: 13
																 height: 20
																	gap: 0
																figures: 1
														   fillWithZero: NO
								   ] autorelease];
		[self.view.layer addSublayer: self.winRateFracNumber.layer];
		self.winRateFracNumber.layer.position = CGPointMake(222 + fixX, 131);
		
		// クリア手数(平均.整数)
		self.triesAvgIntNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																  width: 13
																 height: 20
																	gap: 0
																figures: 3
														   fillWithZero: NO
								   ] autorelease];
		[self.view.layer addSublayer: self.triesAvgIntNumber.layer];
		self.triesAvgIntNumber.layer.position = CGPointMake(194 + fixX, 190);
		
		// クリア手数(平均.小数)
		self.triesAvgFracNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																   width: 13
																  height: 20
																	 gap: 0
																 figures: 1
															fillWithZero: NO
									] autorelease];
		[self.view.layer addSublayer: self.triesAvgFracNumber.layer];
		self.triesAvgFracNumber.layer.position = CGPointMake(238 + fixX, 190);
		
		// クリア手数最大
		self.triesMaxNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
															   width: 13
															  height: 20
																 gap: 0
															 figures: 3
														fillWithZero: NO
								] autorelease];
		[self.view.layer addSublayer: self.triesMaxNumber.layer];
		self.triesMaxNumber.layer.position = CGPointMake(209 + fixX, 220);
		
		// クリア手数最小
		self.triesMinNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
															   width: 13
															  height: 20
																 gap: 0
															 figures: 3
														fillWithZero: NO
								] autorelease];
		[self.view.layer addSublayer: self.triesMinNumber.layer];
		self.triesMinNumber.layer.position = CGPointMake(209 + fixX, 250);
		
		// クリア時間平均(分)
		self.elapsedAvgMinNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																 width: 13
																height: 20
																   gap: 0
															   figures: 2
														  fillWithZero: YES
								  ] autorelease];
		[self.view.layer addSublayer: self.elapsedAvgMinNumber.layer];
		self.elapsedAvgMinNumber.layer.position = CGPointMake(194 + fixX, 309);
		
		// クリア時間平均(秒)
		self.elapsedAvgSecNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																 width: 13
																height: 20
																   gap: 0
															   figures: 2
														  fillWithZero: YES
								  ] autorelease];
		[self.view.layer addSublayer: self.elapsedAvgSecNumber.layer];
		self.elapsedAvgSecNumber.layer.position = CGPointMake(225 + fixX, 309);
		
		// クリア時間最大(分)
		self.elapsedMaxMinNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																	width: 13
																   height: 20
																	  gap: 0
																  figures: 2
															 fillWithZero: YES
									 ] autorelease];
		[self.view.layer addSublayer: self.elapsedMaxMinNumber.layer];
		self.elapsedMaxMinNumber.layer.position = CGPointMake(194 + fixX, 338);
		
		// クリア時間最大(秒)
		self.elapsedMaxSecNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																	width: 13
																   height: 20
																	  gap: 0
																  figures: 2
															 fillWithZero: YES
									 ] autorelease];
		[self.view.layer addSublayer: self.elapsedMaxSecNumber.layer];
		self.elapsedMaxSecNumber.layer.position = CGPointMake(225 + fixX, 338);
		
		// クリア時間平均(分)
		self.elapsedMinMinNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																	width: 13
																   height: 20
																	  gap: 0
																  figures: 2
															 fillWithZero: YES
									 ] autorelease];
		[self.view.layer addSublayer: self.elapsedMinMinNumber.layer];
		self.elapsedMinMinNumber.layer.position = CGPointMake(194 + fixX, 368);
		
		// クリア時間平均(秒)
		self.elapsedMinSecNumber = [[[DigitalNumber alloc] initWithImages: [ScorePageController smallNumImageList]
																	width: 13
																   height: 20
																	  gap: 0
																  figures: 2
															 fillWithZero: YES
									 ] autorelease];
		[self.view.layer addSublayer: self.elapsedMinSecNumber.layer];
		self.elapsedMinSecNumber.layer.position = CGPointMake(225 + fixX, 368);
	}
	return self;
}

- (void)dealloc {
	self.ballNumber = nil;
	self.gameNumber = nil;
	self.winNumber = nil;
	self.winRateIntNumber = nil;
	self.winRateFracNumber = nil;
	self.triesAvgIntNumber = nil;
	self.triesAvgFracNumber = nil;
	self.triesMaxNumber = nil;
	self.triesMinNumber = nil;
	self.elapsedAvgMinNumber = nil;
	self.elapsedAvgSecNumber = nil;
	self.elapsedMaxMinNumber = nil;
	self.elapsedMaxSecNumber = nil;
	self.elapsedMinMinNumber = nil;
	self.elapsedMinSecNumber = nil;
	self.view = nil;
	self.managedObjectContext = nil;
    [super dealloc];
}

- (void)setBalls: (NSInteger)balls{
	if(balls_ == balls){
		return;
	}
	balls_ = balls;
	[self updateBalls];
}

- (void)updateBalls{
	if(self.balls >= 0){
		self.view.hidden = NO;
		[self.ballNumber setValueWithoutAnimation: self.balls];
		struct SummedRecord sum = [Record sumRecordForBalls: self.balls
													context: self.managedObjectContext
								   ];
		self.games = sum.games;
		self.wins = sum.wins;
		self.triesAvg = sum.triesAvg;
		self.triesMax = sum.triesMax;
		self.triesMin = sum.triesMin;
		self.elapsedAvg = sum.elapsedAvg;
		self.elapsedMax = sum.elapsedMax;
		self.elapsedMin = sum.elapsedMin;
	}else{
		self.view.hidden = YES;
	}
}

- (void)setGames:(NSInteger)games{
	games_ = games;
	[self.gameNumber setValueWithoutAnimation: games];
}

// 事前にsetGamesが実行されていることが前提
- (void)setWins:(NSInteger)wins{
	wins_ = wins;
	[self.winNumber setValueWithoutAnimation: wins];
	
	// 勝率の計算
	NSInteger rateInt = 0;
	NSInteger rateFrac = 0;
	if(self.games > 0){
		// 四捨五入
		NSInteger rate = self.wins * 10000 / self.games + 5;
		rateInt = rate / 100;
		rateFrac = rate / 10 % 10;
	}
	[self.winRateIntNumber setValueWithoutAnimation: rateInt];
	[self.winRateFracNumber setValueWithoutAnimation: rateFrac];
}

- (void)setTriesAvg: (float)triesAvg{
	triesAvg_ = triesAvg;
	
	NSInteger triesAvgInt = (NSInteger)(triesAvg);
	NSInteger triesAvgFrac = (NSInteger)(triesAvg * 10 + 0.5) % 10;
	
	[self.triesAvgIntNumber setValueWithoutAnimation: triesAvgInt];
	[self.triesAvgFracNumber setValueWithoutAnimation: triesAvgFrac];
}

- (void)setTriesMax: (NSInteger)triesMax{
	triesMax_ = triesMax;
	
	[self.triesMaxNumber setValueWithoutAnimation: triesMax];
}

- (void)setTriesMin: (NSInteger)triesMin{
	triesMin_ = triesMin;
	
	[self.triesMinNumber setValueWithoutAnimation: triesMin];
}

- (void)setElapsedAvg:(NSInteger)elapsedAvg{
	elapsedAvg_ = elapsedAvg;
	
	[GlobalUtility setElapsed: elapsedAvg
			 minDigitalNumber: self.elapsedAvgMinNumber
			 secDigitalNumber: self.elapsedAvgSecNumber
					 animated: NO
	 ];
}

- (void)setElapsedMax:(NSInteger)elapsedMax{
	elapsedMax_ = elapsedMax;
	
	[GlobalUtility setElapsed: elapsedMax
			 minDigitalNumber: self.elapsedMaxMinNumber
			 secDigitalNumber: self.elapsedMaxSecNumber
					 animated: NO
	 ];
}

- (void)setElapsedMin:(NSInteger)elapsedMin{
	elapsedMin_ = elapsedMin;
	
	[GlobalUtility setElapsed: elapsedMin
			 minDigitalNumber: self.elapsedMinMinNumber
			 secDigitalNumber: self.elapsedMinSecNumber
					 animated: NO
	 ];
}

@end
