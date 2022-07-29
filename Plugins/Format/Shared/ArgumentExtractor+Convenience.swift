// Copyright © 2022 Brian Drelling. All rights reserved.

import PackagePlugin

extension ArgumentExtractor {
    mutating func option(named argument: String) -> String? {
        extractOption(named: argument).first
    }

    mutating func option(named argument: String, defaultValue: String) -> String {
        self.option(named: argument) ?? defaultValue
    }

    mutating func options(named argument: String) -> [String] {
        let options = extractOption(named: argument)

        // To support passing as a comma-delimited list or unique options, check to see if there is a single value, and if so, split by comma.

        // If there is NOT a single value returned, pass the options array back as-is -- empty or not.
        guard options.count == 1 else {
            return options
        }

        // Unwrap the first option -- it should definitely be there if we reach this point in the code.
        guard let firstOption = options.first else {
            return []
        }

        // Since there is a single value, split the string by comma delimiter and return.
        // This allows us to support passing as either of the following:
        //     --target first --target second
        //     --target first,second
        return firstOption.split(separator: ",").map(String.init)
    }

    mutating func options(named argument: String, defaultValues: [String]) -> [String] {
        let options = self.options(named: argument)

        // If options are empty, return the defaultValues array instead.
        return !options.isEmpty ? options : defaultValues
    }

    mutating func flag(named argument: String) -> Bool {
        // The Int value represents the number of occurrences of the flag.
        // Since we won't ever have a use for passing a flag multiple times, we'll just evaluate as a Bool.
        extractFlag(named: argument) > 0
    }
}
