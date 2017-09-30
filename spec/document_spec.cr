describe Tax::Document do
  it "creates an empty doc" do
    doc = Tax::Document.new
    doc.document.to_s.should eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    doc.root.should be_nil
  end

  it "creates a document from Node and sets as the root node" do
    node = Tax::Element.new("Kingsley")
    doc = Tax::Document.new()
    doc.root = node
    doc.root.to_s.should eq "<Kingsley/>"
  end

  it "creates a document from a Tax::Element and sets as the root node" do
    node = Tax::Element.new("Kingsley")
    doc = Tax::Document.new(node)
    doc.root.to_s.should eq "<Kingsley/>"
    new_node = Tax::Element.new("Kingsley")
    new_node.add_child Tax::Element.new("Lewis")
    doc1 = Tax::Document.new(new_node)
    doc1.root.to_s.should eq "<Kingsley>\n  <Lewis/>\n</Kingsley>"
  end

  it "#new_fragment not sure what it does" do
    doc = Tax::Document.new(Tax::Element.new("doc"))
    frag = doc.create_fragment
    puts "find out more on document fragments"
    frag.add_child(Tax::Element.new("frag_child"))
    frag.to_xml.should eq "<frag_child/>\n"
  end

  it "has a version" do
    doc = Tax::Document.new
    doc.version.should eq "1.0"
  end

  it "has an encoding" do
    doc = Tax::Document.new
    doc.encoding.should eq "UTF-8"
  end
end
