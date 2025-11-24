//
//  HistoryEntry.m
//  MasterMind
//
//  Created by minidam on 11/07/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryEntry.h"


@implementation HistoryEntry

@synthesize answer=answer_;
@synthesize hits=hits_;
@synthesize blows=blows_;

-(void)dealloc{
	self.answer = nil;
	[super dealloc];
}

@end
