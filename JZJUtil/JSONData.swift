//
//  JSONData.swift
//  CQTZ_MALL
//
//  Created by 余蛟 on 2021/5/17.
//

import UIKit

class JSONData: NSObject {

}

extension NSDictionary {
    
    @objc func stringValue(key:String) ->String {
        if let str = self[key] as? String {
            return str
        } else if let numberres = self[key] as? NSNumber {
            return numberres.stringValue
        }
        return ""
    }
    
    @objc func arrayValue(key:String) ->Array<AnyObject> {
        if let arr = self[key] as? Array<AnyObject> {
            return arr
        }
        return []
    }
    
    @objc func dictValue(key:String) ->Dictionary<String, AnyObject> {
        if let result = self[key] as? Dictionary<String,AnyObject> {
            return result
        }
        return [:]
    }
 
    @objc func numberValue(key:String) ->NSInteger {
        if let result = self[key] as? NSInteger {
            return result
        }
        return 0
    }
    
}


extension Dictionary where Key == String {
    func stringValue(key:String) ->String {
        if let str = self[key] as? String {
            return str
        } else if let numberres = self[key] as? NSNumber {
            return numberres.stringValue
        }else if let ints = self[key] as? NSInteger {
            return String(ints)
        }
        
        return ""
    }
    
    func arrayValue(key:String) ->Array<AnyObject> {
        if let arr = self[key] as? Array<AnyObject> {
            return arr
        }
        return []
    }
    
    func dictValue(key:String) ->Dictionary<String, AnyObject> {
        if let result = self[key] as? Dictionary<String,AnyObject> {
            return result
        }
        return [:]
    }
    
    func numberValue(key:String) ->NSInteger {
        if let result = self[key] as? NSInteger {
            return result
        }
        return 0
    }
}
