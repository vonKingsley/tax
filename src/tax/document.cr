require "./tree"

module Tax
  class Document
    include Tax::Tree
    delegate to_xml, to_s, to: document

    # initialize a blank document
    def initialize(version : String = "1.0", encoding : String = "UTF-8")
      @doc = LibXMLTree.xmlNewDoc(version)
      self.encoding = encoding
    end

    def initialize(elem : Tax::Element)
      @doc = LibXMLTree.xmlNewDoc("1.0")
      self.root = elem
    end

    def root=(root)
      unless root?
        LibXMLTree.xmlDocSetRootElement(@doc, root.ptr)
      end
      root
    end

    def document
      XML::Node.new(@doc)
    end

    def root
      document.root || nil
    end

    def root?
      !root.nil?
    end

    def version
      ver = @doc.value.version
      ver ? String.new(ver) : nil
    end

    def encoding
      enc = @doc.value.encoding
      enc ? String.new(enc) : nil
    end

    def encoding=(enc)
      @doc.value.encoding = enc
    end

    def create_fragment
      XML::Node.new(LibXMLTree.xmlNewDocFragment(@doc))
    end

    def to_unsafe
      @doc
    end

    protected def doc_ptr
      @doc
    end
  end
end
