//
//  TriedAnswer.h
//  MasterMind
//
//  Created by minidam on 11/09/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface TriedAnswer : NSManagedObject {

}

@property(assign) NSInteger turn;
@property(assign) NSInteger hits;
@property(assign) NSInteger blows;
@property(copy) NSString* answer; 

+ (TriedAnswer*)insertNewObject: (NSManagedObjectContext*)context;
+ (void)deleteAllObject: (NSManagedObjectContext*)context;
- (BOOL)isDuplicate;
- (void)setAnswerByArray: (NSArray*)answerArray;
- (NSArray*)answerByArray;
+ (NSArray*)fetchAll: (NSManagedObjectContext*)managedObjectContext;

@end
