//
//  Record.m
//  MasterMind
//
//  Created by minidam on 11/07/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Record.h"
#import "NSArray+Map.h"
#import "GlobalUtility.h"


@implementation Record

@dynamic recordAt;
@dynamic answer;

static NSString* entityName = @"Record";

-(NSInteger)balls{
	NSNumber* balls = [self valueForKey: @"balls_"];
	return [balls integerValue];
}

-(void)setBalls:(NSInteger)balls{
	[self setValue: [NSNumber numberWithInteger: balls] forKey: @"balls_"];
}

-(NSInteger)elapsed{
	NSNumber* elapsed = [self valueForKey: @"elapsed_"];
	return [elapsed integerValue];
}

-(void)setElapsed:(NSInteger)elapsed{
	[self setValue: [NSNumber numberWithInteger: elapsed] forKey: @"elapsed_"];
}

-(BOOL)success{
	NSNumber* success = [self valueForKey: @"success_"];
	return [success boolValue];
}

-(void)setSuccess:(BOOL)success{
	[self setValue: [NSNumber numberWithBool: success] forKey: @"success_"];
}

-(NSInteger)tries{
	NSNumber* tries = [self valueForKey: @"tries_"];
	return [tries integerValue];
}

-(void)setTries:(NSInteger)tries{
	[self setValue: [NSNumber numberWithInteger: tries] forKey: @"tries_"];
}

-(NSInteger)uniqueTries{
	NSNumber* uniqueTries = [self valueForKey: @"uniqueTries_"];
	return [uniqueTries integerValue];
}

-(void)setUniqueTries:(NSInteger)uniqueTries{
	[self setValue: [NSNumber numberWithInteger: uniqueTries] forKey: @"uniqueTries_"];
}

-(BOOL)finished{
	NSNumber* finished = [self valueForKey: @"finished_"];
	return [finished boolValue];
}

-(void)setFinished:(BOOL)finished{
	[self setValue: [NSNumber numberWithBool: finished] forKey: @"finished_"];
}

- (void)setAnswerByArray: (NSArray*)answerArray{
	self.answer = [[answerArray map: ^(id obj){
		return [NSString stringWithFormat: @"%d", [(NSNumber*)obj integerValue]];
	}] componentsJoinedByString: @","];
}

- (NSArray*)answerByArray{
	return [[self.answer componentsSeparatedByString: @","]
			map: ^(id obj){return (id)[NSNumber numberWithInteger: [(NSString*)obj integerValue]];}
			];
}

// 新しいオブジェクトを作成する
+ (Record*)insertNewObject: (NSManagedObjectContext*)context{
	return [NSEntityDescription insertNewObjectForEntityForName: entityName
										 inManagedObjectContext: context
			];
}

- (void)deleteObject{
	[[self managedObjectContext] deleteObject: self];
}


// レコードの全合計値を求める
+(NSInteger)getGamesForBalls: (NSInteger)balls context: (NSManagedObjectContext*)context{
	// 条件にマッチするオブジェクトを取得
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity: [NSEntityDescription
							  entityForName: entityName
							  inManagedObjectContext: context
							  ]
	 ];
	
	// 条件の設定。
	// ボールの数が一致
	//  かつ
	// 終了している
	NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
							  [NSArray arrayWithObjects:
							   [NSPredicate predicateWithFormat: @"balls_ == %d", balls],
							   [NSPredicate predicateWithFormat: @"finished_ == YES"],
							   nil
							   ]
							  ];
	[fetchRequest setPredicate: predicate];
	
	
    NSError* error = nil;
	NSInteger count = [context countForFetchRequest: fetchRequest error: &error];
	if(error != nil){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[GlobalUtility fatalError: [error localizedDescription]];
		return 0;
	}
	if(count == NSNotFound){
		count = 0;
	}
	
	return count;
}

// 合計値を求める
+(struct SummedRecord)sumRecordForBalls: (NSInteger)balls context: (NSManagedObjectContext*)context{
	struct SummedRecord sum = {0};
	
	sum.games = [self getGamesForBalls: balls context: context];
	
	if(sum.games == 0){
		// そもそもゲーム回数が0なのですることがない。
		return sum;
	}
	
	// クリアしたゲームについて集計
	// 条件にマッチするオブジェクトを取得
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity: [NSEntityDescription
							  entityForName: entityName
							  inManagedObjectContext: context
							  ]
	 ];
	
	// 集計関数の指定。
	NSMutableArray* fields = [NSMutableArray arrayWithCapacity: 0];
	// 全件数
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"recordAt"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"count:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"wins"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSInteger16AttributeType];
		
		[fields addObject: desc];
	}
	
	// 平均手数
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"tries_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"average:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"triesAvg"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSFloatAttributeType];
		
		[fields addObject: desc];
	}
	
	// 最大手数
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"tries_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"max:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"triesMax"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSInteger16AttributeType];
		
		[fields addObject: desc];
	}
	
	// 最小手数
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"tries_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"min:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"triesMin"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSInteger16AttributeType];
		
		[fields addObject: desc];
	}
	
	// 平均ユニーク手数
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"uniqueTries_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"average:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"uniqueTriesAvg"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSFloatAttributeType];
		
		[fields addObject: desc];
	}
	
	// 最大ユニーク手数
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"uniqueTries_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"max:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"uniqueTriesMax"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSInteger16AttributeType];
		
		[fields addObject: desc];
	}
	
	// 最小ユニーク手数
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"uniqueTries_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"min:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"uniqueTriesMin"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSInteger16AttributeType];
		
		[fields addObject: desc];
	}
	
	// 平均時間
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"elapsed_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"average:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"elapsedAvg"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSInteger32AttributeType];
		
		[fields addObject: desc];
	}
	
	// 最大時間
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"elapsed_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"max:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"elapsedMax"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSInteger32AttributeType];
		
		[fields addObject: desc];
	}
	
	// 最小時間
	{
		NSExpression* keyPathExpression = [NSExpression expressionForKeyPath: @"elapsed_"];
		NSExpression* expression =
		[NSExpression expressionForFunction: @"min:"
								  arguments: [NSArray arrayWithObject:keyPathExpression]
		 ];
		
		NSExpressionDescription* desc = [[[NSExpressionDescription alloc] init] autorelease];
		[desc setName: @"elapsedMin"];
		[desc setExpression: expression];
		[desc setExpressionResultType: NSInteger32AttributeType];
		
		[fields addObject: desc];
	}
	
	// 条件の設定。
	// 終了している
	// クリアしている
	// 玉の数が一致している
	NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
							  [NSArray arrayWithObjects:
							   [NSPredicate predicateWithFormat: @"balls_ == %d", balls],
							   [NSPredicate predicateWithFormat: @"finished_ == YES"],
							   [NSPredicate predicateWithFormat: @"success_ == YES"],
							   nil
							   ]
							  ];
	[fetchRequest setPredicate: predicate];
	
	[fetchRequest setResultType: NSDictionaryResultType];
	[fetchRequest setPropertiesToFetch: fields];
	
    NSError* error = nil;
    NSArray* items = [context executeFetchRequest:fetchRequest error:&error];
	if(error != nil){
		/*
		 @throw [NSException exceptionWithName: @"CoreDataException"
		 reason: [error localizedDescription]
		 userInfo: [NSDictionary dictionaryWithObject: error forKey: @"error"]
		 ];
		 */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[GlobalUtility fatalError: [error localizedDescription]];
		return sum;
	}
	
	sum.wins = [[[items objectAtIndex: 0] valueForKey: @"wins"] integerValue];
	sum.triesAvg = [[[items objectAtIndex: 0] valueForKey: @"triesAvg"] floatValue];
	sum.triesMax = [[[items objectAtIndex: 0] valueForKey: @"triesMax"] integerValue];
	sum.triesMin = [[[items objectAtIndex: 0] valueForKey: @"triesMin"] integerValue];
	sum.uniqueTriesAvg = [[[items objectAtIndex: 0] valueForKey: @"uniqueTriesAvg"] floatValue];
	sum.uniqueTriesMax = [[[items objectAtIndex: 0] valueForKey: @"uniqueTriesMax"] integerValue];
	sum.uniqueTriesMin = [[[items objectAtIndex: 0] valueForKey: @"uniqueTriesMin"] integerValue];
	sum.elapsedAvg = [[[items objectAtIndex: 0] valueForKey: @"elapsedAvg"] integerValue];
	sum.elapsedMax = [[[items objectAtIndex: 0] valueForKey: @"elapsedMax"] integerValue];
	sum.elapsedMin = [[[items objectAtIndex: 0] valueForKey: @"elapsedMin"] integerValue];
	
	return sum;
}

@end
