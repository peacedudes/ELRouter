//
//  RouteSpec.swift
//  ELRouter
//
//  Created by Brandon Sneed on 4/19/16.
//  Copyright © 2016 theholygrail.io. All rights reserved.
//

import Foundation

public protocol RouteEnum {
    var spec: RouteSpec { get }
}
/**
 Use a RouteSpec to document and define your routes.
 
 Example:

    struct WMListItemSpec: AssociatedData {
        let blah: Int
    }

    enum WishListRoutes: Int,  {
        case AddToList
        case DeleteFromList
        
        var spec: RouteSpec {
            switch self {
            case .AddToList: return (name: "AddToList", exampleURL: "scheme://item/<variable>/addToList")
            case .DeleteFromList: return (name: "DeleteFromList", exampleURL: "scheme://item/<variable>/deleteFromList")
            }
        }
    }
 
 */

public typealias RouteSpec = (name: String, type: RoutingType, example: String?)


/**
 */
public func Variable(_ value: String) -> RouteEnum {
    
    class VariableRoute: RouteEnum {
        var value: String
        var spec: RouteSpec {
            return (name: value, type: .variable, example: nil)
        }
        
        init(_ rawValue: String) {
            value = rawValue
        }
    }
    
    let variable = VariableRoute(value)
    return variable
}

internal struct Redirection: RouteEnum {
    var name: String
    var spec: RouteSpec {
        // type and exampleURL are irrelevant, name is the only important piece here.
        return (name: name, type: .other, example: nil)
    }
    
    init(name value: String) {
        name = value
    }
}

internal func routeEnumsFromComponents(_ components: [String]) -> [RouteEnum] {
    var result = [RouteEnum]()
    
    components.forEach { (component) in
        result.append(Redirection(name: component))
    }
    
    return result
}
