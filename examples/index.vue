<template>
	<div class="container">
		<text style="margin-bottom: 20px;">weex kdp plugin example</text>
		<weexKdp ref="kdp" class="kdp" style="height:400" :playerConfig="playerConfig" partnerId="2031841" uiConfId="38785592"></weexKdp>
    <div class="controls">
      <button class="controlButton" @click="show">
        <text style="color:#fff">show</text>
      </button>
      <button class="controlButton" @click="play">
        <text style="color:#ffffff">&#9658;</text>
      </button>
      <button class="controlButton" @click="pause">
        <text style="color:#ffffff">&#9616;&#9616;</text>
      </button>
      <button class="controlButton" @click="seekBackward">
        <text style="color:#ffffff">&#10703;</text>
      </button>
      <button class="controlButton" @click="seekForward">
        <text style="color:#ffffff">&#10704;</text>
      </button>
      <button class="controlButton" @click="getTime">
        <text style="color:#ffffff">t</text>
      </button>
    </div>
    <div class="controls">
      <text>Time: </text><text class="time">{{parsedCurrentTime}} / {{parsedTotalTime}}</text>
      <text>State: </text><text class="time">{{state}}</text>
    </div>
    <div class="controls">
      <button class="controlButton" @click="changeMedia">
        <text style="color:#ffffff">Change Video</text>
      </button>
    </div>
	</div>
</template>

<script>

	const plugin = weex.requireModule('weexKdp');
	module.exports = {
		data: {
      currentTime: 0,
      duration: 0,
      str: '',
      playerConfig:
        {
          entryId: 'sintel',
          sources: [
            {
              contentUrl: 'https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8',
              mediaFormat: 'hls' // e.g. ".hls"
            }
          ]
        }

		},
    computed: {
      parsedCurrentTime: function () {
        const secs = parseInt(this.currentTime);
        return `${parseInt(secs/60)}:${secs%60}`
      },
      parsedTotalTime: function () {
        const secs = parseInt(this.duration);
        return `${parseInt(secs/60)}:${secs%60}`
      }
    },
		methods: {
			show: function() {
				plugin.show();
      },
      play() {
        this.$refs.kdp.sendNotification('doPlay');
        this.$refs.kdp.getProperty('duration', duration => {
          this.duration = duration;
        });
        this.$refs.kdp.kBind('time', (currentTime) => {
          this.currentTime = currentTime;
        });
        this.$refs.kdp.kBind('stateChange', (state) => {
          this.state = state;
          console.log('state: ', state);
        });
      },
      pause() {
        this.$refs.kdp.sendNotification('doPause');
      },
      seekForward() {
        this.$refs.kdp.sendNotification('doSeek', this.currentTime + 5);
      },
      seekBackward() {
        this.$refs.kdp.sendNotification('doSeek', this.currentTime - 5);
      },
      getTime() {
        this.$refs.kdp.getProperty('time', (currentTime) => {
          console.log(currentTime);
        });
      },
      changeMedia() {
        this.$refs.kdp.sendNotification('changeMediaEntry', {
          entryId: 'Kaltura Media',
          sources: [
            {
              contentUrl: 'https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8',
              mediaFormat: 'hls' // e.g. ".hls"
            }
          ]
        });
      }
		},
		created() {
			console.log(this.$refs.kdp);
		}
	}
</script>

<style>
	.container{
		flex: 1;
	}
  .controls {
    flex-direction: row;
    padding: 20px;
  }
  .controlButton {
    margin-right: 20px;
    padding:20px;
    background-color:#1ba1e2;
    color:#ffffff;
  }

  .time {
    font-family: monospace;
  }

</style>