//
//  SignInView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/16/23.
//


import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = SignInViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistrationPresented = false
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text("🍹 Welcome to Bartender!")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding()
            Spacer()
            VStack(spacing: 10) {
                TextField("Email address", text: $email)
                    .padding(.bottom)
                SecureField("Password", text: $password)
            }
            .padding(.horizontal, 24)
            
            Button("New User? Register Here") {
                isRegistrationPresented.toggle()
            }
            .foregroundColor(Color(uiColor: .label))
            .sheet(isPresented: $isRegistrationPresented) {
                RegistrationView(appUser: $appUser)
                    .environmentObject(viewModel)
            }
            
            Button {
                Task {
                    do {
                        let appUser = try await viewModel.signInWithEmail(email: email, password: password)
                        self.appUser = appUser
                    } catch {
                        print("issue with sign in")
                    }
                }
            } label: {
                Text("Sign In")
                    .padding()
                    .bold()
                    .foregroundColor(Color(UIColor.systemBackground))
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color(uiColor: .label))
                    }
            }
            .padding(.horizontal, 24)
            
            VStack {
                Button {
                    Task {
                        do {
                            let appUser = try await viewModel.signInWithApple()
                            self.appUser = appUser
                        } catch {
                            print("error signing in")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "applelogo")
                            .foregroundColor(Color(UIColor.systemBackground))

                        Text("Sign in with Apple")
                            .bold()
                            .foregroundColor(Color(UIColor.systemBackground))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("ReverseDark"))
                    .cornerRadius(8)
                }
                
                Button {
                    Task {
                        do {
                            let appUser = try await viewModel.signInWithGoogle()
                            self.appUser = appUser
                        } catch {
                            print("error signing in")
                        }
                    }
                } label: {
                    HStack {
                        Image("googleLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)

                        Text("Sign in with Google")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }

            }
            .padding(.top)
            .padding(.horizontal, 24)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            SignInView(appUser: .constant(.init(uid: "1234", email: nil)))
            
            SignInView(appUser: .constant(.init(uid: "1234", email: nil)))
                .environment(\.colorScheme, .dark)
        }
    }
}
