#STPTransitions

> Unified, easy API for custom iOS view controller transitioning.

Perhaps you watched the [2013 WWDC talk](http://asciiwwdc.com/2013/sessions/218) or read the [slightly](https://developer.apple.com/library/ios/documentation/uikit/reference/UIViewControllerAnimatedTransitioning_Protocol/Reference/Reference.html) [spread-out](https://developer.apple.com/library/ios/documentation/uikit/reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instm/UIViewController/transitionFromViewController:toViewController:duration:options:animations:completion:) [documentation](https://developer.apple.com/library/ios/documentation/uikit/reference/UIViewControllerInteractiveTransitioning_protocol/Reference/Reference.html#//apple_ref/occ/intf/UIViewControllerInteractiveTransitioning) on how to use custom transitions between child view controllers, modal view controllers and in a navigation controller. Couple of minutes in, you're wandering in Protocolandia and you're lost. We don't blame you.  

## Installation

`pod 'STPTransitions'` (via [CocoaPods](http://cocoapods.org))

## Features (TL;DR)

* Child view controller transitions
* Modal view controller transitions (+ fix for landscape)
* Navigation controller transitions
* Unified, simple API

In the works:

* Full interactive transition support

## Usage

First import the library's header:

```
#import <STPTransitions.h>
```

### Quick start: STPBlockTransition

With `STPBlockTransition`, you can quickly create in-line transitions

```
STPTransition *snazzyTransition = [STPTransition transitionWithAnimation:
 ^(UIView *fromView,
   UIView *toView, 
   UIView *containerView, 
   void (^executeOnCompletion)(BOOL finished)) {
     // Your fabulous animations go here
}];
```
Note: You have two important responsibilities:

 * `fromView` **is** a subview of `containerView`, `toView` is **not**. Add it when appropriate. 
 * Execute `executeOnCompletion` when the animation is completed (at the end of its completion block).

### Using transition: navigation controller

To set up, assign the `STPTransitionCenter` singleton as navigation controller's delegate:

```
navigationController.delegate = [STPTransitionCenter sharedInstance];
```

Now simply push and pop view controllers using:

```
[self.navigationController pushViewController:viewController
                              usingTransition:snazzyTransition];
// and                              
[self.navigationController popViewControllerUsingTransition:transition];
```

### Using transition: child controllers

No setup is needed. In the parent controller, switch between two child controllers using:

```
[self transitionFromViewController:oldChildViewController
                  toViewController:newChildViewController
                   usingTransition:snazzyTransition];
```
Note: This transition currently cannot be interactive. If you'd like this feature, voice your opinion in the Issues.

### Using transition: modal controller

To set up, assign the `STPTransitionCenter` singleton as presenting controller's delegate:

```
self.transitioningDelegate = [STPTransitionCenter sharedInstance];
```

Now simply present and dismiss view controllers using:

```
[self presentViewController:viewController
            usingTransition:snazzyTransition
                 completion:completion];
// and                
[self dismissViewControllerUsingTransition:snazzyTransition
                                completion:(void (^)(void))completion];
```

### Proper usage: Subclassing STPTransition

To maintain thin view controllers and a nicely separated codebase, you probably don't want to keep your transition animation code in the view controller itself. It also allows for the transition to be reused. You achieve both of these goals by subclassing `STPTransition`.

See the [example project](Example) for a hands-on code example.

### Reverse transitions

When pushing or presenting a view controller, you can specify which transition should happen when the returning (i.e. pop or dismiss) operation takes place. To do that, simply assign the transition object to be used to `reverseTransition`.

This greatly helps decoupling, because the pushed/presented controller doesn't have to know anything about how it's being shown.

_Pro tip:_ Just assign `reverseTransition` to be a new instance of the same class you just created for the push/present. See below on how to easily handle both animations in one class.


### Modal transitions in landscape orientation

As of iOS 7.0.2, custom modal transitions in landscape orientation are not very usable, because the views iOS gives you have all kinds of messed up frames and transforms. STPTransitions attempts to solve this for you, providing you a view in the orientation you'd expect. This has been tested and works for iPad full-screen landscape custom modals.

### Regular and reverse implementation in one class

Often, you don't want to have two `STPTransition` subclasses for the same type of animation, i.e. one for going forward, and one for going back. When going back – popping or dismissing a controller – the transition instance automatically gets assigned `YES` for `isReversed`.

_Pro tip_: Reuse code and handle both forward and backward transitions in the same class. Usually it means having `if/else` conditionals on `isReversed`.

### Triggering by a gesture recognizer

A transition can have a gesture recognizer assigned. The transition gets _automatically_ kicked off when the recognizer's gesture is detected.

Note: This does **not** mean the transition is interactive (e.g. follows users finger), although it **can** be.

### Interactive transitions

TODO: Interactive transitions aren't fully supported yet.

1. Set the `interactive` property to `YES`.
2. Assign `gestureRecognizer` that is going to track the progress.
3. Implement `interactiveGesturePercentageCompletionForPoint:` in your subclass.

Note: An interactive transition doesn't necessarily need to be _triggered_ interactively, e.g. it can be triggered by a button and happen non-interactively. The `wasTriggeredInteractively` property informs about the way it was triggered.

## Included transitions

If you'd like the library to include some configurable, often used transitions by default, voice your opinion in the Issues. Contributions are also welcome.

## FAQ

**Q: I need for my `UINavigationController` to have my own delegate. What do I do?**  
A: Subclass your delegate from `STPTransitionCenter` and use your own instance instead of the default center. You're responsible for keeping that object around, as you're not using the singleton. Make sure you call `super` in any delegate methods that are implemented by the center.  
  
---

Created by [Stepan Hruda](https://twitter.com/stepanhruda). If you follow him on Twitter, he's gonna have a good time.

Thanks goes to [Josh Vickery](https://twitter.com/vickeryj) and [ShopKeep POS](http://www.shopkeep.com) for contributions and feedback.

Released under [MIT License](LICENSE).
