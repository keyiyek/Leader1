//
//  SQLizer.swift
//  Leader1
//
//  Created by hrs on 03/04/2017.
//  Copyright © 2017 Slothlair. All rights reserved.
//

import Foundation
import SQLite

class SQLizer: NSObject{
    
    var errorString: String = ""
    
    // Database
    let dbName: String = "Leader1"
    let dbExtension: String = "db"
    
    // Tables
    var tablesList = [String: Table]()
    let tbHexagons = Table("Hexagons")
    let tbTerrains = Table("Terrains")
    let tbBackgrounds = Table("Backgrounds")
    let tbBoxes = Table("Boxes")
    let tbHexBack = Table("HexesBackgrounds")
    let tbSiblings = Table("Siblings")
    let tbConfigurations = Table("Configurations")
    
    // Columns
    let clID = Expression<Int64>("ID")
    let clCode = Expression<String>("Code")
    let clCode2 = Expression<Int64>("Code2")
    let clFace = Expression<String>("Face")
    let clTerrain = Expression<Int64>("Terrain")
    let clBox = Expression<Int64>("Box")
    let clMilestone = Expression<Int64>("Milestone")
    
    let clName = Expression<String>("Name")
    let clHexagon = Expression<Int64>("Hexagon")
    let clBackground = Expression<Int64>("Background")
    let clFace1 = Expression<Int64>("Face1")
    let clFace2 = Expression<Int64>("Face2")
    
    let clEntry = Expression<Int64>("Entry")
    let clExit = Expression<Int64>("Exit")

    override init() {
        tablesList["Hexagons"] = tbHexagons
        tablesList["Terrains"] = tbTerrains
        tablesList["Backgrounds"] = tbBackgrounds
        tablesList["Boxes"] = tbBoxes
        tablesList["HexesBackgrounds"] = tbHexBack
        tablesList["Siblings"] = tbSiblings
        
        
        
    }
    
    public func getCompleteHex(code: String) ->Hexagon{
        let requestedHex: Hexagon = Hexagon()
        getHexDetails(code: code, hexagon: requestedHex)
        requestedHex.HexBackgrounds = getHexBacgrounds(hexID: requestedHex.HexID)
        requestedHex.HexSiblingCode = getHexSibling(hexID: requestedHex.HexID)
        requestedHex.HexConfiguration = getHexConfiguration(hexID: requestedHex.HexID)

        return requestedHex
    }
    
    private func getHexDetails(code: String, hexagon: Hexagon){
        let path = Bundle.main.path(forResource: dbName, ofType: dbExtension)
        let query = tbHexagons.select(tbHexagons[clID], tbHexagons[clCode], tbHexagons[clCode2], tbHexagons[clFace], tbHexagons[clTerrain], tbHexagons[clBox], tbHexagons[clMilestone], tbTerrains[clName], tbBoxes[clName])
            .join(tbTerrains, on: tbTerrains[clID] == tbHexagons[clTerrain])
            .join(tbBoxes, on: tbBoxes[clID] == tbHexagons[clBox])
            .filter(tbHexagons[clCode] == code)
            .limit(1)
        
        
        do {
            errorString = "Failed Connection"
            let database = try Connection(path!, readonly: true)
            print("Connection")
            
            errorString = "Failed Query"
            for hex in try database.prepare(query) {
                print("ID: \(hex[clID]), Code: \(hex[clCode]), Code2: \(hex[clCode2]), Face: \(hex[clFace]), Terrain: \(hex[tbTerrains[clName]]), Box: \(hex[tbBoxes[clName]]), Milestone: \(hex[clMilestone])")
                hexagon.HexID = hex[clID]
                hexagon.HexCode = hex[clCode]
                hexagon.HexCode2 = hex[clCode2]
                hexagon.HexFace = hex[clFace]
                hexagon.HexTerrain = hex[tbTerrains[clName]]
                hexagon.HexBox = hex[tbBoxes[clName]]
                hexagon.HexMilestone = hex[clMilestone]
            }
            
        }
        catch {print(errorString)}
    }
    
    private func getHexSibling(hexID: Int64) ->String {
        var siblingHex = ""
        let path = Bundle.main.path(forResource: dbName, ofType: dbExtension)
        let query = tbSiblings.select(tbSiblings[clFace1], tbSiblings[clFace2], tbHexagons[clCode])
            .join(tbHexagons, on: tbHexagons[clID] == tbSiblings[clFace2])
            .filter(tbSiblings[clFace1] == hexID)
            .limit(1)
        
        
        do {
            errorString = "Failed Connection"
            let database = try Connection(path!, readonly: true)
            print("Connection")
            
            errorString = "Failed Query"
            for hex in try database.prepare(query) {
                print("Face1: \(hex[clFace1]), Face2: \(hex[clFace2])")
                siblingHex = hex[tbHexagons[clCode]]
            }
        }
        catch{print(errorString)}
        
        return siblingHex
        
        
    }

    private func getHexConfiguration(hexID: Int64) ->[Int64] {
        var hexConfiguration:[Int64] = [0,0]
        let path = Bundle.main.path(forResource: dbName, ofType: dbExtension)
        let query = tbConfigurations.select(tbConfigurations[clHexagon], tbConfigurations[clEntry], tbConfigurations[clExit])
            .filter(tbConfigurations[clHexagon] == hexID)
            .limit(1)
        
        
        do {
            errorString = "Failed Connection"
            let database = try Connection(path!, readonly: true)
            print("Connection")
            
            errorString = "Failed Query"
            for hex in try database.prepare(query) {
                print("ID: \(hex[tbConfigurations[clHexagon]]), Entry: \(hex[tbConfigurations[clEntry]]), Entry: \(hex[tbConfigurations[clExit]])")
                hexConfiguration[0] = hex[tbConfigurations[clEntry]]
                hexConfiguration[1] = hex[tbConfigurations[clExit]]
            }
        }
        catch{print(errorString)}
        
        return hexConfiguration
        
        
    }

    private func getHexBacgrounds(hexID: Int64) ->[String] {
        var siblingHex = [String]()
        
        let path = Bundle.main.path(forResource: dbName, ofType: dbExtension)
        let query = tbHexBack.select(tbHexBack[clHexagon], tbHexBack[clBackground], tbBackgrounds[clName])
            .join(tbBackgrounds, on: tbBackgrounds[clID] == tbHexBack[clBackground])
            .filter(tbHexBack[clHexagon] == hexID)
        
        
        do {
            errorString = "Failed Connection"
            let database = try Connection(path!, readonly: true)
            print("Connection")
            
            errorString = "Failed Query"
            for hex in try database.prepare(query) {
                print("Hexagon: \(hex[tbHexBack[clHexagon]]), Background: \(hex[tbHexBack[clBackground]])")
                siblingHex.append(hex[tbBackgrounds[clName]])
            }
        }
        catch{print(errorString)}
        
        return siblingHex
        
        
    }
    
    //public func hexCount() -> Int {
    
        
        
    //}
    
    public func GetHexList() -> [String] {
        var hexList = [String]()
        
        let path = Bundle.main.path(forResource: dbName, ofType: dbExtension)
        do {
            errorString = "Failed Connection"
            let database = try Connection(path!, readonly: true)
            print("Connection")
            
            errorString = "Failed Query"
            for hex in try database.prepare(tbHexagons) {
                print("Hexagon: \(hex[clID]), Code: \(hex[clCode])")
                hexList.append(hex[clCode])
            }
        }
        catch{print(errorString)}
        
        return hexList

    }
    
    public func GetTerrainsList() -> [String] {
        var hexList = [String]()
        
        let path = Bundle.main.path(forResource: dbName, ofType: dbExtension)
        do {
            errorString = "Failed Connection"
            let database = try Connection(path!, readonly: true)
            print("Connection")
            
            errorString = "Failed Query"
            for hex in try database.prepare(tbTerrains) {
                print("Hexagon: \(hex[clID]), Code: \(hex[clName])")
                hexList.append(hex[clName])
            }
        }
        catch{print(errorString)}
        
        return hexList
        
    }
    public func GetBackgroundsList() -> [String] {
        var hexList = [String]()
        
        let path = Bundle.main.path(forResource: dbName, ofType: dbExtension)
        do {
            errorString = "Failed Connection"
            let database = try Connection(path!, readonly: true)
            print("Connection")
            
            errorString = "Failed Query"
            for hex in try database.prepare(tbBackgrounds) {
                print("Hexagon: \(hex[clID]), Code: \(hex[clName])")
                hexList.append(hex[clName])
            }
        }
        catch{print(errorString)}
        
        return hexList
        
    }

    
    
}
