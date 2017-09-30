require "./spec_helper"
describe Tax do
  context "#blank?" do 
    it "is false on the root element" do
      doc = Tax::Document.new(Tax::Element.new("blank_test"))
      doc.root.try &.blank?.should be_false
    end

    it "is true on a blank text_node" do
      doc = Tax::Document.new(Tax::Element.new("blank_test"))
      tn = doc.document.text_node
      tn.blank?.should be_true
    end
  end

  it "does README code" do
    doc = Tax::Document.new
    root = Tax::Element.new("root")
    namespace = Tax::NS.new("abc", "uri:tax:code")
    parent = Tax::Element.new("parent", namespace, ns_define: true) 
    child = Tax::Element.new("child", namespace)
    parent.add_child(child)
    root.add_child(parent)
    doc.root = root
    doc.to_xml.should eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n  <abc:parent xmlns:abc=\"uri:tax:code\">\n    <abc:child/>\n  </abc:parent>\n</root>\n"
  end
end

# describe Tax::XML do
#  describe ".create_document" do
#    it "creates a new document node" do
#      doc = Tax::XML.create_document
#      doc.type.should eq XML::Type::DOCUMENT_NODE
#    end
#  end
#
#  describe ".create_element" do
#    it "creates an new Node using a Sting as the name" do
#      #elem_name = "thing"
#      #new_elem = Tax::XML.create_element(elem_name)
#      #new_elem.type.should eq XML::Type::ELEMENT_NODE
#      #new_elem.to_s.should eq "<thing/>"
#    end
#
#    describe ".create_element_ns" do
#      it "creates an element with the namespace and uses a String as the name" do
#        name = "thing"
#        ns = Tax::NS.new("abc", "https://anywhere.but.here.com")
#        new_node = Tax::XML.create_element_ns(name, ns)
#        new_node.to_s.should eq "<abc:thing/>"
#      end
#    end
#  end
# end
