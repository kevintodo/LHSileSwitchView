//
//  LHSlideSwitchView.h
//  MyStyle
//
//  Created by kangylk on 15/7/17.
//  Copyright (c) 2015年 Huuhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didShowIndex)(int nn);

typedef void (^didScroll)(CGFloat xx);

@interface LHSlideSwitchView : UIView

/** 去掉scrollview的滚动效果 */
@property (nonatomic,assign)BOOL NotShowSlideAnimate;

+(LHSlideSwitchView*)buildFrame:(CGRect)rect WithArray:(NSArray *)arr toIndex:(NSInteger)nn showBlock:(didShowIndex)showBlcok moveBlcok:(didScroll)moveBlok;

-(void)didShowIndex:(int)tag;
-(void)freeBlock;
@end
