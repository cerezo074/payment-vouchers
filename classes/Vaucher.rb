
require 'nokogiri'

class Vaucher

  @vaucher_manager
  @vaucher_id

  attr_accessor :vaucher_manager
  attr_accessor :vaucher_id

  def initialize (vaucher_id,vaucher_manager)

    self.vaucher_manager = vaucher_manager
    self.vaucher_id = vaucher_id

  end

  def start()

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