//
//  APIManager.swift
//  ShoppingApp
//
//  Created by apple on 24/04/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPointType {
    var isMultipart: Bool { get }
    var baseUrl: String { get }
    var endPoint: String { get }
    var url: URL? { get }
    var method: HTTPMethod { get }
    var Headers: [String:String]? { get }
    var body: Encodable? { get }
}

enum ProductEndType {
    case login(loginModel: LoginModel)
    case signup(signupModel: SignupModel)
    case uploadFile(uploadFileModel: UploadFileModel)
    case categories
    case products(filter: ProductFilterModel?)
}

extension ProductEndType: EndPointType {
    
    var isMultipart: Bool {
        switch self {
        case .uploadFile:
            return true
        default:
            return false
        }
    }
    
    var baseUrl: String {
        switch self {
        default:
            return "https://api.escuelajs.co/api/v1/"
        }
    }
    
    var endPoint: String {
        switch self {
        case .login:
            return "auth/login"
        case .signup:
            return "users"
        case .uploadFile:
            return "files/upload"
        case .categories:
            return "categories/"
        case .products:
            return "products/"
        }
    }
    
    var url: URL? {
        return URL.init(string: "\(baseUrl)\(endPoint)")
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .signup, .uploadFile:
            return .post
        case .categories, .products:
            return .get
        }
    }
    
    var Headers: [String:String]? {
        let headers: [String:String] = ["Content-Type" : "application/json"]
        return headers
    }
    
    var params: [String:String]? {
        switch self {
        case .products(let filter):
            if let filter = filter {
                let modelToDict = Mirror(reflecting: filter).getDict().compactMapValues { $0 }
                let params = modelToDict.mapValues { String.init(describing: $0)}
                return params
            }
            return nil
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .login(let loginModel):
            return loginModel
        case .signup(let signupModel):
            return signupModel
        case .uploadFile(let model):
            return model
        case .categories, .products:
            return nil
        }
    }
}

enum APIError: Error {
    case invalidUrl
    case invalidRequestData
    case invalidResponse
    case message(String)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl, .invalidRequestData, .invalidResponse:
            return "An unknown error occured."
        case .message(let string):
            return string
        }
    }
}

typealias Handler<T> = (Result<T, APIError>) -> Void

final class APIManager {
    
    static let shared = {
        APIManager()
    }()
    
    class func serverRequest<T: Codable>(modelType:T.Type, apiType: ProductEndType, completion: @escaping Handler<T>) {
        guard !apiType.isMultipart else {
            uploadFile(modelType: modelType, apiType: apiType, completion: completion)
            return
        }
        var url = apiType.url
        
        if apiType.method == .get, let params = apiType.params {
            let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value)}
            url?.append(queryItems: queryItems)
        }
        
        guard let url = url else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiType.method.rawValue
        if let headers = apiType.Headers {
            request.allHTTPHeaderFields = headers
        }
        
        if let body = apiType.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            APIResponseHandler(modelType: modelType, data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    private class func uploadFile<T: Codable>(modelType:T.Type, apiType: ProductEndType, completion: @escaping Handler<T>) {
        guard let url = apiType.url else {
            completion(.failure(.invalidUrl))
            return
        }
        guard let uploadFileModel = apiType.body as? UploadFileModel else {
            completion(.failure(.invalidRequestData))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = apiType.method.rawValue
        if let headers = apiType.Headers {
            request.allHTTPHeaderFields = headers
        }
    
        //create boundary
        let boundary = generateBoundary()
        
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createDataBody(withParameters: uploadFileModel.params, media: [uploadFileModel.media], boundary: boundary)
        request.httpBody = body
        URLSession.shared.dataTask(with: request) { data, response, error in
            APIResponseHandler(modelType: modelType, data: data, response: response, error: error, completion: completion)
        }.resume()
        
    }
    
    /// Common completion handler for all APIs
    /// - Parameters:
    ///   - data: data received from server call
    ///   - response: response received
    ///   - error: error occured
    ///   - completion: callback for caller
    private class func APIResponseHandler<T: Codable>(modelType:T.Type, data: Data?, response: URLResponse?, error: Error?, completion: @escaping Handler<T>) {
        guard let data, error == nil else {
            completion(.failure(.invalidResponse))
            return
        }
        guard let responseData = response as? HTTPURLResponse,
                200 ... 299 ~= responseData.statusCode else {
            if let errorMessage = errorMessage(data: data) {
                completion(.failure(.message(errorMessage)))
            } else {
                completion(.failure(.invalidResponse))
            }
            return
        }
        do {
            let decodedResponse = try JSONDecoder().decode(modelType.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(.message(error.localizedDescription)))
        }
    }
    
    private class func errorMessage(data: Data?) -> String? {
        guard let data else {
            return nil
        }
        guard let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return "JSON Serializaton Error"
        }
        if let messages = responseJson["message"] as? [String], !messages.isEmpty {
            return messages.joined(separator: "\n")
        } else if let messages = responseJson["message"] as? String {
            return messages
        }
        return nil
    }
    
    /// To generate boundary for multipart API
    /// - Returns: generated boundary
    class func generateBoundary() -> String {
       return "Boundary-\(NSUUID().uuidString)"
    }
    
    class func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
       let lineBreak = "\r\n"
       var body = Data()
       if let parameters = params {
           for (key, value) in parameters {
               body.append("--\(boundary + lineBreak)")
               body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
               body.append("\(value + lineBreak)")
           }
       }
       if let media = media {
          for photo in media {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
             body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
             body.append(photo.data)
             body.append(lineBreak)
          }
       }
       body.append("--\(boundary)--\(lineBreak)")
       return body
    }
}
