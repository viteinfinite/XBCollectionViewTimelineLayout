//
//  XBTimelineLayout.h
//  TimelineCollectionView
//
//  Created by Simone Civetta on 6/17/13.
//  Copyright (c) 2013 Xebia IT Architects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSTCollectionView/PSTCollectionView.h>

@protocol XBCollectionViewTimelineLayoutDelegate;

@interface XBCollectionViewTimelineLayout : PSUICollectionViewLayout

@property (nonatomic, weak) IBOutlet id<XBCollectionViewTimelineLayoutDelegate> delegate;

@end

@protocol XBCollectionViewTimelineLayoutDelegate <NSObject>

@required

- (CGPoint)timelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout offsetForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)timelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)timelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout heightForSectionAtIndex:(NSInteger)index;

- (CGFloat)widthForRowHeaderInTimelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout;

@optional
- (CGFloat)heightForColumnHeaderInTimelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout;
- (NSString *)kindForColumnHeaderInTimelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout;

@end
