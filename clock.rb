require 'clockwork'
require './owatta_giron.rb'

include Clockwork

owatta_giron = OwattaGiron.new

handler do |job|
  owatta_giron.fetch_and_notify
end

every(10.seconds, 'response.job')
