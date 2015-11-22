
require 'nokogiri'
require 'nokogiri-pretty'

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

  def Utils.getRandomNumberToMaxInclusive(max_number)

    return Utils::random.rand(max_number+1)

  end

  def Utils.getRandomNumberFromRange(range)

    if(range.kind_of? Range)

      return Utils::random.rand(range)

    end

    return nil

  end

  def Utils.getRandomBoolean()

    return (Utils::random(0..1) == 1)

  end

  def Utils.getRandomDate (from = Time.at(0), to = Time.now)

    return Time.at(from.to_i + rand * ((to.to_i - from.to_i) + 1))

  end

  def Utils.getRandomDateFormated(format = "%Y-%m-%d")

    return Utils::getRandomDate().strftime(format)

  end

  def Utils.random

    return @@random

  end

end