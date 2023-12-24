//
//  AuthManager.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/16/23.
//
//  key eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxYmR1cGVkd3lmcm9icmd0aXBiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk2NzY5ODUsImV4cCI6MjAxNTI1Mjk4NX0.ThiQQmvpSjx87JtO72uyP1AAMQWQMBoH6L8bN8FLzKU
//  url https://vqbdupedwyfrobrgtipb.supabase.co

import Foundation
import Supabase

struct AppUser {
    let uid: String
    let email: String?
}

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://vqbdupedwyfrobrgtipb.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxYmR1cGVkd3lmcm9icmd0aXBiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk2NzY5ODUsImV4cCI6MjAxNTI1Mjk4NX0.ThiQQmvpSjx87JtO72uyP1AAMQWQMBoH6L8bN8FLzKU"
    )

    
    func getCurrentSession() async throws -> AppUser {
        let session = try await client.auth.session
//        print(session)
//        print(session.user.id)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    // MARK: Registration
    func registerNewUserWithEmail(email: String, password: String) async throws -> AppUser {
        let regAuthResponse = try await client.auth.signUp(email: email, password: password)
        guard let session = regAuthResponse.session else {
            print("no session when registering user")
            throw NSError()
        }
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    

    // MARK: Sign In
    func signInWithEmail(email: String, password: String) async throws -> AppUser {
        let session = try await client.auth.signIn(email: email, password: password)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
        
    }
    
    func signInWithApple(idToken: String, nonce: String) async throws -> AppUser {
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signInWithGoogle(idToken: String, nonce: String) async throws -> AppUser {
//        try await network(idToken: idToken, nonce: nonce)
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .google, idToken: idToken, nonce: nonce))
//        print(session)
//        print(session.user)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // THIS CODE CAN BE IGNORED, THIS IS TEST CODE FOR TRYING TO GET SIGN WITH GOOGLE TO WORK
//    func network(idToken: String, nonce: String) async throws {
//        let url = URL(string: "https://ixjfvcdmqnhfzdhpcjwv.supabase.co/auth/v1/token?grant_type=id_token")!
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("YOUR_KEY", forHTTPHeaderField: "apikey")
//
//        let json = [
//            "id_token": idToken,
//            "provider": "google"
//        ]
//
//        let jsonData = try JSONSerialization.data(withJSONObject: json)
//        print(json)
//        print(jsonData)
//        urlRequest.httpBody = jsonData
//
//        let (data, response) = try await URLSession.shared.data(for: urlRequest)
//        print(String(data: data, encoding: .utf8))
//    }
   
    
}
