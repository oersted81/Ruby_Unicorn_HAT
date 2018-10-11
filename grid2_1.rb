require 'ws2812'
require 'benchmark'
require_relative 'clk_m.rb'
require_relative 'splash_m.rb'
include Clk_def
include Splash

#HAT/time variables
unicorn =  Array.new(4, Array.new(4,0))
index = [[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15]].flatten
strip_map = [[7,6,5,4,8,9,10,11,23,22,21,20,24,25,26,27],[3,2,1,0,12,13,14,15,19,18,17,16,28,29,30,31],
             [39,38,37,36,40,41,42,43,55,54,53,52,56,57,58,59],[35,34,33,32,44,45,46,47,51,50,49,48,60,61,62,63]]
time_spec = ['time', 'date', 'sun_rise', 'sun_set']
converted_time = []

#Unicor_HAT ini
n = 64 # num leds
ws = Ws2812::Basic.new(n, 18) # +n+ leds at pin 18, using defaults
ws.open
#splash screen
Splash.light_show.each_index {|i|
  ws[light_show[i]] = Ws2812::Color.new(80,80,80)
  sleep 0.01
  ws.show}

#main loop
begin
Clk_def.every_sec(1) do
  ws.brightness = Clk_def.brightness(Time.now.strftime("%H").to_i)
  time_spec.each_index { |n|
    Clk_def.out_led(time_spec[n]).each_with_index { |j,i| unicorn[i] = Clk_def.grid_time(j)}
      index.each_with_index {|j,i| converted_time[j] = unicorn.flatten[i] }
        converted_time.each_with_index { |j,i|
          ws[strip_map[n][i]] = Ws2812::Color.new(Clk_def.rgb_color(n)[0],Clk_def.rgb_color(n)[1],Clk_def.rgb_color(n)[2]) if converted_time[i] == 1
          ws[strip_map[n][i]] = Ws2812::Color.new(0,0,0) if converted_time[i] == 0}
  }
  ws.show
end
rescue Interrupt
    ws[0..63] = Ws2812::Color.new(0,0,0)
    ws.show
end