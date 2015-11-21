
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

  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :amount_vauchers
  attr_accessor :vauchers_array
  attr_accessor :vaucher_created

  def initialize(amount_vauchers)

    $accountsXMLFile = Utils::loadXMLFile(Utils::ACCOUNT_XML_FILE_PATH)
    $partiesXMLFile = Utils::loadXMLFile(Utils::ACCOUNT_XML_FILE_PATH)
    self.amount_vauchers = amount_vauchers
    self.vauchers_array = Array.new()
    self.vaucher_created = 0

  end

  def start_manager()

    self.start_date = Time.now

    puts("\nManager has started in: #{self.start_date}\n\n")

    self.amount_vauchers = (self.amount_vauchers > 0) ? self.amount_vauchers : 1
    range = Range.new(1,self.amount_vauchers,false)
    threads_array = []

    range.each do |vaucher_id|

      #CONCURRENCY!!!

      thread = Thread.new{

        Thread.current[:thread_id] = vaucher_id
        vaucher = Vaucher.new(vaucher_id, self)
        self.vauchers_array.push(vaucher)
        vaucher.start()

      }

      threads_array.push(thread)

      #CONCURRENCY

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
    puts("\n\nManager has finished in: #{self.end_date}\nTime elapsed: #{TimeDifference.between(self.start_date, self.end_date).in_each_component}")

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