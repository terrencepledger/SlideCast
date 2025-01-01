//
//  GoogleAlbumError.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//

import Foundation

enum GooglePhotosServiceError: LocalizedError, Identifiable {
    var id: GooglePhotosServiceError {
        self
    }
    
    case accessTokenError
    case invalidURLError
    case serverError

    public var errorDescription: String? {
        switch self {        
        case .accessTokenError:
            return "No Access Token When Attempting to Fetch Albums"
        case .invalidURLError:
            return "Invalid Server URL"
        case .serverError:
            return "Server Error Encountered When Fetching Albums"
        }
    }
}
