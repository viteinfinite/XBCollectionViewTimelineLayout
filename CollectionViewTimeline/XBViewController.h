//
//  XBViewController.h
//  TimelineCollectionView
//
//  Created by Simone Civetta on 6/17/13.
//  Copyright (c) 2013 Xebia IT Architects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCollectionViewTimelineLayout.h"
#import <PSTCollectionView/PSTCollectionView.h>

UIKIT_EXTERN NSString * const XBTimelineColumnHeaderKind;

@interface XBViewController : UIViewController<PSUICollectionViewDataSource, PSUICollectionViewDelegate, XBCollectionViewTimelineLayoutDelegate>

@property (nonatomic, weak) IBOutlet PSUICollectionView *collectionView;

@end
