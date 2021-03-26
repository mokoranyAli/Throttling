//
//  ViewController.swift
//  Throttling
//
//  Created by Mohamed Korany on 3/26/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
private lazy var throttler: Throttler = Throttler(seconds: 2)
  
  @IBAction func makeApi(_ sender: Any) {
    throttler.throttle {
      print("make api")
      
    }
  }
  
}

