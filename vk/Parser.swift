//
//  Parser.swift
//  vk
//
//  Created by Александр on 30.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

struct ParserVK : Codable {
    let response: ResponseVK
}

struct ResponseVK: Codable {
    var items: [ItemVK]
    let groups: [GroupVK]
    let profiles: [ProfileVK]
}

struct ItemVK: Codable {
    let type: String
    let source_id: Int
    let text: String?
    let attachments: [AttachmentVK]
    let comments: CommentVK
    let likes: LikeVK
    let reposts: RepostVK
    
    var photoID: String
    var nameID: String
    
    struct CommentVK: Codable {
        let count: Int
        var countString : String {
            return String(count)
        }
    }
    struct LikeVK: Codable {
        let count: Int
        var countString : String {
            return String(count)
        }
    }
    struct RepostVK: Codable {
        let count: Int
        var countString : String {
            return String(count)
        }
    }
}

struct AttachmentVK: Codable {
    let type: TypeOfAttachment
    let photo: PhotoVK?
    let url: String
    let title: String
}

struct PhotoVK: Codable {
    let photo_604: String?
    let photo_800: String?
    let width: Int
    let height: Int
    let preview: PreviewVK?
    var ratio: Double {
        return Double(height) / Double(width)
    }
    
    var ratioForGif: Double {
        var ratio: Double?
        if let height = preview?.video.height, let width = preview?.video.width {
            ratio = Double(height) / Double(width)
        }
        return ratio ?? 0.5
    }
}

struct PreviewVK: Codable {
    let video: VideoVK

    struct VideoVK: Codable {
        let width: Int
        let height: Int
    }
}

struct GroupVK: Codable {
    
}

struct ProfileVK: Codable {
    let id: Int
    let photo_100: String
    let first_name: String
    let last_name: String
    var fullName: String {
        return first_name + " " + last_name
    }
}

enum TypeOfAttachment: String, Codable {
    case photo
    case link
    case audio
    case video
    case doc
    case poll
    case none
}
