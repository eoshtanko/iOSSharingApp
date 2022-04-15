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
        print(#function)
        connection.invoke(method: "SetMail", "1@edu.hse.ru") { error in
            if let error = error {
                print("error: \(error)")
            } else {
                print(#function)
            }
        }
    }

    func connectionDidFailToOpen(error: Error) {
        print(#function)
    }

    func connectionDidClose(error: Error?) {
        print(#function)
    }

    private func initSignalRService() {
        let url = URL(string: "\(baseURL)/chat")!
        connection = HubConnectionBuilder(url: url).withLogging(minLogLevel: .error).build()
        connection.delegate = self
        connection.on(method: "Receive", callback: { (message: Message) in
            print(#function)
            print(message.text)
            self.handleMessage(message)
        })

        connection.on(method: "Send", callback: { () in
            print(#function)
        })
        connection.start()
    }

    func startMessaging(email: String) {
        initSignalRService()
    }

    func sendMessage(mail: String, message: Message) {
        connection.invoke(method: "Send", arguments: [mail, message]) { error in
            if let error = error {
                print("error: \(error)")
            } else {
                print(#function)
            }
        }
    }

    func stopMessaging() {
        connection.stop()
    }

    private func handleMessage(_ message: Message) {
        print(#function)
    }
}
