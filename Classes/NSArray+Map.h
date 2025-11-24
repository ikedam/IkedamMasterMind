//
//  NSArray+Map.h
//  MasterMind
//
//  Created by minidam on 11/09/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Map);

- (NSArray *)map:(id (^)(id object))block;

@end
