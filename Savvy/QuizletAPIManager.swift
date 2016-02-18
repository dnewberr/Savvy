//
//  QuizletAPIManager.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/17/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class QuizletAPIManager {
    static let sharedInstance = QuizletAPIManager()
    
    var clientID = "kCdX95Dr9F"
    var clientSecret = "hEftM82BfGH58dMRhzRhfT"
    var OAuthToken : String?
    var userID : String?
    
    var OAuthTokenCompletionHandler : (NSError? -> Void)?
    
    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        return false
    }
    
    func startOAuth2Login() {
        let authURL = "https://quizlet.com/authorize?response_type=code&client_id=\(clientID)&scope=read&state=NewberryRhoadToSuccess"
        
        if let url = NSURL(string: authURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func processOAuthStep1Response(url : NSURL) {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        var code : String?
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if queryItem.name.lowercaseString == "code" {
                    code = queryItem.value
                    break
                }
            }
            
            if let receivedCode = code {
                let getTokenPath = "https://api.quizlet.com/oauth/token"
                let tokenParams = ["grant_type": "authorization_code", "code": receivedCode, "redirect_uri": "cpe458-savvy://after-oauth", "client_id": clientID, "client_secret": clientSecret]
                Alamofire.request(.POST, getTokenPath, parameters: tokenParams).response { (request, response, results, error) in
                    
                    if let anError = error {
                        print(anError)
                        if let completionHandler = self.OAuthTokenCompletionHandler {
                            let nOAuthError = NSError(domain: "AlamofireErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                            completionHandler(nOAuthError)
                        }
                        return
                    }
                    
                    if let receivedResults = results {
                        var stringResults = NSString(data: receivedResults, encoding: NSASCIIStringEncoding)
                        
                        stringResults = stringResults!.stringByReplacingOccurrencesOfString("{", withString: "")
                        stringResults = stringResults!.stringByReplacingOccurrencesOfString("}", withString: "")
                        
                        let resultsParams = String(stringResults!).componentsSeparatedByString(",")
                        for param in resultsParams {
                            let resultsSplit = param.componentsSeparatedByString(":")
                            
                            if resultsSplit.count == 2 {
                                let key = resultsSplit[0].lowercaseString
                                var value = resultsSplit[1]
                                
                                if key == "\"access_token\"" {
                                    value = value.stringByReplacingOccurrencesOfString("\"", withString: "")
                                    self.OAuthToken = value
                                }
                                else if key == "\"user_id\"" {
                                    value = value.stringByReplacingOccurrencesOfString("\"", withString: "")
                                    self.userID = value
                                }
                            }
                        }
                    }
                    
                    if self.hasOAuthToken() {
                        if let completionHandler = self.OAuthTokenCompletionHandler {
                            completionHandler(nil)
                        }
                    }
                    else {
                        if let completionHandler = self.OAuthTokenCompletionHandler {
                            let nOAuthError = NSError(domain: "AlamofireErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                            completionHandler(nOAuthError)
                        }
                    }
                }
            }
        }
    }
}