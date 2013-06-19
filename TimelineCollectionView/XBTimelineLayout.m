//
//  XBTimelineLayout.m
//  TimelineCollectionView
//
//  Created by Simone Civetta on 6/17/13.
//  Copyright (c) 2013 Xebia IT Architects. All rights reserved.
//

#import "XBTimelineLayout.h"
#import "XBTimelineColumnHeaderView.h"

@interface XBTimelineLayout() {
    CGSize _collectionViewContentSize;
}

@property (nonatomic, strong) NSDictionary *cellLayoutAttributes;
@property (nonatomic, strong) NSArray *rowHeaderLayoutAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *columnHeaderLayoutAttributes;

@end

@implementation XBTimelineLayout

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
	
	return self;
}

- (void)prepareLayout
{
    if (!self.delegate) {
        NSLog(@"Not enough info for creating the stories");
        return;
    }
    
    CGFloat rowHeaderWidth = [self.delegate widthForRowHeaderInTimelineLayout:self];
    CGFloat columnHeaderHeight = [self.delegate heightForColumnHeaderInTimelineLayout:self];
    
    NSMutableDictionary *cellLayoutAttributes = [NSMutableDictionary dictionary];
    NSMutableArray *headerLayoutAttributes = [NSMutableArray array];
    
    CGFloat cumulativeHeight = 0;
    
    NSInteger sectionCount = [self.collectionView numberOfSections];    
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        CGFloat cumulativeWidth = 0;
        CGFloat sectionHeight = [self.delegate timelineLayout:self heightForSectionAtIndex:section];
        
        // Calculate the frame for each cell
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            CGFloat itemWidth = [self.delegate timelineLayout:self widthForItemAtIndexPath:indexPath];
            CGPoint offset = [self.delegate timelineLayout:self offsetForItemAtIndexPath:indexPath];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(offset.x + rowHeaderWidth,
                                              cumulativeHeight + columnHeaderHeight,
                                              itemWidth,
                                              sectionHeight);
            itemAttributes.zIndex = 1024;
            
            cellLayoutAttributes[indexPath] = itemAttributes;
            
            cumulativeWidth += itemWidth;
        }
        
        // Calculate the frame for each row header
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        headerAttributes.frame = CGRectMake(0,
                                            cumulativeHeight + columnHeaderHeight,
                                            rowHeaderWidth,
                                            sectionHeight);
        headerAttributes.zIndex = 2048;
        headerLayoutAttributes[section] = headerAttributes;
        
        cumulativeHeight += sectionHeight;
        
    }
    
    // Add Headers
    self.cellLayoutAttributes = cellLayoutAttributes;
    self.rowHeaderLayoutAttributes = headerLayoutAttributes;
    
    NSString *columnHeaderKind = [self.delegate kindForColumnHeaderInTimelineLayout:self];
    self.columnHeaderLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:columnHeaderKind withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    self.columnHeaderLayoutAttributes.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, columnHeaderHeight);
}


- (CGSize)collectionViewContentSize
{
    // Use the cached collectionViewContentSize
    if (!CGSizeEqualToSize(_collectionViewContentSize, CGSizeZero)) {
        return _collectionViewContentSize;
    }
    
    CGFloat cumulativeHeight = 0;
    CGFloat maxWidth = 0;
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        CGFloat sectionHeight = [self.delegate timelineLayout:self heightForSectionAtIndex:section];
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGPoint offset = [self.delegate timelineLayout:self offsetForItemAtIndexPath:indexPath];
            CGFloat itemWidth = [self.delegate timelineLayout:self widthForItemAtIndexPath:indexPath];
            maxWidth = MAX(maxWidth, offset.x + itemWidth);
        }
        
        cumulativeHeight += sectionHeight;
    }
    
    CGFloat rowHeaderWidth = [self.delegate widthForRowHeaderInTimelineLayout:self];
    CGFloat columnHeaderHeight = [self.delegate heightForColumnHeaderInTimelineLayout:self];
    
    _collectionViewContentSize = CGSizeMake(maxWidth + rowHeaderWidth,
                                            cumulativeHeight + columnHeaderHeight);
    
    return _collectionViewContentSize;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    __block int i = 0;
    
    // Show only pertinent layoutAttributes
    [self.cellLayoutAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         UICollectionViewLayoutAttributes *attributes,
                                                         BOOL *stop) {

        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
            i++;
        }

    }];
    
    // NSLog(@"%d", i);
    // NSLog(@"%f, %f, %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    // Header 
    [self.rowHeaderLayoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        attributes.frame = (CGRect){
            .origin = CGPointMake(self.collectionView.contentOffset.x, attributes.frame.origin.y),
            .size = CGSizeMake(attributes.frame.size.width, attributes.frame.size.height)
        };

        [allAttributes addObject:attributes];
    }];
    
    self.columnHeaderLayoutAttributes.frame = (CGRect){
        .origin = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y),
        .size = CGSizeMake(self.columnHeaderLayoutAttributes.frame.size.width, self.columnHeaderLayoutAttributes.frame.size.height)
    };
    
    [allAttributes addObject:self.columnHeaderLayoutAttributes];
    
    return allAttributes;
}

/*
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attributes in answer) {
        NSLog(@"%@", attributes);
    }
    
    
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
	
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
	
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
		
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
		
        [answer addObject:layoutAttributes];
		
    }];
	
	for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
		
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
			
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
			
            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
			
            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
			
			
//			if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
//				CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
//				CGPoint origin = layoutAttributes.frame.origin;
//				origin.y = MIN(
//							   MAX(contentOffset.y, (CGRectGetMinY(firstCellAttrs.frame) - headerHeight)),
//							   (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight)
//							   );
//				
//				layoutAttributes.zIndex = 1024;
//				layoutAttributes.frame = (CGRect){
//					.origin = origin,
//					.size = layoutAttributes.frame.size
//				};
//			} else {
//				CGFloat headerWidth = CGRectGetWidth(layoutAttributes.frame);
//				CGPoint origin = layoutAttributes.frame.origin;
//				origin.x = MIN(
//							   MAX(contentOffset.x, (CGRectGetMinX(firstCellAttrs.frame) - headerWidth)),
//							   (CGRectGetMaxX(lastCellAttrs.frame) - headerWidth)
//							   );
//				
//				layoutAttributes.zIndex = 1024;
//				layoutAttributes.frame = (CGRect){
//					.origin = origin,
//					.size = layoutAttributes.frame.size
//				};
//			}
            
        }
    }
	
    return answer;
}
*/

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

- (void)invalidateLayout
{
    [super invalidateLayout];
    _collectionViewContentSize = CGSizeZero;
}

@end