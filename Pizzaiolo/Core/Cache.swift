//
//  Cache.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 04/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation

class Cache {
    
    static let instance = Cache()
    private var directory: String {
        return cacheDirectory()
    }
    
    private init() {}
    
    @discardableResult
    func put(key: String, data: Data) -> Bool {
        let file = (self.directory as NSString).appendingPathComponent(self.makeKey(with: key))
        
        return FileManager.default.createFile(atPath: file, contents: data)
    }
    
    func get(key: String) -> Data? {
        if self.has(key: self.makeKey(with: key)) {
            let file = (self.directory as NSString).appendingPathComponent(self.makeKey(with: key))
            
            return FileManager.default.contents(atPath: file)
        }
        
        return nil
    }
    
    func has(key: String) -> Bool {
        let file = (self.directory as NSString).appendingPathComponent(self.makeKey(with: key))
        
        return FileManager.default.fileExists(atPath: file)
    }
    
    func forget(key: String) {
        if self.has(key: self.makeKey(with: key)) {
            let file = (self.directory as NSString).appendingPathComponent(self.makeKey(with: key))
            
            do {
                try FileManager.default.removeItem(atPath: file)
            }
            catch {}
        }
    }
    
    func flush() {
        let files = try! FileManager.default.contentsOfDirectory(atPath: self.directory)
        
        for file in files {
            do {
                try FileManager.default.removeItem(atPath: file)
            }
            catch {}
        }
    }
    
    private func cacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let directory = (paths.first! as NSString).appendingPathComponent("pizzaiolo")
        let fileManager = FileManager.default
        var cacheDir = directory
        
        if !fileManager.fileExists(atPath: directory) {
            do {
                try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true)
                cacheDir = directory
            } catch {
                cacheDir = paths.first!
            }
        }
        
        return cacheDir
    }
    
    private func makeKey(with: String) -> String {
        return with
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: ".", with: "")
    }
    
}
