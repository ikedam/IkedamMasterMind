//
//  HistoryEntry.h
//  MasterMind
//
//  Created by minidam on 11/07/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HistoryEntry : NSObject {
@private
	NSArray* answer_;
	NSInteger hits_;
	NSInteger blows_;
}

@property(retain) NSArray* answer;
@property(assign) NSInteger hits;
@property(assign) NSInteger blows;

@end
