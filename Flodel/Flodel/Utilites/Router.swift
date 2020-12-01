//
//  Router.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 01/12/2020.
//

import Foundation

protocol Router {
    
    /// Base url of the router
    static var baseURL: URL? { get }
    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var accessType: AccessType? { get }
    
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    /// - Returns: A `URLRequest`.
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    func asURLRequest() throws -> URLRequest
}

enum HTTPHeaderField: String {
    case authorization =    "Authorization"
    case contentType =      "Content-Type"
    case acceptType =       "Accept"
    case acceptEncoding =   "Accept-Encoding"
}

/// HTTP supported method type
enum HTTPMethod: String {
    case get =              "get"
    case post =             "post"
    case delete =           "DELETE"
    case patch =            "PATCH"
    case put =              "PUT"
}

/// HTTP content supported content type
enum ContentType: String {
    
    // MARK: - Application content-type
    case json =             "application/json"
    case ldJson =           "application/ld+json"
    case pdf =              "application/pdf"
    case xml =              "application/xml"
    
    // MARK: - Image content-type
    case gif =              "image/gif"
    case jpeg =             "image/jpeg"
    case png =              "image/png"
    case tiff =             "image/tff"
    
    // MARK: - Text content-type
    case css =              "text/css"
    case cvs =              "text/csv"
    case htmp =             "text/html"
    case javascript =       "text/javascript"
    case plain =            "text/plain"
    case _xml =             "text/xml"
}

/// Access type. Related to design of the api, private type requires `Authorization` key in the request `Headers` which indicates that the user is logged in, and this is a private information.
enum AccessType {
    case publicRoute
    case privateRoute
}

enum AccessTypeError: Error {
    case noAccessToken
}

typealias Parameters = [String: Any]
typealias QueryParameters = [String: String]
