//
//  XBTimelineColumnHeaderView.m
//  TimelineCollectionView
//
//  Created by Simone Civetta on 6/18/13.
//  Copyright (c) 2013 Xebia IT Architects. All rights reserved.
//

#import "XBTimelineColumnHeaderView.h"

@implementation XBTimelineColumnHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *l = [[UILabel alloc] initWithFrame:self.bounds];
        [self setBackgroundColor:[UIColor whiteColor]];
        l.text = @"CHEADER";
        [self addSubview:l];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
