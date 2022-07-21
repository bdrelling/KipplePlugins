// Copyright © 2022 Brian Drelling. All rights reserved.

import PluginsCore
import XCTest

final class FileClerkTests: XCTestCase {
    func testAllConfigurationFilesAreInBundle() throws {
        let files = FileClerk.shared.configurationFiles

        // Evaluate the total number of expected files in the bundle.
        XCTAssertEqual(files.count, 2)
    }

    func testSwiftFormatFilesAreValid() throws {
        try self.evaluate(.swiftFormat, expectedNumberOfFiles: 1)
    }

    func testSwiftLintFilesAreValid() throws {
        try self.evaluate(.swiftLint, expectedNumberOfFiles: 1)
    }
}

// MARK: - Extensions

private extension FileClerkTests {
    func evaluate(_ tool: ConfigurationTool, expectedNumberOfFiles: Int) throws {
        let files = FileClerk.shared.configurationFiles.filter { $0.tool == tool }

        // Evaluate the total number of expected files in the bundle.
        XCTAssertEqual(files.count, expectedNumberOfFiles)

        // There should be exactly one default file included in the bundle.
        XCTAssertEqual(files.filter(\.isDefault).count, 1, "There must be exactly one default configuration file in the bundle.")
    }
}
