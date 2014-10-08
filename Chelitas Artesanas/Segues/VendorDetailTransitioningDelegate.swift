//
//  VendorDetailTransitioningDelegate.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 10/7/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

// MARK: - VendorDetailAnimator
// MARK: -

class VendorDetailAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool;
    
    init(isPresenting: Bool) {
        self.presenting = isPresenting
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController =
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController =
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let offPageTransform =
            CGAffineTransformMakeTranslation(-CGRectGetWidth(toViewController.view.bounds), 0)
        
        if presenting {
            transitionContext.containerView().addSubview(toViewController.view)

            toViewController.view.transform = offPageTransform
            
            UIView.animateWithDuration(transitionDuration(transitionContext),
                animations: { () -> Void in
                    toViewController.view.transform = CGAffineTransformIdentity
                }) { (finished) -> Void in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                }
        } else {
            UIView.animateWithDuration(transitionDuration(transitionContext),
                animations: { () -> Void in
                    fromViewController.view.transform = offPageTransform
                }) { (finished) -> Void in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                }
        }
    }
}




// MARK: - VendorDetailTransitioningDelegate
// MARK: -

class VendorDetailTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var interactionController: UIPercentDrivenInteractiveTransition?
    weak var viewController: VendorDetailViewController?
    weak var presentationView: UIView?

    required init(viewController: VendorDetailViewController) {
        self.viewController = viewController
        super.init()
    }
    
    // Required
    func setupGestureRecognizer(#view: UIView) {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "onPan:")
        presentationView = view
        presentationView!.addGestureRecognizer(panRecognizer)
    }
    
    
    // MARK: - Gesture Recognizers
    
    func onPan(recognizer: UIPanGestureRecognizer) {
        func noop() {}
        
        if let view = self.presentationView {
            switch recognizer.state {
                
            case .Began:
                let location = recognizer.locationInView(view)
                if location.x > CGRectGetMidX(view.bounds) {
                    self.interactionController = UIPercentDrivenInteractiveTransition()
                    self.viewController?.dismissViewControllerAnimated(true, completion: nil)
                }
                
            case .Changed:
                let translation = recognizer.translationInView(view)
                let percentComplete = fabs(translation.x / CGRectGetWidth(view.bounds))
                interactionController?.updateInteractiveTransition(percentComplete)
                
            case .Ended:
                let isClosing = recognizer.velocityInView(view).x < 0
                if isClosing {
                    interactionController?.finishInteractiveTransition()
                } else {
                    interactionController?.cancelInteractiveTransition()
                }
                interactionController = nil
                
            default:
                noop()
            }
        }
    }
    
    
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let animator = VendorDetailAnimator(isPresenting: true)
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = VendorDetailAnimator(isPresenting: false)
        return animator
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
