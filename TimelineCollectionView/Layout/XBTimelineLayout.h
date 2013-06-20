//
//  XBTimelineLayout.h
//  TimelineCollectionView
//
//  Created by Simone Civetta on 6/17/13.
//  Copyright (c) 2013 Xebia IT Architects. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XBTimelineLayoutDelegate;

@interface XBTimelineLayout : UICollectionViewLayout

@property (nonatomic, weak) IBOutlet id<XBTimelineLayoutDelegate> delegate;

@end

@protocol XBTimelineLayoutDelegate <NSObject>

@required

- (CGPoint)timelineLayout:(XBTimelineLayout *)timelineLayout offsetForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)timelineLayout:(XBTimelineLayout *)timelineLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)timelineLayout:(XBTimelineLayout *)timelineLayout heightForSectionAtIndex:(NSInteger)index;

- (CGFloat)widthForRowHeaderInTimelineLayout:(XBTimelineLayout *)timelineLayout;
- (CGFloat)heightForColumnHeaderInTimelineLayout:(XBTimelineLayout *)timelineLayout;

- (NSString *)kindForColumnHeaderInTimelineLayout:(XBTimelineLayout *)timelineLayout;

@end
