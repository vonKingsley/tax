require "../spec_helper"

describe XML::Namespace do
  it "has accepts a href and prefix" do
    node = XML::Node.new("new_node")
    ns = XML::Namespace.new(node, "abc", "http://uri.com")
    ns.href.should eq "http://uri.com"
    ns.prefix.should eq "abc"
    node.to_s.should eq "<new_node xmlns:abc=\"http://uri.com\"/>"
  end
end
