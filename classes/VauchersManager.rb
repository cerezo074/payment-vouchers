
require_relative 'utils/Utils'
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

    $accounts_XML_doc = Utils::loadXMLFile(Utils::ACCOUNT_XML_FILE_PATH)
    $debit_accounts_xml_node_set = $accounts_XML_doc.xpath("//Cuenta[ starts-with(Codigo,'1') or starts-with(Codigo,'3') or starts-with(Codigo,'4') ]")
    $credit_accounts_xml_node_set = $accounts_XML_doc.xpath("//Cuenta[ not(starts-with(Codigo,'1')) and not(starts-with(Codigo,'3')) and not(starts-with(Codigo,'4')) ]")
    $parties_XML_doc = Utils::loadXMLFile(Utils::PARTIES_XML_FILE_PATH)
    $companies_XML_node_list = $parties_XML_doc.xpath("//Tercero[Codigo >= '80000000']")
    $third_persons_name_XML_node_list = $parties_XML_doc.xpath("//Tercero[Codigo < '80000000']")

    self.amount_vauchers = amount_vauchers
    self.max_amount_register = max_amount_register
    self.vauchers_array = Array.new()
    self.vaucher_created = 0

  end

  def start_manager()

    self.start_date = Time.now

    puts("\nManager has started in: #{self.start_date}\n\n")

    self.amount_vauchers = (self.amount_vauchers > 0) ? self.amount_vauchers : 1
    iteration_range = Range.new(1,self.amount_vauchers,false)
    vauchers_ids_array = []
    threads_array = []

    iteration_range.each do |index|

      vaucher_id = 0

      loop do

        vaucher_id = 1 + Utils::getRandomNumberToMaxInclusive(9999999999)
        break !(vauchers_ids_array.include?(vaucher_id))

      end

      vauchers_ids_array.push(vaucher_id)

      #CONCURRENCY!!!

      thread = Thread.new{

        Thread.current[:thread_id] = vaucher_id
        vaucher = Vaucher.new(vaucher_id, self, self.max_amount_register)
        self.vauchers_array.push(vaucher)
        vaucher.start()

      }

      threads_array.push(thread)

      #CONCURRENCY!!!

    end

    puts("Manager waiting for all vauchers are created")
    threads_array.each{| thread | thread.join}

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
      #puts "Vaucher #{vaucher.vaucher_id} saved"

    end

  end

  def end_manager()

    self.saveVauchers()
    self.end_date = Time.now
    puts("\nManager has finished in: #{self.end_date}\nTime elapsed: #{TimeDifference.between(self.start_date, self.end_date).in_each_component}")

  end

  include MonitorMixin

  def vaucherWasCreated()

    self.vaucher_created += 1
    #puts("vachers created: #{self.vaucher_created}")

    if self.vaucher_created == self.amount_vauchers

      #puts("Thread calling saved:  #{Thread.current[:thread_id]}")
      self.end_manager()

    end

  end

end
