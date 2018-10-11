require 'sun_times'

module Clk_def
    def every_sec(seconds) #main loop
      last_tick = Time.now
      loop do
        sleep 0.1
        if Time.now - last_tick >= seconds
          last_tick += seconds
          yield
        end 
      end
    end     

    def grid_time(time) #divide 8/4/2/1
      matrix = []    
      div = [4,2,1]
      grid_show = [time.divmod(8)]
      div.each_index {|i| grid_show << grid_show[i][1].divmod(div[i])}
      grid_show.each_index {|i| matrix << grid_show[i][0] } 
     return matrix
    end

    def sun  #resolve sun rise/set according coordinate 
      day = Date.new(Time.now.strftime("%Y").to_i, Time.now.strftime("%m").to_i, Time.now.strftime("%d").to_i)
      latitude = 50.075383 #Prague/Czech 
      longitude = 14.455366
      sun_times = SunTimes.new
      sun_rise = sun_times.rise(day, latitude, longitude) + (60*60*2) #UTC to local eg. +2h - Prague
      sun_set = sun_times.set(day, latitude, longitude)  + (60*60*2)
     return sun_rise, sun_set
    end

    def out_led(sel) #generate single time digit array eg. 14:21 => [1,4,2,1]
      time = Time.now
      case sel  
        when 'time'  
          pars_td = ["%H", "%M"]
          out_led = [time.strftime(pars_td[0])[0].to_i, time.strftime(pars_td[0])[1].to_i,
            time.strftime(pars_td[1])[0].to_i, time.strftime(pars_td[1])[1].to_i]
        when 'date'
          pars_td = ["%d","%m"] 
          out_led = [time.strftime(pars_td[0])[0].to_i, time.strftime(pars_td[0])[1].to_i,
            time.strftime(pars_td[1])[0].to_i, time.strftime(pars_td[1])[1].to_i]
        when 'sun_rise'
          pars_td = ["%H", "%M"]
          out_led = [sun[0].strftime(pars_td[0])[0].to_i, sun[0].strftime(pars_td[0])[1].to_i,
            sun[0].strftime(pars_td[1])[0].to_i, sun[0].strftime(pars_td[1])[1].to_i]
        when 'sun_set'
          pars_td = ["%H", "%M"]
          out_led = [sun[1].strftime(pars_td[0])[0].to_i, sun[1].strftime(pars_td[0])[1].to_i,
            sun[1].strftime(pars_td[1])[0].to_i, sun[1].strftime(pars_td[1])[1].to_i ]            
      end
     return out_led     
    end

    def rgb_color(n) #set led color for 8x8 segment
      case n
      when 0 #time
        c1 = 80
        c2 = 0 
        c3 = 0
      when 1 #date
        c1 = 0
        c2 = 0
        c3 = 80
      when 2 #sun_rise
        c1 = 80
        c2 = 80
        c3 = 80
      when 3 #sun_set
        c1 = 0
        c2 = 80
        c3 = 0
      end
     return c1, c2, c3
    end

    def brightness(time_now) #set brightness@time
      case time_now
        when 6..21 
          br = 128
        else
          br = 40
      end
     return br
    end

 module_function :every_sec
 module_function :grid_time
 module_function :sun
 module_function :out_led
 module_function :rgb_color
 module_function :brightness
end
