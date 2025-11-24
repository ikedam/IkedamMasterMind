//
//  UIBlockAlertView.m
//  MasterMind
//
//  Created by minidam on 11/06/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIBlockAlertView.h"


@implementation UIBlockAlertView

@synthesize clickedButtonAtIndex=clickedButtonAtIndex_;

+ (id)alertViewWithTitle:(NSString *)title
				 message:(NSString *)message
	   cancelButtonTitle:(NSString *)cancelButtonTitle
		otherButtonTitle:(NSString *)otherButtonTitle{
	UIBlockAlertView* this = [self alloc];
	return [[this initWithTitle: title
						message: message
					   delegate: this
			  cancelButtonTitle: cancelButtonTitle
			  otherButtonTitles: otherButtonTitle, nil
			 ] autorelease];
}

+ (id)alertViewWithTitle:(NSString *)title
				 message:(NSString *)message
	clickedButtonAtIndex:(void(^)(UIBlockAlertView*, NSInteger))clickedButtonAtIndex
	   cancelButtonTitle:(NSString *)cancelButtonTitle
		otherButtonTitle:(NSString *)otherButtonTitle{
	UIBlockAlertView* this = [self alertViewWithTitle: title
											  message: message
									cancelButtonTitle: cancelButtonTitle
									 otherButtonTitle: otherButtonTitle
							  ];
	if(this != nil){
		this.clickedButtonAtIndex = clickedButtonAtIndex;
	}
	return this;									  
}

- (void)dealloc{
	self.clickedButtonAtIndex = nil;
	[super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(self.clickedButtonAtIndex != nil){
		(self.clickedButtonAtIndex)((UIBlockAlertView*)alertView, buttonIndex);
	}
}

@end
