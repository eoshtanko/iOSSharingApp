//
//  NetworkManager + Chat.swift
//  HSE Sharing
//
//  Created by Екатерина on 13.04.2022.
//

import Foundation
import SwiftSignalRClient

extension Api {
    
    func initSignalRService() {
        let url = URL(string: "\(baseURL)/chat")!
        connection = HubConnectionBuilder(url: url).withLogging(minLogLevel: .error).build()
        connection.on(method: "Receive", callback: { (Message message) in
            do {
                self.handleMessage(message, from: user)
            } catch {
                print(error)
            }
        })
        connection.start()
    }
    
    func startMessaging(email: String) {
        initSignalRService()
        connection.start()
        connection.invoke(method: "SetMail", email) { error in
            if let error = error {
                print("error: \(error)")
            } else {
                print("Broadcast invocation completed without errors")
            }
        }
    }
    
    func stopMessaging() {
        connection.stop()
    }
    
    private func handleMessage(_ message: String, from user: String) {
        // Do something with the message.
    }
}
