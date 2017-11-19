local json = require 'vendor.json'

game = {
  audio = nil,
  current_choices = nil,
  manifest = nil,

  load_manifest = function(self, json_path)
    self.manifest = json.decode(love.filesystem.read(json_path))
  end,

  start = function(self)
    self:play_choice('root')
  end,

  play_audio = function(self, ogg_path)
    self.audio = love.audio.newSource(ogg_path, 'stream')
    self.audio:play()
  end,

  play_choice = function(self, identifier)
    self:play_audio(identifier .. '.ogg')
    self.current_choices = self.manifest[identifier]
  end,

  keypressed = function(self, scancode)
    if self.audio and self.audio:isStopped() then
      if self.current_choices and scancode:match("%w") then
        choice = self.current_choices[tonumber(scancode)]
        if choice then
          self:play_choice(choice)
        end
      end
    end
  end,
}

-------------------------------------------------------------------------------

function love.load(args)
  game:load_manifest('game.json')
  game:start()
  -- game:play_audio('fooey.ogg')
end

function love.keypressed(key, scancode, is_repeat)
  game:keypressed(scancode)
end

function love.update()
  if game.audio and game.audio:isStopped() then
    if #game.current_choices == 0 then
      love.event.quit()
    end
  end
end
