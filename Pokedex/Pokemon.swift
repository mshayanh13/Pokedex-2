//
//  Pokemon.swift
//  Pokedex
//
//  Created by Mohammad Hemani on 3/6/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
        
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
        
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
        
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
        
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
        
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
        
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
        
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
        
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
        
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
        
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)" + String(_pokedexId) + "/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        let url = URL(string: _pokemonURL)!
        Alamofire.request(url).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, Any> {
                
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                    
                }
                
                if let height = dict["height"] as? String {
                    
                    self._height = height
                    
                }
                
                if let attack = dict["attack"] as? Int {
                    
                    self._attack = String(attack)
                    
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._defense = String(defense)
                    
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        
                        self._type = name.capitalized
                        
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            
                            if let name = types[x]["name"] {
                                
                                self._type! += " / \(name.capitalized)"
                                
                            }
                            
                        }
                        
                    }
                    
                } else {
                    
                    self._type = ""
                    
                }
                
                print(self._type)
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>], descriptions.count > 0 {
                    
                    if let uri = descriptions[0]["resource_uri"] {
                        let url = URL(string: "\(URL_BASE)\(uri)")!
                        Alamofire.request(url).responseJSON(completionHandler: { (response) in
                            
                            let descriptionResult = response.result
                            if let descriptionDictionary = descriptionResult.value as? Dictionary<String, Any> {
                                
                                if let description = descriptionDictionary["description"] as? String {
                                    
                                    self._description = description
                                    print(self._description)
                                    
                                }
                                
                            }
                            
                            completed()
                            
                        })
                        
                    }
                    
                } else {
                    
                    self._description = ""
                    
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        //Mega is not found
                        //Can't support mega pokemon right now, but api has the data
                        if to.range(of: "mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let num = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    
                                    self._nextEvolutionLevel = String(level)
                                    
                                } else {
                                    
                                    self._nextEvolutionLevel = ""
                                    
                                }
                                
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionText)
                                print(self._nextEvolutionLevel)
                                
                            }
                            
                        } else {
                            
                            self._nextEvolutionId = ""
                            self._nextEvolutionText = ""
                            self._nextEvolutionLevel = ""
                            
                        }
                        
                    }
                    
                } else {
                    
                    self._nextEvolutionId = ""
                    self._nextEvolutionText = ""
                    self._nextEvolutionLevel = ""
                    
                }
                
            }
            
        }
        
    }
    
}
