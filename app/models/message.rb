class Message < ApplicationRecord

  after_commit :sync, on: :create

  def sync
    BasicBotService.new(self).sync_message
  end

end
