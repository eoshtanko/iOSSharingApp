//
//  ConversationViewController + SendMessageMethods.swift
//  HSE Sharing
//
//  Created by Екатерина on 22.04.2022.
//

import Foundation
import UIKit

// Настройка view для ввода сообщения.
extension ConversationViewController {
    
    override var inputAccessoryView: UIView? {
        if entreMessageBar == nil {
            
            entreMessageBar = Bundle.main.loadNibNamed("EntryMessageView", owner: self, options: nil)?.first as? EntryMessageView
            
            entreMessageBar?.setSendMessageAction { [weak self] message in
                guard let self = self else { return }
                self.entreMessageBar?.sendMessageButton.isEnabled = false
                self.sendMessage(message: message)
            }
        }
        
        return entreMessageBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    private func sendMessage(message: String) {
        let recieverMail = channel?.mail1 == CurrentUser.user.mail ? (channel?.mail2)! : (channel?.mail1)!
        let newMessage = Message(id: 0, sendTime: "", text: message, senderMail: CurrentUser.user.mail!, receiverMail: recieverMail)
        Api.shared.sendMessage(mail: recieverMail, message: newMessage, complitionSeccess: self.addMessage, complitionFail: self.showFailToSendMessageAlert)
    }
    
    private func addMessage(message: Message) {
        self.messages?.append(message)
        self.tableView.reloadData()
        self.scrollToBottom(animated: false)
        self.entreMessageBar?.textView.text = ""
        createMessage(message: message)
    }
    
    private func showFailToSendMessageAlert() {
        Api.shared.startMessaging()
        DispatchQueue.main.async {
        let failureAlert = UIAlertController(title: EnterViewController.isEnglish ? "Error" : "Ошибка",
                                             message: EnterViewController.isEnglish ? "The message could not be sent." : "Не удалось отправить сообщение.",
                                             preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "OK",
                                             style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: EnterViewController.isEnglish ? "Try again" : "Повторить",
                                             style: UIAlertAction.Style.cancel) {_ in
            self.entreMessageBar?.sendMessage()
        })
            self.present(failureAlert, animated: true, completion: nil)
        }
    }
    
    func createMessage(message: Message) {
        Api.shared.createMessage(message: message) {result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.entreMessageBar?.sendMessageButton.isEnabled = true
                }
                let date = Formatter.iso8601.string(from: Date())
                print(date)
                let channel = Conversation(id: self.channel!.id, lastMessage: message.text, sendTime: Formatter.iso8601.string(from: Date()), mail1: self.channel!.mail1, name1: self.channel!.name1, surname1: self.channel!.surname1, photo1: self.channel!.photo1, mail2: self.channel!.mail2, name2: self.channel!.name2, surname2: self.channel!.surname2, photo2: self.channel!.photo2, users: self.channel!.users)

                Api.shared.editConversation(conversation: channel) {_ in
                    print("success")
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showFailToSaveMessageAlert(message: message)
                }
            }
        }
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification) {
        if entreMessageBar?.textView.isFirstResponder ?? false {
            guard let payload = KeyboardInfo(notification) else { return }
            hightOfKeyboard = payload.frameEnd?.size.height
        }
        scrollToBottom(animated: false)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollToBottom(animated: false)
    }
    
    private func showFailToSaveMessageAlert(message: Message) {
        let failureAlert = UIAlertController(title: EnterViewController.isEnglish ? "Error" : "Ошибка",
                                             message: EnterViewController.isEnglish ? "The message could not be sent." : "Не удалось отправить сообщение.",
                                             preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "OK",
                                             style: UIAlertAction.Style.default) {_ in
            self.messages? = (self.messages?.filter{ mess in
                return mess.id != message.id
            })!
            self.tableView.reloadData()
            self.scrollToBottom(animated: false)
        })
        failureAlert.addAction(UIAlertAction(title: EnterViewController.isEnglish ? "Try again" : "Повторить",
                                             style: UIAlertAction.Style.cancel) {_ in
            self.createMessage(message: message)
        })
        present(failureAlert, animated: true, completion: nil)
    }
}
