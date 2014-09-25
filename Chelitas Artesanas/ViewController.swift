//
//  ViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let map: Mapper
    var breweryViewController: BreweryViewController?
    let aboutButton: UIButton
    
    // MARK: Lifecycle
    
    required init(coder aDecoder: NSCoder) {
        map = Mapper()
    
        aboutButton = UIButton();

        super.init(coder: aDecoder)
    }
    
    
    // MARK: View Management

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.requestAuthorization()
        map.view.frame = self.view.bounds
        self.view.addSubview(map.view)
        
        aboutButton.setTitle("About", forState: .Normal)
        aboutButton.frame = CGRect(x: 5, y: 10, width: 100, height: 30)
        aboutButton.addTarget(self, action: "aboutButtonDidTap:", forControlEvents: .TouchUpInside)
        self.view.addSubview(aboutButton)
    }
    
    
    // MARK: - Button Responders
    
    func aboutButtonDidTap(sender: UIButton!) {
        var aboutViewController = AboutViewController()

        softPresentViewController(aboutViewController,
            animations: { (viewController: UIViewController) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    viewController.view.alpha = 1
                })
            })
    }
    
    
    // MARK: - Private
    
    private func softPresentViewController(viewController: UIViewController, animations: ((_: UIViewController) -> Void)?) {

        viewController.willMoveToParentViewController(self)
        viewController.view.willMoveToSuperview(self.view)
        self.addChildViewController(viewController)
        
        viewController.view.alpha = 0
        self.view.addSubview(viewController.view)
        self.view.bringSubviewToFront(viewController.view)

        if let animations = animations {
            animations(viewController)
        }
        
        CATransaction.setCompletionBlock { [weak viewController, weak self] () -> Void in
            if let weakViewController = viewController {
                weakViewController.view.didMoveToSuperview()
                if let weakSelf = self {
                    weakViewController.didMoveToParentViewController(weakSelf)
                }
            }
            
            // Reset the completion block
            CATransaction.setCompletionBlock({})
        }
    }
}

