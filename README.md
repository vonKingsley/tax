# tax
**T**ree **A**PI for **X**ML
Bindings for libXML2 Tree API


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  tax:
    github: vonKingsley/tax
```


## Usage


```crystal
require "tax"
```

```crystal
doc = Tax::Document.new
root = Tax::Element.new("root")
namespace = Tax::NS.new("abc", "uri:tax:code")
parent = Tax::Element.new("parent", namespace, ns_define: true) 
child = Tax::Element.new("child", namespace)

parent.add_child(child)
root.add_child(parent)
doc.root = root
#=><?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n  <abc:parent xmlns:abc=\"uri:tax:code\">\n    <abc:child/>\n  </abc:parent>\n</root>\n
```


## Contributing

1. Fork it ( https://github.com/vonKingsley/tax/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [vonKingsley](https://github.com/vonKingsley) vonKingsley - creator, maintainer
