# Lingo

![Swift](http://img.shields.io/badge/swift-3.1-brightgreen.svg)
![MIT](http://img.shields.io/badge/license-MIT-brightgreen.svg)

Lingo is a pure Swift localization library ready to be used in Server Side Swift project but not limited to those. 

Features:

* Pluralization - including custom language specific pluralization rules (CLDR compatible)
* String interpolation
* Default locale - if the localization for a requested locale is not available, it will fallback to the default one
* Locale validation - the library will warn you for using invalid locale identifiers (`en_fr` instead of `en_FR` etc.)

# Setup

The supported method for using this library is trough the Swift Package manager, like this:

```
import PackageDescription

let package = Package(
    name: "MyCoolApp",
    dependencies: [.Package(url: "https://github.com/miroslavkovac/Lingo.git", majorVersion: 1)]
)
```

Optionally, if you are using Xcode, you can generate Xcode project by running:

```
swift package generate-xcodeproj
```

In your app create an instance of `Lingo` object passing the root directory path where the localization files are located:

```
let lingo = try Lingo(rootURL: URL(fileURLWithPath: "/users/user.name/localizations"), defaultLocale: "en")
```
> Note that the call can throw in case of an IO error or invalid JSON file.

### Vapor

If you are using Vapor for you server side swift project, you can initialise `Lingo` alongside `Droplet` which will make it accessible everywhere in code:

```
import Vapor
import Lingo

let drop = try Droplet()
let lingo = try Lingo(rootURL: URL(fileURLWithPath: drop.config.workDir.appending("Localizations")), defaultLocale: "en")

try drop.run()
```

> Further versions of Vapor will hopefully provide some hooks for localization engines to be plugged in, and then we will be able to do something like `drop.localize(...)`.

# Usage

Use the following syntax for defining localizations in the JSON file:

```
{
	"title": "Hello Swift!",
	"greeting.message": "Hi %{full-name}! How are your Swift skills today?",
    "unread.messages": {
        "one": "You have an unread message.",
        "other": "You have %{count} unread messages."
    }
}
```

> Note that this syntax is compatible with `i18n-node-2`. This is useful in case you are using a 3rd party localization service which will export the localization files for you.

## Localization

You can retrieve localized string like this:

```
let localizedTitle = lingo.localized("title", locale: "en")

print(localizedTitle) // will print: "Hello Swift!"
```

## String interpolation

You can interpolate the strings like this:

```
let greeting = lingo.localized("greeting.message", locale: "en", interpolations: ["full-name": "John"])

print(greeting) // will print: "Hi John! How are your Swift skills today?"
```

## Pluralization

Lingo supports all Unicode plural categories as defined in [CLDR](http://cldr.unicode.org/index/cldr-spec/plural-rules):

* zero
* one
* two
* few
* many
* other

Example:

```
let unread1 = lingo.localized("unread.messages", locale: "en", interpolations: ["count": 1])
let unread24 = lingo.localized("unread.messages", locale: "en", interpolations: ["count": 24]) 

print(unread1) // Will print: "You have an unread message."
print(unread24) // Will print: "You have 24 unread messages."
```

Each language contains custom pluralization rules. Lingo currently implements rules for the following languages:
> ak, am, ar, az, be, bg, bh, bm, bn, bo, br, bs, by, ca, cs, cy, da, de\_AT, de\_CH, de\_DE, de, dz, el, en\_AU, en\_CA, en\_GB, en\_IN, en\_NZ, en, eo, es\_419, es\_AR, es\_CL, es\_CO, es\_CR, es\_EC, es\_ES, es\_MX, es\_NI, es\_PA, es\_PE, es\_US, es\_VE, es, et, eu, fa, ff, fi, fil, fr\_CA, fr\_CH, fr\_FR, fr, ga, gd, gl, guw, gv, he, hi\_IN, hi, hr, hsb, hu, id, ig, ii, it\_CH, it, iu, ja, jv, ka, kab, kde, kea, km, kn, ko, ksh, kw, lag, ln, lo, lt, lv, mg, mk, ml, mn, mo, mr\_IN, ms, mt, my, naq, nb, ne, nl, nn, nso, or, pa, pl, pt, ro, root, ru, sah, se, ses, sg, sh, shi, sk, sl, sma, smi, smj, smn, sms, sr, sv\_SE, sv, sw, th, ti, tl, to, tr, tzm, uk, ur, vi, wa, wo, yo, zh\_CN, zh\_HK, zh\_TW, zh\_YUE, zh

# Performance

I have made some test with a set of 1000 localization keys including pluralizations and the library was able to handle:

* ~ 1M non interpolated localizations per second or 0.001ms per key.
* ~ 110K interpolated localizations per second or 0.009ms per key.

> String interpolation uses regular expressions under the hood, which can explain the difference in performance. All tests were performed on i7 4GHz CPU.

# Note on locale identifiers

Although it is completely up to you how you name the locales, there is an easy way to get the list of all locales directly from `Locale` class:

```
#import Foundation

print(Locale.availableIdentifiers)
```

Just keep that in mind when adding a support for a new locale.

# Test

To build and run tests from command line just run:

```
swift test
```

or simply `cmd+U` from Xcode.

# Limitations

Currently the library doesn't support the case where different plural categories should be applied to different parts of the *same* localization string. For example, given the definition:

```
{
    "key": {
        "one": "You have 1 apple and 1 orange.",
        "other": "You have %{apples-count} apples and %{oranges-count} oranges."
    }
}
```

and passing numbers 1 and 7:

```
print(lingo.localized("key", locale: "en", interpolations: ["apples-count": 1, "oranges-count": 7]))

```

will print:

```
You have 1 apple and 7 orange.
```
> Note the missing *s* in the printed message.

The reason for this was to keep the JSON file syntax simple and elegant (in comparison to iOS .stringsdict file), but if you still need to support this case, the workaround is to split the string in two and combine it later in code.

# Further work

- Locale fallbacks, being RFC4647 compliant.
- Options for doubling the length of a localized string, which can be useful in debugging.
- Implement debug mode for easier testing and finding missing localizations.
- Support for non integer based pluralization rules

# License

MIT License. See the included LICENSE file.
