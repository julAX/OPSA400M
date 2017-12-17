//
//  LegsSelectionView.h
//  Esterel OPS
//
//  Created by utilisateur on 01/04/2014.
//  Copyright (c) 2014 Esterel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Mission;

@protocol LegsSelectionDelegate <NSObject>

- (void)selectionDidChange:(NSDictionary*)selectedLegs;

@end

@interface LegsSelectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property id<LegsSelectionDelegate> selectionDelegate;

@property (weak, nonatomic) Mission *mission;
@property (strong, nonatomic) NSMutableDictionary *selectedLegs;

@end
