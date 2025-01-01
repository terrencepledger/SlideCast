//
//  GoogleAlbumError.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//

import Foundation

enum GoogleAlbumServiceError: LocalizedError, Identifiable {
    var id: GoogleAlbumServiceError {
        self
    }
    
    case serviceError
    case accessTokenError
    
    public var errorDescription: String? {
        switch self {
        case .serviceError:
            return "Some Service Error When Fetching Albums"
        case .accessTokenError:
            return "No Access Token When Attempting to Fetch Albums"
        }
    }
}
