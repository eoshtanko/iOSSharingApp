//
//  ConversationTableViewCell.swift
//  ChatApp
//
//  Created by Екатерина on 06.03.2022.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ConversationTableViewCell.self)
    private static let formatter = DateFormatter()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: Const.verticalInserts, left: Const.horizontalInserts,
            bottom: Const.verticalInserts, right: Const.horizontalInserts))
        contentView.layer.cornerRadius = Const.contentViewCornerRadius
        configureSubviews()
    }
    
    func configureCell(_ conversation: Conversation) {
        if conversation.mail1 == CurrentUser.user.mail {
            configureNameLabel(conversation.name2)
            configureProfileImageView(conversation.photo2)
        } else {
            configureNameLabel(conversation.name1)
            configureProfileImageView(conversation.photo1)
        }
        print(conversation.sendTime)
        configureLastMessageDate(getDate(str: conversation.sendTime))
        configureLastMessageLabel(conversation.lastMessage)
    }
    
    func configureSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    private func configureNameLabel(_ name: String?) {
        nameLabel.text = name == nil ? "No Name" : name
        if (name == nil) {
            nameLabel.font = .italicSystemFont(ofSize: Const.textSize)
        } else {
            nameLabel.font = .systemFont(ofSize: Const.textSize, weight: .semibold)
        }
    }
    
    private func configureLastMessageDate(_ date: Date?) {
        lastMessageDateLabel.text = date == nil ? "No Date" : fromDateToString(from: date!)
        if (date == nil) {
            lastMessageDateLabel.font = .italicSystemFont(ofSize: Const.textSize)
        } else {
            lastMessageDateLabel.font = .systemFont(ofSize: Const.textSize)
        }
    }
    
    private func configureLastMessageLabel(_ message: String?) {
        lastMessageLabel.text = message == nil ? "No messages yet" : message
        if (message == nil) {
            lastMessageLabel.font = .italicSystemFont(ofSize: Const.textSize)
        } else {
            lastMessageLabel.font = .systemFont(ofSize: Const.textSize)
        }
    }
    
    private func configureProfileImageView(_ image: String?) {
        if let imageBase64String = image {
            let imageData = Data(base64Encoded: imageBase64String)
            profileImageView.image = UIImage(data: imageData!)
        } else {
            setDefaultImage()
        }
    }
    
    private func setDefaultImage() {
        profileImageView.image = UIImage(named: "crowsHoldingWings")
    }
    
    private func fromDateToString(from date: Date) -> String {
        if (Calendar.current.isDateInToday(date)) {
            ConversationTableViewCell.formatter.dateFormat = "HH:mm a"
            return ConversationTableViewCell.formatter.string(from: date)
        }
        
        ConversationTableViewCell.formatter.timeStyle = .none
        ConversationTableViewCell.formatter.dateStyle = .medium
        ConversationTableViewCell.formatter.locale = Locale(identifier: "en_GB")
        ConversationTableViewCell.formatter.doesRelativeDateFormatting = true
        return ConversationTableViewCell.formatter.string(from: date)
    }
    
    func getDate(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: str) // replace Date String
    }
    
    private enum Const {
        static let textSize: CGFloat = 15
        static let verticalInserts: CGFloat = 15
        static let horizontalInserts: CGFloat = 10
        static let contentViewCornerRadius: CGFloat = 10
    }
}
