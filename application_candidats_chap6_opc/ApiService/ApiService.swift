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
                             responseType: T.Type) async throws -> Result<T?, CustomErrors> {
        
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
            return .failure(CustomErrors.invalidDecode)
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

enum CustomErrors: Error, Equatable {
    case invalidResponse
    case invalidDecode
    case invalidURL
    case invalidEmail
    case invalidFrenchPhoneNumber
    case noPasswordEntered
    case emptyPrompt
    case noError
    case lastNameIsEmpty
    case firstNameIsEmpty
    case passwordIsEmpty
    case passwordNotTheSame
    case emailIsEmpty
    case emailIsNotValid
    case registerSuccess
    case deleteCandidateSuccess(name: String)
    case favoriteCandidateSuccess(name: String)
    case updateCandidateSuccess
    
    var description: String {
        switch self {
        case .invalidResponse:
            return "Invalid response."
        case .invalidDecode:
            return "Not able to decode the JSON."
        case .invalidURL:
            return "URL is invalid."
        case .invalidEmail:
            return "Not an email address ! Please enter an email valid."
        case .invalidFrenchPhoneNumber:
            return "It doesn't look like to a french phone number."
        case .noPasswordEntered:
            return "Please enter a correct password."
        case .passwordNotTheSame:
            return "Please confirmed with the same password entered."
        case .emptyPrompt:
            return "Please enter something."
        case .noError:
            return "No error."
        case .lastNameIsEmpty:
            return "Last name is empty. Please enter something."
        case .firstNameIsEmpty:
            return "First name is empty. Please enter something."
        case .passwordIsEmpty:
            return "Password is empty. Please enter something."
        case .emailIsEmpty:
            return "Email is empty. Please enter something."
        case .emailIsNotValid:
            return "Email entered is not a valid email address. Please enter something else."
        case .registerSuccess:
            return "You successfully created a new account."
        case .deleteCandidateSuccess(let name):
            return "Successfully deleted user: \(name)."
        case .favoriteCandidateSuccess(let name):
            return "Updated favorite parameter for candidate: \(name)"
        case .updateCandidateSuccess:
            return "Successfully updated candidate informations."
        }
    }
}

enum RouteV2 {
    case auth
    case userRegister
    case fetchCandidate(candidate: String)
    case fetchCandidates
    case createCandidate
    case deleteCandidate(candidate: String)
    case updateCandidate(candidate: String)
    case updateFavorite(candidate: String)
    
    var method: Methods {
        switch self {
        case .auth:
            return .post
        case .userRegister:
            return .post
        case .fetchCandidate:
            return .get
        case .fetchCandidates:
            return .get
        case .createCandidate:
            return .post
        case .deleteCandidate:
            return .delete
        case .updateCandidate:
            return .put
        case .updateFavorite:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .auth:
            return "user/auth/"
        case .userRegister:
            return "user/register/"
        case .fetchCandidate(let candidateId):
            return "candidate/\(candidateId)"
        case .fetchCandidates:
            return "candidate"
        case .createCandidate:
            return "candidate"
        case .deleteCandidate(let candidateId):
            return "candidate/\(candidateId)"
        case .updateCandidate(let candidateId):
            return "candidate/\(candidateId)"
        case .updateFavorite(let candidateId):
            return "candidate/\(candidateId)/favorite"
        }
    }
  
  enum Methods: String {
    case get
    case post
    case put
    case delete
  }
}

class ApiServiceV2 {
    let websiteURL = "http://127.0.0.1:8080/"
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(endpoint: RouteV2,
                             parametersBody: [String: Any]? = nil,
                             responseType: T.Type) async throws -> Result<T?, CustomErrors> {
        
        guard let url = URL(string: websiteURL + endpoint.path) else {
            print("invalid URL")
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue.uppercased()
        
        let userDefaults = UserDefaults.standard
        
        let savedToken = userDefaults.object(forKey: "token") as? String
        let token = savedToken ?? ""
        
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parametersBody {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parametersBody, options: [])
        }
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              [200, 201].contains(httpResponse.statusCode) else {
            return .failure(.invalidResponse)
        }
        
        if data.isEmpty {
            return .success(nil)
        }
        
        guard let decodedData = try? JSONDecoder().decode(responseType, from: data) else {
            return .failure(CustomErrors.invalidDecode)
        }
        //String(data: decodedData, encoding: .utf8)
        return .success(decodedData)
    }
}
