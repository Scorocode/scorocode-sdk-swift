//
//  SCUpdateOperator.swift
//  SC
//
//  Created by Alexey Kuznetsov on 27/12/2016.
//  Copyright © 2016 Prof-IT Group OOO. All rights reserved.
//

import Foundation

public enum SCUpdateOperator: Equatable {
    
//    case Set(String, SCValue)
    case set([String: SCValue])
    case push(name: String, value: SCValue, each: Bool)
    case pull(String, SCPullable)
    case pullAll(String, SCValue)
    case addToSet(name: String, value: SCValue, each: Bool)
    case pop(String, Int)
    case inc(String, SCValue)
    case currentDate(String, String)
    case mul(String, SCValue)
    case min(String, SCValue)
    case max(String, SCValue)

    public var name: String {
        switch self {
        case .set:
            return "$set"
        case .push:
            return "$push"
        case .pull:
            return "$pull"
        case .pullAll:
            return "$pullAll"
        case .addToSet:
            return "$addToSet"
        case .pop:
            return "$pop"
        case .inc:
            return "$inc"
        case .currentDate:
            return "$currentDate"
        case .mul:
            return "$mul"
        case .min:
            return "$min"
        case .max:
            return "$max"
        }
    }
    
    public var dic: Any {
        
        switch self {
            
//        case .Set(let name, let value):
//            return [name : value.apiValue]
        case .set(let dic):
            var result = [String: Any]()
            for (name, value) in dic {
                result[name] = value.apiValue
            }
            return result as Any

        // TODO: $sort, $slice, $position
        case .push(let name, let value, let each):
            if !each {
                return [name : value.apiValue]
            } else {
                return [name: ["$each" : value.apiValue]]
            }
    
        case .pull(let name, let value):
            if let val = value as? SCValue {
                return [name : val.apiValue]
            } else {
                let cond = value as! SCOperator
                return [name : cond.dic]
            }

        case .pullAll(let name, let value):
            return [name : value.apiValue]
            
        case .addToSet(let name, let value, let each):
            if !each {
                return [name : value.apiValue]
            } else {
                return [name: ["$each" : value.apiValue]]
            }
            
        case .pop(let name, let value):
            return [name : SCInt(value).apiValue]
            
        case .inc(let name, let value):
            return [name : value.apiValue]
            
        case .currentDate(let name, let typeSpec):
            let value = ["$type" : typeSpec]
            return [name : value]
            
        case .mul(let name, let value):
            return [name : value.apiValue]
            
        case .min(let name, let value):
            return [name : value.apiValue]
            
        case .max(let name, let value):
            return [name : value.apiValue]
        }

    }
    
}

public func ==(lhs: SCUpdateOperator, rhs: SCUpdateOperator) -> Bool {
    switch (lhs, rhs) {
        
//    case (let SCUpdateOperator.Set(name1, v1), let SCUpdateOperator.Set(name2, v2)):
//        return name1 == name2 && v1 == v2
    case (let SCUpdateOperator.set(dic1), let SCUpdateOperator.set(dic2)):
        return dic1 == dic2
        
    case (let SCUpdateOperator.push(name1, v1, each1), let SCUpdateOperator.push(name2, v2, each2)):
        return name1 == name2 && v1 == v2 && each1 == each2

        // TODO: Pull
    case (let SCUpdateOperator.pull(name1, v1), let SCUpdateOperator.pull(name2, v2)):
        if name1 != name2 { return false }
        
        switch (v1, v2) {
        case (is SCValue, is SCValue):
            return (v1 as! SCValue) == (v2 as! SCValue)
        default:
            return false
        }
        
    case (let SCUpdateOperator.pullAll(name1, v1), let SCUpdateOperator.pullAll(name2, v2)):
        return name1 == name2 && v1 == v2
        
    case (let SCUpdateOperator.addToSet(name1, v1, each1), let SCUpdateOperator.addToSet(name2, v2, each2)):
        return name1 == name2 && v1 == v2 && each1 == each2
        
    case (let SCUpdateOperator.pop(name1, v1), let SCUpdateOperator.pop(name2, v2)):
        return name1 == name2 && v1 == v2
        
    case (let SCUpdateOperator.inc(name1, v1), let SCUpdateOperator.inc(name2, v2)):
        return name1 == name2 && v1 == v2
        
    case (let SCUpdateOperator.currentDate(name1, type1), let SCUpdateOperator.currentDate(name2, type2)):
        return name1 == name2 && type1 == type2
        
    case (let SCUpdateOperator.mul(name1, v1), let SCUpdateOperator.mul(name2, v2)):
        return name1 == name2 && v1 == v2
        
    case (let SCUpdateOperator.min(name1, v1), let SCUpdateOperator.min(name2, v2)):
        return name1 == name2 && v1 == v2
        
    case (let SCUpdateOperator.max(name1, v1), let SCUpdateOperator.max(name2, v2)):
        return name1 == name2 && v1 == v2
        
    default: return false
    }
}
