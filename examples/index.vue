<template>
	<div class="container">
		<text style="margin-bottom: 20px;">weex plugin example</text>
		<text>a{{ref}}a</text>
		<button @click="createAction" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;">
			<text style="color:#fff">hello world2</text>
		</button>

		<weexKdp ref="kdp" class="kdp" style="height:400"></weexKdp>
    <button @click="play" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;">
			<text style="color:#fff">play</text>
		</button>
		<button @click="pause" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;">
			<text style="color:#fff">pause</text>
		</button>
	</div>
</template>

<style>
	.container{
		flex: 1;
	}
</style>

<script>

	const plugin = weex.requireModule('weexKdp');
	module.exports = {
		data: {
			value: '',
			index: 0,
			txtChange: '',
			ref: '<no ref>'
		},
		methods: {
			createAction: function() {
				plugin.show();
				console.log(this.$refs.kdp);
				this.ref = this.$refs.kdp.ref;
      },
      play() {
        this.$refs.kdp.play();
      },
      pause() {
        this.$refs.kdp.pause();
      }

		},
		created() {
			console.log(this.$refs.kdp);
		}
	}
</script>