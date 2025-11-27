//
//  TableViewCell.h
//  Attack
//
//  Created by minidam on 11/05/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCell;

@interface TableViewCell : NSObject {
@private
	UITableViewCell* cell_;
	void (^didClicked_)(TableViewCell*);
}

@property(retain, readonly) UITableViewCell* cell;
@property(copy, readonly) void (^didClicked)(TableViewCell*);

+(id)cellFor: (UITableViewCell*)cell;
+(id)cellFor: (UITableViewCell*)cell didClicked: (void(^)(TableViewCell*))didClicked;

@end
