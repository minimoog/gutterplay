//
//  EditorViewController.swift
//  gutterplay
//
//  Created by minimoog on 12/5/17.
//  Copyright © 2017 minimoog. All rights reserved.
//

import UIKit

let EditorGutterWidth: CGFloat = 22.0

struct CompilerErrorMessage {
    let lineNumber: Int
    let columnNumber: Int
    let message: String
}

class EditorViewController: UIViewController, UITextViewDelegate {
    var sourceTextView: UITextView?
    var messageButtons = [MessageButton]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sourceTextView = UITextView(frame: view.frame)
        view.addSubview(sourceTextView!)
        
        sourceTextView?.translatesAutoresizingMaskIntoConstraints = false
        sourceTextView?.delegate = self
        sourceTextView?.isEditable = true
        sourceTextView?.isSelectable = true
        sourceTextView?.autocapitalizationType = .none
        sourceTextView?.autocorrectionType = .no
        sourceTextView?.allowsEditingTextAttributes = false
        sourceTextView?.text = "Lorem ipsum dolor sit er elit lamet\n, consectetaur cillium adipisicing pecu\n, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda..\n"
        sourceTextView?.textContainerInset = UIEdgeInsets(top: 10, left: EditorGutterWidth, bottom: 0, right: 0)
        sourceTextView?.keyboardAppearance = .dark
        sourceTextView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        //contraints
        sourceTextView?.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        sourceTextView?.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        sourceTextView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: (self.sourceTextView?.bottomAnchor)!).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rangeOfString(subString: String, inString: String, atOccurence: Int) -> NSRange {
        var currentOccurence = 0
        var rangeToSearchWithin = NSRange(location: 0, length: inString.count)
        
        while true {
            let string = NSString(string: inString)
            let searchResult = string.range(of: subString, options: .caseInsensitive, range: rangeToSearchWithin)
            
            if searchResult.location == NSNotFound {
                return searchResult
            }
            
            if currentOccurence == atOccurence {
                return searchResult
            }
            
            currentOccurence += 1
            
            let newLocationToStartAt = searchResult.location + searchResult.length
            rangeToSearchWithin = NSRange(location: newLocationToStartAt, length: inString.count - newLocationToStartAt)
        }
    }
    
    func sourceViewGutterPointForMessage(lineNumber: Int, columnNumber: Int) -> CGPoint {
        var rangeOfPrecedingNewLine = self.rangeOfString(subString: "\n", inString: (self.sourceTextView?.text)!, atOccurence: lineNumber - 1)
        
        if rangeOfPrecedingNewLine.location == NSNotFound {
            rangeOfPrecedingNewLine = NSRange(location: 0, length: 1)
        }
        
        let offendingCharacterIndex = rangeOfPrecedingNewLine.location + columnNumber
        
        let errorStartPosition = self.sourceTextView?.position(from: (self.sourceTextView?.beginningOfDocument)!, offset: offendingCharacterIndex)
        let errorStartPositionPlusOne = self.sourceTextView?.position(from: errorStartPosition!, offset: 1)
        let textRangeForError = self.sourceTextView?.textRange(from: errorStartPosition!, to: errorStartPositionPlusOne!)
        let offendingCharacterREct = self.sourceTextView?.firstRect(for: textRangeForError!)
        
        let y = floor((offendingCharacterREct?.midY)! - 16.0 * 0.5)
        
        return CGPoint(x: 2, y: y)
    }
    
    func updateGutterViewsWithMessages(messages: [CompilerErrorMessage]) {
        messageButtons.forEach { $0.removeFromSuperview() }
        messageButtons = []
        
        for message in messages {
            let buttonOrigin = self.sourceViewGutterPointForMessage(lineNumber: message.lineNumber, columnNumber: message.columnNumber)
            let buttonRect = CGRect(x: buttonOrigin.x, y: buttonOrigin.y, width: CGFloat(ButtonSize), height: CGFloat(ButtonSize))
            
            let button = MessageButton(frame: buttonRect)
            button.message = message.message
            button.popupPresentingViewController = self
            
            self.sourceTextView?.addSubview(button)
            
            messageButtons.append(button)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let cmpMsg0 = CompilerErrorMessage(lineNumber: 2, columnNumber: 1, message: sourceTextView!.text)
        
        updateGutterViewsWithMessages(messages: [cmpMsg0])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
