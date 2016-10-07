import Foundation

public final class Networking {

  public enum Kind {
    case sync, async, limited(Int)
  }

  public let kind: Kind
  fileprivate let session: URLSession
  fileprivate let queue: OperationQueue

  // MARK: - Initialization

  public init(kind: Kind, session: URLSession = URLSession.shared) {
    self.kind = kind
    self.session = session
    queue = OperationQueue()

    switch kind {
    case .sync:
      queue.maxConcurrentOperationCount = 1
    case .async:
      queue.maxConcurrentOperationCount = -1
    case .limited(let count):
      queue.maxConcurrentOperationCount = count
    }
  }

  // MARK: - Data request

  public func send(_ request: URLRequest,
                   saveOffline: Bool = false,
                   completion: @escaping DataTaskCompletion) {
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
