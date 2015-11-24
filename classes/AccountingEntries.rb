
require 'nokogiri'
require_relative 'utils/Utils'
require_relative 'AccountingEntry'

class AccountingEntries

  @debit_accounts_index_array
  @debit_entries_array
  @credit_accounts_index_array
  @credit_entries_array
  @max_entries
  @total
  @credit_total
  @debit_total

  attr_accessor :debit_accounts_index_array
  attr_accessor :debit_entries_array
  attr_accessor :credit_accounts_index_array
  attr_accessor :credit_entries_array
  attr_accessor :max_entries
  attr_accessor :total
  attr_accessor :debit_total
  attr_accessor :credit_total

  def initialize(max_entries, total)

    self.max_entries = max_entries
    self.total = total
    self.debit_accounts_index_array = []
    self.credit_accounts_index_array = []
    self.debit_entries_array = []
    self.credit_entries_array = []

    start()

  end

  def start

    if(self.max_entries == 2)

      amount_registers = self.max_entries
      max_top_debits = 1
      max_top_credits = 1
      self.debit_total = self.tota
      self.credit_total = self.tota

    else

      amount_registers = Utils::getRandomNumberFromRange(2..self.max_entries)
      max_top_debits = Float(Utils::getRandomNumberFromRange(Range.new(1,amount_registers,true)))
      max_top_credits = Float(amount_registers - max_top_debits)
      self.debit_total = self.total/max_top_debits
      self.credit_total = self.total/max_top_credits

    end

    #puts "Total Register: #{amount_registers}"
    #puts "Total Debit Register: #{max_top_debits}"
    #puts "Total Credit Register: #{max_top_credits}"

    range_debits = Range.new(1,max_top_debits,false)

    range_debits.each do

      debit_index = -1

      loop do

        debit_index = Utils::getRandomNumberToMaxInclusive($debit_accounts_xml_node_set.length - 1)
        break !(self.debit_accounts_index_array.include?(debit_index))

      end

      self.debit_accounts_index_array.push(debit_index)
      account_xml_node = $debit_accounts_xml_node_set[debit_index]
      accounting_entry = AccountingEntry.new(account_xml_node, "COMUN",TYPEACCOUNT::DEBIT,self.debit_total)
      self.debit_entries_array.push(accounting_entry)

    end

    range_credits = Range.new(1,max_top_credits,false)

    range_credits.each do

      credit_index = -1

      loop do

        credit_index = Utils::getRandomNumberToMaxInclusive($credit_accounts_xml_node_set.length - 1)
        break !(self.credit_accounts_index_array.include?(credit_index))

      end

      self.credit_accounts_index_array.push(credit_index)
      account_xml_node = $credit_accounts_xml_node_set[credit_index]
      accounting_entry = AccountingEntry.new(account_xml_node, "COMUN",TYPEACCOUNT::CREDIT,self.credit_total)
      self.credit_entries_array.push(accounting_entry)

    end

  end

  def xmlState(accounting_entries_document)

    #In a future we implement this!!!#

  end

end