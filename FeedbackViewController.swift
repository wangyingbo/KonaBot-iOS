//
//  FeedbackViewController.swift
//  KonaBot
//
//  Created by Alex Ling on 5/3/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
	
	var backgroundBlurImageView : UIImageView!
	var dismissButton : UIImageView!
	var yesButton : UIButton!
	var noButton : UIButton!
	var titleLabel : UILabel!
	
	var dialogView : UIView!
	var dialogWidth : CGFloat = 300
	var dialogHeight : CGFloat = 100
	var animationDuration : NSTimeInterval = 0.3
	
	var baseColor : UIColor!
	var secondaryColor : UIColor!
	var dismissButtonColor : UIColor!
	
	init(backgroundView : UIView, baseColor : UIColor, secondaryColor : UIColor, dismissButtonColor : UIColor) {
		super.init(nibName: nil, bundle: nil)
		
		self.baseColor = baseColor
		self.secondaryColor = secondaryColor
		self.dismissButtonColor = dismissButtonColor
		
		self.backgroundBlurImageView = UIImageView(frame: backgroundView.bounds)
		self.backgroundBlurImageView.image = UIImage.imageFromUIView(backgroundView).applyKonaDarkEffect()!
		self.backgroundBlurImageView.alpha = 0
		self.view.addSubview(self.backgroundBlurImageView)
		
		self.dialogView = UIView(frame: CGRectMake(0, 0, self.dialogWidth, self.dialogHeight))
		self.dialogView.center = self.view.center
		self.dialogView.backgroundColor = baseColor
		self.dialogView.layer.cornerRadius = 10
		self.view.addSubview(self.dialogView)
		
		self.dismissButton = UIImageView(frame: CGRectMake(20, 40, 25, 25))
		self.dismissButton.image = UIImage(named: "Dismiss")!.coloredImage(dismissButtonColor)
		self.dismissButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismiss"))
		self.dismissButton.alpha = 0
		self.view.addSubview(self.dismissButton)
		
		self.showFeedbackAlert("Enjoying KonaBot?", badChoiceTitle: "Not really", goodChoiceTitle: "Yes!", badChoiceHandler: {print ("yes")}, goodChoiceHandler: {print ("no")})
	}
	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	func dismiss(){
		self.rotateDismissBtn(-1)
		UIView.animateWithDuration(self.animationDuration, delay: 0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
			self.dialogView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, -self.dialogHeight/2)
			self.backgroundBlurImageView.alpha = 0
			self.dismissButton.alpha = 0
			}, completion: {(finished) in
				self.view.removeFromSuperview()
		})
	}
	
	func showFeedbackAlert(title : String, badChoiceTitle : String, goodChoiceTitle : String, badChoiceHandler : (() -> Void), goodChoiceHandler : (() -> Void)) {
		self.dialogView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height + self.dialogHeight/2)
		
		titleLabel = UILabel(frame: CGRectMake(20, 10, self.dialogWidth - 40, 30))
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.textColor = secondaryColor
		titleLabel.text = title
		self.dialogView.addSubview(titleLabel)
		
		yesButton = UIButton(type: .System)
		yesButton.setTitle(goodChoiceTitle, forState: .Normal)
		yesButton.backgroundColor = secondaryColor
		yesButton.setTitleColor(baseColor, forState: .Normal)
		yesButton.layer.cornerRadius = 5
		yesButton.sizeToFit()
		var frame = yesButton.frame
		frame.size.width = self.dialogWidth/3
		yesButton.frame = frame
		yesButton.center = CGPointMake(13/18 * self.dialogWidth, self.dialogHeight - 10 - frame.height/2)
		yesButton.layer.borderWidth = 1
		yesButton.layer.borderColor = secondaryColor.CGColor
		yesButton.block_setAction(goodChoiceHandler)
		self.dialogView.addSubview(yesButton)
		
		noButton = UIButton(type: .System)
		noButton.setTitle(badChoiceTitle, forState: .Normal)
		noButton.setTitleColor(secondaryColor, forState: .Normal)
		noButton.backgroundColor = baseColor
		noButton.layer.cornerRadius = 5
		noButton.sizeToFit()
		var frame_ = noButton.frame
		frame_.size.width = self.dialogWidth/3
		noButton.frame = frame_
		noButton.center = CGPointMake(5/18 * self.dialogWidth, self.dialogHeight - 10 - frame_.height/2)
		noButton.layer.borderWidth = 1
		noButton.layer.borderColor = secondaryColor.CGColor
		noButton.block_setAction(badChoiceHandler)
		self.dialogView.addSubview(noButton)
		
		yesButton.enabled = false
		noButton.enabled = false
		self.dismissButton.userInteractionEnabled = false
		
		self.rotateDismissBtn(1)
		
		UIView.animateWithDuration(self.animationDuration, delay: 0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
			self.dialogView.center = self.view.center
			self.backgroundBlurImageView.alpha = 1
			self.dismissButton.alpha = 1
			}, completion: {(finished) in
				self.yesButton.enabled = true
				self.noButton.enabled = true
				self.dismissButton.userInteractionEnabled = true
		})
	}
	
	func rotateDismissBtn(numberOfPi : CGFloat) {
		let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotateAnimation.duration = self.animationDuration
		rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		rotateAnimation.toValue = NSNumber(double: Double(numberOfPi) * M_PI)
		self.dismissButton.layer.addAnimation(rotateAnimation, forKey: nil)
	}
}