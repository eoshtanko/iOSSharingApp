//
//  Api.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class Api {
    
    static let formatter = DateFormatter()
    static var lastMessage: ChatMessage?
    
    static func getCurrentUser() -> User {
        Api.formatter.dateFormat = "dd/MM/yyyy"
        return User(mail: "eoshtanko@edu.hse.ru", confirmationCodeServer: "12345", confirmationCodeUser: "12345", password: "12345", name: "Екатерина", surname: "Shtanko", birthDate: formatter.date(from: "27/2/2001")!, gender: 1, studyingYearId: 3, majorId: 9, campusLocationId: 1, dormitoryId: 1, about: "Programmer", contact: "@kotkusy", photo: nil, transactions: [], skills: [])
    }
    
    static func getOnlineConversations() -> [Conversation]{
        Api.formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return [
            Conversation(name: "Ivan Simonov", message: "What's the algebra homework?🥺", date: NSDate() as Date - 100, online: true, hasUnreadMessages: false, image: UIImage(named: "man1.jpg")),
            Conversation(name: "Alexandr Kozlov", message: "Watch the movie \"Kill the Dragon\". It's very good!", date: NSDate() as Date - 1000, online: true, hasUnreadMessages: true, image: UIImage(named: "man2.jpg")),
            Conversation(name: "Lily Jones", message: "Надо просить позволить свои команды.", date: NSDate() as Date - Const.day, online: true, hasUnreadMessages: false, image: nil),
            Conversation(name: "Sophie Williams", message: "Привет! Я с ПИ, мы на одном курсе. Слушай, нам тут разрешили свопаться вариантами по ПАПСу, и мне это было бы интересно, поэтому тебе и пишу.", date: NSDate() as Date - Const.day - 100, online: true, hasUnreadMessages: false, image: UIImage(named: "woman1.jpg")),
            Conversation(name: "Isabella Li", message: nil, date: NSDate() as Date - Const.day - 1000, online: true, hasUnreadMessages: false, image: UIImage(named: "woman2.jpg")),
            Conversation(name: "Ava Anderson", message: "Come out for a walk today! 🌞 The weather is so wonderful there! Birds, spring, grace!", date: Api.formatter.date(from: "3/3/2022 14:30"), online: true, hasUnreadMessages: false, image: nil),
            Conversation(name: "Jacob Morton", message: "Let's go to the Ludovico Einaudi concert!", date: Api.formatter.date(from: "1/3/2022 11:12"), online: true, hasUnreadMessages: false, image: UIImage(named: "man3.jpg")),
            Conversation(name: "Jessica Brown", message: "I don't have time to finish my term paper 🤯", date: Api.formatter.date(from: "1/3/2022 11:11"), online: true, hasUnreadMessages: true, image: UIImage(named: "woman3.jpg")),
            Conversation(name: "Alex Mironov", message: "Have you read The Death of Ivan Ilyich? Awesome book!!!", date: Api.formatter.date(from: "5/3/2022 10:12"), online: true, hasUnreadMessages: true, image: nil),
            Conversation(name: "Katya Shtanko", message: nil, date: Api.formatter.date(from: "5/3/2022 10:11"), online: true, hasUnreadMessages: false, image: UIImage(named: "woman4.jpg")),
            Conversation(name: "Alan Ranger", message: nil, date: Api.formatter.date(from: "27/2/2022 10:10"), online: true, hasUnreadMessages: false, image: nil),
            Conversation(name: "Viktoria Maass", message: "Thank you! 😊", date: Api.formatter.date(from: "5/1/2022 13:27"), online: true, hasUnreadMessages: false, image: UIImage(named: "woman5.jpg")),
            Conversation(name: "Donald Trump", message: "What's up?", date: Api.formatter.date(from: "31/12/2021 10:12"), online: true, hasUnreadMessages: true, image: nil)
        ]
    }
    
    static func getOfflineConversations() -> [Conversation]{
        Api.formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return [
            Conversation(name: "Nikolay Romahkov", message: "I overslept the class... Again.", date: NSDate() as Date - 1000, online: false, hasUnreadMessages: false, image: UIImage(named: "man4.jpg")),
            Conversation(name: "Denis Kizodov", message: "I'm so sorry 😔", date: NSDate() as Date - 2000, online: false, hasUnreadMessages: true, image: UIImage(named: "man5.jpg")),
            Conversation(name: "Emily Taylor", message: "That's cute!!! :)", date: NSDate() as Date - Const.day, online: false, hasUnreadMessages: true, image: nil),
            Conversation(name: "Thomas Evans", message: "А как у тебя описана такая функциональность системы как например распределение в стационаре", date: NSDate() as Date - Const.day - 10000, online: false, hasUnreadMessages: false, image: UIImage(named: "man6.jpg")),
            Conversation(name: "Poppy Davies", message: "Чтобы ответить на этот вопрос, придётся заглянуть в прошлую таблицу. Больше 40.", date: Api.formatter.date(from: "4/3/2022 20:20"), online: false, hasUnreadMessages: true, image: UIImage(named: "woman6.jpg")),
            Conversation(name: "Charlie O'Kelly", message: "Very anxious about the latest news", date: Api.formatter.date(from: "2/3/2022 15:23"), online: false, hasUnreadMessages: false, image: UIImage(named: "man7.jpg")),
            Conversation(name: "Liza Frank", message: nil, date: Api.formatter.date(from: "1/3/2022 21:21"), online: false, hasUnreadMessages: false, image: UIImage(named: "woman7.jpg")),
            Conversation(name: "Olesya Romanova", message: "Сегодня начала", date: Api.formatter.date(from: "1/3/2022 17:40"), online: false, hasUnreadMessages: true, image: nil),
            Conversation(name: "Artem Belyaev", message: nil, date: Api.formatter.date(from: "1/1/2022 15:28"), online: false, hasUnreadMessages: false, image: UIImage(named: "man8.jpg")),
            Conversation(name: "Alla Timkanova", message: "Хочу сказать, что ты молодец.", date: Api.formatter.date(from: "6/12/2021 18:19"), online: false, hasUnreadMessages: true, image: UIImage(named: "woman8.jpg")),
            Conversation(name: "Andrey Romanyuk", message: "Whoa! Did you try to set a breakpoint?", date: Api.formatter.date(from: "2/11/2021 10:27"), online: false, hasUnreadMessages: false, image: nil),
            Conversation(name: "Oleg Oparinov", message: "ААААААА!!!", date: Api.formatter.date(from: "17/9/2021 16:32"), online: false, hasUnreadMessages: true, image: nil)
        ]
    }
    
    static func getMessages() -> [ChatMessage] {
        Api.formatter.dateFormat = "dd/MM/yyyy HH:mm"
        var messages = [
            ChatMessage(text: "Hi!", isIncoming: true, date: Api.formatter.date(from: "2/11/2019 9:10")),
            ChatMessage(text: "How are you? Whats going on???", isIncoming: true, date: Api.formatter.date(from: "2/11/2019 9:40")),
            ChatMessage(text: "Hi! Fine. Let's me tell you about Shakespeare.", isIncoming: false, date: Api.formatter.date(from: "2/11/2019 13:27")),
            ChatMessage(text: "Какая погода в Грузии?", isIncoming: false, date: Api.formatter.date(from: "3/5/2019 10:11")),
            ChatMessage(text: "В уездном городе N было так много парикмахерских заведений и бюро похоронных процессий, что казалось, жители города рождаются лишь затем, чтобы побриться, остричься, освежить голову вежеталем и сразу же умереть.", isIncoming: true, date: Api.formatter.date(from: "21/3/2019 10:27")),
            ChatMessage(text: "Отличная!", isIncoming: true, date: Api.formatter.date(from: "3/5/2019 10:30")),
            ChatMessage(text: "Здесь Паша Эмильевич, обладавший сверхъестественным чутьем, понял, что сейчас его будут бить, может быть, даже ногами.", isIncoming: false, date: Api.formatter.date(from: "1/8/2017 10:30")),
            ChatMessage(text: "Дверь открылась. Остап прошел в комнату, которая могла быть обставлена только существом с воображением дятла.", isIncoming: false, date: Api.formatter.date(from: "1/6/2016 10:30")),
            ChatMessage(text: "Держите гроссмейстера!", isIncoming: true, date: Api.formatter.date(from: "1/6/2016 10:33")),
            ChatMessage(text: "А вообще, описать климат Грузии парой предложений практически невозможно — в каждом регионе свои особенности.", isIncoming: true, date: Api.formatter.date(from: "3/5/2019 10:40")),
            ChatMessage(text: "Киса, я хочу вас спросить, как художник художника: вы рисовать умеете?", isIncoming: true, date: Api.formatter.date(from: "1/8/2015 10:30"))
        ]
        
        if(lastMessage != nil) {
            messages[0] = lastMessage!
        }
        
        return messages
    }
    
    static var canSkills = [
            Skill(id: 0, status: 1, name: "Писать iOS-приложения", description: "Ну работать что-то будет", category: 0, subcategory: 2, userMail: ""),
            Skill(id: 0, status: 1, name: "Готовить гречку", description: "Ну съесть это можно будет", category: 1, subcategory: 4, userMail: ""),
            Skill(id: 0, status: 1, name: "Программы на Java", description: "Ну работать что-то будет", category: 0, subcategory: 2, userMail: "")
        ]
    
    static var wantSkills = [
            Skill(id: 0, status: 2, name: "Решение задачек по алгебре", description: "2 курс линейная алгебра", category: 0, subcategory: 2, userMail: ""),
            Skill(id: 0, status: 2, name: "Торт ко дню рождения", description: "Шоколадный. Нарядный", category: 1, subcategory: 4, userMail: "")
        ]
    
    static func getDefaultDate() -> Date {
        Api.formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return Api.formatter.date(from: "1/1/2000 00:00")!
    }
    
    private enum Const {
        static let day: Double = 60*60*24
    }
}
