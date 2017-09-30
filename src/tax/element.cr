require "./tree"

module Tax
  class Element
    include Tax::Tree
    #getter element : XML::Node
    forward_missing_to @element

    def initialize(@name : String)
      @element = XML::Node.new(@name)
    end

    def initialize(@name, ns, **named)
      @element = XML::Node.new(@name, ns.ptr, **named)
    end

    def to_s
      @element.to_xml
    end

    protected def ptr
      @element.to_unsafe
    end
  end
end
