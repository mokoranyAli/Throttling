//
//  Throttler.swift
//  Throttling
//
//  Created by Mohamed Korany on 3/26/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//

import Foundation

/// Throttler class
///
/// To throttle a function means to ensure that the function is called at most once in a specified time period (for instance, once every 10 seconds).
/// Throttle function must be called at each change of the state.
/// (eg: in a search box you may want call it on textDidChange)
///
final class Throttler {
  
  /// Backgroud queue
  ///
  private let queue = DispatchQueue.global(qos: .background)
  
  
  /// Work item should perform in throttling process
  ///
  /*** The DispatchWorkItem class is an encapsulation of the concept of work item */
  ///
  /*** A dispatch work item has a cancel flag. If it is cancelled before running, the dispatch queue won’t execute it and will skip it. If it is cancelled during its execution, the cancel property return True. In that case, we can abort the execution */
  ///
  /*** By encapsulating our request code in a work item, we can very easily cancel it whenever it's replaced by a new one */
  private var job: DispatchWorkItem = DispatchWorkItem(block: {})
  
  /// Last time of execution is done
  ///
  private var previousRun: Date = Date.distantPast
  
  /// Wanna apply throttling process every x time
  ///
  private var maxInterval: Double
  
  // MARK: - Init
  
  init(seconds: Double) {
    self.maxInterval = seconds
  }
  
  
  /// Apply throttling process
  /// - Parameter block: Block of code that should performed in throttling process
  ///
  func throttle(block: @escaping () -> ()) {
    cancel()
    job = DispatchWorkItem() { [weak self] in
      self?.previousRun = Date()
      block()
    }
    let delay = maxInterval.isLess(than: Date.second(from: previousRun)) ? 0 : maxInterval
    queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
  }
  
  /// Cancel throttling process
  func cancel() {
    job.cancel()
  }
}

// MARK: - Date + helpers
//
private extension Date {
  
  static func second(from referenceDate: Date) -> Double {
    return Date().timeIntervalSince(referenceDate)
  }
}
