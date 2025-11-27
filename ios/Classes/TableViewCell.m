//
//  TableViewCell.m
//  Attack
//
//  Created by minidam on 11/05/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ();

@property(retain, readwrite) UITableViewCell* cell;
@property(copy, readwrite) void (^didClicked)(TableViewCell*);


@end

@implementation TableViewCell

@synthesize cell=cell_;
@synthesize didClicked=didClicked_;

+(id)cellFor: (UITableViewCell*)cell didClicked: (void(^)(TableViewCell*))didClicked{
	TableViewCell* obj = [[[TableViewCell alloc] init] autorelease];
	if(obj != nil){
		obj.cell = cell;
		obj.didClicked = didClicked;
	}
	
	return obj;
}

+(id)cellFor: (UITableViewCell*)cell{
	return [self cellFor: cell didClicked: nil];
}


-(void)dealloc{
	self.cell = nil;
	self.didClicked = nil;
	[super dealloc];
}
@end
