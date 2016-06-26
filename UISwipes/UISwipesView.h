//
//  UISwipesView.h
//  UISwipesView
//
//  Created by Christopher Miller on 28/03/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UISwipesView;

/**
 The Directions are abstractions of 4 directional swipe operations. They
allow the swiping away of the currently viewed card (or View), to the top, bottom, left or right of the screen.
 </br></br>The following are the Directions Class' Values: </br>
 [Directions LEFT] [Directions DOWN] [Directions RIGHT] [Directions UP]</br>
 
 Objective-C Usage Example:</br>
 ```
 
    UISwipesView *swipesView = [[UISwipesView alloc] init];
    // Or from Storyboard Outlet (self.swipesView)
 
    NSArray * directions = @[[Directions LEFT], [Directions RIGHT]];
    // Or from Storyboard Options (Direction left, ...)
 
    [swipesView setAllowedDirections:directions];
 
 ```
 */
@interface Directions : NSObject
/**
 * LEFT Direction (0x03)
 */
+(Directions* _Nonnull)LEFT;
/**
 * DOWN Direction (0x50)
 */
+(Directions* _Nonnull)DOWN;
/**
 * RIGHT Direction (0x30)
 */
+(Directions* _Nonnull)RIGHT;
/**
 * UP Direction (0x05)
 */
+(Directions* _Nonnull)UP;

/**
 * Human readable string representing the direction
 */
- (NSString * _Nonnull)description;
@end

/**
 * Subclass of UICollectionViewCell for the UISwipesView
 */
@interface UISwipesViewCell : UICollectionViewCell
@end


/** UISwipesViewDataSource is a common protocol for data containment, made specifically for UISwipesView. The UISwipesViewDataSource works just like any other UIKit dataSource, and the following is a basic implementation of UISwipesViewDataSource:
 
 ```
    @interface BasicSwipes () <UISwipesViewDataSource>
    @property (strong, nonatomic) NSMutableArray *cardData;
    @property (strong, nonatomic) CGRect screenBounds;
    @end

    @implementation BasicSwipes
 
     - (void)viewDidLoad {
         [super viewDidLoad];
 
         self.screenBounds = [[UIScreen mainScreen] bounds];
         self.cardData = [[NSMutableArray alloc] initWithArray:@[ @1, @11, @111 ]];
 
         UISwipesView *swipesView = [[UISwipesView alloc] initWithFrame:self.screenBounds];
         [self.view addSubview:swipesView];
         [swipesView setDataSource:self];
         
         [swipesView registerClass:[BasicCardCell class] forCellWithReuseIdentifier:@"BasicCardCell"];
 
     }
     - (NSInteger)swipesView:(UISwipesView *)swipesView numberOfItemsInSection:(NSInteger) nis {
        return self.cardData.count;
     }
 
     - (CGPoint)swipesView:(UISwipesView *)swipesView centerForItemAtIndexPath:(NSIndexPath *)indexPath {
         return CGPointMake(self.screenBounds.width * .50f, self.screenBounds.height * .35f);
     }
     
     - (CGSize)swipesView:(UISwipesView *)swipesView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
         CGFloat defaultCellSize = self.screenBounds.size.width;
         return CGSizeMake(defaultCellSize * .85f, defaultCellSize * .55f);
     }
     
     - (void)swipesView:(UISwipesView *)swipesView postSwipeOperationAtIndexPath:(NSIndexPath*)indexPath {
         [self.cardData removeObjectAtIndex:indexPath.item];
     }
     
     - (UISwipesViewCell *)swipesView:(UISwipesView *)swipesView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
         BasicCardCell *cell = (BasicCardCell*)[swipesView dequeueReusableCellWithReuseIdentifier:@"BasicCardCell" forIndexPath:indexPath];
         cell.label.text = [NSString stringWithFormat:@"%@", self.cardData[indexPath.item]];
     
         return cell;
     }
     @end

 ```
 */
@protocol UISwipesViewDataSource

@optional
- (int)swipesView:(UISwipesView* _Nonnull)swipesView numberOfSectionsInSwipesView:(UISwipesView* _Nonnull)swipesView;


@required
/**
Sets up and returns the center position in the UISwipesView.
 @param swipesView The Swipes View that can be used as a position reference.
 @param indexPath The position in the Swipes View of the UISwipesViewCell
 @return The CGPoint in the Swipes View of the UISwipesViewCell
 */
- (CGPoint)swipesView:(UISwipesView * _Nonnull)swipesView centerForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

/**
 Sets up and returns the size in the UISwipesView.
 @param swipesView The Swipes View that can be used as a position reference.
 @param indexPath The position in the Swipes View of the UISwipesViewCell
 @return The CGSize within the Swipes View of the UISwipesViewCell
 */
- (CGSize)swipesView:(UISwipesView * _Nonnull)swipesView sizeForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

/**
 Sets up and returns the count in the UISwipesView within a section.
 @param swipesView The Swipes View that can be used as a position reference.
 @param indexPath The position in the Swipes View of the UISwipesViewCell
 @return The count of items in the Swipes View Section
 */
- (int)swipesView:(UISwipesView* _Nonnull)swipesView numberOfItemsInSection:(NSInteger)section;

/**
 Sets up and returns a UISwipesViewCell in the UISwipesView.
 @param swipesView The Swipes View that can be used as a position reference.
 @param indexPath The position in the Swipes View of the UISwipesViewCell
 @return The cell data populated in the Swipes View Cell
 */
- (UISwipesViewCell * _Nonnull)swipesView:(UISwipesView* _Nonnull)swipesView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

/**
 Is called after a Swipe Operation, and allows clean up of your data (deletions, moves, etc.).
 @param swipesView The Swipes View that can be used as a position reference.
 @param indexPath The position in the Swipes View of the UISwipesViewCell
 */
- (void)swipesView:(UISwipesView* _Nonnull)swipesView postSwipeOperationAtIndexPath:(NSIndexPath* _Nonnull)indexPath;

@end

/**
 * Delegates updates on swipe threshold and direction.
 */
@protocol UISwipesViewDelegate
/**
 * Provides updates on swipe threshold.
 */
- (void)onThresholdChange:(UISwipesViewCell* _Nonnull)card threshold:(CGFloat)threshold;

/**
 * Provides updates on swipe direction, but is not a callback for successful swipes.
 */
- (void)onDirectionSwipe:(UISwipesViewCell* _Nonnull)card direction:(Directions* _Nonnull)direction;

/**
 * Provides updates on successful swipes with direction.
 */
- (void)onSuccessfulSwipe:(UISwipesViewCell* _Nonnull)card direction:(Directions* _Nonnull)direction;
@end


/** The Swipes View is a new implementation of iOS's CollectionView specifically made for 4 directional swiping. This implementation is loosely based upon Tinder's Like/Nope Swiping action. <br/><br/>As in the example below, to pass data to the UISwipesView, the UISwipesViewDataSource needs to be implemented and passed to SwipesView dataSource.
 
 ```
     UISwipesView *swipesView = [[UISwipesView alloc] init];
     // Or from Storyboard Outlet (self.swipesView)
     
     swipesView.dataSource = someController;
     // Or Class that implements UISwipesViewDataSource
 ```
 */
@interface UISwipesView : UIView

/*
 @see UISwipesViewDataSource
 */
@property(nonatomic, assign) id<UISwipesViewDataSource> _Nonnull dataSource;

/*
 @see UISwipesView
 */
@property(nonatomic, assign) NSInteger count;

/**
 Sets the horizontal and vertical swiping directions enabled, and
 is automatically called when set in IB via the "direction_*" properties.
 
 Objective-C Usage Example:</br>
 ```
 
 UISwipesView *swipesView = [[UISwipesView alloc] init];
 // Or from Storyboard Outlet (self.swipesView)
 
 NSArray * directions = @[[Directions LEFT], [Directions RIGHT]];
 // Or from Storyboard Options (Direction left, ...)
 
 [swipesView setAllowedDirections:directions];
 
 ```
 */
- (void)setAllowedDirections:(NSArray* _Nonnull)allowed;

/**
 * The left swipe callback that performs the swipe operation.
 */
- (void)performSwipeLeft;

/**
 * The down swipe callback that performs the swipe operation.
 */
- (void)performSwipeDown;

/**
 * The right swipe callback that performs the swipe operation.
 */
- (void)performSwipeRight;

/**
 * The up swipe callback that performs the swipe operation.
 */
- (void)performSwipeUp;

/**
The collection setter for Swipe Delegate changes.<br/><br/>
This method (and the related collection) allows for multiple delegates for the swipes
 */
+(void) addUISwipesViewDelegate:(id<UISwipesViewDelegate> _Nonnull)newDelegate;

/**
 The collection unsetter for Swipe Delegate changes.<br/><br/>
 This method (and the related collection) allows for one less delegate for the swipes
 */
+(void) removeUISwipesViewDelegate:(id<UISwipesViewDelegate> _Nonnull)oldDelegate;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString * _Nonnull)identifier;

- (void)reloadData; // discard the dataSource and delegate data and requery as necessary

- (__kindof UISwipesViewCell * _Nonnull)dequeueReusableCellWithReuseIdentifier:(NSString * _Nonnull)identifier forIndexPath:(NSIndexPath * _Nonnull)indexPath;

- (void)performBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion;

- (nullable NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;

- (nullable UISwipesViewCell *)cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> * _Nonnull)indexPaths;

@end