
require 'nokogiri'

class AccountingEntries

  @debit_entries_array = []
  @credit_entries_array = []
  @max_entries
  @third_party
  @total

  attr_accessor :debit_entries_array
  attr_accessor :credit_entries_array
  attr_accessor :max_entries
  attr_accessor :third_party
  attr_accessor :total

  def initialize(third_party, max_entries, total)

    self.third_party = third_party
    self.max_entries = max_entries
    self.total = total

  end

  def start

    #APPLY CONDITIONS!!!



    #APPLY CONDITIONS!!!

  end

  def xmlState

    builder = Nokogiri::XML::Builder.new do

    end

    return builder.to_xml

  end

end