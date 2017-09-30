module Tax
  module Tree
    struct XML::Node
      def add_child(child)
        child_node = LibXMLTree.xmlAddChild(self, child)
        if child_node.null?
          raise XML::Error.new("Error adding child node #{child.name} to parent node #{self.name}", 0)
        end
      end

      def add_sibling(sibling)
        sib_node = LibXMLTree.xmlAddSibling(self, sibling)
        if sib_node.null?
          raise XML::Error.new("Error adding sibling node #{sibling.name} to parent node #{self.name}", 0)
        end
      end

      def next_sibling=(sibling)
        sib_node = LibXMLTree.xmlAddNextSibling(self, sibling)
        if sib_node.null?
          raise XML::Error.new("Error adding next sibling #{sibling.name} to parent node #{self.name}", 0)
        end
      end

      def prev_sibling=(sibling)
        raise XML::Error.new("Node must be attached to a parent before adding a sibling", 0) if self.parent.nil?
        sib_node = LibXMLTree.xmlAddPrevSibling(self, sibling)
        if sib_node.null?
          raise XML::Error.new("Error adding prev sibling #{sibling.name} to parent node #{self.name}", 0)
        end
      end

      # Get the closest previous sibling to element
      #def previous_element
      #  prev_sib = LibXMLTree.xmlPreviousElementSibling(self)
      #  if prev_sib.null?
      #    raise XML::Error.new("Error finding prev sibling for node #{self.name}", 0)
      #  end
      #  Tax::Element.new(XML::Node.new(prev_sib)).name
      #end

      def blank?
        empty = LibXMLTree.xmlIsBlankNode(self)
        empty == 1
      end

      def text_node(string : String = "")
        XML::Node.new(LibXMLTree.xmlNewText(string))
      end
    end
  end
end
