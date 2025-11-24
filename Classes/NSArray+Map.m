//
//  NSArray+Map.m
//  MasterMind
//
//  Created by minidam on 11/09/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Map.h"


@implementation NSArray (Map)

- (NSArray *)map:(id (^)(id object))block{
	NSMutableArray *newArray = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id item,NSUInteger idx,BOOL *stop){
		id obj = block(item);
		[newArray addObject:obj];
	}];
	return newArray;
}

@end
