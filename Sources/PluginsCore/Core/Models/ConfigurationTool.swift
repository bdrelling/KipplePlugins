// Copyright © 2022 Brian Drelling. All rights reserved.

public enum ConfigurationTool: CaseIterable {
    case swiftFormat
    case swiftLint

    var fileExtension: String {
        switch self {
        case .swiftFormat:
            return "swiftformat"
        case .swiftLint:
            return "swiftlint.yml"
        }
    }
}
