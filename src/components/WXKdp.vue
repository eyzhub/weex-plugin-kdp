<template>
  <div>
    <iframe
      :id="videoElementId"
      :src="iframeSrc"
      allowfullscreen webkitallowfullscreen mozAllowFullScreen frameborder="0">
    </iframe>
  </div>
</template>

<script>
export default {
  props: {
    partnerId: {
      type: String,
      required: true
    },
    uiConfId: {
      type: String,
      required: true
    },
    playerConfig: {
      type: Object,
      required: false
    }
  },
  data () {
    return {
      videoElementId: null
    }
  },
  computed: {
    iframeSrc () {
      return `http://www.kaltura.com/p/${this.partnerId}/sp/${this.partnerId}00/embedIframeJs/uiconf_id/${this.uiConfId}/partnerId/${this.partnerId}?iframeembed=true&kaltura_player_1523614365&entry_id=0_yoramceq&flashvars[streamerType]=auto&flashvars[autoPlay]=true`
    }
  },
  methods: {
    show () {
      alert('SHOW DO PLUGINS!');
    }
  },
  mounted () {
    this.videoElementId = 've_' + this._uid

  }
}
</script>

<style>
h1 {
  background-color: #00FFFF;
}
</style>
