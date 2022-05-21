//
//  DataManager.swift
//  Gaga
//
//  Created by Erendira Cruz Reyes on 20/05/22.
//

import Foundation



struct Item: Codable{
    let pict: String
    let title:String
}

class DataManager: NSObject { // Singleton
    static let instance = DataManager()
    override private init(){
        super.init()
        getInfo()
    }
    let baseURL = "http://janzelaznog.com/DDAM/iOS/gaga"
    var info = [Item]()
    func getInfo(){
        if let url = URL(string: baseURL + "/info.json"){
            
            do{
                let bytes = try Data(contentsOf: url)
                /*let tmp = try JSONSerialization.jsonObject(with: bytes, options: .allowFragments)
                self.info = tmp as! [Item]*/
                self.info = try JSONDecoder().decode([Item].self, from:bytes)
                print(self.info)
            }
            catch{
                
            }
        }
    }
}
