class StartController < ApplicationController
  before_start :start_game
  
  def start_game    
    id = @@counter += 1
    @@games[id] = Dominion::Game.new :id=>id
    @@games[id].start
    
    uuid = UUID.new.generate
    hash = {'uuid'=>uuid, 'name'=>'You'} 
    @@games[id].notify hash
    
    # Initialize queues
    @game_queue   = MQ.queue "game-#{id}"
    @player_queue = MQ.queue "player-#{uuid}"
    
    halt 302, {'Location'=>"games/#{id}/players/#{uuid}"}
  end
  
end