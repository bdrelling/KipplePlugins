# KipplePlugins

A collection of Swift Package Manager plugins to be used across a variety of Swift projects.

>:warning: The code in this library has been provided as-is. It includes limited documentation and testing. If you do decide to pull in this package for any reason and find any issues, pull requests are welcome.

## To Do

### General

- [x] Include default configuration files (so repositories don't need their own) via `PluginSupport` module.
- [x] Allow repository to override the configuration file used with standard local dotfile for the applicable command.
- [] Add pre-commit installation scripts.
- [] Add `setup.sh` and other common script files to the project.

### Format

- [x] Add Format command (via SwiftFormat) as Swift Package and Xcode plugins.
- [x] Add functionality for formatting staged files only.

### Lint

- [] Add Lint command (via SwiftLint) as Swift Package and Xcode plugin.
- [] Add functionality for linting staged files only.


# Example Xcode Plugin:

```swift
#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension FormatPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        try self.perform(
            swiftformat: try context.tool(named: "swiftformat"),
            fileFetcher: try context.tool(named: "kipple-file-fetcher"),
            // FIXME: This needs to detect the version somehow! Detect a .swift-version file, maybe?
            defaultSwiftVersion: "5.7",
            arguments: arguments
        ) { targetNames in
            // It is impossible to provide directories like in Swift Package case
            // because input files in XcodeTarget aren't restricted by a directory.
            let targets = context.xcodeProject.targets.filter { targetNames.contains($0.displayName) }
            return targets.flatMap(\.inputFiles).map(\.path.string)
        }
    }
}
#endif
```
