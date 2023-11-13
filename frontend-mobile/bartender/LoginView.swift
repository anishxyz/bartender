//
//  LoginView.swift
//  bartender
//
//  Created by Anish Agrawal on 11/10/23.
//

import SwiftUI
import Supabase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Text("Bartender")
                .font(.largeTitle)
                .foregroundColor(.blue) // Example color
                .padding(.bottom, 50)

            TextField("Email", text: $email)
                .textFieldStyle(ClassyTextFieldStyle())

            SecureField("Password", text: $password)
                .textFieldStyle(ClassyTextFieldStyle())

            Button("Login") {
                // Login action
            }
            .buttonStyle(ClassyButtonStyle())

            Button("Sign Up") {
                // Sign Up action
            }
            .buttonStyle(ClassyButtonStyle())
        }
        .padding()
        .background(Color.black) // Dark background color
    }
}

// Custom TextField Style
struct ClassyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(white: 1, opacity: 0.1)) // Slightly transparent
            .cornerRadius(5)
            .foregroundColor(.white) // Light text color
            .padding(.bottom, 10)
    }
}

// Custom Button Style
struct ClassyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(.blue) // Example color
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
