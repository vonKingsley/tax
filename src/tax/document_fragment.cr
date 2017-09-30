require "./tree"

struct XML::DocumentFragment
  include Tax::Tree

  getter fragment : XML::Node

  @frag_ptr : Pointer(LibXML::Node)
  def initialize
    @frag_ptr = LibXMLTree.xmlNewDocFragment(LibXMLTree.xmlNewDoc("1.0"))
    @fragment = XML::Node.new(ptr_frag_doc)
  end


  def to_unsafe
    @frag_ptr
  end
end
