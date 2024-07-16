import { withPluginApi } from "discourse/lib/plugin-api";
import loadScript from "discourse/lib/load-script";

function initializeVideoPlayer(api) {
  api.onPageChange(() => {
    const videos = document.querySelectorAll("video.video-js");
    if (videos.length > 0) {
      loadScript("https://vjs.zencdn.net/7.20.3/video.min.js").then(() => {
        videos.forEach((video) => {
          if (!videojs.getPlayer(video)) {
            videojs(video, {
              fluid: true,
              controls: true,
              preload: 'auto'
            }, function() {
              console.log('Video player is ready');
              this.on('error', function(e) {
                console.error('Video player error:', e);
              });
            });
          }
        });
      }).catch(error => {
        console.error("Failed to load Video.js:", error);
      });
    }
  });
}

export default {
  name: "initialize-video-player",
  initialize(container) {
    const siteSettings = container.lookup('site-settings:main');
    if (siteSettings.video_player_enabled) {
      withPluginApi("0.8.31", initializeVideoPlayer);
    }
  },
};
