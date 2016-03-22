# Swipes View Library (Android)
[SwipesView](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.html) (a Tinder-like View) displays **views (or cards) to be swiped** in all **directions of your choice** and also allows you to **programatically swipe** (with a button or a command).

![swipes](https://raw.githubusercontent.com/Operators/swipes-view-android/master/d2ucKOT49Hchristopher03162016012902.gif "SwipesView") ![swipes](https://raw.githubusercontent.com/Operators/swipes-view-android/master/d2ucKOT49Hchristopher03162016013504.gif "SwipesView") ![swipes](https://raw.githubusercontent.com/Operators/swipes-view-android/master/d2ucKOT49Hchristopher03212016160353.gif "SwipesView") ![swipes](https://raw.githubusercontent.com/Operators/swipes-view-android/master/d2ucKOT49Hchristopher03212016160804.gif "SwipesView")

On this page, you can:
* [Download the latest version](https://github.com/Operators/swipes-view-android/files/183224/Swipes.zip) of the library
* Download the [Swipes View Library and Eclipse Examples](https://github.com/Operators/swipes-view-android/files/183225/SwipesEclipseExamples.zip)
* Or download the [Swipes View Library and Studio Examples](https://github.com/Operators/swipes-view-android/files/183223/SwipesStudioExamples.zip)
* Check out [How to set up the SwipesView](https://github.com/Operators/swipes-view-android#setup)
* Check out [How to pass data](https://github.com/Operators/swipes-view-android#passing-data)
* Check out [How to automate swipes](https://github.com/Operators/swipes-view-android#automating-swipes)
* Check out [How to swipe w/ WebView](https://github.com/Operators/swipes-view-android#swiping-with-self-contained-views)
* Check out [How to listen for swipe actions](https://github.com/Operators/swipes-view-android#listening-for-swipe-actions)
* Check out [our Further Reading section](https://github.com/Operators/swipes-view-android#further-reading)

Happy Swiping, :)

Setup
-----

The [SwipesView](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.html) can be defined programmatically in Java:
```    
    //The array defines which directions the SwipesView will swipe to
    Directions directions[] = new Directions[] { Directions.LEFT, Directions.RIGHT };
    
    SwipesView swipesView = new SwipesView(context); //(SwipesView) findViewById(R.id.swipes);
	swipesView.setAllowedDirections(directions); //setAllowedDirections(Directions.RIGHT, Directions.DOWN);
```
    
Or in an Android XML Layout:
```
    <?xml version="1.0" encoding="utf-8"?>
	<com.operators.swipes.SwipesView 
	    xmlns:android="http://schemas.android.com/apk/res/android"
	    xmlns:swipes="http://schemas.android.com/apk/res-auto"
	    android:id="@+id/container"
	    android:layout_width="match_parent"
	    android:layout_height="match_parent"
	    android:background="#40aeaeae"
	    swipes:directions="right|down"
	    swipes:swipe_rotation="15.5" />
```	    
Passing Data
---------------

Data must be passed to the [SwipesView](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.html) from a [SwipesAdapter](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesAdapter.html) subclass:

	swipesView.setAdapter(new BasicExampleSwipesAdapter(this, R.layout.card_item));
	
A basic example of a [SwipesAdapter](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesAdapter.html) subclass would look as follows:
```	
	class BasicExampleSwipesAdapter extends SwipesAdapter<Integer> {
		ArrayList<Integer> mInts = new ArrayList<Integer>(Arrays.asList(new Integer[]{
			1, 11, 111
		}));
		public BasicExampleSwipesAdapter(Context context, int resource) {
			super(context, resource);
		}
		@Override public View getView (int position, View convertView, ViewGroup parent) {
			View inflatedResource = super.getView(position, convertView, parent);
			TextView card_text = (TextView) inflatedResource.findViewById(R.id.card_text);
			
			String integer = getItem(position);
			card_text.setText(integer);
			
			return inflatedResource;
		}
		@Override public Integer getItem(int position) { return mInts.get(position); }
		@Override public void removeItem(int position) { mInts.remove(position); }
		@Override public int getCount() { return mInts.size(); }
	}
```

Automating Swipes
---------------

The [SwipesView](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.html) can swipe programatically as well, ideally through a button click (or some other action):
```
	Button swipeLeftButton = new Button(context);
	swipeLeftButton.setOnClickListener(new View.OnClickListener() {
		@Override public void onClick(View v) { swipesView.performSwipeLeft(); }
	});
	
	Button swipeRightButton = new Button(context);
	swipeRightButton.setOnClickListener(new View.OnClickListener() {
		@Override public void onClick(View v) { swipesView.performSwipeRight(); }
	});
	
	Button swipeUpButton = new Button(context);
	swipeUpButton.setOnClickListener(new View.OnClickListener() {
		@Override public void onClick(View v) { swipesView.performSwipeUp(); }
	});
	
	Button swipeDownButton = new Button(context);
	swipeDownButton.setOnClickListener(new View.OnClickListener() {
		@Override public void onClick(View v) { swipesView.performSwipeDown(); }
	});
```	

Swiping With Self Contained Views
---------------

The [SwipesView](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.html) can swipe with self contained views like WebView as well. We simply have to add the SwipesView.onTouch static reference:
```
	WebView wv = new WebView(context) {
        @Override public boolean onTouchEvent(MotionEvent event) {
        	SwipesView.onTouch(event);
            return super.onTouchEvent(event);
        }
	};
 ```   	
...or subclass instead:
```
	class CustomWebView extends WebView {
        @Override public boolean onTouchEvent(MotionEvent event) {
        	SwipesView.onTouch(event);
            return super.onTouchEvent(event);
        }
	};
```	
...using the subclass you can then add the reference in XML:
```
    <com.operators.swipes.CustomWebView
        android:id="@+id/swipesWebView"
		... />
```     
        
Listening For Swipe Actions
---------------

The [SwipesView](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.html) can have multiple listeners. Card components (as well as Views, Activities or Fragments) can listen for swipes all simultaneously:
	
* First update your class to implement [SwipesView.OnSwipeListener](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html)
```
	class YourClass implements SwipesView.OnSwipeListener {
	
		@Override public void onThresholdChange(View card, float threshold) {
			// Handle some threshold change like view alpha
		}
		
		@Override public void onDirectionSwipe(View card, Directions direction) {
			// Handle some direction change like change indicator color
		}
		
		@Override public void onSuccessfulSwipe(View card, Directions direction) {
			// Handle some success by updating data set, or application state
		}
	}
```
* Alternatively, you can update your interfaces to extend [SwipesView.OnSwipeListener](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html)
	
* Next place the addSwipesListener reference along with your implementation of [SwipesView.OnSwipeListener](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html).
```
	class YourClass implements SwipesView.OnSwipeListener {
		public YourClass(...) {
		
			SwipesView.addSwipesListener(this);
		}
		...
	}
```


**Once that is complete, you're ready to listen for [onThresholdChange](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html#onThresholdChange(android.view.View, float)), [onDirectionSwipe](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html#onDirectionSwipe(android.view.View, com.operators.swipes.SwipesView.Directions)) or [onSuccessfulSwipe](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html#onSuccessfulSwipe(android.view.View, com.operators.swipes.SwipesView.Directions)).**

* The [onThresholdChange](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html#onThresholdChange(android.view.View, float)) Swipe Action provides feedback on what amount the swipe is complete. An Example of this would look as follows:
```
	@Override public void onThresholdChange(View card, float threshold) {
	
		TextView someOverlayView = (TextView) card.findViewById(R.id.someOverlayView);
		someOverlayView.setAlpha(threshold);// Set the alpha of some overlay view
	}
```
* The [onDirectionSwipe](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html#onDirectionSwipe(android.view.View, com.operators.swipes.SwipesView.Directions)) Swipe Action provides feedback on what direction the swipe is going. An Example of this would look as follows:
```
	@Override public void onDirectionSwipe(View card, Directions direction) {
	
		mSomeDirectionState.setState(direction);// Reset the direction state of some object		
	}
```
* The [onSuccessfulSwipe](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.OnSwipeListener.html#onSuccessfulSwipe(android.view.View, com.operators.swipes.SwipesView.Directions)) Swipe Action provides feedback on what direction the sucessful swipe was going. An Example of this would look as follows:
```
	@Override public void onSuccessfulSwipe(View card, Directions direction) {
		
		// There needs to be a filter on the view state
		Object tag = card.findViewById(R.id.youTubePresenter).getTag();
		boolean isCurrentPreview = tag.equals(mCurrentPreview.getTag());
		if(isCurrentPreview) mCurrentPreview.setTag(""); // Reset current view
		
	}
```

Further Reading
---------------

See the [Javadocs](http://operators.github.io/swipes-view-android) for more on the [SwipesView](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.html), or [SwipesAdapter](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesAdapter.html) functions.

See the [MAC Guides](#) for detailed examples of how to use the [SwipesView](http://operators.github.io/swipes-view-android/com/operators/swipes/SwipesView.html).
* Like with a [Basic Example](#)
* Interacting with other [View Components](#)
* Or with [SwipesViewListeners](#).

See the [Android Javadocs](http://developer.android.com/reference/android/widget/AdapterView.html) for more on [AdapterView](https://github.com/android/platform_frameworks_base/blob/master/core/java/android/widget/AdapterView.java), for a peek into the SwipesView origins.

See the [Android Javadocs](http://developer.android.com/reference/android/widget/BaseAdapter.html) for more on [BaseAdapter](https://github.com/android/platform_frameworks_base/blob/7de7e0b0dd61acba813dec3a07d29f1d62026470/core/java/android/widget/BaseAdapter.java), to see how the SwipesAdapter started.

	
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
