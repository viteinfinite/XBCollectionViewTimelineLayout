//
//  XBTimelineLayout.m
//  TimelineCollectionView
//
//  Created by Simone Civetta on 6/17/13.
//  Copyright (c) 2013 Xebia IT Architects. All rights reserved.
//

#import "XBCollectionViewTimelineLayout.h"

@interface XBCollectionViewTimelineLayout() {
    CGSize _collectionViewContentSize;
}

@property (nonatomic, strong) NSArray *cellLayoutAttributes;
@property (nonatomic, strong) NSArray *rowHeaderLayoutAttributes;
@property (nonatomic, strong) PSUICollectionViewLayoutAttributes *columnHeaderLayoutAttributes;

@end

@implementation XBCollectionViewTimelineLayout

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
    CGFloat columnHeaderHeight = 0;
    
    if ([self.delegate respondsToSelector:@selector(heightForColumnHeaderInTimelineLayout:)]) {
        columnHeaderHeight = [self.delegate heightForColumnHeaderInTimelineLayout:self];
    }
    
    
    NSMutableArray *cellLayoutAttributes = [NSMutableArray array];
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
            
            PSUICollectionViewLayoutAttributes *itemAttributes = [PSUICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(offset.x + rowHeaderWidth,
                                              cumulativeHeight + columnHeaderHeight,
                                              itemWidth,
                                              sectionHeight);
            itemAttributes.zIndex = 0;
            
            [cellLayoutAttributes addObject:itemAttributes];
            
            cumulativeWidth += itemWidth;
        }
        
        // Calculate the frame for each row header
        PSUICollectionViewLayoutAttributes *headerAttributes = [PSUICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        headerAttributes.frame = CGRectMake(0,
                                            cumulativeHeight + columnHeaderHeight,
                                            rowHeaderWidth,
                                            sectionHeight);
        headerAttributes.zIndex = 1;
        headerLayoutAttributes[section] = headerAttributes;
        
        cumulativeHeight += sectionHeight;
        
    }
    
    // Add Headers
    self.cellLayoutAttributes = cellLayoutAttributes;
    self.rowHeaderLayoutAttributes = headerLayoutAttributes;
    
    if ([self.delegate respondsToSelector:@selector(kindForColumnHeaderInTimelineLayout:)]) {
        NSString *columnHeaderKind = [self.delegate kindForColumnHeaderInTimelineLayout:self];
        self.columnHeaderLayoutAttributes = [PSUICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:columnHeaderKind withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.columnHeaderLayoutAttributes.zIndex = 2;
        self.columnHeaderLayoutAttributes.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, columnHeaderHeight);
    }
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
    CGFloat columnHeaderHeight = 0;
    
    if ([self.delegate respondsToSelector:@selector(heightForColumnHeaderInTimelineLayout:)]) {
        columnHeaderHeight = [self.delegate heightForColumnHeaderInTimelineLayout:self];
    }
    
    _collectionViewContentSize = CGSizeMake(maxWidth + rowHeaderWidth,
                                            cumulativeHeight + columnHeaderHeight);
    
    return _collectionViewContentSize;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
        
    // Show only pertinent layoutAttributes
    for (PSUICollectionViewLayoutAttributes *attributes in self.cellLayoutAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }
    
    // Header
    for (PSUICollectionViewLayoutAttributes *attributes in self.rowHeaderLayoutAttributes) {
        attributes.frame = (CGRect){
            .origin = CGPointMake(self.collectionView.contentOffset.x, attributes.frame.origin.y),
            .size = CGSizeMake(attributes.frame.size.width, attributes.frame.size.height)
        };
        
        [allAttributes addObject:attributes];
    }
    
    if (self.columnHeaderLayoutAttributes) {
        self.columnHeaderLayoutAttributes.frame = (CGRect){
            .origin = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y),
            .size = CGSizeMake(self.columnHeaderLayoutAttributes.frame.size.width, self.columnHeaderLayoutAttributes.frame.size.height)
        };
        
        [allAttributes addObject:self.columnHeaderLayoutAttributes];
    }
    
    return allAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

- (void)invalidateLayout
{
    [super invalidateLayout];
    _collectionViewContentSize = CGSizeZero;
}

- (PSUICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)kind atIndexPath:(NSIndexPath *)indexPath
{
    return self.columnHeaderLayoutAttributes;
}

@end