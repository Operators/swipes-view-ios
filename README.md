# Swipes View Library (iOS)
[UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html) (a Tinder-like View) displays **views (or cards) to be swiped** in all **directions of your choice** and also allows you to **programatically swipe** (with a button or a command).

![swipes](https://raw.githubusercontent.com/Operators/swipes-view-ios/master/basic.gif "UISwipesView") ![swipes](https://raw.githubusercontent.com/Operators/swipes-view-ios/master/components.gif "UISwipesView") ![swipes](https://raw.githubusercontent.com/Operators/swipes-view-ios/master/advanced.gif "UISwipesView")

On this page, you can:
* [Download the latest version](https://github.com/Operators/swipes-view-ios/files/183224/Swipes.zip) of the library
* Download the [Swipes View Library and Eclipse Examples](https://github.com/Operators/swipes-view-ios/files/183225/SwipesEclipseExamples.zip)
* Or download the [Swipes View Library and Studio Examples](https://github.com/Operators/swipes-view-ios/files/183223/SwipesStudioExamples.zip)
* Check out [How to set up the UISwipesView](https://github.com/Operators/swipes-view-ios#setup)
* Check out [How to pass data](https://github.com/Operators/swipes-view-ios#passing-data)
* Check out [How to automate swipes](https://github.com/Operators/swipes-view-ios#automating-swipes)
* Check out [How to listen for swipe actions](https://github.com/Operators/swipes-view-ios#listening-for-swipe-actions)
* Check out [our Further Reading section](https://github.com/Operators/swipes-view-ios#further-reading)

Happy Swiping, :)

Setup
-----

The [UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html) can be defined programmatically in Objective-C:
```    
    //The array defines which directions the UISwipesView will swipe to
    NSNumber * directions = @[[Directions LEFT], [Directions.RIGHT]];
    
    UISwipesView *swipesView = [[UISwipesView alloc] initWithFrame:CGRect(10, 10, 300,300)]; //Or from Storyboard Outlet (self.swipesView)
	[swipesView setAllowedDirections:directions]; //setAllowedDirections(Directions.RIGHT, Directions.DOWN);
```

The [UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html) can also be defined programmatically in Swift:
```    
    //The array defines which directions the UISwipesView will swipe to
	var directions: [Directions] = [Directions.LEFT(), Directions.RIGHT()]
	
	var swipesView: UISwipesView = UISwipesView(frame: CGRect(10, 10, 300, 300)) //Or from Storyboard Outlet (self.swipesView)
	swipesView.setAllowedDirections(directions) //setAllowedDirections(Directions.RIGHT(), Directions.DOWN());
```
    
Alternatively [UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html) can be defined in XCode IB:

![inspector](https://raw.githubusercontent.com/Operators/swipes-view-ios/master/ib_inspector.png "Interface Builder")
   
Passing Data
---------------

Data must be passed to the [UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html) from a [UISwipesViewDataSource](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDataSource.html) implementation, and using a [UISwipesViewCell](http://operators.github.io/swipes-view-ios/Classes/UISwipesViewCell.html).

A basic example of a [UISwipesViewCell](http://operators.github.io/swipes-view-ios/Classes/UISwipesViewCell.html) subclass would look as follows:
```	
@interface BasicCardCell : UISwipesViewCell
@property (strong, nonatomic) UILabel *label;
@end

```

A basic example of a [UISwipesViewCell](http://operators.github.io/swipes-view-ios/Classes/UISwipesViewCell.html) implementation accepting data would look as follows:
```	
- (UISwipesViewCell *)swipesView:(UISwipesView *)swipesView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCardCell *cell = (BasicCardCell*)[swipesView dequeueReusableCellWithReuseIdentifier:@"BasicCardCell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%@", self.cardData[indexPath.item]];
    
    return cell;
}

```

Automating Swipes
---------------

The [UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html) can swipe programatically as well, ideally through a button click (or some other action):
```
	UIButton swipeLeftButton = [[UIButton alloc] init];
    [swipeLeftButton 
    		addTarget:self.swipesView 
    		action:@selector(performSwipeLeft) 
    		forControlEvents:UIControlEventTouchUpInside];
    		
	UIButton swipeDownButton = [[UIButton alloc] init];
    [swipeDownButton 
    		addTarget:self.swipesView 
    		action:@selector(performSwipeDown) 
    		forControlEvents:UIControlEventTouchUpInside];
    		
	UIButton swipeRightButton = [[UIButton alloc] init];
    [swipeRightButton 
    		addTarget:self.swipesView 
    		action:@selector(performSwipeRight) 
    		forControlEvents:UIControlEventTouchUpInside];
    		
	UIButton swipeUpButton = [[UIButton alloc] init];
    [swipeUpButton 
    		addTarget:self.swipesView 
    		action:@selector(performSwipeUp) 
    		forControlEvents:UIControlEventTouchUpInside];
```	
        
Listening For Swipe Actions
---------------

The [UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html) can have multiple listeners. Card components (as well as Views or Controllers) can listen for swipes all simultaneously:
	
* First update your class to implement [UISwipesViewDelegate](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html)
```
@interface YourClass : UIView <UISwipesViewDelegate>
@property (strong, nonatomic) Directions *direction;
@property (strong, nonatomic) UILabel *label;
@end

@implementation YourClass
- (void)onThresholdChange:(UISwipesViewCell*)card threshold:(CGFloat)threshold {
	// Handle some threshold change like view alpha
}

- (void)onDirectionSwipe:(UISwipesViewCell*)card direction:(Directions*)direction {
	// Handle some direction change like change indicator color
}

- (void)onSuccessfulSwipe:(UISwipesViewCell*)card direction:(Directions*)direction {
	// Handle some success by updating data set, or application state
}
@end
```
* Alternatively, you can update your protocols to extend [UISwipesViewDelegate](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html)
	
* Next place the addSwipesListener reference along with your implementation of [UISwipesViewDelegate](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html).
```
@implementation YourClass
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [UISwipesView addUISwipesViewDelegate:self];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.label];
    }
    return self;
}
@end
```


**Once that is complete, you're ready to listen for [onThresholdChange](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html#//api/name/onThresholdChange:threshold:), [onDirectionSwipe](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html#//api/name/onDirectionSwipe:direction:) or [onSuccessfulSwipe](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html#//api/name/onSuccessfulSwipe:direction:).**

* The [onThresholdChange](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html#//api/name/onThresholdChange:threshold:) Swipe Action provides feedback on what amount the swipe is complete. An Example of this would look as follows:
```
- (void)onThresholdChange:(UISwipesViewCell*)card threshold:(CGFloat)threshold {
    
    self.label.alpha = threshold;// Set the alpha of some overlay view
    
}
```
* The [onDirectionSwipe](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html#//api/name/onDirectionSwipe:direction:) Swipe Action provides feedback on what direction the swipe is going. An Example of this would look as follows:
```
- (void)onDirectionSwipe:(UISwipesViewCell*)card direction:(Directions*)direction {
    self.direction = direction;// Reset the direction state wthin some object
}
```
* The [onSuccessfulSwipe](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDelegate.html#//api/name/onSuccessfulSwipe:direction:) Swipe Action provides feedback on what direction the sucessful swipe was going. An Example of this would look as follows:
```
- (void)onSuccessfulSwipe:(UISwipesViewCell*)card direction:(Directions*)direction {
    
	// There needs to be a filter on the views
	BOOL isCurrentView = [self isEqual:card.yourClassObject];
    if(isCurrentView) self.label.text = @"New State"; // Reset view state, possibly for reuse
	
}
```

Further Reading
---------------

See the [Documentation](http://operators.github.io/swipes-view-ios) for more on the [UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html), or [UISwipesViewDataSource](http://operators.github.io/swipes-view-ios/Protocols/UISwipesViewDataSource.html) functions.

See the [MAC Guides](#) for detailed examples of how to use the [UISwipesView](http://operators.github.io/swipes-view-ios/Classes/UISwipesView.html).
* Like with a [Basic Example](#)
* Interacting with other [View Components](#)
* Or with [UISwipesViewDelegates](#).

See the [iOS Documentation](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionView_class/) for more on [UICollectionView](https://github.com/Microsoft/WinObjC/blob/master/Frameworks/UIKit/UICollectionView.mm), for a peek into the UISwipesView origins.

See the [iOS Documentation](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionViewDataSource_protocol/) for more on [UICollectionViewDataSource](https://github.com/Microsoft/WinObjC/blob/343f28478265d455489ae107fb9542a01bc15103/include/UIKit/UICollectionViewDataSource.h), to see how the UISwipesViewDataSource started.

	
LICENSE
===============
The MIT License (MIT)
Copyright (c) 2016 Operators

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
