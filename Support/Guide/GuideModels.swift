import Foundation

public enum GuideCalloutKind: Sendable {
    case tip
    case `do`
    case dont
}

public struct GuideCallout: Sendable {
    public let kind: GuideCalloutKind
    public let titleKey: String
    public let bodyKey: String

    public init(kind: GuideCalloutKind, titleKey: String, bodyKey: String) {
        self.kind = kind
        self.titleKey = titleKey
        self.bodyKey = bodyKey
    }
}

public struct GuideSection: Sendable {
    public let headingKey: String
    public let bodyKey: String?
    public let bulletKeys: [String]
    public let callout: GuideCallout?

    public init(
        headingKey: String,
        bodyKey: String? = nil,
        bulletKeys: [String] = [],
        callout: GuideCallout? = nil
    ) {
        self.headingKey = headingKey
        self.bodyKey = bodyKey
        self.bulletKeys = bulletKeys
        self.callout = callout
    }
}

public struct GuideScreenshotRef: Sendable {
    public let assetName: String
    public let captionKey: String
    public let accessibilityKey: String

    public init(assetName: String, captionKey: String, accessibilityKey: String) {
        self.assetName = assetName
        self.captionKey = captionKey
        self.accessibilityKey = accessibilityKey
    }
}

public struct GuideArticle: Sendable {
    public let topic: GuideTopic
    public let introKey: String
    public let sections: [GuideSection]
    public let screenshots: [GuideScreenshotRef]
    public let relatedTopics: [GuideTopic]
    public let appCalloutKey: String?

    public init(
        topic: GuideTopic,
        introKey: String,
        sections: [GuideSection],
        screenshots: [GuideScreenshotRef] = [],
        relatedTopics: [GuideTopic] = [],
        appCalloutKey: String? = nil
    ) {
        self.topic = topic
        self.introKey = introKey
        self.sections = sections
        self.screenshots = screenshots
        self.relatedTopics = relatedTopics
        self.appCalloutKey = appCalloutKey
    }
}
