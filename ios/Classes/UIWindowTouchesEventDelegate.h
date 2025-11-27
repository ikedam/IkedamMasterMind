//
//  TouchesEventDelegate.h
//  Omikuji2
//
//  Created by minidam on 11/01/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UIWindowTouchesEventDelegate<NSObject>
@optional
- (void)window:(UIWindow*)window touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)window:(UIWindow*)window touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)window:(UIWindow*)window touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)window:(UIWindow*)window touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
