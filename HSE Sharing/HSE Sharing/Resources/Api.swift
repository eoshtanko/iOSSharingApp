//
//  Api.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class Api {
    
    static let formatter = DateFormatter()
    static var lastMessage: Message?
    
    static func getCurrentUser() -> User {
        Api.formatter.dateFormat = "dd/MM/yyyy"
        
        return User(mail: "ffbsoshtanko@edu.hse.ru", confirmationCodeServer: 12345, confirmationCodeUser: 12345, password: "12345", name: "Екатерина", surname: "Shtanko", birthDate: formatter.date(from: "27/2/2001")!, gender: 1, studyingYearId: 3, majorId: 9, campusLocationId: 1, dormitoryId: 1, about: "Programmer", contact: "t.me/kotkusy", photo: nil, transactions: [], skills: [], feedbacks: [], gradesCount: 1, gradesSum: 1, averageGrade: 1, isModer: false)

    }
}
//    
//    static func getOnlineConversations() -> [Conversation]{
//        Api.formatter.dateFormat = "dd/MM/yyyy HH:mm"
//        return [
////            Conversation(name: "Ivan Simonov", message: "What's the algebra homework?🥺", date: NSDate() as Date - 100, online: true, hasUnreadMessages: false, image: UIImage(named: "man1.jpg")),
////            Conversation(name: "Alexandr Kozlov", message: "Watch the movie \"Kill the Dragon\". It's very good!", date: NSDate() as Date - 1000, online: true, hasUnreadMessages: true, image: UIImage(named: "man2.jpg")),
////            Conversation(name: "Lily Jones", message: "Надо просить позволить свои команды.", date: NSDate() as Date - Const.day, online: true, hasUnreadMessages: false, image: nil),
////            Conversation(name: "Sophie Williams", message: "Привет! Я с ПИ, мы на одном курсе. Слушай, нам тут разрешили свопаться вариантами по ПАПСу, и мне это было бы интересно, поэтому тебе и пишу.", date: NSDate() as Date - Const.day - 100, online: true, hasUnreadMessages: false, image: UIImage(named: "woman1.jpg")),
////            Conversation(name: "Isabella Li", message: nil, date: NSDate() as Date - Const.day - 1000, online: true, hasUnreadMessages: false, image: UIImage(named: "woman2.jpg")),
////            Conversation(name: "Ava Anderson", message: "Come out for a walk today! 🌞 The weather is so wonderful there! Birds, spring, grace!", date: Api.formatter.date(from: "3/3/2022 14:30"), online: true, hasUnreadMessages: false, image: nil),
////            Conversation(name: "Jacob Morton", message: "Let's go to the Ludovico Einaudi concert!", date: Api.formatter.date(from: "1/3/2022 11:12"), online: true, hasUnreadMessages: false, image: UIImage(named: "man3.jpg")),
////            Conversation(name: "Jessica Brown", message: "I don't have time to finish my term paper 🤯", date: Api.formatter.date(from: "1/3/2022 11:11"), online: true, hasUnreadMessages: true, image: UIImage(named: "woman3.jpg")),
////            Conversation(name: "Alex Mironov", message: "Have you read The Death of Ivan Ilyich? Awesome book!!!", date: Api.formatter.date(from: "5/3/2022 10:12"), online: true, hasUnreadMessages: true, image: nil),
////            Conversation(name: "Katya Shtanko", message: nil, date: Api.formatter.date(from: "5/3/2022 10:11"), online: true, hasUnreadMessages: false, image: UIImage(named: "woman4.jpg")),
////            Conversation(name: "Alan Ranger", message: nil, date: Api.formatter.date(from: "27/2/2022 10:10"), online: true, hasUnreadMessages: false, image: nil),
////            Conversation(name: "Viktoria Maass", message: "Thank you! 😊", date: Api.formatter.date(from: "5/1/2022 13:27"), online: true, hasUnreadMessages: false, image: UIImage(named: "woman5.jpg")),
////            Conversation(name: "Donald Trump", message: "What's up?", date: Api.formatter.date(from: "31/12/2021 10:12"), online: true, hasUnreadMessages: true, image: nil)
//        ]
//    }
//
//    static func getOfflineConversations() -> [Conversation]{
//        Api.formatter.dateFormat = "dd/MM/yyyy HH:mm"
//        return [
////            Conversation(name: "Nikolay Romahkov", message: "I overslept the class... Again.", date: NSDate() as Date - 1000, online: false, hasUnreadMessages: false, image: UIImage(named: "man4.jpg")),
////            Conversation(name: "Denis Kizodov", message: "I'm so sorry 😔", date: NSDate() as Date - 2000, online: false, hasUnreadMessages: true, image: UIImage(named: "man5.jpg")),
////            Conversation(name: "Emily Taylor", message: "That's cute!!! :)", date: NSDate() as Date - Const.day, online: false, hasUnreadMessages: true, image: nil),
////            Conversation(name: "Thomas Evans", message: "А как у тебя описана такая функциональность системы как например распределение в стационаре", date: NSDate() as Date - Const.day - 10000, online: false, hasUnreadMessages: false, image: UIImage(named: "man6.jpg")),
////            Conversation(name: "Poppy Davies", message: "Чтобы ответить на этот вопрос, придётся заглянуть в прошлую таблицу. Больше 40.", date: Api.formatter.date(from: "4/3/2022 20:20"), online: false, hasUnreadMessages: true, image: UIImage(named: "woman6.jpg")),
////            Conversation(name: "Charlie O'Kelly", message: "Very anxious about the latest news", date: Api.formatter.date(from: "2/3/2022 15:23"), online: false, hasUnreadMessages: false, image: UIImage(named: "man7.jpg")),
////            Conversation(name: "Liza Frank", message: nil, date: Api.formatter.date(from: "1/3/2022 21:21"), online: false, hasUnreadMessages: false, image: UIImage(named: "woman7.jpg")),
////            Conversation(name: "Olesya Romanova", message: "Сегодня начала", date: Api.formatter.date(from: "1/3/2022 17:40"), online: false, hasUnreadMessages: true, image: nil),
////            Conversation(name: "Artem Belyaev", message: nil, date: Api.formatter.date(from: "1/1/2022 15:28"), online: false, hasUnreadMessages: false, image: UIImage(named: "man8.jpg")),
////            Conversation(name: "Alla Timkanova", message: "Хочу сказать, что ты молодец.", date: Api.formatter.date(from: "6/12/2021 18:19"), online: false, hasUnreadMessages: true, image: UIImage(named: "woman8.jpg")),
////            Conversation(name: "Andrey Romanyuk", message: "Whoa! Did you try to set a breakpoint?", date: Api.formatter.date(from: "2/11/2021 10:27"), online: false, hasUnreadMessages: false, image: nil),
////            Conversation(name: "Oleg Oparinov", message: "ААААААА!!!", date: Api.formatter.date(from: "17/9/2021 16:32"), online: false, hasUnreadMessages: true, image: nil)
//        ]
//    }
//
//    static func getMessages() -> [Message] {
//        Api.formatter.dateFormat = "dd/MM/yyyy HH:mm"
//        var messages: [Message] = []
//
//        if(lastMessage != nil) {
//            messages[0] = lastMessage!
//        }
//
//        return messages
//    }
//
//    static var comments = [
//        Feedback(id: 0, gade: 1, comment: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", senderMail: "", receiverMail: ""),
//        Feedback(id: 0, gade: 2, comment: "hfuhfkjhsdkjfhsk", senderMail: "", receiverMail: ""),
//        Feedback(id: 0, gade: 3, comment: "d", senderMail: "", receiverMail: "")
//    ]
//
//    static var canSkills = [
////        Skill(id: 0, status: 1, name: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", description: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", category: 0, subcategory: 2, userName: "Nikolay Romahkov", userPhoto: UIImage(named: "man1.jpg")!),
////        Skill(id: 0, status: 1, name: "Готовить гречку", description: "Ну съесть это можно будет", category: 1, subcategory: 4, userName: "Charlie O'Kelly", userPhoto: UIImage(named: "man2.jpg")!),
////        Skill(id: 0, status: 1, name: "Программы на Java", description: "Ну работать что-то будет", category: 0, subcategory: 2, userName: "Poppy Davies", userPhoto: UIImage(named: "woman6.jpg")!)
//        ]
//
//    static var wantSkills = [
////        Skill(id: 0, status: 2, name: "Решение задачек по алгебре", description: "2 курс линейная алгебра", category: 0, subcategory: 2, userName: "Паша Эмильевич", userPhoto: UIImage(named: "man6.jpg")!),
////        Skill(id: 0, status: 2, name: "Торт ко дню рождения", description: "Шоколадный. Нарядный", category: 1, subcategory: 4, userName: "Artem Belyaev", userPhoto: UIImage(named: "man8.jpg")!)
//        ]
//
//    static var currentTransactions = [
////        Transaction(id: 0, skill1: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", skill2: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", description: "Игра для курсовой", userName: "Artem Belyaev", userPhoto: UIImage(named: "man8.jpg")!, status: 0),
////        Transaction(id: 0, skill1: "Дизайн мобильного приложения", skill2: "Тортик", description: "Шоколадный", userName: "Паша Эмильевич", userPhoto: UIImage(named: "man6.jpg")!, status: 0),
////        Transaction(id: 0, skill1: "3D модель", skill2: "Фотосессия", description: "Шоколадный", userName: "Poppy Davies", userPhoto: UIImage(named: "woman6.jpg")!, status: 0),
////        Transaction(id: 0, skill1: "frontend на swift", skill2: "backend на java", description: "Шоколадный", userName: "Charlie O'Kelly", userPhoto: UIImage(named: "man2.jpg")!, status: 0),
////        Transaction(id: 0, skill1: "Портрет", skill2: "Стихи", description: "Честно сам писать буду", userName: "Nikolay Romahkov", userPhoto: UIImage(named: "man1.jpg")!, status: 0),
////        Transaction(id: 0, skill1: "Презентация", skill2: "Эссе по ПАПС", description: "По материалам лекций", userName: "Poppy Davies", userPhoto: UIImage(named: "woman6.jpg")!, status: 0),
////        Transaction(id: 0, skill1: "Сайт js html", skill2: "Дискретная математика", description: "10 задачек 1 курс", userName: "Artem Belyaev", userPhoto: UIImage(named: "man8.jpg")!, status: 0)
//        ]
//
//    static var outcomingTransactions = [
////        Transaction(id: 0, skill1: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", skill2: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", description: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", userName: "Nikolay Romahkov", userPhoto: UIImage(named: "man1.jpg")!, status: 0),
////        Transaction(id: 0, skill1: "Презентация", skill2: "Эссе по ПАПС", description: "По материалам лекций", userName: "Poppy Davies", userPhoto: UIImage(named: "woman6.jpg")!, status: 0),
////        Transaction(id: 0, skill1: "Сайт js html", skill2: "Дискретная математика", description: "10 задачек 1 курс", userName: "Artem Belyaev", userPhoto: UIImage(named: "man8.jpg")!, status: 0)
//        ]
//
//    static var searchSkills = [
////        Skill(id: 0, status: 1, name: "Писать iOS-приложения", description: "Ну работать что-то будет", category: 0, subcategory: 2, userName: "Nikolay Romahkov", userPhoto: UIImage(named: "man1.jpg")!),
////        Skill(id: 0, status: 1, name: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", description: "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW", category: 1, subcategory: 4, userName: "Charlie O'Kelly", userPhoto: UIImage(named: "man2.jpg")!),
////        Skill(id: 0, status: 1, name: "Программы на Java", description: "Ну работать что-то будет", category: 0, subcategory: 2, userName: "Poppy Davies", userPhoto: UIImage(named: "woman6.jpg")!),
////        Skill(id: 0, status: 2, name: "Решение задачек по алгебре", description: "2 курс линейная алгебра", category: 0, subcategory: 2, userName: "Паша Эмильевич", userPhoto: UIImage(named: "man6.jpg")!),
////        Skill(id: 0, status: 2, name: "Торт ко дню рождения", description: "Шоколадный. Нарядный", category: 1, subcategory: 4, userName: "Artem Belyaev", userPhoto: UIImage(named: "man8.jpg")!)
//    ]
//
//    static func getDefaultDate() -> Date {
//        Api.formatter.dateFormat = "dd/MM/yyyy HH:mm"
//        return Api.formatter.date(from: "1/1/2000 00:00")!
//    }
//
//    private enum Const {
//        static let day: Double = 60*60*24
//    }
//}
