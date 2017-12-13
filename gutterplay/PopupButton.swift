//
//  PopupButton.swift
//  gutterplay
//
//  Created by minimoog on 11/30/17.
//  Copyright © 2017 minimoog. All rights reserved.
//

import UIKit

let ButtonSize: Float = 16.0
let MaxWidth: Float = 320.0
let MinHeight:Float = 44.0

class PopupMessageViewController: UIViewController, KUIPopOverUsable {
    var contentSize: CGSize = CGSize()
    
    var message: String = "" {
        didSet {
            loadViewIfNeeded()
            
            messageLabel?.text = message

            let tempLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: CGFloat(MaxWidth - 20.0), height: CGFloat.greatestFiniteMagnitude))
            tempLabel.numberOfLines = 0
            tempLabel.font = messageLabel?.font
            tempLabel.text = messageLabel?.text
            tempLabel.sizeToFit()
            
            preferredContentSize = CGSize(width: CGFloat(MaxWidth), height: tempLabel.frame.height + CGFloat(MinHeight))
            contentSize = preferredContentSize
            
            messageLabel?.frame = CGRect(x: 10, y: 10, width: tempLabel.frame.width, height: tempLabel.frame.height)
        }
    }
    var messageLabel: UILabel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //init var here
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //init var here
        
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        let labelBounds = self.view.bounds
        messageLabel = UILabel(frame: labelBounds)
        messageLabel?.isOpaque = false
        messageLabel?.backgroundColor = UIColor.clear
        messageLabel?.text = "test message"
        messageLabel?.numberOfLines = 0
        
        view.addSubview(messageLabel!)
    }
}

class MessageButton: UIView {
    open weak var popupPresentingViewController: UIViewController?
    open var message: String?
    
    fileprivate var button: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button = UIButton(frame: self.bounds)
        button?.contentMode = .scaleAspectFill
        button?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        self.addSubview(button!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func presentMessagePopup() {
        let messageViewController = PopupMessageViewController(nibName: nil, bundle: nil)
        messageViewController.message = message!
        messageViewController.showPopover(sourceView: button!, sourceRect: CGRect(x: 0, y: CGFloat(ButtonSize * 0.5), width: 1.0, height: 1.0))
    }
    
    @objc func buttonTapped(sender: UIButton) {
        self.presentMessagePopup()
    }
    
}
