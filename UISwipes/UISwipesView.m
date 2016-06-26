//
//  UISwipesView.m
//  UISwipesView
//
//  Created by Christopher Miller on 28/03/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import "UISwipesView.h"
#import <Foundation/Foundation.h>
#import "OSwipesManager.h"

static NSMutableArray *mSwipesDelegates = nil;
static Directions *LEFT = nil;
static Directions *DOWN = nil;
static Directions *RIGHT = nil;
static Directions *UP = nil;

@interface Directions ()
@property (nonatomic, assign) int bit;
//- (int)bits;
@end

@implementation Directions

-(id) init:(int)input {
    self = [super init];
    self.bit = input;
    return self;
}

+(Directions*)directionWithInt:(int)input {
    return [[Directions alloc] init:input];
}
/**
 * LEFT Direction (0x03)
 */
+(Directions*)LEFT {
    if(LEFT == nil)
        LEFT = [Directions directionWithInt:0x3];
    return LEFT;
}
/**
 * DOWN Direction (0x50)
 */
+(Directions*)DOWN {
    if(DOWN == nil)
        DOWN = [Directions directionWithInt:0x50];
    return DOWN;
}
/**
 * RIGHT Direction (0x30)
 */
+(Directions*)RIGHT {
    if(RIGHT == nil)
        RIGHT = [Directions directionWithInt:0x30];
    return RIGHT;
}
/**
 * UP Direction (0x05)
 */
+(Directions*)UP {
    if(UP == nil)
        UP = [Directions directionWithInt:0x5];
    return UP;
}

- (NSString *)description {
    
    if(self.bit == 0x3) return @"LEFT";
    else if(self.bit == 0x5) return @"UP";
    else if(self.bit == 0x30) return @"RIGHT";
    else return @"DOWN";
    
}

- (int)bits {
    return self.bit;
}
@end

@implementation UISwipesViewCell
@end

@interface UISwipesView () <UICollectionViewDataSource, OSwipesManagerDelegate>
/**
 Allows left swipes through Interface Builder
 **/
@property (nonatomic, assign) IBInspectable BOOL direction_left;
/**
 Allows down swipes through Interface Builder
 **/
@property (nonatomic, assign) IBInspectable BOOL direction_down;
/**
 Allows right swipes through Interface Builder
 **/
@property (nonatomic, assign) IBInspectable BOOL direction_right;
/**
 Allows up swipes through Interface Builder
 **/
@property (nonatomic, assign) IBInspectable BOOL direction_up;
/**
 Allows changes in swipe rotation through Interface Builder
 **/
@property (nonatomic, assign) IBInspectable CGFloat swipeRotation;

@property (nonatomic, assign) BOOL loadedFromNib;
@property (nonatomic, assign) int mAllowedDirections;
@property (nonatomic, assign) int maxVisibleCards;

@property(nonatomic, assign) UISwipesViewCell *visibleCard;
@property (strong, nonatomic) OSwipesManager * swipesManager;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;
@end

@implementation UISwipesView

+ (void) addUISwipesViewDelegate:(id<UISwipesViewDelegate>)u {
    if (mSwipesDelegates == nil)
        mSwipesDelegates = [[NSMutableArray alloc] init];
    if (![mSwipesDelegates containsObject:u]) {
        [mSwipesDelegates addObject:u];
    }
}
+(void) removeUISwipesViewDelegate:(id<UISwipesViewDelegate>)u {
    if (mSwipesDelegates == nil)
        mSwipesDelegates = [[NSMutableArray alloc] init];
    if ([mSwipesDelegates containsObject:u]) {
        NSLog(@"%@", u);
        [mSwipesDelegates removeObject:u];
    }
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpDefaults];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.collectionViewLayout];
        [self addSubview:self.collectionView];
        
        [self awakeFromNib];
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.loadedFromNib = YES;
    
    [self setUpDefaults];
    NSArray *subviews = super.subviews;
    
    for (UIView * view in subviews) {
        if ([view isKindOfClass:[UICollectionView class]]) {
            self.collectionView = (UICollectionView*) view;
        }
    }
    [self.collectionView setCollectionViewLayout:self.collectionViewLayout];
    
    return self;
}
/*- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"self.collectionView=%@",self.collectionView);

        self.loadedFromNib = YES;
        
        [self setUpDefaults];
        
        NSArray *subviews = super.subviews;
        
        for (UIView * view in subviews) {
            if ([view isKindOfClass:[UICollectionView class]]) {
                self.collectionView = (UICollectionView*) view;
            }
        }
    }
    NSLog(@"self.collectionView=%@",self.collectionView);
    return self;
}*/
- (void) setUpDefaults {
    
    self.mAllowedDirections = 0;
    self.swipeRotation = .15f;
    self.maxVisibleCards = 3;
    self.collectionViewLayout = [[UISwipesViewLayout alloc] init];
    
}
-(void) awakeFromNib {
    NSLog(@"self.collectionView=%@",self.collectionView);
    
    UISwipesViewLayout *sl = (UISwipesViewLayout*) self.collectionViewLayout;
    sl.swipesView = self;
    
    self.swipesManager = [[OSwipesManager alloc] initWithSwipesView:self andLayout:(UISwipesViewLayout*)self.collectionViewLayout];
    [self.collectionView addGestureRecognizer:self.swipesManager];
    
    
    if(self.loadedFromNib) {
        
        if(self.direction_left) [self addAllowedDirections:[Directions LEFT]];
        if(self.direction_down) [self addAllowedDirections:[Directions DOWN]];
        if(self.direction_right) [self addAllowedDirections:[Directions RIGHT]];
        if(self.direction_up) [self addAllowedDirections:[Directions UP]];
        
        self.swipeRotation = .09f;
        
    }
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    
    //Bring to front so that it does not get hidden by cells
    [self bringSubviewToFront:view];
}
-(NSInteger)count {
    return self.collectionView.subviews.count;
}
-(void) setAllowedDirections:(NSArray*)allowed {
    self.mAllowedDirections = 0;
    for (Directions * direction in allowed) {
        self.mAllowedDirections |= direction.bit;
    }
}
-(void) addAllowedDirections:(Directions*)d {
    self.mAllowedDirections |= d.bit;
}

-(void) setDelegate:(id<UISwipesViewDelegate>)delegate {
    [UISwipesView addUISwipesViewDelegate:delegate];
}

-(void) setDataSource:(id<UISwipesViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self.collectionView setDataSource:self];
}

-(void)setBackgroundColor:(UIColor*)color {
    [self.collectionView setBackgroundColor:color];
}

-(void)setCenter:(CGPoint)center {
    UISwipesViewLayout *sl = (UISwipesViewLayout*) self.collectionViewLayout;
    sl.center = center;
}

-(void)setFrame:(CGRect)frame {
    super.frame = frame;
    self.collectionView.frame = frame;
}

-(int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    UISwipesViewLayout *sl = (UISwipesViewLayout*) self.collectionViewLayout;
    sl.cellCount = MIN(self.maxVisibleCards, [self.dataSource swipesView:self numberOfItemsInSection:section]);
    
    return sl.cellCount;
}

-(int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    id someCaller = self.dataSource;
    if ([someCaller respondsToSelector:@selector(numberOfSectionsInSwipesView:)]) {
        return [self.dataSource swipesView:self numberOfSectionsInSwipesView:self];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource swipesView:self cellForItemAtIndexPath:indexPath];
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (__kindof UISwipesViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    UISwipesViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if([indexPath isEqual:[NSIndexPath indexPathForItem:0 inSection:0]]) self.visibleCard = cell;
    return cell;
}

- (nullable NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point {
    return [self.collectionView indexPathForItemAtPoint:point];
}

- (void)performBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion {
    [self.collectionView performBatchUpdates:^{
        NSLog(@"performBatchUpdates");
    } completion:nil];
}

- (nullable UISwipesViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UISwipesViewCell *cell = (UISwipesViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
//    if (cell.layer.zPosition != indexPath.item) {
//        int zIndex = [self.dataSource swipesView:self numberOfItemsInSection:0] - indexPath.item - 1;
//        [cell.layer setZPosition:zIndex];
//    }
    
//    if (cell.layer.zPosition != indexPath.item) {
//        [cell.layer setZPosition:indexPath.item];
//    }

    return cell;
}

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)onSuccessfulSwipe:(Directions*)direction  {
    for (id<UISwipesViewDelegate> delegate in mSwipesDelegates) {
        if(self.visibleCard) [delegate onSuccessfulSwipe:self.visibleCard direction:direction];
    }
}
- (void)onDirectionChange:(Directions*)direction  {
    for (id<UISwipesViewDelegate> delegate in mSwipesDelegates) {
        if(self.visibleCard) [delegate onDirectionSwipe:self.visibleCard direction:direction];
    }
}
- (void)onThresholdChange:(float)threshold  {
    for (id<UISwipesViewDelegate> delegate in mSwipesDelegates) {
        if(self.visibleCard) [delegate onThresholdChange:self.visibleCard threshold:threshold];
    }
}
- (BOOL)isAllowed:(Directions*)direction  {
    return (self.mAllowedDirections & direction.bit) == direction.bit;
}
- (CGFloat)getRotation  {
    return self.swipeRotation;
}
- (UISwipesViewCell*)getSelectedView  {
    return self.visibleCard;
}

-(void)performSwipeLeft {
    
    int cellCount = [[self collectionView] numberOfItemsInSection:0];
    if (cellCount == 0) return;
    
    [self onDirectionChange:[Directions LEFT]];
    if (![self isAllowed:[Directions LEFT]]) {
        return;
    }
    [self onThresholdChange:1.0f];
//    NSLog(@"performSwipeLeft");
    [self swipeVisibleCard:[Directions LEFT]];
    
}
-(void)performSwipeDown {
    
    int cellCount = [[self collectionView] numberOfItemsInSection:0];
    if (cellCount == 0) return;
    
    [self onDirectionChange:[Directions DOWN]];
    if (![self isAllowed:[Directions DOWN]]) {
        return;
    }
    [self onThresholdChange:1.0f];
//    NSLog(@"performSwipeDown");
    [self swipeVisibleCard:[Directions DOWN]];
    
}
-(void)performSwipeRight {
    
    int cellCount = [[self collectionView] numberOfItemsInSection:0];
    if (cellCount == 0) return;
    
    [self onDirectionChange:[Directions RIGHT]];
    if (![self isAllowed:[Directions RIGHT]]) {
        return;
    }
    [self onThresholdChange:1.0f];
//    NSLog(@"performSwipeRight");
    [self swipeVisibleCard:[Directions RIGHT]];
    
}
-(void)performSwipeUp {
    
    int cellCount = [[self collectionView] numberOfItemsInSection:0];
    if (cellCount == 0) return;
    
    [self onDirectionChange:[Directions UP]];
    if (![self isAllowed:[Directions UP]]) {
        return;
    }
    [self onThresholdChange:1.0f];
//    NSLog(@"performSwipeUp");
    [self swipeVisibleCard:[Directions UP]];
    
}
-(void)swipeVisibleCard:(Directions*)direction {
    
    NSMutableArray * output = nil;
    if(DEBUG) output = [[NSMutableArray alloc] init];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UISwipesViewLayout* sl = (UISwipesViewLayout*) self.collectionViewLayout;
    sl.currentDirection = direction;
    
    if(DEBUG) [output addObject:[NSString stringWithFormat:@"path=%@\ndirection=%@", path, direction]];
    
    if(sl.pannedIndexPath == nil) {
        
        sl.pannedIndexPath = path;
        
        BOOL correctDirection = direction == [Directions LEFT] || direction == [Directions RIGHT];
        if(correctDirection) {
            sl.rotation = .02f;
//            sl.rotation = .00f;
            sl.rotation = .06f;
        }
    }
    
    [self.dataSource swipesView:self postSwipeOperationAtIndexPath:path];
    int cardCount = [self collectionView:self.collectionView numberOfItemsInSection:0];
    BOOL canSimplyDeleteCell = cardCount < self.maxVisibleCards;
    
    if(canSimplyDeleteCell) {
        NSLog(@"canSimplyDeleteCell due to cardCount: %d\n\nself.maxVisibleCards: %d", cardCount, self.maxVisibleCards);
        
        if(DEBUG) [output addObject:[NSString stringWithFormat:@"canSimplyDeleteCell due to cardCount: %d\n\nself.maxVisibleCards: %d", cardCount, self.maxVisibleCards]];
        
        [self.collectionView performBatchUpdates:^{
            @try { [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:path]]; }
            @catch(NSException *e) { [self.collectionView reloadData]; }
            
        } completion:^(BOOL complete) {
            [self onThresholdChange:0.f];
            [self onSuccessfulSwipe:direction];
            
            self.visibleCard = [self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            NSIndexPath *visibleCardIndexPath = [self.collectionView indexPathForCell:self.visibleCard];
            
            if(DEBUG) [output addObject:[NSString stringWithFormat:@"visibleCardIndexPath=%@\nself.visibleCard=%@", visibleCardIndexPath, self.visibleCard]];
            if(DEBUG) NSLog([output componentsJoinedByString:@"\n"]);
        }];
    } else {
        
        if(DEBUG) [output addObject:[NSString stringWithFormat:@"cardCount: %d\n\nself.maxVisibleCards: %d", cardCount, self.maxVisibleCards]];
        
        [self.collectionView performBatchUpdates:^{
            
            NSIndexPath * newPath = [NSIndexPath indexPathForItem:cardCount - 1 inSection:0];
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newPath]];
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:path]];
            
        } completion:^(BOOL complete) {
            [self onThresholdChange:0.f];
            [self onSuccessfulSwipe:direction];
            
            self.visibleCard = [self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            NSIndexPath *visibleCardIndexPath = [self.collectionView indexPathForCell:self.visibleCard];
            if(DEBUG) [output addObject:[NSString stringWithFormat:@"visibleCardIndexPath=%@\nself.visibleCard=%@", visibleCardIndexPath, self.visibleCard]];
            if(DEBUG) NSLog([output componentsJoinedByString:@"\n"]);
            
        }];
    }
}
@end