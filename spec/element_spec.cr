require "./spec_helper"
describe Tax::Element do
  it "takes a String for name" do
    name = "element"
    node = Tax::Element.new(name)
    node.to_s.should eq "<element/>"
    node.to_xml.should eq "<element/>"
  end

  it "takes a name and Tax::NS" do
    name = "element"
    ns = Tax::NS.new("abc", "uri:tax:code")
    node = Tax::Element.new(name, ns)
    node.to_s.should eq "<abc:element/>"
  end

  it "still accepts XML::Node methods" do
    name = "element"
    ns = Tax::NS.new("abc", "uri:tax:code")
    node = Tax::Element.new(name, ns)
    node.content = "content"
    node.to_s.should eq "<abc:element>content</abc:element>"
  end

  describe "Namespaces" do
    it "ads the namespace prefix to the name" do
      name = "element"
      ns = Tax::NS.new("abc", "uri:tax:code")
      node = Tax::Element.new(name, ns, ns_define: true)
      node.to_s.should eq "<abc:element xmlns:abc=\"uri:tax:code\"/>"
    end

    it "removes the namespace prefix to the name" do
      name = "element"
      ns = Tax::NS.new("abc", "uri:tax:code")
      node = Tax::Element.new(name, ns, ns_define: true)
      node.remove_namespace
      node.to_s.should eq "<element xmlns:abc=\"uri:tax:code\"/>"
    end
  end

  describe "#add_child" do
    it "adds a child element to self" do
      parent = Tax::Element.new("parent")
      child = Tax::Element.new("child")
      parent.add_child child
      parent.to_s.should eq "<parent>\n  <child/>\n</parent>"
    end
  end

  describe "siblings" do
    #siblings must have a parent
    it "raises when parent is not associated to self" do
      expect_raises(XML::Error) do
        orphan_sister = Tax::Element.new("sister")
        orphan_brother = Tax::Element.new("brother")
        orphan_sister.prev_sibling = orphan_brother
      end
    end

    describe "#add_sibling" do
      it "adds a sibling element after child" do
        parent = Tax::Element.new("parent")
        child = Tax::Element.new("child")
        sibling = Tax::Element.new("sibling")
        parent.add_child child
        child.add_sibling sibling
        parent.to_s.should eq "<parent>\n  <child/>\n  <sibling/>\n</parent>"
      end
    end

    describe "#next_sibling=" do
      it "adds a sibling element after child" do
        parent = Tax::Element.new("parent")
        sister = Tax::Element.new("sister")
        brother = Tax::Element.new("brother")
        parent.add_child sister
        sister.next_sibling = brother
        parent.to_s.should eq "<parent>\n  <sister/>\n  <brother/>\n</parent>"
      end
    end

    describe "#prev_sibling=" do
      it "adds a sibling element before child" do
        parent = Tax::Element.new("parent")
        sister = Tax::Element.new("sister")
        brother = Tax::Element.new("brother")
        parent.add_child(sister)
        sister.prev_sibling = brother
        sister.previous_element.to_s.should eq "<brother/>"
        parent.to_s.should eq "<parent>\n  <brother/>\n  <sister/>\n</parent>"
      end
    end
  end
end
