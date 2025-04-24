import XCTest
import InstagramFeedClone

final class RemoteDataItemMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() {
        let jsonData = makeValidJSON()
        let response = HTTPURLResponse(statusCode: 400)
        
        XCTAssertThrowsError(try RemoteDataItemMapper.map(jsonData, from: response)) { error in
            XCTAssertEqual(error as? RemoteFeedLoader.Error, .invalidData)
        }
    }
    
    func test_map_throwsErrorOnInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        let response = HTTPURLResponse(statusCode: 200)
        
        XCTAssertThrowsError(try RemoteDataItemMapper.map(invalidJSON, from: response)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func test_map_deliversPostsOnValidJSON() throws {
        let post1 = makePost(id: "1", images: [makeImage(id: "1", type: "image/jpeg", link: "https://example.com/image1.jpg")])
        let post2 = makePost(id: "2", images: [makeImage(id: "2", type: "image/jpeg", link: "https://example.com/image2.jpg")])
        let jsonData = makeValidJSON(posts: [post1, post2])
        let response = HTTPURLResponse(statusCode: 200)
        
        let result = try RemoteDataItemMapper.map(jsonData, from: response)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].images?.first?.link, "https://example.com/image1.jpg")    }
    
    // MARK: - Helpers
    
    private func makePost(id: String, images: [[String: Any]]) -> [String: Any] {
        return [
            "id": id,
            "images": images
        ]
    }
    
    private func makeImage(id: String, type: String, link: String) -> [String: Any] {
        return [
            "id": id,
            "type": type,
            "link": link
        ]
    }
    
    private func makeValidJSON(posts: [[String: Any]] = []) -> Data {
        let json: [String: Any] = [
            "success": true,
            "status": 200,
            "data": posts
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(
            url: anyURL(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
