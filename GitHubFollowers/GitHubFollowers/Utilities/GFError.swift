//
//  GFError.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 18.02.20.
//

import Foundation

enum GFError: String, Error{
    
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data recieved from the server was invalid. Please try again."
    case unableToFavourite = "There was an error favouriting this user. Please try again."
    case alreadyInFavourites = "You have already favourited this user."
}
