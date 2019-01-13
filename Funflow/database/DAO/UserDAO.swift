//
//  UserDAO.swift
//  Funflow
//
//  Created by Jayson Galante on 13/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit
import SQLite
import CryptoSwift

let KEY = "bbC2H19lkVbQDfakxcrtNMQdd0FloLyw"
let LETTERS = "abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

class UserDAO{
    private let dbConnector : Connection!
    let userTable = Table("User")
    
    let userID = Expression<Int>("id")
    let password = Expression<String>("password")
    let iv = Expression<String>("iv")
    let biometrics = Expression<Bool>("biometrics")
    
    init(_ dbConnector: Connection) throws {
        self.dbConnector = dbConnector
        
        try dbConnector.run(userTable.create(ifNotExists: true){ t in
            t.column(self.userID, primaryKey: .autoincrement)
            t.column(self.password)
            t.column(self.iv)
            t.column(self.biometrics, defaultValue: false)
        })
    }
    
    func insert(forPwd password : String) throws {
        let iv = String((0...15).map{_ in LETTERS.randomElement()!})
        try dbConnector.run(userTable.insert(
            self.password <- try password.aesEncrypt(iv: iv),
            self.iv <- iv
        ))
    }
    
    func isUserSetup() throws -> Bool {
        print("user: ", try dbConnector.scalar(userTable.count) )
        return try dbConnector.scalar(userTable.count) > 0
    }
    
    func isBiometrics() throws -> Bool {
        for user in try dbConnector.prepare(userTable) { return user[self.biometrics] }
        return false
    }
    
    func comparePassword(forPwd pass : String) throws -> Bool {
        for user in try dbConnector.prepare(userTable) {
            let passwordStr = user[self.password]
            let iv = user[self.iv]
            
            return try pass == passwordStr.aesDecrypt(iv: iv)
        }
        
        return false
    }
    
    func updatePassword(newPassword password: String) throws {
        let iv = String((0...15).map{_ in LETTERS.randomElement()!})
        try dbConnector.run(userTable.update(self.password <- password.aesEncrypt(iv: iv)))
        try dbConnector.run(userTable.update(self.iv <- iv))
    }
    
    func updateBiometrics(isOn : Bool) throws {
        try dbConnector.run(userTable.update(self.biometrics <- isOn))
    }
}

extension String {
    func aesEncrypt(iv : String) throws -> String {
        let encrypted = try AES(key: KEY, iv: iv, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
        return Data(encrypted).base64EncodedString()
    }
    
    func aesDecrypt(iv : String) throws -> String {
        guard let data = Data(base64Encoded: self) else {return ""}
        let decrypted = try AES(key: KEY, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        return String(bytes: Data(decrypted).bytes, encoding: .utf8) ?? "Could not decrypt"
    }
}

