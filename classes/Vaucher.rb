
require 'nokogiri'
require_relative 'utils/Utils'
require_relative 'AccountingEntries'

class Vaucher

  @@total = Range.new(1000,1000000,true)

  @vaucher_manager
  @max_amount_register
  @type
  @vaucher_id
  @date
  @note
  @total_value
  @company_index
  @third_party_index
  @acounting_entries

  attr_accessor :vaucher_manager
  attr_accessor :max_amount_register
  attr_accessor :type
  attr_accessor :vaucher_id
  attr_accessor :date
  attr_accessor :note
  attr_accessor :total_value
  attr_accessor :company_index
  attr_accessor :third_party_index
  attr_accessor :acounting_entries

  def initialize (vaucher_id,vaucher_manager, max_amount_register)

    self.vaucher_manager = vaucher_manager
    self.vaucher_id = vaucher_id
    self.max_amount_register = max_amount_register

  end

  def start()

    #APPLY CONDITIONS!!!

    notes_array = ["Pago de Servicios Publicos", "Pago de Nomina", "Pago de Nomina"]

    self.type = "Egresos"
    self.date = Utils::getRandomDateFormated()
    self.note = notes_array[Utils::getRandomNumberToMaxInclusive(notes_array.count - 1)]
    self.total_value = Utils.getRandomNumberFromRange(Utils::total)
    self.company_index = Utils::getRandomNumberToMaxInclusive($companies_XML_node_list.length - 1)
    self.third_party_index = Utils::getRandomNumberToMaxInclusive($third_persons_name_XML_node_list.length - 1)
    self.acounting_entries = AccountingEntries.new(self.max_amount_register, self.total_value)

    if (third_party_index == company_index)

      loop do

        third_party_index = Utils::getRandomNumberToMaxInclusive($companies_XML_node_list.length)
        break third_party_index != company_index

      end

    end

    #APPLY CONDITIONS!!!

    self.callManager()

  end

  def xmlState()

    #MODIFY THE STATE BASED ON THE REAL XML COMPROBANT!!!

    old_third_party_node_list = $third_persons_name_XML_node_list[self.third_party_index].element_children()
    old_company_node_list = $companies_XML_node_list[self.third_party_index].element_children()

    builder = Nokogiri::XML::Builder.new do

      Comprobante(){

        Tipo self.type
        Numero String(self.vaucher_id).rjust(10,"0")
        Fecha self.date
        Nota self.note
        Empresa{
          Codigo old_company_node_list[0].content
          DV 2
          Nombre old_company_node_list[1].content
        }
        Tercero{
          Codigo old_third_party_node_list[0].content
          Nombre old_third_party_node_list[1].content
        }
        Totales{
          Valor self.total_value
        }
        Contabilizacion{

          #Debitos{

            self.acounting_entries.debit_entries_array.each do |debit_entry|

              Asiento{

                Libro debit_entry.book
                Cuenta{
                  Codigo debit_entry.code
                  Nombre debit_entry.name
                }
                Tercero{
                  Codigo old_third_party_node_list[0].content
                  Nombre old_third_party_node_list[1].content
                }
                Debito debit_entry.total
                Credit 0

              }

            end

          #}

          #Creditos{

            self.acounting_entries.credit_entries_array.each do |credit_entry|

              Asiento{

                Libro credit_entry.book
                Cuenta{
                  Codigo credit_entry.code
                  Nombre credit_entry.name
                }
                Tercero{
                  Codigo old_third_party_node_list[0].content
                  Nombre old_third_party_node_list[1].content
                }
                Debito 0
                Credit credit_entry.total

              }

            end

          #}

        }

      }

    end

    #doc = builder.doc
    #root = doc.root

    #Create the third party node

    #third_party_name_node = Nokogiri::XML::Node.new("Nombre",doc)
    #third_party_name_node.content = old_third_party_node_list[1].content
    #third_party_code_node = Nokogiri::XML::Node.new("Codigo",doc)
    #third_party_code_node.content = Nokogiri::XML::Text.new(old_third_party_node_list[0].content, doc)
    #third_party_node = Nokogiri::XML::Node.new("Tercero",doc)
    #third_party_node.add_child(third_party_code_node)
    #third_party_node.add_child(third_party_name_node)

    #root.add_child(third_party_node)

    return builder.to_xml

  end

  #Called when this vaucher was finished create

  def callManager ()

    self.vaucher_manager.vaucherWasCreated()

  end

  def Utils.total

    return @@total

  end

end