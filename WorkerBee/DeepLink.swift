//
//  DeepLink.swift
//  WorkerBee
//
//  Created by nixzhu on 2018/2/13.
//  Copyright © 2018年 nixWork. All rights reserved.
//
//  ref: https://github.com/ijoshsmith/swift-deep-linking/blob/master/DeepLinking/DeepLinking.swift

import Foundation

public protocol DeepLink {

    static var template: DeepLinkTemplate { get }

    init(values: DeepLinkValues)
}

public struct DeepLinkTemplate {

    fileprivate enum PathPart {
        case hosts(caseInsensitiveSymbols: [String])
        case term(symbol: String)
        case string(name: String)
        case int(name: String)
        case double(name: String)
        case bool(name: String)
    }

    public enum QueryStringParameter {
        case requiredString(named: String)
        case requiredInt(named: String)
        case requiredDouble(named: String)
        case requiredBool(named: String)
        case optionalString(named: String)
        case optionalInt(named: String)
        case optionalDouble(named: String)
        case optionalBool(named: String)
    }

    fileprivate let pathParts: [PathPart]
    fileprivate let parameters: Set<QueryStringParameter>

    private init(pathParts: [PathPart], parameters: Set<QueryStringParameter>) {
        self.pathParts = pathParts
        self.parameters = parameters
    }
}

extension DeepLinkTemplate {

    public init() {
        self.init(pathParts: [], parameters: [])
    }

    public func hosts(_ caseInsensitiveSymbols: [String]) -> DeepLinkTemplate {
        return appending(pathPart: .hosts(caseInsensitiveSymbols: caseInsensitiveSymbols))
    }

    public func host(_ caseInsensitiveSymbol: String) -> DeepLinkTemplate {
        return appending(pathPart: .hosts(caseInsensitiveSymbols: [caseInsensitiveSymbol]))
    }

    public func term(_ symbol: String) -> DeepLinkTemplate {
        return appending(pathPart: .term(symbol: symbol))
    }

    public func string(named name: String) -> DeepLinkTemplate {
        return appending(pathPart: .string(name: name))
    }

    public func int(named name: String) -> DeepLinkTemplate {
        return appending(pathPart: .int(name: name))
    }

    public func double(named name: String) -> DeepLinkTemplate {
        return appending(pathPart: .double(name: name))
    }

    public func bool(named name: String) -> DeepLinkTemplate {
        return appending(pathPart: .bool(name: name))
    }

    public func queryStringParameters(_ parameters: Set<QueryStringParameter>) -> DeepLinkTemplate {
        return DeepLinkTemplate(pathParts: pathParts, parameters: self.parameters.union(parameters))
    }

    public func queryStringParameter(_ parameter: QueryStringParameter) -> DeepLinkTemplate {
        return queryStringParameters([parameter])
    }

    private func appending(pathPart: PathPart) -> DeepLinkTemplate {
        return DeepLinkTemplate(pathParts: pathParts + [pathPart], parameters: parameters)
    }
}

extension DeepLinkTemplate.QueryStringParameter: Hashable {

    public var hashValue: Int {
        return name.hashValue
    }

    public static func ==(lhs: DeepLinkTemplate.QueryStringParameter, rhs: DeepLinkTemplate.QueryStringParameter) -> Bool {
        return lhs.name == rhs.name
    }

    fileprivate var name: String {
        switch self {
        case let .requiredString(name): return name
        case let .requiredInt(name):    return name
        case let .requiredDouble(name): return name
        case let .requiredBool(name):   return name
        case let .optionalString(name): return name
        case let .optionalInt(name):    return name
        case let .optionalDouble(name): return name
        case let .optionalBool(name):   return name
        }
    }

    fileprivate enum ParameterType {
        case string
        case int
        case double
        case bool
    }

    fileprivate var type: ParameterType {
        switch self {
        case .requiredString, .optionalString: return .string
        case .requiredInt,    .optionalInt:    return .int
        case .requiredDouble, .optionalDouble: return .double
        case .requiredBool,   .optionalBool:   return .bool
        }
    }

    fileprivate var isRequired: Bool {
        switch self {
        case .requiredString, .requiredInt, .requiredDouble, .requiredBool: return true
        case .optionalString, .optionalInt, .optionalDouble, .optionalBool: return false
        }
    }
}

public struct DeepLinkValues {

    public let path: [String: Any]
    public let query: [String: Any]
    public let fragment: String?

    fileprivate init(path: [String: Any], query: [String: Any], fragment: String?) {
        self.path = path
        self.query = query
        self.fragment = fragment
    }
}

public struct DeepLinkRecognizer {

    private let deepLinkTypes: [DeepLink.Type]

    public init(deepLinkTypes: [DeepLink.Type]) {
        self.deepLinkTypes = deepLinkTypes
    }

    public func deepLink(matching url: URL) -> DeepLink? {
        for deepLinkType in deepLinkTypes {
            if let values = DeepLinkRecognizer.extractValues(in: deepLinkType.template, from: url) {
                return deepLinkType.init(values: values)
            }
        }
        return nil
    }

    private static func extractValues(in template: DeepLinkTemplate, from url: URL) -> DeepLinkValues? {
        guard let pathValues = extractPathValues(in: template, from: url) else { return nil }
        guard let queryValues = extractQueryValues(in: template, from: url) else { return nil }
        return DeepLinkValues(path: pathValues, query: queryValues, fragment: url.fragment)
    }

    private static func extractPathValues(in template: DeepLinkTemplate, from url: URL) -> [String: Any]? {
        let allComponents: [String]
        if let host = url.host {
            allComponents = [host] + url.pathComponents
        } else {
            allComponents = url.pathComponents
        }
        let components = allComponents
            .filter({ $0 != "/" })
            .map({ $0.removingPercentEncoding ?? "" })
        guard components.count == template.pathParts.count else { return nil }
        var values = [String: Any]()
        for (pathPart, component) in zip(template.pathParts, components) {
            switch pathPart {
            case let .hosts(caseInsensitiveSymbols):
                guard caseInsensitiveSymbols.map({ $0.lowercased() }).contains(component.lowercased()) else { return nil }
            case let .term(symbol):
                guard symbol == component else { return nil }
            case let .string(name):
                values[name] = component
            case let .int(name):
                guard let value = Int(component) else { return nil }
                values[name] = value
            case let .double(name):
                guard let value = Double(component) else { return nil }
                values[name] = value
            case let .bool(name):
                guard let value = Bool(component) else { return nil }
                values[name] = value
            }
        }
        return values
    }

    private static func extractQueryValues(in template: DeepLinkTemplate, from url: URL) -> [String: Any]? {
        if template.parameters.isEmpty {
            return url.query == nil ? [:] : nil
        }
        let requiredParameters = template.parameters.filter { $0.isRequired }
        let optionalParameters = template.parameters.subtracting(requiredParameters)
        let queryMap = createQueryMap(of: url)
        var values: [String: Any] = [:]
        for parameter in requiredParameters {
            guard let value = value(of: parameter, in: queryMap) else { return nil }
            values[parameter.name] = value
        }
        for parameter in optionalParameters {
            if let value = value(of: parameter, in: queryMap) {
                values[parameter.name] = value
            }
        }
        return values
    }

    private typealias QueryMap = [String: String]
    private static func createQueryMap(of url: URL) -> QueryMap {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else { return [:] }
        var queryMap = QueryMap()
        for queryItem in queryItems {
            if let value = queryItem.value {
                queryMap[queryItem.name] = value
            }
        }
        return queryMap
    }

    private static func value(of parameter: DeepLinkTemplate.QueryStringParameter, in queryMap: QueryMap) -> Any? {
        guard let value: String = queryMap[parameter.name] else { return nil }
        switch parameter.type {
        case .string: return value.removingPercentEncoding ?? ""
        case .int:    return Int(value)
        case .double: return Double(value)
        case .bool:   return Bool(value)
        }
    }
}
