//
//  GoogleSignInService.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//


import GoogleSignIn

struct GoogleSignInService {
    private static var accessToken: String?

    static func signIn(presentingViewController: UIViewController, completion: @escaping (Result<String, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let accessToken = signInResult?.user.accessToken.tokenString else {
                completion(.failure(NSError(domain: "AccessTokenError", code: 0, userInfo: nil)))
                return
            }

            self.accessToken = accessToken
            completion(.success(accessToken))
        }
    }

    static func getAccessToken() -> String? {
        return accessToken
    }
}
