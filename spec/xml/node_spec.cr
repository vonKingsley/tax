require "../spec_helper"

describe XML::Node do

  it "returns an empty element with just a name" do
    name = "element"
    node = XML::Node.new(name)
    node.to_s.should eq "<element/>"
    node.to_xml.should eq "<element/>"
  end
  describe "namespaces" do
    it "returns a element with a ns and prefix" do
      name = "element"
      ns = XML::Namespace.new("abc", "uri:tax:code")
      node = XML::Node.new(name, ns)
      node.to_s.should eq "<abc:element/>"
    end

    it "adds namespace as an attribute" do
      name = "element"
      ns = XML::Namespace.new("abc", "uri:tax:code")
      node = XML::Node.new(name, ns, ns_define: true)
      node.to_s.should eq "<abc:element xmlns:abc=\"uri:tax:code\"/>"
    end

    it "adds the namespace as an attr but removes the prefix" do
      name = "element"
      ns = XML::Namespace.new("abc", "uri:tax:code")
      node = XML::Node.new(name, ns, ns_define: true, define_only: true)
      node.to_s.should eq "<element xmlns:abc=\"uri:tax:code\"/>"
    end

    it "child nodes have the ns" do
      name = "element"
      ns = XML::Namespace.new("abc", "uri:tax:code")
      node = XML::Node.new(name, ns, ns_define: true)
      node.add_child(XML::Node.new("child", ns))
      node.to_xml(0, "", XML::SaveOptions::AS_XML).should eq "<abc:element xmlns:abc=\"uri:tax:code\"><abc:child/></abc:element>"
    end

    it "raises when ns_define is false, but define_only is true" do
    end

    describe "#set_namespace" do
      it "set the namespace on the node" do
        name = "element"
        ns = XML::Namespace.new("abc", "uri:tax:code")
        node = XML::Node.new(name, ns, ns_define: true, define_only: true)
        node.to_s.should eq "<element xmlns:abc=\"uri:tax:code\"/>"
        node.set_namespace(ns)
        node.to_s.should eq "<abc:element xmlns:abc=\"uri:tax:code\"/>"
      end
    end

    describe "#remove_namespace" do
      it "removes the namespace from the node" do
        name = "element"
        ns = XML::Namespace.new("abc", "uri:tax:code")
        node = XML::Node.new(name, ns, ns_define: true)
        node.to_s.should eq "<abc:element xmlns:abc=\"uri:tax:code\"/>"
        node.remove_namespace
        node.to_s.should eq "<element xmlns:abc=\"uri:tax:code\"/>"
      end
    end

    describe "#add_namespace_definition" do
      it "adds a new ns definition" do
        name = "element"
        ns = XML::Namespace.new("abc", "uri:tax:code")
        ns1 = XML::Namespace.new("def", "uri:new:href")
        node = XML::Node.new(name, ns, ns_define: true)
        node.add_namespace_definition ns1
        node.to_s.should eq "<abc:element xmlns:abc=\"uri:tax:code\" xmlns:def=\"uri:new:href\"/>"
      end
    end

    describe "#remove_namespace_definition" do
      it "removes the decleration" do
        name = "element"
        ns = XML::Namespace.new("abc", "uri:tax:code")
        ns1 = XML::Namespace.new("def", "uri:new:href")
        ns2 = XML::Namespace.new("ghi", "uri:old:a")
        node = XML::Node.new(name, ns, ns_define: true)
        node.add_namespace_definition ns1
        node.add_namespace_definition ns2
        node.remove_namespace_definition("def")
        node.to_s.should eq "<abc:element xmlns:abc=\"uri:tax:code\" xmlns:ghi=\"uri:old:a\"/>"
      end

      it "removes the decleration even if the element is the node namesapce" do
        name = "element"
        ns = XML::Namespace.new("abc", "uri:tax:code")
        ns1 = XML::Namespace.new("def", "uri:new:href")
        ns2 = XML::Namespace.new("ghi", "uri:old:a")
        node = XML::Node.new(name, ns, ns_define: true)
        node.add_namespace_definition ns1
        node.add_namespace_definition ns2
        node.remove_namespace_definition("abc")
        node.to_s.should eq "<abc:element xmlns:def=\"uri:new:href\" xmlns:ghi=\"uri:old:a\"/>"
      end
    end
  end

  describe "#add_child" do
    it "adds a child element to self" do
      parent = XML::Node.new("parent")
      child = XML::Node.new("child")
      parent.add_child child
      parent.to_s.should eq "<parent>\n  <child/>\n</parent>"
    end
  end

  describe "#add_sibling" do
    it "adds a sibling element after child" do
      parent = XML::Node.new("parent")
      child = XML::Node.new("child")
      sibling = XML::Node.new("sibling")
      parent.add_child child
      child.add_sibling sibling
      parent.to_s.should eq "<parent>\n  <child/>\n  <sibling/>\n</parent>"
    end
  end

  describe "#next_sibling=" do
    it "adds a sibling element after child" do
      parent = XML::Node.new("parent")
      sister = XML::Node.new("sister")
      brother = XML::Node.new("brother")
      parent.add_child sister
      sister.next_sibling = brother
      parent.to_s.should eq "<parent>\n  <sister/>\n  <brother/>\n</parent>"
    end
  end

  describe "#prev_sibling=" do
    it "adds a sibling element before child" do
      parent = XML::Node.new("parent")
      sister = XML::Node.new("sister")
      brother = XML::Node.new("brother")
      parent.add_child(sister)
      sister.prev_sibling = brother
      sister.previous_element.to_s.should eq "<brother/>"
      parent.to_s.should eq "<parent>\n  <brother/>\n  <sister/>\n</parent>"
    end
  end
end
