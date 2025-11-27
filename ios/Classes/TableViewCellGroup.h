//
//  CellGroup.h
//  Attack
//
//  Created by minidam on 11/05/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"


@interface TableViewCellGroup : NSObject {
@private
	NSString* title_;
	NSArray* cellList_;
	UIView* footerView_;
}

@property(copy,readonly) NSString* title;
@property(retain,readonly) NSArray* cellList;
@property(retain,readonly) UIView* footerView;

+ (id)cellGroupTitle: (NSString*)title
			   cells: (TableViewCell*)firstCell, ...;

+ (id)cellGroupTitle: (NSString*)title
		  footerView: (UIView*)footerView
			   cells: (TableViewCell*)firstCell, ...;

@end
