use_bpm 90
keys = [:G3, :A3, :G3, :E3, :G3, :A3, :G3, :E3,
        :D4, :D4, :B3, :C4, :C4, :G3, :A3, :A3,
        :C4, :B3, :A3, :G3, :A3, :G3, :E3, :A3,
        :A3, :C4, :B3, :A3, :G3, :A3, :G3, :E3].ring
kickCount = 0
harmonyCount = 0

with_fx :reverb, room: 0.9, mix: 0.4 do
  with_fx :hpf, cutoff: 80 do
    with_fx :echo, phase: 0.125, decay: 2 do
      live_loop :osc2 do
        osc=sync "/snowflake"
        puts osc
        
        use_synth :mod_beep
        if (one_in(4))
          use_transpose 12
        elsif
          use_transpose 0
        end
        use_synth_defaults phase: 0.25, mod_range: 12, amp: 1.2, attack: 0, release: 0.5, cutoff: 80
        play keys.choose, pan: rrand(-0.8, 0.8)
        sample :loop_amen, beat_stretch: 2, slice: pick(16), amp: 0.8, cutoff: 90, pan: rrand(-0.4, 0.4)
        sample :bd_haus, cutoff: 70
      end
    end
  end
end

live_loop :oscKick do
  osc=sync "/snowflake"
  puts osc
  
  if (kickCount % 4 == 0)
    sample :bd_haus, cutoff: 70
  end
  kickCount += 1
end

harmonyNotes1 = [:C4, :G3, :D3].ring
harmonyNotes2 = [:G3, :E4, :A3].ring

with_fx :reverb, room: 0.8, mix: 0.4 do
  with_fx :echo, phase: 1, decay: 1.5, mix: 0.3 do
    with_fx :panslicer, phase: 0.2, wave: 2, mix: 0.5 do
      live_loop :harmonies do
        osc=sync "/snowflake"
        puts osc
        
        use_synth :blade
        use_synth_defaults cutoff: 75, amp: 0.7, attack: 2, release: 3.5
        
        if (harmonyCount % 8 == 0)
          note = harmonyNotes1.tick
          play note, pan: -0.4
          with_synth :subpulse do
            play note, cutoff: 75, amp: 0.6, attack: 2, release: 3.5
          end
          play harmonyNotes2.look, pan: 0.4
        end
        harmonyCount += 1
      end
      
      live_loop :click do
        osc=sync "/click"
        puts osc
        
        use_synth :pretty_bell
        use_synth_defaults cutoff: 110, amp: 0.5, attack: 0.1, release: 0.4
        
        if (one_in(3))
          use_transpose 12
        elsif
          use_transpose 24
        end
        
        play keys.choose
      end
    end
  end
end