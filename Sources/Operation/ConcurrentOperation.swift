import Foundation

class ConcurrentOperation: Operation {

  enum State: String {
    case ready = "isReady"
    case executing = "isExecuting"
    case finished = "isFinished"
  }

  var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.rawValue)
      willChangeValue(forKey: state.rawValue)
    }
    didSet {
      didChangeValue(forKey: oldValue.rawValue)
      didChangeValue(forKey: state.rawValue)
    }
  }

  override var isAsynchronous: Bool {
    return true
  }

  override var isReady: Bool {
    return super.isReady && state == .ready
  }

  override var isExecuting: Bool {
    return state == .executing
  }

  override var isFinished: Bool {
    return state == .finished
  }

  override func start() {
    guard !isCancelled else {
      state = .finished
      return
    }

    execute()
  }

  func execute() {
    state = .executing
  }
}
