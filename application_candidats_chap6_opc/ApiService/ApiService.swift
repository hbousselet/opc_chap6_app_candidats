//
//  ApiService.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import Foundation


class ApiService {
    let websiteURL = "http://127.0.0.1:8080/"
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(endpoint: Endpoint,
                             responseType: T.Type) async throws -> Result<T?, APIErrors> {
        
        guard let url = URL(string: websiteURL + endpoint.route) else {
            print("invalid URL")
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        
        let userDefaults = UserDefaults.standard
        
        let savedToken = userDefaults.object(forKey: "token") as? String
        let token = savedToken ?? ""
        
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = endpoint.method
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              [200, 201].contains(httpResponse.statusCode) else {
            return .failure(.invalidResponse)
        }
        
        if data.isEmpty {
            return .success(nil)
        }
        
        guard let decodedData = try? JSONDecoder().decode(responseType, from: data) else {
            return .failure(APIErrors.invalidDecode)
        }
        //String(data: decodedData, encoding: .utf8)
        return .success(decodedData)
    }
}

enum Endpoint {
    case get(Route?, String?)
    case put(Route?, String?, [String: Any?]?)
    case delete(Route?, String?)
    case post(Route?, [String: Any]?)
    
    var method: Data? {
        switch self {
        case .get:
            return nil
        case .put(_, _, let parameters):
            if let parameters {
                return try? JSONSerialization.data(withJSONObject: parameters, options: [])
            } else {
                return nil
            }
        case .delete:
            return nil
        case .post(_, let parameters):
            if let parameters {
                return try? JSONSerialization.data(withJSONObject: parameters, options: [])
            } else {
                return nil
            }
        }
    }
        
        var httpMethod: String {
            switch self {
            case .get:
                return "GET"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
            default:
                return "POST"
            }
        }
        
        var route: String {
            switch self {
            case .put(let route, let id,_):
                if let route, let id {
                    if route == .updateFavorite {
                        return "candidate/" + String("\(id)") + route.rawValue
                    } else {
                        return route.rawValue + String("/\(id)")
                    }
                } else {
                    return ""
                }
            case .get(let route, let id):
                if let route, let id {
                    return route.rawValue + String("/\(id)")
                } else {
                    return ""
                }
            case .delete(let route, let id):
                if let route, let id {
                    return route.rawValue + String("/\(id)")
                } else {
                    return ""
                }
            case .post(let route,_):
                if let route {
                    return route.rawValue
                } else {
                    return ""
                }
            }
        }
    }

enum Route: String {
    case auth = "user/auth/"
    case register = "user/register/"
    case getCandidatesList = "candidate"
    case getCandidateById = "candidate/"
    case updateFavorite = "/favorite"
}

enum APIErrors: Error {
    case invalidResponse
    case invalidDecode
    case invalidURL
    case noError
}
