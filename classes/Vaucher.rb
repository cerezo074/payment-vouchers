
require_relative 'utils/Utils'
require 'nokogiri'

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

  attr_accessor :vaucher_manager
  attr_accessor :max_amount_register
  attr_accessor :type
  attr_accessor :vaucher_id
  attr_accessor :date
  attr_accessor :note
  attr_accessor :total_value
  attr_accessor :company_index
  attr_accessor :third_party_index

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
    self.company_index = Utils::getRandomNumberToMaxInclusive($companies_XML_node_list.length)
    self.third_party_index = Utils::getRandomNumberToMaxInclusive($third_persons_name_XML_node_list.length)

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

      vaucher(){

        Tipo self.type
        Numero self.vaucher_id
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

      }

    end

    doc = builder.doc
    root = doc.root

    #Create the third party node

    third_party_name_node = Nokogiri::XML::Node.new("Nombre",doc)
    third_party_name_node.content = old_third_party_node_list[1].content
    third_party_code_node = Nokogiri::XML::Node.new("Codigo",doc)
    third_party_code_node.content = Nokogiri::XML::Text.new(old_third_party_node_list[0].content, doc)
    third_party_node = Nokogiri::XML::Node.new("Tercero",doc)
    third_party_node.add_child(third_party_code_node)
    third_party_node.add_child(third_party_name_node)

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