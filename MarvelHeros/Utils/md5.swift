import Foundation

extension Int {
    func hexedString() -> String {
        return NSString(format: "%02x", self) as String
    }
}

extension NSData {
    func hexedString() -> String {
        var string = String()
        let unsafePointer = bytes.assumingMemoryBound(to: UInt8.self)
        for char in UnsafeBufferPointer<UInt8>(start: unsafePointer, count: length) {
            string += Int(char).hexedString()
        }
        return string
    }
    
    func MD5() -> NSData? {
        guard let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH)) else { return nil }
        let unsafePointer = result.mutableBytes.assumingMemoryBound(to: UInt8.self)
        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(unsafePointer))
        return NSData(data: result as Data)
    }
}

extension String {
    var md5: String? {
        let data = (self as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?
        return data?.MD5()?.hexedString()
    }
}
