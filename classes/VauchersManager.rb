
require_relative '../utils/Utils'
require_relative 'Vaucher'
require 'time_difference'

class VauchersManager

  VAUCHERS_PATH_DIR = './vauchers'

  @start_date
  @end_date
  @amount_vauchers
  @vauchers_array
  @vaucher_created
  @max_amount_register

  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :amount_vauchers
  attr_accessor :vauchers_array
  attr_accessor :vaucher_created
  attr_accessor :max_amount_register

  def initialize(amount_vauchers, max_amount_register)

    $accountsXMLFile = Utils::loadXMLFile(Utils::ACCOUNT_XML_FILE_PATH)
    $partiesXMLFile = Utils::loadXMLFile(Utils::ACCOUNT_XML_FILE_PATH)

    self.amount_vauchers = amount_vauchers
    self.max_amount_register = max_amount_register
    self.vauchers_array = Array.new()
    self.vaucher_created = 0

  end

  def start_manager()

    self.start_date = Time.now
    self.amount_vauchers = (self.amount_vauchers > 0) ? self.amount_vauchers : 1
    range = Range.new(1,self.amount_vauchers,false)

    range.each do |voucher_id|

      #CONCURRENCY!!!

      puts "Creating the voucher: #{voucher_id}"
      vaucher = Vaucher.new(voucher_id, self)
      self.vauchers_array.push(vaucher)
      vaucher.start()

      #CONCURRENCY

    end

    end_manager()

  end

  def vaucherWasCreated()

    if self.vaucher_created != self.amount_vauchers

      self.vaucher_created += 1

    else

      self.end_manager()

    end

  end

  def saveVauchers()

    #Delete the vauchers folder if exist and make it after, late write one vaucher at time into the folder

    if Dir.exist?(VAUCHERS_PATH_DIR)
      FileUtils.remove_dir(VAUCHERS_PATH_DIR)
    end

    FileUtils.mkdir(VAUCHERS_PATH_DIR)

    for vaucher in self.vauchers_array

      xml_vaucher = vaucher.xmlState()
      File.write(VAUCHERS_PATH_DIR+"/#{vaucher.vaucher_id}.xml", xml_vaucher)
      puts "Vaucher #{vaucher.vaucher_id} saved"

    end

  end

  def end_manager()

    self.saveVauchers()

    self.end_date = Time.now
    puts TimeDifference.between(self.start_date, self.end_date).in_each_component

  end

end
