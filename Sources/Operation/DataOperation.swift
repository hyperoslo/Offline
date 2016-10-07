import Foundation

public typealias DataTaskCompletion = (Data?, URLResponse?, NSError?) -> Void

class DataOperation: ConcurrentOperation {

  fileprivate let session: URLSession
  fileprivate let request: URLRequest
  fileprivate let completion: DataTaskCompletion
  fileprivate var task: URLSessionDataTask?

  init(session: URLSession, request: URLRequest, completion: @escaping DataTaskCompletion) {
    self.session = session
    self.request = request
    self.completion = completion
  }

  override func execute() {
    task = session.dataTask(with: request, completionHandler: {
      [weak self] (data, response, error) in

      self?.completion(data, response, error as NSError?)
      self?.state = .finished
    }) 

    task?.resume()
  }

  override func cancel() {
    super.cancel()
    task?.cancel()
  }
}
