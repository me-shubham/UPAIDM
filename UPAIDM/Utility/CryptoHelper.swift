//
//  CurrencyConverterHelper.swift
//  UPAIDM
//
//  Created by shubham singh on 30/11/21.
//

import Foundation
import Alamofire
import Gloss

struct CryptoHelper {
    
    
    func getXLMCurrentValue(baseCurrency: String, completionHandler: @escaping (Error?, Double?) -> Void) {
        
        let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=XLM&tsyms=\(baseCurrency)")!
        let urlRequest = URLRequest(url: url)
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            if error != nil {
                
                completionHandler(error, nil)
                
                return
            }
            
            guard let responseData = data else {return}
            
            do {
                
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                let currencyRate = jsonData as? [String: Double]
                let currentValue = currencyRate?[baseCurrency]
                completionHandler(nil, currentValue)
                
            }catch (let jsonError) {
                
                print("jsonError: ", jsonError.localizedDescription)
                completionHandler(jsonError, nil)
                
            }
            
            
        }.resume()
        
        
    }
    
    
    func getMSC1CurrentValue(baseCurrency: String) -> Double {
        
        if baseCurrency == "EUR" {
            
            return 1.82
            
        } else if baseCurrency == "USD" {
            
            return 2.07
            
        } else if baseCurrency == "GBP" {
            
            return 1.54
            
        } else if baseCurrency == "CHF" {
            
            return 1.91
            
        }
        
        return 0.0
    }
    
    
    func requestCryptoTransaction(transactionType: CryptoTransactionType, request: CryptoTransactionRequest, completionHandler: @escaping (GenricResponse?) -> Void) {
        
        let url = transactionType.rawValue
        
        print("Request: ", request.toJSON())
        
        Alamofire.Session.default.request(url, method: .post, parameters: request.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completionHandler(responseModel)
                    return
                }
            }else{
                completionHandler(nil)
            }
            
        }
        
        
    }
    
    
}


enum CryptoTransactionType: String {
    
    case sell = "https://api.hellenium.com/api/transactions/sell"
    case buy = "https://api.hellenium.com/api/transactions/buy"
    
}

class CryptoTransactionRequest: Encodable {
    
    var walletId: String?
    var password: String?
    var baseCurrency: String?
    var baseAmount: Double?
    var targetCurrency: String?
    var targetAmount: Double?
    
    func toJSON() -> JSON? {
        return jsonify([
            
            "walletId" ~~> self.walletId,
            "password" ~~> self.password,
            "baseCurrency" ~~> self.baseCurrency,
            "baseAmount" ~~> self.baseAmount,
            "targetCurrency" ~~> self.targetCurrency,
            "targetAmount" ~~> self.targetAmount
            
        ])
    }
    
}

enum NotificationName: String {
    
    case cryptoTransactionSuccess = "cryptoTransactionSuccess"
    
}
 
