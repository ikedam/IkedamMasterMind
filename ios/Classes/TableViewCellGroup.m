//
//  CellGroup.m
//  Attack
//
//  Created by minidam on 11/05/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewCellGroup.h"

@interface TableViewCellGroup ();

@property(copy,readwrite) NSString* title;
@property(retain,readwrite) NSArray* cellList;
@property(retain,readwrite) UIView* footerView;

+ (id)cellGroupTitle: (NSString*)title
		  footerView: (UIView*)footerView
		   firstCell: (TableViewCell*)firstCell
		  otherCells: (va_list)argumentList; 

@end

@implementation TableViewCellGroup

@synthesize title=title_;
@synthesize cellList=cellList_;
@synthesize footerView=footerView_;

+ (id)cellGroupTitle: (NSString*)title
			   cells: (TableViewCell*)firstCell, ...{
	va_list argumentList;
	va_start(argumentList, firstCell);
	TableViewCellGroup* cellGroup = [self cellGroupTitle: title
									 footerView: nil
									  firstCell: firstCell
									 otherCells: argumentList
							];
	va_end(argumentList);
	return cellGroup;
}

+ (id)cellGroupTitle: (NSString*)title
		  footerView: (UIView*)footerView
			   cells: (TableViewCell*)firstCell, ...{
	va_list argumentList;
	va_start(argumentList, firstCell);
	TableViewCellGroup* cellGroup = [self cellGroupTitle: title
									 footerView: footerView
									  firstCell: firstCell
									 otherCells: argumentList
							];
	va_end(argumentList);
	return cellGroup;
}

+ (id)cellGroupTitle: (NSString*)title
		  footerView: (UIView*)footerView
		   firstCell: (TableViewCell*)firstCell
		  otherCells: (va_list)argumentList{
	TableViewCell* eachCell;
	TableViewCellGroup* cellGroup = [[[TableViewCellGroup alloc] init] autorelease];
	if(cellGroup != nil){
		cellGroup.title = title;
		cellGroup.footerView = footerView;
		NSMutableArray* cellList = [NSMutableArray arrayWithCapacity: 0];
		if(firstCell != nil){
			[cellList addObject: firstCell];
			while(eachCell = va_arg(argumentList, TableViewCell*)){
				[cellList addObject: eachCell];
			}
		}
		cellGroup.cellList = [NSArray arrayWithArray: cellList];
	}	
	return cellGroup;
}

-(void)dealloc{
	self.title = nil;
	self.cellList = nil;
	self.footerView = nil;
	
	[super dealloc];
}

@end
