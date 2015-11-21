
require 'nokogiri'

class Utils

  @@random = Random.new()

  attr_reader :random

  ACCOUNT_XML_FILE_PATH = './resources/cuentas.xml'
  PARTIES_XML_FILE_PATH = './resources/parties.xml'

  def Utils.loadXMLFile(name_file)

    #Creating the document and delete the blank nodes

    doc = Nokogiri::XML(File.open(name_file)) do | config |
      config.options = Nokogiri::XML::ParseOptions::NOBLANKS
    end

    return doc

  end

  def Utils.getRandomNumberFromRange(range)

    if(range.kind_of? Range)

      return Utils::random.rand(range)

    end

    return nil

  end

  def Utils.random

    return @@random

  end

end