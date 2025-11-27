//
//  TriedAnswer.m
//  MasterMind
//
//  Created by minidam on 11/09/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TriedAnswer.h"
#import "GlobalUtility.h"
#import "NSArray+Map.h"


@implementation TriedAnswer

@dynamic answer;

static NSString* entityName = @"TriedAnswer";


-(NSInteger)turn{
	NSNumber* turn = [self valueForKey: @"turn_"];
	return [turn integerValue];
}

-(void)setTurn:(NSInteger)turn{
	[self setValue: [NSNumber numberWithInteger: turn] forKey: @"turn_"];
}

-(NSInteger)hits{
	NSNumber* hits = [self valueForKey: @"hits_"];
	return [hits integerValue];
}

-(void)setHits:(NSInteger)hits{
	[self setValue: [NSNumber numberWithInteger: hits] forKey: @"hits_"];
}

-(NSInteger)blows{
	NSNumber* blows = [self valueForKey: @"blows_"];
	return [blows integerValue];
}

-(void)setBlows:(NSInteger)blows{
	[self setValue: [NSNumber numberWithInteger: blows] forKey: @"blows_"];
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
+ (TriedAnswer*)insertNewObject: (NSManagedObjectContext*)context{
	return [NSEntityDescription insertNewObjectForEntityForName: entityName
										 inManagedObjectContext:context
			];
}

// すべてのオブジェクトを削除
+ (void)deleteAllObject: (NSManagedObjectContext*)context{
	// 全オブジェクトを取得
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity: [NSEntityDescription
							  entityForName:entityName
							  inManagedObjectContext:context
							  ]];
	
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
	}
	
	// 片っ端から削除
	for(TriedAnswer* triedAnswer in items){
        [context deleteObject: triedAnswer];
    }
}

// 重複チェック
- (BOOL)isDuplicate{
	// 条件にマッチするオブジェクトを取得
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity: [NSEntityDescription
							  entityForName: entityName
							  inManagedObjectContext: [self managedObjectContext]
							  ]];
	// 条件の設定。
	// 自分よりも若いレコードで、同じ回答のデータが存在するか？
	NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
							  [NSArray arrayWithObjects:
							   [NSPredicate predicateWithFormat: @"turn_ < %d", self.turn],
							   [NSPredicate predicateWithFormat: @"answer = %@", self.answer],
							   nil
							   ]
							  ];
	[fetchRequest setPredicate: predicate];
	
	
    NSError* error = nil;
    NSArray* items = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	if(error != nil){
		/*
		@throw [NSException exceptionWithName: @"CoreDataException"
									   reason: [error localizedDescription]
									 userInfo: [NSDictionary dictionaryWithObject: error forKey: @"error"]
				];
		 */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[GlobalUtility fatalError: [error localizedDescription]];
		return NO;
	}
	
	return [items count] > 0;
}

+ (NSArray*)fetchAll: (NSManagedObjectContext*)managedObjectContext{
	// 全オブジェクトを取得
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity: [NSEntityDescription
							  entityForName:entityName
							  inManagedObjectContext: managedObjectContext
							  ]];
	
	// ソート順序
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"turn_"
																	ascending:YES
										 ] autorelease];
	[fetchRequest setSortDescriptors: [NSArray arrayWithObjects: sortDescriptor, nil]];
	
    NSError* error = nil;
    NSArray* items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if(error != nil){
		/*
		 @throw [NSException exceptionWithName: @"CoreDataException"
		 reason: [error localizedDescription]
		 userInfo: [NSDictionary dictionaryWithObject: error forKey: @"error"]
		 ];
		 */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[GlobalUtility fatalError: [error localizedDescription]];
	}
	
	return items;
}

@end
