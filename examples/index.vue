<template>
	<div class="container">
		<text style="margin-bottom: 20px;">weex kdp plugin example</text>
		<weexKdp ref="kdp" class="kdp" style="height:400"></weexKdp>
    <div class="controls">
      <button class="controlButton" @click="play">
        <text style="color:#fff">&#9658;</text>
      </button>
      <button class="controlButton" @click="pause">
        <text style="color:#fff">&#9616;&#9616;</text>
      </button>
      <button class="controlButton" @click="seekBackward">
        <text style="color:#fff">&#10703;</text>
      </button>
      <button class="controlButton" @click="seekForward">
        <text style="color:#fff">&#10704;</text>
      </button>
    </div>
    <div class="controls">
      <text>Time: </text><text class="time">{{parsedCurrentTime}} / {{parsedTotalTime}}</text>
    </div>
	</div>
</template>

<script>

	const plugin = weex.requireModule('weexKdp');
	module.exports = {
		data: {
      currentTime: 0,
      duration: 0,
      str: ''
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
			createAction: function() {
				plugin.show();
      },
      play() {
        this.$refs.kdp.play();
         this.$refs.kdp.getDuration((duration) => {
          this.duration = duration;
        });
        this.$refs.kdp.trackTime((currentTime) => {
          this.currentTime = currentTime;
        });
      },
      pause() {
        this.$refs.kdp.pause();
      },
      seekForward() {
        this.$refs.kdp.seek(this.currentTime + 5);
      },
      seekBackward() {
        this.$refs.kdp.seek(this.currentTime - 5);
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
    color:#fff;
  }

  .time {
    font-family: monospace;
  }

</style>