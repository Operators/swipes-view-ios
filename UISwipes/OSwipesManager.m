//
//  OSwipesManager.m
//  UISwipes
//
//  Created by Christopher Miller on 29/03/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import "OSwipesManager.h"
#import "UISwipesView.h"

@implementation UISwipesViewLayout

-(CGSize)collectionViewContentSize {
    return [self collectionView].frame.size;
}

-(void)prepareLayout {
    [super prepareLayout];
    CGSize size = self.collectionView.frame.size;
    _cellSize = size.width;
    
    id<UISwipesViewDataSource> ds = (id<UISwipesViewDataSource>) self.swipesView.dataSource;
    _size = [ds swipesView:self.swipesView sizeForItemAtIndexPath:_pannedIndexPath];
    _epiCenter = [ds swipesView:self.swipesView centerForItemAtIndexPath:_pannedIndexPath];
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < _cellCount; i++) {

        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* attributeSet = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributes addObject:attributeSet];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    
    if (CGSizeEqualToSize(_size, CGSizeZero)) {
        attributes.size = CGSizeMake(_cellSize * .85f, _cellSize * .55f);
    } else {
        attributes.size = _size;
    }
    
    if (CGPointEqualToPoint(_center, CGPointZero)) {
        _center =  _epiCenter;
    }
    
    if ([self.pannedIndexPath isEqual:path]) {
        attributes.center = CGPointMake(_center.x,_center.y);
        
        CATransform3D transform = CATransform3DMakeTranslation(0, 0, self.swipesView.count - path.item - 1);
        transform = CATransform3DRotate(transform, _rotation * M_PI / 2, 0, 0, 1);
        attributes.transform3D = transform;
        
        _rotation = 0.f;
        _center = _epiCenter;
    } else {
        attributes.center = CGPointMake(_epiCenter.x,_epiCenter.y);
        attributes.transform3D = CATransform3DMakeTranslation(0, 0, self.swipesView.count - path.item - 1);
    }
    
    return attributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    NSMutableArray * output = nil;
    
    if(DEBUG) output = [[NSMutableArray alloc] init];
    if(DEBUG) [output addObject:[NSString stringWithFormat:@"itemIndexPath=%@\nintitialZIndex=%d", itemIndexPath, attributes.zIndex]];
    
    if (![self.pannedIndexPath isEqual:itemIndexPath]) {
        if(DEBUG) NSLog([output componentsJoinedByString:@"\n"]);
        return attributes;
    }
    
    float size = [[UIScreen mainScreen] bounds].size.width;
    
    if (_currentDirection == [Directions LEFT]) {
        
        if(DEBUG) [output addObject:@"LEFT"];
        attributes.center = CGPointMake(attributes.center.x + (-3 * size), attributes.center.y);
    } else if (_currentDirection == [Directions DOWN]) {
        
        if(DEBUG) [output addObject:@"DOWN"];
        attributes.center = CGPointMake(attributes.center.x, attributes.center.y + (3 * size));
    } else if (_currentDirection == [Directions RIGHT]) {
        
        if(DEBUG) [output addObject:@"RIGHT"];
        attributes.center = CGPointMake(attributes.center.x + (3 * size), attributes.center.y);
    } else if (_currentDirection == [Directions UP]) {
        
        if(DEBUG) [output addObject:@"UP"];
        attributes.center = CGPointMake(attributes.center.x, attributes.center.y + (-3 * size));
    }
    
    if(DEBUG) [output addObject:[NSString stringWithFormat:@"self.pannedIndexPath=%@\nattributes.zIndex=%d", self.pannedIndexPath, attributes.zIndex]];
    
    if(DEBUG) NSLog([output componentsJoinedByString:@"\n"]);
    
    _center = _epiCenter;
    _currentDirection = nil;
    _pannedIndexPath = nil;
    return attributes;
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    self.pannedIndexPath = nil;
}

-(void)setPannedIndexPath:(NSIndexPath *)pannedIndexPath {
    if(pannedIndexPath) {
        _pannedIndexPath = pannedIndexPath;
    } else {
        _pannedIndexPath = pannedIndexPath;
        _center = _epiCenter;
    }
}
-(void)setRotation:(CGFloat)rotation {
    _rotation = rotation;
    [self invalidateLayout];
}
-(void)setCenter:(CGPoint)center {
    _center = center;
    [self invalidateLayout];
}
-(void)setEpiCenter:(CGPoint)center {
    _epiCenter = center;
}
-(void)setCellCount:(NSInteger)count {
    _cellCount = count;
}
@end

@implementation OSwipesManager

+(NSNumber*)TOUCH_ABOVE {
    return @0;
}
+(NSNumber*)TOUCH_BELOW {
    return @1;
}
+(NSNumber*)SWIPE_DIVISOR {
    return @2;
}
+(NSNumber*)EXTRA_SPACE {
    return @42;
}

-(id)initWithSwipesView:(UISwipesView*)view andLayout:(UISwipesViewLayout*)layout {
    self = [super initWithTarget:self action:@selector(handleSwipeGesture:)];
    if (self) {
        self.swipesView = view;
        self.swipesViewLayout = layout;
        self.swipesDelegate = view;
        self.delegate = self;
    }
    return self;
}

- (void)handleSwipeGesture:(UIPanGestureRecognizer *)sender {
    
    UISwipesViewLayout *sl = (UISwipesViewLayout*) self.swipesViewLayout;
    self.swipesCard = [self.swipesDelegate getSelectedView];
    
    if (self.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.swipesView];
        sl.pannedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        if (point.y < self.swipesCard.frame.size.height / 2) {
            self.touchPosition = [[OSwipesManager TOUCH_BELOW] intValue];
        } else {
            self.touchPosition = [[OSwipesManager TOUCH_ABOVE] intValue];
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if(DEBUG) NSLog(@"handlePanSwipe(UIGestureRecognizerStateEnded) self.swipeOperation=%@", self.swipeOperation);
        
        [self.swipesDelegate onThresholdChange:0.f];
        if(![self checkForSwipe]) {
            [self.swipesView performBatchUpdates:^{
                if(DEBUG) NSLog(@"performBatchUpdates self.swipeOperation=%@", self.swipeOperation);
            } completion:nil];
        }
    }
    else {
        if (!sl.pannedIndexPath) return;
        
        CGPoint dis = [sender translationInView:self.view];
        float dx = dis.x, dy = dis.y;
        if(DEBUG) NSLog(@"handleSwipeGesture(...) dx=%f\nhandleSwipeGesture(...) dy=%f",dx, dy);
        
        Directions *swipeOperation = nil;
        BOOL hasSignificantlyChangedX = fabsf(dx) > fabsf(dy) * 4;
        BOOL hasSignificantlyChangedY = fabsf(dx) * 4 < fabsf(dy);
        
        if(hasSignificantlyChangedX) { // FLINGING MORE ON THE X AXIS
            if (dx > 0) swipeOperation = [Directions RIGHT];
            else swipeOperation = [Directions LEFT];
        } else if(hasSignificantlyChangedY) { // FLINGING MORE ON THE Y AXIS
            if (dy > 0) swipeOperation = [Directions DOWN];
            else swipeOperation = [Directions UP];
        }
        
        CGPoint center = [sender locationInView:self.swipesView];
        CGFloat factor = [self getSwipeOffset];
        
        [self.swipesDelegate onThresholdChange:fabsf(factor) + .33f];
        if(center.x != 0 && center.y != 0) sl.center = center;
        if(factor != 0) sl.rotation = [self getExitRotation:swipeOperation withFactor:factor];
        
        BOOL isReady = hasSignificantlyChangedX || hasSignificantlyChangedY;
        if(swipeOperation != nil && swipeOperation != self.swipeOperation && isReady) {
            self.swipeOperation = swipeOperation;
            [self.swipesDelegate onDirectionChange:self.swipeOperation];
            if(DEBUG) NSLog(@"self.swipeOperation=%@", self.swipeOperation);
        }
        
    }
}

-(CGFloat) getExitRotation:(Directions*) swipeOperation withFactor:(CGFloat) factor {
    CGFloat rotation = [self.swipesDelegate getRotation] * 2.f * factor;
    
    if (self.touchPosition == [[OSwipesManager TOUCH_BELOW] intValue]) {
        rotation = -rotation;
    }
    if (self.swipeOperation == Directions.UP || self.swipeOperation == Directions.DOWN) {
        rotation = 0;
    }
    return rotation;
}
- (CGFloat) getSwipeOffset {
    
    BOOL isVertical = self.swipeOperation == [Directions UP] || self.swipeOperation == [Directions DOWN];
    
    CGFloat zeroToOneValue = isVertical ?
    (self.swipesCard.frame.origin.y + (self.swipesCard.frame.size.height / 2) - self.swipesView.frame.origin.y) / (self.swipesView.frame.size.height)
    : (self.swipesCard.frame.origin.x + (self.swipesCard.frame.size.width / 2) - self.swipesView.frame.origin.x) / (self.swipesView.frame.size.width);
    if (zeroToOneValue < 0) zeroToOneValue = 0.f;
    if (zeroToOneValue > 1) zeroToOneValue = 1.f;
    return zeroToOneValue * 2.f - 1.f;
}

-(BOOL)swipedBeyondRightEdge {
    BOOL isCorrectDirection = self.swipeOperation == [Directions RIGHT];
    
    float screenWidth = self.swipesView.frame.size.width;
    float rightSide = self.swipesCard.frame.origin.x + self.swipesCard.frame.size.width;
    float rightEdge = (4 * screenWidth) / 7.f;
    float swipeEdgeLimit = rightSide / [[OSwipesManager SWIPE_DIVISOR] floatValue];
    BOOL isOutsideBounds = swipeEdgeLimit > rightEdge;
    if(DEBUG) NSLog(@"screenWidth=%f\nswipeEdgeLimit=%f\nrightSide=%f\nrightEdge=%f\nisOutsideBounds=%d",screenWidth, swipeEdgeLimit, rightSide, rightEdge, isOutsideBounds);
    
    return isCorrectDirection && isOutsideBounds;
}
-(BOOL)swipedBeyondLeftEdge {
    BOOL isCorrectDirection = self.swipeOperation == [Directions LEFT];
    
    float screenWidth = self.swipesView.frame.size.width;
    float leftSide = self.swipesCard.frame.origin.x + self.swipesCard.frame.size.width;
    float leftEdge = 2 * screenWidth / 7.f;
    float swipeEdgeLimit = leftSide / [[OSwipesManager SWIPE_DIVISOR] floatValue];
    BOOL isOutsideBounds = swipeEdgeLimit < leftEdge;
    if(DEBUG) NSLog(@"screenWidth=%f\nswipeEdgeLimit=%f\nleftSide=%f\nleftEdge=%f\nisOutsideBounds=%d",screenWidth, swipeEdgeLimit, leftSide, leftEdge, isOutsideBounds);
    
    return isCorrectDirection && isOutsideBounds;
}
-(BOOL)swipedBeyondTopEdge {
    BOOL isCorrectDirection = self.swipeOperation == [Directions UP];
    
    float screenHeight = self.swipesView.frame.size.height;
    float leftSide = self.swipesCard.frame.origin.x;
    float leftEdge = self.swipesView.frame.origin.x - [[OSwipesManager EXTRA_SPACE] floatValue];
    float rightSide = self.swipesCard.frame.origin.x + self.swipesCard.frame.size.width;
    float rightEdge = self.swipesView.frame.origin.x + self.swipesView.frame.size.width + [[OSwipesManager EXTRA_SPACE] floatValue];
    
    float topSide = self.swipesCard.frame.origin.y + (self.swipesCard.frame.size.height/([[OSwipesManager SWIPE_DIVISOR] floatValue] + 1));
    float topEdge = screenHeight / 7.f;
    
    BOOL isOutsideBounds = leftEdge < leftSide && rightEdge > rightSide && topSide < topEdge;
    if(DEBUG) NSLog(@"screenHeight=%f\nleftSide=%f\nleftEdge=%f\nrightSide=%f\nrightEdge=%f\ntopSide=%f\ntopEdge=%f\nisOutsideBounds=%d",screenHeight, leftSide, leftEdge, rightSide, rightEdge, topSide, topEdge, isOutsideBounds);
    
    return isCorrectDirection && isOutsideBounds;
}
-(BOOL)swipedBeyondBottomEdge {
    BOOL isCorrectDirection = self.swipeOperation == [Directions DOWN];
    
    float screenHeight = self.swipesView.frame.size.height;
    float leftSide = self.swipesCard.frame.origin.x;
    float leftEdge = self.swipesView.frame.origin.x - [[OSwipesManager EXTRA_SPACE] floatValue];
    float rightSide = self.swipesCard.frame.origin.x + self.swipesCard.frame.size.width;
    float rightEdge = self.swipesView.frame.origin.x + self.swipesView.frame.size.width + [[OSwipesManager EXTRA_SPACE] floatValue];
    
    float bottomSide = self.swipesCard.frame.origin.y + (self.swipesCard.frame.size.height / ([[OSwipesManager SWIPE_DIVISOR] floatValue] / 2));
    float bottomEdge = 6 * screenHeight / 7.f;
    
    BOOL isOutsideBounds = leftEdge < leftSide && rightEdge > rightSide && bottomSide > bottomEdge;
    if(DEBUG) NSLog(@"screenHeight=%f\nleftSide=%f\nleftEdge=%f\nrightSide=%f\nrightEdge=%f\nbottoself.side=%f\nbottomEdge=%f\nisOutsideBounds=%d",screenHeight, leftSide, leftEdge, rightSide, rightEdge, bottomSide, bottomEdge, isOutsideBounds);
    
    return isCorrectDirection && isOutsideBounds;
}

- (void)processSwipe:(Directions*)direction {
    if(DEBUG) NSLog(@"direction=%@", direction);
    
    [self.swipesDelegate onDirectionChange:direction];
    if(![self.swipesDelegate isAllowed:direction]) {
        [self.swipesView performBatchUpdates:^{
            if(DEBUG) NSLog(@"performBatchUpdates self.swipeOperation=%@", self.swipeOperation);
        } completion:^(BOOL finished) { }];
        return;
    }
    
    if(direction == [Directions LEFT]) [self.swipesDelegate performSwipeLeft];
    else if(direction == [Directions RIGHT]) [self.swipesDelegate performSwipeRight];
    else if(direction == [Directions UP]) [self.swipesDelegate performSwipeUp];
    else if(direction == [Directions DOWN]) [self.swipesDelegate performSwipeDown];
}
-(BOOL)checkForSwipe {
    BOOL checked = NO;
    if((checked=[self swipedBeyondTopEdge])) [self processSwipe:[Directions UP]];
    else if((checked=[self swipedBeyondBottomEdge])) [self processSwipe:[Directions DOWN]];
    else if((checked=[self swipedBeyondRightEdge])) [self processSwipe:[Directions RIGHT]];
    else if((checked=[self swipedBeyondLeftEdge])) [self processSwipe:[Directions LEFT]];
    return checked;
}
@end
