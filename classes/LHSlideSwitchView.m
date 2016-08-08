//
//  LHSlideSwitchView.m
//  MyStyle
//
//  Created by kangylk on 15/7/17.
//  Copyright (c) 2015年 Huuhoo. All rights reserved.
//

#import "LHSlideSwitchView.h"

@interface LHSlideSwitchView()<UIScrollViewDelegate>
{
    UIScrollView *_rootScrollView;
    NSArray *_VCArray;
    
    NSInteger _showViewIndex;
}

@property (nonatomic,copy) didShowIndex didShowBlock;

@property (nonatomic,copy) didScroll didScrollBlock;

@end

@implementation LHSlideSwitchView

+(LHSlideSwitchView*)buildFrame:(CGRect)rect WithArray:(NSArray *)arr toIndex:(NSInteger)nn showBlock:(didShowIndex)showBlcok moveBlcok:(didScroll)moveBlok
{
    LHSlideSwitchView *ins = [[self alloc] initWithFrame:rect];
    ins.didScrollBlock = moveBlok;
    ins.didShowBlock = showBlcok;
    [ins buildUIWithArray:arr toIndex:nn];
    return ins;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}

#pragma mark - 初始化视图

-(void)initValues
{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _rootScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_rootScrollView setScrollsToTop:NO];
//    [_rootScrollView setContentOffset:CGPointMake(_showViewIndex*self.bounds.size.width, 0)];
    [self addSubview:_rootScrollView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * _VCArray.count, 1);
    for (int i = 0; i<_VCArray.count; i++) {
        UIViewController *listVC = _VCArray[i];
        listVC.view.frame = CGRectOffset(self.bounds, _rootScrollView.bounds.size.width*i, 0);
    }
}

-(void)didMoveToWindow
{
    [_rootScrollView setContentOffset:CGPointMake(self.bounds.size.width*_showViewIndex,0) animated:NO];
}


- (void)buildUIWithArray:(NSArray *)arr toIndex:(NSInteger)nn
{
    NSInteger number = arr.count;
    for (int i = 0; i<number; i++) {
        UIViewController *vc = arr[i];
        [_rootScrollView addSubview:vc.view];
    }
    _VCArray = [arr copy];
    
    [self setNeedsLayout];
    
    [self didShowIndex:nn];
}

-(void)didShowIndex:(NSInteger)tag
{
    if (!_NotShowSlideAnimate) {
        [_rootScrollView setContentOffset:CGPointMake(self.bounds.size.width*tag,0) animated:YES];
    }else{
        [_rootScrollView setContentOffset:CGPointMake(self.bounds.size.width*tag,0) animated:NO];
    }
    
    _showViewIndex = tag;
    if (_didShowBlock) {
        _didShowBlock(tag);
    }
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_didScrollBlock) {
        _didScrollBlock(scrollView.contentOffset.x);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int tag = (int)scrollView.contentOffset.x/self.bounds.size.width;
    [self didShowIndex:tag];
}

-(void)freeBlock
{
    _didScrollBlock = nil;
    _didShowBlock = nil;
}

@end
