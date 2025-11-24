//
//  UIBlockAlertView.h
//  MasterMind
//
//  Created by minidam on 11/06/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class UIBlockAlertView;

@interface UIBlockAlertView : UIAlertView<UIAlertViewDelegate> {
@private
	void(^clickedButtonAtIndex_)(UIBlockAlertView*, NSInteger);
}

@property(copy) void(^clickedButtonAtIndex)(UIBlockAlertView*, NSInteger);

+ (id)alertViewWithTitle:(NSString *)title
				 message:(NSString *)message
	clickedButtonAtIndex:(void(^)(UIBlockAlertView*, NSInteger))clickedButtonAtIndex
	   cancelButtonTitle:(NSString *)cancelButtonTitle
		otherButtonTitle:(NSString *)otherButtonTitle;

+ (id)alertViewWithTitle:(NSString *)title
				 message:(NSString *)message
	   cancelButtonTitle:(NSString *)cancelButtonTitle
		otherButtonTitle:(NSString *)otherButtonTitle;
	
@end
