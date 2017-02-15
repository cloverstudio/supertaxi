Diskcached [![Build Status](https://travis-ci.org/hirohisa/Diskcached.png?branch=master)](https://travis-ci.org/hirohisa/Diskcached)
==================

Diskcached is simple disk cache for iOS.

- Simple methods
- Writing asynchronously to disk
- Controlling to clean disk when it called `dealloc`

Installation
----------

There are two ways to use this in your project:

- Copy the Diskcached class files into your project

- Install with CocoaPods to write Podfile
```ruby
platform :ios
pod 'Diskcached', '~> 0.0.1'
```

Example
----------

```objc


Diskcached *cached = [[Diskcached alloc] init];
[cached setObject:object forKey:@"key"];

id result = [cached objectForKey:@"key"];

```

Unsupport
----------

- Dont implement hash function in Diskcached. If need, generate the key with hash function.

### Hash Function
- [MD5](Hash/NSString+MD5.h)


## License

Diskcached is available under the MIT license.
