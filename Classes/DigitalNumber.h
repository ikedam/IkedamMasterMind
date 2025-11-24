//
//  DigitalNumber.h
//  Attack
//
//  Created by minidam on 11/05/07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface DigitalNumber : NSObject {
@private
	NSArray* images_;
	NSInteger width_;
	NSInteger height_;
	NSInteger gap_;
	NSInteger figures_;
	BOOL fillWithZero_;
	CALayer* layer_;
	
	NSMutableArray* figureLayers_;
	
	NSInteger value_;
}

@property(retain,readonly) CALayer* layer;	// 数字が表示されるレイヤ
@property(assign) NSInteger value;	// 表示する/されている値

- (id)initWithImages: (NSArray*)images
			   width: (NSInteger)width
			  height: (NSInteger)height
				 gap: (NSInteger)gap
			 figures: (NSInteger)figures
		fillWithZero: (BOOL)fillWithZero;

- (void)setValueWithoutAnimation:(NSInteger)value;
- (void)drawValue: (NSInteger)value atPoint: (CGPoint)pt;


@end
