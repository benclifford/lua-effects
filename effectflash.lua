print("effectful LED flashes using co-routines as 1-shot continuations")

function initLed()
    gpio.mode(3, gpio.OUTPUT)
end

flashDelay = 200

function flasher()
  while 1 do
    gpio.write(3, gpio.HIGH)
    coroutine.yield(flashDelay)
    gpio.write(3, gpio.LOW)
    coroutine.yield(flashDelay)
  end
end


-- buggy one that will likely
-- crash the ESP8266
function driveCoroutineBad(proc)
  co = coroutine.create(proc)
  while 1 do
    -- TODO: check bool here and end if appropriate
    bool, time = coroutine.resume(co)
    tmr.delay(time * 1000)
  end 
end

function driveCoroutineGood(proc)
  co = coroutine.create(proc)

  delay = 1

  function resumeAfterDelay() 
    -- TODO: handle bool
    bool, delay = coroutine.resume(co)
    tmr.alarm(0, delay, 0, resumeAfterDelay)
  end

  resumeAfterDelay()

end

