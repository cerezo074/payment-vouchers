
require_relative 'classes/VauchersManager'

amount_vauchers = ARGV[0].length > 0 ? Integer(ARGV[0]) : 1000
max_amount_register = ARGV[1].length > 0 ? Integer(ARGV[1]) : 10
vuacher_manager = VauchersManager.new(amount_vauchers, max_amount_register)
vuacher_manager.start_manager()