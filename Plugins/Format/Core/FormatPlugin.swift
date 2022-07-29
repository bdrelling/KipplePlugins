// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import PackagePlugin

@main
struct FormatPlugin {
    private func perform(
        kipple: PluginContext.Tool,
        defaultSwiftVersion: String,
        package: Package,
        arguments: [String]
    ) throws {
        var extractor = ArgumentExtractor(arguments)

        // we're going to manually add arguments, so convert to a mutable var.
        var arguments = arguments

        if let _ = extractor.option(named: "swift-version") {
            // do nothing -- just pass the argument along
        } else {
            // no argument was explicitly passed, so add the default swift version
            arguments.append(contentsOf: ["--swift-version", defaultSwiftVersion])
        }

        // prepend the "format" subcommand to the front of the arguments list.
        arguments.insert("format", at: 0)

        // finally, run the command and pass along all the arguments -- kipple will handle the rest!
        try ConfiguredProcess(
            executablePath: kipple.path.string,
            arguments: arguments
        ).run()
    }
}

// MARK: - Extensions

extension FormatPlugin: CommandPlugin {
    private static let kippleCommandName = "kipple"

    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let toolsVersion = context.package.toolsVersion
        let swiftVersion = "\(toolsVersion.major).\(toolsVersion.minor).\(toolsVersion.patch)"

        try self.perform(
            kipple: try context.tool(named: Self.kippleCommandName),
            defaultSwiftVersion: swiftVersion,
            package: context.package,
            arguments: arguments
        )
    }
}
