//
//  DigitalNumber.m
//  Attack
//
//  Created by minidam on 11/05/07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DigitalNumber.h"

@interface DigitalNumber();

@property(retain) NSArray* images;	// 画像のリスト
@property(assign) NSInteger width;	// 1文字の幅
@property(assign) NSInteger height;	// 1文字の高さ
@property(assign) NSInteger gap;	// 文字の間の間隔
@property(assign) NSInteger figures;	// 桁数
@property(assign) BOOL fillWithZero;	// 先頭のゼロを表示するか？
@property(retain) CALayer* layer;	// 大本のレイヤ
@property(retain) NSMutableArray* figureLayers;	// 各数字を表示しているレイヤ。下の桁から順に入っている。

- (void)buildLayers;
- (void)updateFigure;

@end

@implementation DigitalNumber

@synthesize images=images_;
@synthesize width=width_;
@synthesize height=height_;
@synthesize gap=gap_;
@synthesize figures=figures_;
@synthesize layer=layer_;
@synthesize figureLayers=figureLayers_;
@synthesize fillWithZero=fillWithZero_;

- (id)initWithImages: (NSArray*)images
			   width: (NSInteger)width
			  height: (NSInteger)height
				 gap: (NSInteger)gap
			 figures: (NSInteger)figures
		fillWithZero: (BOOL)fillWithZero
{
	if((self = [self init]) != nil){
		self.images = images;
		self.width = width;
		self.height = height;
		self.gap = gap;
		self.figures = figures;
		self.fillWithZero = fillWithZero;
		self.figureLayers = [NSMutableArray arrayWithCapacity: self.figures];
		[self buildLayers];
		value_ = -1;
		//[self updateFigure];
	}
	return self;
}

- (void)dealloc{
	self.images = nil;
	self.figureLayers = nil;
	[self.layer removeFromSuperlayer];
	self.layer = nil;
	
	[super dealloc];
}


// レイヤの初期化
- (void)buildLayers{
	// 大本のレイヤの作成
	int width = self.width * self.figures + self.gap * (self.figures - 1);
	int height = self.height;
	self.layer = [CALayer layer];
	self.layer.anchorPoint = CGPointMake(0, 0);
	self.layer.frame = CGRectMake(0,
								  0,
								  width,
								  height
								  );
	
	// 数字レイヤの作成
	// 下の桁から順に作成
	[self.figureLayers removeAllObjects];
	for(int i = self.figures - 1; i >= 0; --i){
		int x = (self.width + self.gap) * i;
		CALayer* figureLayer = [CALayer layer];
		figureLayer.anchorPoint = CGPointMake(0, 0);
		figureLayer.frame = CGRectMake(x,
									   0,
									   self.width,
									   self.height
									   );
		[self.layer addSublayer: figureLayer];
		[self.figureLayers addObject: figureLayer];
	}
}

- (void)updateFigure{
	NSInteger rest = self.value;
	BOOL first = YES;
	for(CALayer* layer in self.figureLayers){
		if(!first && rest == 0 && !self.fillWithZero){
			layer.contents = nil;
			first = NO;
			continue;
		}
		first = NO;
		UIImage* image = [self.images objectAtIndex: rest % 10];
		rest = rest / 10;
		layer.contents = (id)image.CGImage;
	}
}

- (void)drawValue: (NSInteger)value atPoint: (CGPoint)pt{
	BOOL first = YES;
	
	NSInteger rest = value;
	for(int i = self.figures - 1; i >= 0; --i){
		if(!first && rest == 0 && !self.fillWithZero){
			break;
		}
		first = NO;
		int x = (self.width + self.gap) * i;
		[[self.images objectAtIndex: rest % 10]
		 drawAtPoint: CGPointMake(pt.x + x, pt.y)
		 ];
		rest = rest / 10;
	}
}

- (void)setValue:(NSInteger)value{
	if(value_ == value){
		return;
	}
	value_ = value;
	[self updateFigure];
}

- (NSInteger)value{
	return value_;
}

- (void)setValueWithoutAnimation:(NSInteger)value{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey: kCATransactionDisableActions
	 ];
	self.value = value;
	[CATransaction commit];
}


@end
