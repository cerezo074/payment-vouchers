
require 'nokogiri'
require_relative '../utils/Utils'

class Vaucher

  @vaucher_manager
  @vaucher_id
  @max_amount_register

  attr_accessor :vaucher_manager
  attr_accessor :vaucher_id
  attr_accessor :max_amount_register

  def initialize (vaucher_id,vaucher_manager, max_amount_register)

    self.vaucher_manager = vaucher_manager
    self.vaucher_id = vaucher_id
    self.max_amount_register = max_amount_register

  end

  def start()

    #APPLY CONDITIONS!!!

    #APPLY CONDITIONS!!!


    self.callManager()

  end

  def xmlState()

    #MODIFY THE STATE BASED ON THE REAL XML COMPROBANT!!!

    builder = Nokogiri::XML::Builder.new do |xml|

      xml.vaucher{

        xml.vaucher_id self.vaucher_id

      }

    end

    return builder.to_xml

  end

  #Called when this vaucher was finished creating
  def callManager ()

    self.vaucher_manager.vaucherWasCreated()

  end

end