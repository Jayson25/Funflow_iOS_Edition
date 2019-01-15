//
//  GenericObserver.swift
//  Funflow
//
//  Created by Jayson Galante on 14/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit

protocol GenericObserver: class{
    func notify(target: Any?)
}

protocol GenericObservable: class {
    func addObserver(observer: GenericObserver)
    func removeObserver(observer: GenericObserver)
}

class Observable : UIViewController, GenericObservable {
    
    var observers = [GenericObserver]()
    
    func addObserver(observer: GenericObserver) {
        print("adding observer")
        observers.append(observer)
    }
    
    func removeObserver(observer: GenericObserver) {
        print("removing observer")
        observers.remove(at: observers.firstIndex(where: {  $0 === observer })!)
    }
    
    func update(target: Any?){
        for obs in observers {
            obs.notify(target: target)
        }
    }
}
