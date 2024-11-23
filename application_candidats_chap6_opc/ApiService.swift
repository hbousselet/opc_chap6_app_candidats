//
//  ApiService.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import Foundation


class ApiService {
    let websiteURL = "http://127.0.0.1:8080/"

    static var shared = ApiService()

    static var token: String?
    
    private init() {}
    
    func fetch<T: Decodable>(endpoint: Endpoint,
                             responseType: T.Type) async throws -> Result<T?, APIErrors> {
        
        guard let url = URL(string: websiteURL + endpoint.route) else {
            print("invalid URL")
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        let token = ApiService.token ?? ""
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = endpoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
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
        return .success(decodedData)
    }
}

enum Endpoint {
    case get(Route?, String?)
    case put(Route?, String?)
    case delete(Route?, String?)
    case post(Route?, [String: Any])
    
    var method: Data? {
        switch self {
        case .get:
            return nil
        case .put:
            return nil
        case .delete:
            return nil
        case .post(_, let parameters):
            return try? JSONSerialization.data(withJSONObject: parameters, options: [])
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
        case .put(let route, let id):
            if let route, let id {
                return route.rawValue + String("/\(id)")
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
}

enum APIErrors: Error {
    case invalidResponse
    case invalidDecode
    case invalidURL
}

struct Login: Decodable {
    let token: String
    let isAdmin: Bool
}

struct Register: Decodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}

struct Candidates: Decodable {    
    let candidate: [Candidate]
}

struct Candidate: Decodable, Identifiable, Hashable {
    let phone: String?
    let note: String?
    let id: UUID
    let firstName: String
    let linkedinURL: String?
    let isFavorite: Bool
    let email: String
    let lastName: String
}

