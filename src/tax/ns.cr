module Tax
  class NS
    getter prefix, href

    def initialize(@prefix : String, @href : String)
      @ns = XML::Namespace.new(@prefix, @href)
    end

    def to_unsafe
    end

    protected def ptr
      @ns
    end
  end
end
