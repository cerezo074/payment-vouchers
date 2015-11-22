
module TYPEACCOUNT

  DEBIT = 1
  CREDIT = 2

end

class AccountingEntry

  @book
  @code
  @name
  @total
  @account_type

  attr_accessor :book
  attr_accessor :code
  attr_accessor :name
  attr_accessor :total
  attr_accessor :account_type

  def initialize(xml_account_node, book, type, total)

    self.book = book
    self.total = total
    self.account_type = type

    childs_nodes_set = xml_account_node.element_children()
    code_node = childs_nodes_set[0]
    self.code = code_node.content.gsub(/\s{2,}/,"")
    name_node = childs_nodes_set[1]
    self.name = name_node.content.gsub(/\s{2,}/,"")

  end

end