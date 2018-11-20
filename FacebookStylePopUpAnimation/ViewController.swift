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
        //        let redView = UIView()
        //        redView.backgroundColor = .red
        //
        //        let blueView = UIView()
        //        blueView.backgroundColor = .blue
        //
        //        let yellowView = UIView()
        //        yellowView.backgroundColor = .yellow
        //
        //        let orangeView = UIView()
        //        orangeView.backgroundColor = .orange
        
        //add those subviews to the stack view
        //let arrangedSubviews = [redView, blueView, yellowView, orangeView]
        
        //mapping an array generates another array, which we use in kind to grab the backgroundColor property
        
        let iconHeight: CGFloat = 50
        let padding: CGFloat = 8
        
        //MARK:-Images Map
        //image literals are a little fucked in Xcode 10
        let images = [#imageLiteral(resourceName: "like.png"),#imageLiteral(resourceName: "love.png"),#imageLiteral(resourceName: "haha.png"), #imageLiteral(resourceName: "smiling.png"),#imageLiteral(resourceName: "surprised.png"),#imageLiteral(resourceName: "sad.png"),#imageLiteral(resourceName: "angry.png")]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            return imageView
        })
        
        //MARK:-Subview Map
//        let arrangedSubviews = [UIColor.red, .blue, .yellow, .orange, .green].map({ (color) -> UIView in
//            let v = UIView()
//            v.backgroundColor = color
//            v.layer.cornerRadius = iconHeight / 2 //creates a circular subview
//            return v
//        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        
        //MARK:- Stack View Properties
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        let numIcons = CGFloat(arrangedSubviews.count)
        let width = numIcons * iconHeight + (numIcons + 1) * padding
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2 //rounded
        
        stackView.frame = containerView.frame
        
        //MARK:- ContainerView Shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4) //down 4 pixels
        
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

