struct XML::Node

  # Create a new Element node with **name**
  #
  # NOTE: This node is detached from a document
  # Create the element node
  # ```
  # XML::Node.new("element") #=> <element/>
  # ```
  #
  # Create the element node associated to a namespace
  # ```
  # ns = XML::Namespace.new("prefix", "uri:id:href")
  # elem = XML::Node.new(ns, "element") #=> <prefix:element/>
  # ```
  #
  # Create the element with namespace prefix and xmlns definition
  # ```
  # ns = XML::Namespace.new("prefix", "uri:id:href")
  # elem = XML::Node.new(ns, "element", ns_define: true) #=> <prefix:element xmlns:prefix="uir:id:href"/>
  # ```
  #
  # Create the element and set only the namespace definition, remove the tag prefix
  # ```
  # ns = XML::Namespace.new("prefix", "uri:id:href")
  # elem = XML::Node.new(ns, "element", : true, ns_define: true, define_only: true) #=> <element xmlns:prefix="uir:id:href"/>
  # ```
  # You can define multiple namespaces on a node, but only one will associate the node to the namespace.
  def initialize(name : String, ns : XML::Namespace? = nil, ns_define = false, define_only = false)
    raise "Cannot declare only if namespace declare is false" if ns_define == false && define_only == true
    @node = LibXMLTree.xmlNewNode(nil, name)
    if ns
      if ns_define
        prefix = ns.prefix.to_s
        href = ns.href.to_s
        #this adds the namespace definition in the element tag <name xmlns:prefix="href">
        #namespace is not actaully on this node.
        XML::Namespace.new(@node, prefix, href)
      end
      #This applies the namespace to the node, adds the prefix to the element name <prefix:name> unless dec_only
      LibXMLTree.xmlSetNs(@node, ns) unless define_only
    end
  end

  # Sets the namespace on the element
  #TODO: lots of tests what happens when namspace is already on the node
  # ```crystal
  # node #=> <element/>
  # node.add_name_prefix(ns) #=> <prefix:element/>
  # ```
  #
  def set_namespace(ns : XML::Namespace)
    LibXMLTree.xmlSetNs(@node, ns)
  end
  
  # Sets the namespace definition on the element
  # ```crystal
  # node #=> <element/>
  # node.add_namespace_definition(ns) #=> <element xmlns:prefix="href"/>
  # ```
  #
  def add_namespace_definition(ns = XML::Namespace)
    prefix = ns.prefix.to_s
    href = ns.href.to_s
    XML::Namespace.new(@node, prefix, href)
  end

  # Removes the namespace from the element
  #
  # ```crystal
  # node #=> <prefix:element/>
  # node.remove_namespace #=> <element/>
  # ```
  #
  def remove_namespace
    LibXMLTree.xmlSetNs(@node, nil)
  end

  # Removes a namespace definition from a node
  def remove_namespace_definition(prefix : String)
    ns_def = @node.value.ns_def
    recreate = {} of String => String
    while ns_def
      def_prefix = String.new(ns_def.value.prefix)
      if prefix == def_prefix
        cur = ns_def
        ns_def = ns_def.value.next
        LibXMLTree.xmlFreeNs(cur)
        next
      end
      recreate[String.new(ns_def.value.prefix)] = String.new(ns_def.value.href)
      ns_def = ns_def.value.next
    end
    @node.value.ns_def = nil
    @node.value.next = nil
    recreate.each do |prefix, href|
      add_namespace_definition(XML::Namespace.new(prefix.to_s, href.to_s))
    end
  end

  # returns array of `XML::Namespaces` or nil if there are no namespace definitions
  def namespace_definitions
    ns_arr = [] of XML::Namespace
    dec = @node.value.ns_def
    while dec
      ns_arr << XML::Namespace.new(document,dec)
      dec = dec.value.next
    end
    ns_arr.empty? ? nil : ns_arr
  end

  # Override to_xml to accept partial nodes
  # Serialize this Node as XML to *io* using default options.
  #
  # See `XML::SaveOptions.xml_default` for default options.
  def to_xml(io : IO, indent = 2, indent_text = " ", options : SaveOptions = SaveOptions.xml_default)
    # We need to use a mutex because we modify global libxml variables
    SAVE_MUTEX.synchronize do
      oldXmlIndentTreeOutput = LibXML.xmlIndentTreeOutput
      LibXML.xmlIndentTreeOutput = 1
      oldXmlTreeIndentString = LibXML.xmlTreeIndentString
      LibXML.xmlTreeIndentString = (indent_text * indent).to_unsafe

      encoding = @node.value.doc.null? ? nil : @node.value.doc.value.encoding

      save_ctx = LibXML.xmlSaveToIO(
        ->(ctx, buffer, len) {
          Box(IO).unbox(ctx).write Slice.new(buffer, len)
          len
        },
        ->(ctx) {
          Box(IO).unbox(ctx).flush
          0
        },
        Box(IO).box(io),
        encoding,
        options)
      LibXML.xmlSaveTree(save_ctx, self)
      LibXML.xmlSaveClose(save_ctx)

      LibXML.xmlIndentTreeOutput = oldXmlIndentTreeOutput
      LibXML.xmlTreeIndentString = oldXmlTreeIndentString
    end
    io
  end
end
