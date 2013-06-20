//
//  XBViewController.m
//  TimelineCollectionView
//
//  Created by Simone Civetta on 6/17/13.
//  Copyright (c) 2013 Xebia IT Architects. All rights reserved.
//

#import "XBViewController.h"
#import "XBTimelineColumnHeaderView.h"

NSString * const XBTimelineColumnHeaderKind = @"XBTimelineColumnHeaderKind";
static NSString * const XBTimelineColumnReuseIdentifier = @"TimelineColumnHeader";

@interface XBViewController ()

@end

@implementation XBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.collectionView collectionViewLayout] registerClass:[XBTimelineColumnHeaderView class] forDecorationViewOfKind:XBTimelineColumnHeaderKind];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source

- (PSUICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PSUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == PSTCollectionElementKindSectionHeader) {
        PSUICollectionReusableView *reusableView = [[PSUICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:reusableView.bounds];
        [label setBackgroundColor:[UIColor whiteColor]];
        label.text = [NSString stringWithFormat:@"H%d", indexPath.section];
        [reusableView addSubview:label];
        return reusableView;
    } else if (kind == XBTimelineColumnHeaderKind) {
        return [self.collectionView dequeueReusableSupplementaryViewOfKind:XBTimelineColumnHeaderKind
                                                       withReuseIdentifier:XBTimelineColumnReuseIdentifier
                                                              forIndexPath:indexPath];
    }
    
    return nil;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView
{
    return 20;
}

// iOS 5.0 only
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
}


#pragma mark - Timeline layout delegate

- (CGPoint)timelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout offsetForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGPointMake(indexPath.item * 50.0, 0);
}

- (CGFloat)timelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (CGFloat)timelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout heightForSectionAtIndex:(NSInteger)index
{
    return 50.0;
}

- (CGFloat)heightForColumnHeaderInTimelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout
{
    return 100.0;
}

- (CGFloat)widthForRowHeaderInTimelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout
{
    return 100.0;
}

- (NSString *)kindForColumnHeaderInTimelineLayout:(XBCollectionViewTimelineLayout *)timelineLayout
{
    return XBTimelineColumnHeaderKind;
}

@end
