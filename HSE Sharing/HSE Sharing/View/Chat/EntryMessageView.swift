//
//  EntryMessageView.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class EntryMessageView: UIView {
    
    private var sendMessageAction: ((String) -> Void)?
    
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var entryMessageView: UIView!
    @IBOutlet weak var textViewHightConstraint: NSLayoutConstraint!
    
    @IBAction func sendMessage(_ sender: Any) {
        sendMessage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCurrentTheme()
        configureTextView()
        sendMessageButton.isEnabled = !textView.text.isEmpty
    }
    
    override var intrinsicContentSize: CGSize {
        return textViewContentSize()
    }
    
    func sendMessage() {
        if !textView.text.isEmpty {
            sendMessageAction?(textView.text)
        }
    }
    
    func setSendMessageAction(_ action: ((String) -> Void)?) {
        sendMessageAction = action
    }
    
    private func textViewContentSize() -> CGSize {
        let size = CGSize(width: textView.bounds.width,
                          height: CGFloat.greatestFiniteMagnitude)
        
        let textSize = textView.sizeThatFits(size)
        return CGSize(width: bounds.width, height: textSize.height)
    }
    
    private func configureTextView() {
        textView.delegate = self
        textView.layer.borderWidth = Const.textViewBorderWidth
        textView.layer.cornerRadius = Const.textViewCornerRadius
    }
    
    private func setCurrentTheme() {
        setDayOrClassicTheme()
    }
    
    private func setDayOrClassicTheme() {
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.keyboardAppearance = .light
        backgroundColor = UIColor(named: "BackgroundNavigationBarColor")
        entryMessageView.tintColor = .systemBlue
    }
    
    
    private enum Const {
        static let textViewBorderWidth = 0.1
        static let textViewCornerRadius: CGFloat = 10
        static let textViewMaxHight: CGFloat = 71
    }
}

extension EntryMessageView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        sendMessageButton.isEnabled = !textView.text.isEmpty
        
        let contentHeight = textViewContentSize().height
        if textViewHightConstraint.constant != contentHeight && contentHeight < Const.textViewMaxHight {
            textViewHightConstraint.constant = contentHeight
            layoutIfNeeded()
        }
    }
}
