//
//  WalletList.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class WalletList: Decodable {
    
    private var _wallets: [Wallet]?
    var wallets: [Wallet]?{
        return _wallets
    }

    func getDataFromArr(dataArr: NSArray) -> [Wallet] {
        var dataList = [Wallet]()
        
        for item in dataArr {
            if let itemData = Wallet(item as! JSON){
                dataList.append(itemData)
            }
        }
        
        return dataList
    }
    
    init?(_ json: [Wallet]) {
        self._wallets = getDataFromArr(dataArr: json as NSArray)
    }

}

