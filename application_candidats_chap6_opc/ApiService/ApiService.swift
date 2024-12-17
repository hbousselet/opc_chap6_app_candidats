//
//  ApiService.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import Foundation

protocol ApiService {
    func fetch<T: Decodable>(endpoint: Route,
                             responseType: T.Type) async -> Result<T?, CustomErrors>
}

class MockAPIService<D: Decodable>: ApiService {
    var data: D?
    var error: CustomErrors?
    var shouldSuccess: Bool = true
    
    func fetch<T>(endpoint: Route, responseType: T.Type) async -> Result<T?, CustomErrors> where T : Decodable {
        if shouldSuccess {
            return .success(data! as? T)
        } else {
            return .failure(error!)
        }
    }
}

class DefaultApiService: ApiService {
    let websiteURL = "http://127.0.0.1:8080/"
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(endpoint: Route,
                             responseType: T.Type) async -> Result<T?, CustomErrors> {
        
        guard let url = URL(string: websiteURL + endpoint.path) else {
            print("invalid URL")
            return .failure(CustomErrors.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue.uppercased()
        
        let userDefaults = UserDefaults.standard
        
        if let savedToken = userDefaults.object(forKey: "token") as? String {
            request.setValue("Bearer " + savedToken, forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parametersBody = endpoint.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parametersBody, options: [])
            } catch {
                return .failure(.cantCreateJSONParams)
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            print(String(data: data, encoding: .utf8))
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return .failure(CustomErrors.invalidResponse)
            }
            
            if data.isEmpty {
                return .success(nil)
            }
            
            guard let decodedData = try? JSONDecoder().decode(responseType, from: data) else {
                return .failure(CustomErrors.invalidDecode)
            }
            //String(data: decodedData, encoding: .utf8)
            return .success(decodedData)
          
        } catch {
            return .failure(.errorSessionData)
        }
    }
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
    case cantCreateJSONParams
    case errorSessionData
    
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
        case .cantCreateJSONParams:
            return "Not able to turn parameters into JSON"
        case .errorSessionData:
            return "Error when performing the call."
        }
    }
}

enum Route {
    case auth(email: String, password: String)
    case userRegister(email: String, password: String, firstName: String, lastName: String)
    case fetchCandidate(candidate: String)
    case fetchCandidates
    case createCandidate
    case deleteCandidate(candidate: String)
    case updateCandidate(candidate: String, email: String, note: String?, linkedinURL: String?, firstName: String, lastName: String, phone: String?)
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
  
  var parameters: [String: Any?]? {
      switch self {
      case .auth(let email, let password):
          return ["email": email, "password": password]
      case .userRegister(let email, let password, let firstName, let lastName):
          return ["email": email, "password": password, "firstName": firstName, "lastName": lastName]
      case .updateCandidate(_, let email, let note, let linkedinURL, let firstName, let lastName, let phone):
          return ["email": email, "note": note,"linkedinURL": linkedinURL, "firstName": firstName, "lastName": lastName, "phone": phone].compactMapValues { $0 }
      default:
          return nil
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
        case .updateCandidate(let candidateId,_,_,_,_,_,_):
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


