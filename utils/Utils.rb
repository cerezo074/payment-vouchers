
require 'nokogiri'

class Utils

  ACCOUNT_XML_FILE_PATH = './resources/cuentas.xml'
  PARTIES_XML_FILE_PATH = './resources/parties.xml'

  def Utils.loadXMLFile(name_file)

    #Creating the document and delete the blank nodes

    doc = Nokogiri::XML(File.open(name_file)) do | config |
      config.options = Nokogiri::XML::ParseOptions::NOBLANKS
    end

    return doc

  end


end