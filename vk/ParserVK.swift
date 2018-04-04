//
//  Parser.swift
//  vk
//
//  Created by Александр on 30.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

struct NewsParserVK : Codable {
    let response: ResponseNewsVK
}

struct FriendsParserVK : Codable {
    let response: [ProfileVK]
}

struct GroupsParserVK : Codable {
    let response: [Group]
}

struct ResponseNewsVK: Codable {
    var items: [ItemVK]
    let groups: [GroupVK]
    let profiles: [ProfileVK]
}

struct ItemVK: Codable {
    let type: String
    let source_id: Int
    let text: String?
    let attachments: [AttachmentVK]?
    let comments: CommentVK
    let likes: LikeVK
    let reposts: RepostVK
    
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
    let url: String?
    let title: String?
    let link: LinkVK?
    let doc: DocVK?
    let video: VideoVK?
}

struct PhotoVK: Codable {
    let photo_604: String?
    let photo_800: String?
    let width: Int
    let height: Int
    var ratio: Double {
        return Double(height) / Double(width)
    }
}

struct LinkVK: Codable {
    let url: String?
    let title: String?
    let photo: PhotoVK?
}

struct DocVK: Codable {
    let url: String?
    let preview: PreviewVK?
    
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
}

struct VideoVK: Codable {
    let photo_800: String?
    let photo_640: String?
    let photo_320: String?
    let width: Int?
    let height: Int?
}

struct GroupVK: Codable {
    let id: Int
    let name: String
    let photo_100: String
}

struct ProfileVK: Codable {
    let id: Int?
    let photo_100: String
    let first_name: String
    let last_name: String
    var fullName: String {
        return first_name + " " + last_name
    }
    let user_id: Int?
}

enum TypeOfAttachment: String, Codable {
    case photo
    case link
    case audio
    case video
    case doc
    case poll
    case page
    case none
}
