//
//  ViewController.swift
//  TestPopupApp
//
//  Created by User on 7/4/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
class ViewController: UIViewController {
    /// My ScrollView
    @IBOutlet weak var myScrollView: UIScrollView!
    /// Alert BaseView
    @IBOutlet weak var alertBaseView: UIView!
    /// Comment TextView
    @IBOutlet weak var commentTextView: UITextView!
    /// Comment TextView Height Constraint
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    
    /// Orignal Height of Description TV
    private var orignalTvHeight: CGFloat?
    /// Screen Tap Gesture
    private var screenTapGesture: UITapGestureRecognizer?


    
    //MARK: Okay Button Action
    @IBAction func okayBtnAction(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        commentTextView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        /// Set Initial Value
        if commentTextView.tag == 0 {
            DispatchQueue.main.async {
                self.commentTextView.frame.size.height = 40
                self.commentTextViewHeightConstraint.constant = 40
                self.orignalTvHeight = self.commentTextView.frame.size.height
                self.commentTextView.text = "Comment"
            }
        }
        
        /// Tap Gesture
        screenTapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapHandler(Gesture:)))
        view.addGestureRecognizer(screenTapGesture!)
        myScrollView.addGestureRecognizer(screenTapGesture!)
        registerForKeyboardNotifications()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
}

//MARK:- Required Functions
extension ViewController {
    // MARK: Screen Tap Handler
    @objc func screenTapHandler(Gesture _: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}

// MARK: - UITextView Delegates

extension ViewController: UITextViewDelegate {
    // MARK: Text Did Change
    /**
     The text view calls this method in response to user-initiated changes to the text
     - parameter textView : textView Instance
     */
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.textColor = UIColor.black
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        commentTextViewHeightConstraint.constant = newFrame.size.height
        textView.isScrollEnabled = false
        if textView.text.trimmed().isEmpty {
            print("TextView tag is 0 now")
            textView.tag = 0
        } else { textView.tag = 1 }
    }
    
    // MARK: Text View should Begin Editing
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.tag == 0 {
            textView.isScrollEnabled = false
            print("TextView tag was 0 now")
            textView.tag = 1
            textView.text = nil
        }
        return true
    }
    
    // MARK: Text View Change Range
    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        textViewDidChange(textView)
        return true
    }
    
    // MARK: Text View Did End Editing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmed() == "" {
            textView.tag = 0
            textView.isScrollEnabled = false
            print("TextView tag is 0 now")
            textView.text = "Comment"
        } else { textView.tag = 1 }
    }
}



// MARK: - Keyboard Handler

extension ViewController {
    // MARK: Add Observer - Keyboard
    
    /**
     This function is used to Add All observers required for Keyboard
     */
    private func registerForKeyboardNotifications() {
        // Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Remove Observer - Keyboard
    
    /**
     This function is used to Remove All observers added
     */
    private func deregisterFromKeyboardNotifications() {
        // Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard Show
    
    /**
     This is used to add the Keyboard Height to ScrollView for scrolling Effect
     - parameter notification : notification instance
     */
    @objc private func keyboardWasShown(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset: UIEdgeInsets = myScrollView.contentInset
            contentInset.bottom = keyboardSize.height
            myScrollView.contentInset = contentInset
        }
    }
    
    // MARK: Keyboard Hide
    
    /**
     This is used to retain the orignal Height of View
     - parameter notification : notification instance
     */
    @objc private func keyboardWillBeHidden(_: Notification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        myScrollView.contentInset = contentInset
    }
}
