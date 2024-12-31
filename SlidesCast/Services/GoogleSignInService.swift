//
//  GoogleSignInService.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//
import GoogleSignIn

@MainActor
struct GoogleSignInService {
    private static var accessToken: String?
    private static var scopes = ["https://www.googleapis.com/auth/photoslibrary.readonly"]
    
    static func setup() {
        let clientID = "876425669175-mfhhv72lp3064328a2pe8nl6bc8r7pqj.apps.googleusercontent.com"
        let signInConfig = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = signInConfig
    }
    
    static func signIn(presentingViewController: UIViewController) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController, hint: nil, additionalScopes: scopes) { signInResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let accessToken = signInResult?.user.accessToken.tokenString else {
                    continuation.resume(throwing: NSError(domain: "AccessTokenError", code: 0, userInfo: nil))
                    return
                }

                self.accessToken = accessToken
                continuation.resume(returning: accessToken)
            }
        }
    }
    
    static func getAccessToken() -> String? {
        return accessToken
    }
}
