require 'gosu'

class MetroidvaniaGame < Gosu::Window
  def initialize
    super(640, 480)
    self.caption = "Metroidvania Game"
    @player = { x: 40, y: 400, vx: 0, vy: 0, has_key: false }
    @platforms = [ [0,460,640,20], [60,400,120,14], [220,340,120,14], [400,260,180,14], [520,180,80,14] ]
    @key = [550,140]
    @door = [600,120]
    @font = Gosu::Font.new(22)
  end

  def update
    @player[:vx] = 0
    @player[:vx] -= 4 if Gosu.button_down? Gosu::KB_LEFT
    @player[:vx] += 4 if Gosu.button_down? Gosu::KB_RIGHT
    @player[:vy] += 1
    @player[:x] += @player[:vx]
    @player[:y] += @player[:vy]
    @platforms.each do |px,py,w,h|
      if @player[:x]<px+w&&@player[:x]+32>px&&@player[:y]+32>py&&@player[:y]<py+h
        @player[:y]=py-32; @player[:vy]=0
      end
    end
    if Gosu.button_down?(Gosu::KB_SPACE) && @player[:vy]==0
      @player[:vy] = -15
    end
    if !@player[:has_key] && (@player[:x]-@key[0]).abs<32 && (@player[:y]-@key[1]).abs<32
      @player[:has_key] = true
    end
    if @player[:has_key] && (@player[:x]-@door[0]).abs<32 && (@player[:y]-@door[1]).abs<32
      @player[:x]=40;@player[:y]=400;@player[:has_key]=false
    end
    @player[:y]=400 if @player[:y]>460
  end

  def draw
    Gosu.draw_rect(@player[:x], @player[:y], 32, 32, Gosu::Color::YELLOW)
    @platforms.each { |px,py,w,h| Gosu.draw_rect(px,py,w,h,Gosu::Color::GREEN) }
    Gosu.draw_rect(@key[0],@key[1],20,20, Gosu::Color::CYAN) unless @player[:has_key]
    Gosu.draw_rect(@door[0],@door[1],30,40, Gosu::Color::RED)
    @font.draw_text("Metroidvania: Get the key and reach the door!",10,10,0)
    @font.draw_text("Has key: #{@player[:has_key]}",10,40,0)
  end
end

MetroidvaniaGame.new.show