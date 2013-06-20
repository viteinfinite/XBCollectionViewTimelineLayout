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

@end
