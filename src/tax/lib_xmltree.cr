require "xml"

@[Link("xml2")]
lib LibXMLTree
  fun xmlNewDoc(version : UInt8*) : LibXML::Doc*
  fun xmlDocGetRootElement(doc : LibXML::Doc*) : LibXML::Node*
  fun xmlDocSetRootElement(doc : LibXML::Doc*, root : LibXML::Node*) : LibXML::Node*
  fun xmlFreeDoc(cur : LibXML::Doc*) : Void
  fun xmlNewNs(node : LibXML::Node*, href : UInt8*, prefix : UInt8*) : LibXML::NS*
  fun xmlSetNs(node : LibXML::Node*, ns : LibXML::NS*) : Void*
  fun xmlNewNsPropEatName(node : LibXML::Node*, ns : LibXML::NS*, name : UInt8*, value : UInt8*) : LibXML::Attr*
  fun xmlSetNsProp(node : LibXML::Node*, ns : LibXML::NS*, name : UInt8*, value : UInt8*) : LibXML::Attr*
  fun xmlFreeNs(LibXML::NS*) : Void
  fun xmlUnsetNsProp(node : LibXML::Node*, ns : LibXML::NS*, name : UInt8*) : Int32
  fun xmlNewNode(ns : LibXML::NS*, name : UInt8*) : LibXML::Node*
  fun xmlNewProp(node : LibXML::Node*, name : UInt8*, value : UInt8*) : LibXML::Attr*
  fun xmlNewText(content : UInt8*) : LibXML::Node*
  fun xmlNewChild(parent : LibXML::Node*, ns : LibXML::NS*, name : UInt8*, content : UInt8*) : LibXML::Node*
  fun xmlAddChild(parent : LibXML::Node*, cur : LibXML::Node*) : LibXML::Node*
  fun xmlAddChildList(parent : LibXML::Node*, cur : LibXML::Node*) : LibXML::Node*
  fun xmlAddSibling(cur : LibXML::Node*, elem : LibXML::Node*) : LibXML::Node*
  fun xmlAddNextSibling(cur : LibXML::Node*, elem : LibXML::Node*) : LibXML::Node*
  fun xmlAddPrevSibling(cur : LibXML::Node*, elem : LibXML::Node*) : LibXML::Node*
  fun xmlPreviousElementSibling(node : LibXML::Node*) : LibXML::Node*
  fun xmlNewDocFragment(doc : LibXML::Doc*) : LibXML::Node*
  fun xmlIsBlankNode(node : LibXML::Node*) : UInt8
  fun xmlSplitQName2(name : UInt8*,prefix : UInt8** ) : UInt8*
  fun xmlCopyNamespace(cur : LibXML::NS*) : LibXML::NS*
  fun xmlCopyNode(node : LibXML::Node*, extended : Int32) : LibXML::Node*
end
