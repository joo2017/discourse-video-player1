# name: discourse-video-player
# about: 支持播放 m3u8 格式的视频
# version: 0.1
# authors: 你的名字
# url: 插件的网址（可以是你的 GitHub 页面）

enabled_site_setting :video_player_enabled

register_asset 'stylesheets/videojs.min.css'
register_asset 'javascripts/discourse/initializers/initialize-video-player.js.es6'

after_initialize do
  module ::DiscourseVideoPlayer
    class Engine < ::Rails::Engine
      engine_name "discourse_video_player"
      isolate_namespace DiscourseVideoPlayer
    end
  end

  require_dependency "onebox/engine/video_onebox"

  class ::Onebox::Engine::VideoOnebox
    def to_html
      if @url.match?(/\.m3u8/)
        <<-HTML
          <div class='onebox video-onebox'>
            <video id='video-#{SecureRandom.hex(6)}' class='video-js' controls preload='auto' width='100%' height='100%'>
              <source src='#{@url}' type='application/x-mpegURL'>
              <p class='vjs-no-js'>
                要查看此视频，请启用 JavaScript，并考虑升级到支持 HTML5 视频的浏览器。
              </p>
            </video>
          </div>
        HTML
      else
        super
      end
    end
  end
end
