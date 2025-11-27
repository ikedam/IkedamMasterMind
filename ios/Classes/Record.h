//
//  Record.h
//  MasterMind
//
//  Created by minidam on 11/07/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

struct SummedRecord{
	NSInteger games;
	NSInteger wins;
	float triesAvg;
	NSInteger triesMax;
	NSInteger triesMin;
	float uniqueTriesAvg;
	NSInteger uniqueTriesMax;
	NSInteger uniqueTriesMin;
	NSInteger elapsedAvg;
	NSInteger elapsedMax;
	NSInteger elapsedMin;
};

@interface Record : NSManagedObject {

}

@property(assign) NSInteger balls;
@property(assign) NSInteger elapsed;
@property(retain) NSDate* recordAt;
@property(assign) BOOL success;
@property(assign) NSInteger tries;
@property(assign) NSInteger uniqueTries;
@property(assign) BOOL finished;
@property(copy) NSString* answer;

+ (Record*)insertNewObject: (NSManagedObjectContext*)context;
- (void)deleteObject;
- (void)setAnswerByArray: (NSArray*)answerArray;
- (NSArray*)answerByArray;
+ (struct SummedRecord)sumRecordForBalls: (NSInteger)balls context: (NSManagedObjectContext*)context;
+ (NSInteger)getGamesForBalls: (NSInteger)balls context: (NSManagedObjectContext*)context;

@end
