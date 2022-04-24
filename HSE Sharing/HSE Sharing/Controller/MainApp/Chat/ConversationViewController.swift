//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Екатерина on 07.03.2022.
//

import UIKit

class ConversationViewController: UITableViewController {
    
    let channel: Conversation?
    private var activityIndicator: UIActivityIndicatorView!
    
    var entreMessageBar: EntryMessageView?
    var hightOfKeyboard: CGFloat?
    
    var user: User?
    var messages: [Message]? = []
    
    init?(channel: Conversation?) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        loadMessages()
        loadUser()
        configureMessageReceiving()
        configureTableView()
        configureNavigationBar()
        registerKeyboardNotifications()
        configureTapGestureRecognizer()
        configureNavigationButton()
        scrollToBottom(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    private func configureMessageReceiving() {
        Api.shared.handleMessage = self.handleMessage
    }
    
    private func handleMessage(message: Message) {
        if message.senderMail == (CurrentUser.user.mail == channel?.mail1 ? channel?.mail2 : channel?.mail1) {
            messages?.append(message)
            tableView.reloadData()
        }
    }
    
    private func configureNavigationButton() {
        let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40,
                                                   height: 40))
        setImageToProfileNavigationButton(profileButton)
        profileButton.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
    
    private func setImageToProfileNavigationButton(_ profileButton: UIButton) {
    
        if let imageBase64String = user?.photo, let imageData = Data(base64Encoded: imageBase64String), var image = UIImage(data: imageData) {
           // image = image.resized(to: CGSize(width: 40, height: 40))
            image = image.resizedImageWithinRect(rectSize: CGSize(width: 40, height: 40))!
            profileButton.setImage(image, for: .normal)
        } else {
            var image = UIImage(named: "crowsHoldingWings")!
            image = image.resized(to: CGSize(width: 40,
                                             height: 40))
            profileButton.setImage(image, for: .normal)
        }
        configureImage(profileButton)
    }
    
    private func configureImage(_ profileButton: UIButton) {
        profileButton.imageView?.layer.cornerRadius = profileButton.frame.size.width / 2
        profileButton.layer.cornerRadius = profileButton.frame.size.width / 2
        profileButton.contentHorizontalAlignment = .fill
        profileButton.contentVerticalAlignment = .fill
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.contentMode = .scaleAspectFill
        
        profileButton.imageView?.clipsToBounds = true
        
    }
    
    private func loadUser() {
        let mail = channel?.mail2 == CurrentUser.user.mail ? (channel?.mail1)! : (channel?.mail2)!
        Api.shared.getUserByEmail(email: mail) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                    self.configureNavigationButton()
                }
            case .failure(_):
                print()
            }
        }
    }
    
    @objc private func goToProfile() {
        if let user = user {
            self.navigationItem.title = ""
            let storyboard = UIStoryboard(name: "ForeignProfile", bundle: nil)
            let profileViewController = storyboard.instantiateViewController(withIdentifier: "ForeignProfile") as! ForeignProfileViewController
            profileViewController.setUser(user: user)
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        let yoffset = view.frame.midY // - 60
        activityIndicator.center = CGPoint(x: view.frame.midX, y: yoffset)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        tableView.addSubview(activityIndicator)
    }
    
    private func loadMessages() {
        self.view.isUserInteractionEnabled = false
        Api.shared.getMessages(email: channel?.mail1 == CurrentUser.user.mail ? (channel?.mail2)! : (channel?.mail1)! , id: 0) { result in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.messages = messages
                    self.tableView.reloadData()
                    self.scrollToBottom(animated: false)
                    self.view.isUserInteractionEnabled = true
                    self.scrollToBottom(animated: false)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.showFailToLoadMessagesAlert()
                }
            }
        }
    }
    
    private func showFailToLoadMessagesAlert() {
        let failureAlert = UIAlertController(title: "Ошибка",
                                             message: "Не удалось загрузить сообщения.",
                                             preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "OK",
                                             style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: "Повторить",
                                             style: UIAlertAction.Style.cancel) {_ in
            self.loadMessages()
        })
        present(failureAlert, animated: true, completion: nil)
    }
    
    
    private func configureTapGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        entreMessageBar?.textView.resignFirstResponder()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = channel?.mail1 == CurrentUser.user.mail ? channel?.name2 : channel?.name1
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTableView() {
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func scrollToBottom(animated: Bool) {
        view.layoutIfNeeded()
        if isScrollingNecessary() {
            let bottomOffset = entreMessageBar?.textView.isFirstResponder ?? false ? bottomOffsetWithKeyboard() : bottomOffsetWithoutKeyboard()
            
            tableView.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    private func isScrollingNecessary() -> Bool {
        let bottomOffset = entreMessageBar?.textView.isFirstResponder ?? false ? hightOfKeyboard : entreMessageBar?.bounds.size.height
        return tableView.contentSize.height > tableView.bounds.size.height - (bottomOffset ?? 0) - Const.empiricalValue
    }
    
    private func bottomOffsetWithKeyboard() -> CGPoint {
        return CGPoint(x: 0, y: tableView.contentSize.height - tableView.bounds.size.height + (hightOfKeyboard ?? 0))
    }
    
    private func bottomOffsetWithoutKeyboard() -> CGPoint {
        return CGPoint(x: 0, y: tableView.contentSize.height - tableView.bounds.size.height + (entreMessageBar?.bounds.size.height ?? 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Const {
        static let dataModelName = "Chat"
        static let estimatedRowHeight: CGFloat = 60
        static let heightOfHeader: CGFloat = 50
        static let empiricalValue: CGFloat = 70
    }
}
public extension UIImage {
    
    func resizedImage(newSize: CGSize) -> UIImage? {
        guard size != newSize else { return self }
        
        let hasAlpha = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale)
        
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage? {
         let widthFactor = size.width / rectSize.width
         let heightFactor = size.height / rectSize.height
         
         var resizeFactor = widthFactor
         if size.height > size.width {
             resizeFactor = heightFactor
         }
         
         let newSize = CGSize(width: size.width / resizeFactor, height: size.height / resizeFactor)
         let resized = resizedImage(newSize: newSize)
         
         return resized
     }
}
