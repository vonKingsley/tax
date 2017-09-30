struct XML::Namespace

  def initialize(@ns : LibXML::NS*)
    @document = XML::Node.new("")
  end

  def initialize(@document, prefix : String, href : String)
    @ns = LibXMLTree.xmlNewNs(@document, href, prefix)
  end

  def initialize(node : LibXML::Node*, prefix : String, href : String)
    @document = XML::Node.new("")
    @ns = LibXMLTree.xmlNewNs(node, href, prefix)
  end

  def initialize(prefix : String, href : String)
    @document = XML::Node.new("")
    @ns = LibXMLTree.xmlNewNs(@document, href, prefix)
  end

  def to_unsafe
    @ns
  end
end
