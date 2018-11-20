//
//  ViewController.swift
//  FacebookStylePopUpAnimation
//
//  Created by Charles Martin Reed on 11/19/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Application Background Properties
    
    //not currently using this since I don't have the BG that Brian uses in the demo video...
//    let bgImageView: UIImageView = {
//        let imageView = UIImageView(image: "")
//        return imageView
//    }()
    
    //MARK:- Emoji Icon Container View Properties
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        //let's add some subviews for the emojis
        let redView = UIView()
        redView.backgroundColor = .red
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        //add those subviews to the stack view
        let arrangedSubviews = [redView, blueView]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        
        //MARK:- Stack View Properties
        stackView.distribution = .fillEqually
        let padding: CGFloat = 8
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        stackView.frame = containerView.frame
        
        
        
        
        return containerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(bgImageView)
//        bgImageView.frame = view.frame
        
        setupLongPressGesture()
        
    }

    //MARK:- Gesture methods
    fileprivate func setupLongPressGesture() {
        
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        //print("Long pressed", Date()) //logs a date when we press, and a date when we release.
        
        if gesture.state == .began {
           handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            //remove the previously animated view
            iconsContainerView.removeFromSuperview()
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        //animate a view INTO application
        view.addSubview(iconsContainerView)
        
        //grab the touch point
        let pressedLocation = gesture.location(in: self.view)
        print(pressedLocation)
        
        //use a transformation to move the box
        let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        // gently fade in the iconsContainerView
        iconsContainerView.alpha = 0
        
        //begin the transformation at the pressed location, transform that location to slightly above the touch location by using the iconContainerView's height as an offset
        self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
            
        })
    }

    // won't do much until we get the background up
    override var prefersStatusBarHidden: Bool { return true }
}

