//
//  NetworkManager + Chat.swift
//  HSE Sharing
//
//  Created by Екатерина on 13.04.2022.
//

import Foundation
import SwiftSignalRClient

extension Api: HubConnectionDelegate {
    func connectionDidOpen(hubConnection: HubConnection) {
        connection.invoke(method: "SetMail",  CurrentUser.user.mail) { error in
            if let error = error {
                print("error: \(error)")
            } else {
                print(#function)
            }
        }
    }

    func connectionDidFailToOpen(error: Error) {
        Api.shared.startMessaging()
    }

    func connectionDidClose(error: Error?) {
        if error != nil {
            Api.shared.startMessaging()
        }
        print("!!!!!!!!!!!!!!!!!")
        print(#function)
        print(error)
    }

    private func initSignalRService() {
        let url = URL(string: "\(baseURL)/chat")!
        connection = HubConnectionBuilder(url: url).withLogging(minLogLevel: .error).build()
        connection.delegate = self
        connection.on(method: "Receive", callback: { (message: Message) in
            print(#function)
            print(message.text)
            self.handleMessage?(message)
        })

        connection.on(method: "Send", callback: { () in
            print(#function)
        })
        connection.start()
    }

    func startMessaging() {
        initSignalRService()
    }

    func sendMessage(mail: String, message: Message, complitionSeccess:  @escaping ((Message) -> Void), complitionFail:  @escaping (() -> Void)) {
        connection.invoke(method: "Send", arguments: [mail, message]) { error in
            if  error != nil {
                Api.shared.startMessaging()
                complitionFail()
            } else {
               complitionSeccess(message)
            }
        }
    }

    func stopMessaging() {
        connection.stop()
    }
}
