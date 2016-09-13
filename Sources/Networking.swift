import Foundation

public final class Networking {

  public enum Kind {
    case Sync, Async, Limited(Int)
  }

  public let kind: Kind
  private let session: NSURLSession
  private let queue: NSOperationQueue

  // MARK: - Initialization

  public init(kind: Kind, session: NSURLSession = NSURLSession.sharedSession()) {
    self.kind = kind
    self.session = session
    queue = NSOperationQueue()

    switch kind {
    case .Sync:
      queue.maxConcurrentOperationCount = 1
    case .Async:
      queue.maxConcurrentOperationCount = -1
    case .Limited(let count):
      queue.maxConcurrentOperationCount = count
    }
  }

  // MARK: - Data request

  public func send(request: NSURLRequest, saveOffline: Bool = false, completion: DataTaskCompletion) {
    let operation = DataOperation(session: session, request: request) {
      data, response, error in

      if saveOffline && error?.isOffline == true {
        RequestStorage.shared.save(request)
      }

      completion(data, response, error)
    }

    queue.addOperation(operation)
  }
}
