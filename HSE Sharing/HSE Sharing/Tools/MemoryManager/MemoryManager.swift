//
//  MemoryManager.swift
//  HSE Sharing
//
//  Created by Екатерина on 26.04.2022.
//

import Foundation

class MemoryManager {
    
    static let instance = MemoryManager()

    private let defaults = UserDefaults.standard
    private let newsKey = "applicationPreferences"
    
    func getApplicationPreferences()->[ApplicationPreferences]? {
        let pref = defaults.data(forKey: newsKey)
        guard pref != nil else { return nil }
        let decodedNews = NSKeyedUnarchiver.unarchiveObject(with: pref!) as! [ApplicationPreferences]
        return decodedNews
    }

    func saveApplicationPreferences(_ appPref: [ApplicationPreferences]){
        defaults.removeObject(forKey: newsKey)
        let encodedNews: Data = NSKeyedArchiver.archivedData(withRootObject: appPref)
        defaults.set(encodedNews, forKey: newsKey)
        defaults.synchronize()
    }
}
