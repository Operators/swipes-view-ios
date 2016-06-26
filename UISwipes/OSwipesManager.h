//
//  OSwipesManager.h
//  UISwipesView
//
//  Created by Christopher Miller on 29/03/16.
//  Copyright (c) 2015 The MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Directions;
@class UISwipesView;
@class UISwipesViewLayout;
@class UISwipesViewCell;

@interface UISwipesViewLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGPoint epiCenter;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) NSInteger cellSize;
@property (nonatomic, strong) NSIndexPath *pannedIndexPath;
@property (nonatomic, strong) Directions *currentDirection;
@property (nonatomic, strong) UISwipesView *swipesView;

@end

/**
 * Delegates updates on swipe threshold and direction.
 */
@protocol OSwipesManagerDelegate

/**
 * The currently selected view
 **/
- (UISwipesViewCell*)getSelectedView;

/**
 * Provides updates on swipe threshold.
 */
- (void)onThresholdChange:(CGFloat)threshold;

/**
 * Provides updates on swipe direction, but is not a callback for successful swipes.
 */
-(void)onDirectionChange:(Directions*)direction;

/**
 * Provides updates on successful swipes with direction.
 */
- (void)onSuccessfulSwipe:(Directions*)direction;

/**
 * Checks whether a swipe direction change is allowed.
 */
- (BOOL)isAllowed:(Directions*)direction;

/**
 * The swipes rotation value maximum.
 */
- (CGFloat)getRotation;

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
@end


/**
 * The Operators Swipes Manager is an abstraction of swipe operations (in 4 directions). It
 * will allow the swiping away of the currently viewed card (or View), to the top, bottom,
 * left or right of the screen (but only if the message [OSwipesManagerDelegate isAllowed:Directions] returns true).
 *
 * @see OSwipesManagerDelegate#isAllowed:Directions
 * @author christopher
 */
@interface OSwipesManager : UIPanGestureRecognizer <UIGestureRecognizerDelegate>

@property (strong, nonatomic) id<OSwipesManagerDelegate> swipesDelegate;
@property (strong, nonatomic) Directions *swipeOperation;
@property (strong, nonatomic) UISwipesViewCell *swipesCard;
@property (strong, nonatomic) UISwipesView *swipesView;
@property (strong, nonatomic) UISwipesViewLayout *swipesViewLayout;
@property (assign, nonatomic) int touchPosition;

-(id)initWithSwipesView:(UISwipesView*)view andLayout:(UISwipesViewLayout*)layout;
@end