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

enum ParametersError: Error {
    case encodingError
    case encoderError
}

/// Success response status
enum SuccessResponseStatus: Int {
    case ok = 200
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
}

/// Error response status
enum ErrorResponseStatus: Int {
    // MARK:- Flicker API error response status
    case requiredArgugmentMissing = 1
    case notAValidLatitude
    case notAValidLongitude
    case notAValidAccuracy
    case SSLIsRequired = 95
    case invalidSignature
    case missingSignature
    case loginFailedOrInvalidAuthToken
    case userNotLoggedInOrInsufficientPermissions
    case InvalidAPIKey
    case serviceCurrentlyUnavailable
    case writeOperationFailed
    case formatNotFound = 111
    case methodNotFound
    case invalidSOAPEnvelope = 114
    case invalidXMPRPCMethodCall
    case badURLFound
    
    // MARK:- Redirection response status
    case multipleChoices = 300
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case temporaryRedirect
    case permanentRedirect
    
    // MARK:- Client error response status
    case badRequest = 400
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequried
    case preconditionFailed
    case payloadTooLarge
    case requestURITooLong
    case unsupportedMediaType
    case requestedRangeTotSatisfiable
    case exceptionFailed
    case misdirectedRequest = 421
    case unprocessableentity
    case locked
    case failedDependency
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequestes
    case requestHeaderFieldsTooLarge = 431
    case connectionCloseWithoutResponse = 44
    case unavaliableForLegalResons = 451
    case clientClosedRequest = 499
    
    //MARK:- Server error response status
    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended
    case networkAuthenticationRequired
    case networkConnectTimeoutError = 599
}
