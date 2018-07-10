// { "framework": "Vue" } 

/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(1)
)

/* script */
__vue_exports__ = __webpack_require__(2)

/* template */
var __vue_template__ = __webpack_require__(3)
__vue_options__ = __vue_exports__ = __vue_exports__ || {}
if (
  typeof __vue_exports__.default === "object" ||
  typeof __vue_exports__.default === "function"
) {
if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
__vue_options__ = __vue_exports__ = __vue_exports__.default
}
if (typeof __vue_options__ === "function") {
  __vue_options__ = __vue_options__.options
}
__vue_options__.__file = "/Users/tralves/code/eyzhub/clone/weex-kdp/examples/index.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-fb6b22b8"
__vue_options__.style = __vue_options__.style || {}
__vue_styles__.forEach(function (module) {
  for (var name in module) {
    __vue_options__.style[name] = module[name]
  }
})
if (typeof __register_static_styles__ === "function") {
  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
}

module.exports = __vue_exports__
module.exports.el = 'true'
new Vue(module.exports)


/***/ }),
/* 1 */
/***/ (function(module, exports) {

module.exports = {
  "container": {
    "flex": 1
  },
  "controls": {
    "flexDirection": "row",
    "paddingTop": "20",
    "paddingRight": "20",
    "paddingBottom": "20",
    "paddingLeft": "20"
  },
  "controlButton": {
    "marginRight": "20",
    "paddingTop": "20",
    "paddingRight": "20",
    "paddingBottom": "20",
    "paddingLeft": "20",
    "backgroundColor": "#1ba1e2",
    "color": "#ffffff"
  },
  "time": {
    "fontFamily": "monospace"
  }
}

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


var plugin = weex.requireModule('weexKdp');
module.exports = {
  data: {
    currentTime: 0,
    duration: 0,
    str: '',
    playerConfig: {
      entryId: 'sintel',
      sources: [{
        id: "1_w9zx2eti",
        contentUrl: 'https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8',
        mediaFormat: 'hls' // e.g. ".hls"
      }]
    }

  },
  computed: {
    parsedCurrentTime: function parsedCurrentTime() {
      var secs = parseInt(this.currentTime);
      return parseInt(secs / 60) + ':' + secs % 60;
    },
    parsedTotalTime: function parsedTotalTime() {
      var secs = parseInt(this.duration);
      return parseInt(secs / 60) + ':' + secs % 60;
    }
  },
  methods: {
    show: function show() {
      plugin.show();
    },
    play: function play() {
      var _this = this;

      this.$refs.kdp.sendNotification('doPlay');
      this.$refs.kdp.getProperty('duration', function (duration) {
        _this.duration = duration;
      });
      this.$refs.kdp.kBind('timeChange', function (currentTime) {
        _this.currentTime = currentTime;
      });
      this.$refs.kdp.kBind('stateChange', function (state) {
        console.log('state: ', state);
        _this.state = state;
      });
    },
    pause: function pause() {
      this.$refs.kdp.sendNotification('doPause');
    },
    seekForward: function seekForward() {
      this.$refs.kdp.sendNotification('doSeek', this.currentTime + 5);
    },
    seekBackward: function seekBackward() {
      this.$refs.kdp.sendNotification('doSeek', this.currentTime - 5);
    },
    getTime: function getTime() {
      this.$refs.kdp.getProperty('time', function (currentTime) {
        console.log(currentTime);
      });
    },
    changeMedia: function changeMedia() {
      this.playerConfig = {
        entryId: 'Kaltura Media',
        sources: [{
          id: "1_vl96wf1o",
          contentUrl: 'https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8',
          mediaFormat: 'hls' // e.g. ".hls"
        }]
      };
      // this.$refs.kdp.sendNotification('changeMediaEntry', {
      //   entryId: 'Kaltura Media',
      //   sources: [
      //     {
      //       id: "1_vl96wf1o",
      //       contentUrl: 'https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8',
      //       mediaFormat: 'hls' // e.g. ".hls"
      //     }
      //   ]
      // });
    }
  },
  created: function created() {
    console.log(this.$refs.kdp);
  }
};

/***/ }),
/* 3 */
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: ["container"]
  }, [_c('text', {
    staticStyle: {
      marginBottom: "20px"
    }
  }, [_vm._v("weex kdp plugin example")]), _c('weexKdp', {
    ref: "kdp",
    staticClass: ["kdp"],
    staticStyle: {
      height: "400"
    },
    attrs: {
      "playerConfig": _vm.playerConfig,
      "partnerId": "2031841",
      "uiConfId": "38785592"
    }
  }), _c('div', {
    staticClass: ["controls"]
  }, [_c('button', {
    staticClass: ["controlButton"],
    on: {
      "click": _vm.show
    }
  }, [_c('text', {
    staticStyle: {
      color: "#fff"
    }
  }, [_vm._v("show")])]), _c('button', {
    staticClass: ["controlButton"],
    on: {
      "click": _vm.play
    }
  }, [_c('text', {
    staticStyle: {
      color: "#ffffff"
    }
  }, [_vm._v("►")])]), _c('button', {
    staticClass: ["controlButton"],
    on: {
      "click": _vm.pause
    }
  }, [_c('text', {
    staticStyle: {
      color: "#ffffff"
    }
  }, [_vm._v("▐▐")])]), _c('button', {
    staticClass: ["controlButton"],
    on: {
      "click": _vm.seekBackward
    }
  }, [_c('text', {
    staticStyle: {
      color: "#ffffff"
    }
  }, [_vm._v("⧏")])]), _c('button', {
    staticClass: ["controlButton"],
    on: {
      "click": _vm.seekForward
    }
  }, [_c('text', {
    staticStyle: {
      color: "#ffffff"
    }
  }, [_vm._v("⧐")])]), _c('button', {
    staticClass: ["controlButton"],
    on: {
      "click": _vm.getTime
    }
  }, [_c('text', {
    staticStyle: {
      color: "#ffffff"
    }
  }, [_vm._v("t")])])], 1), _c('div', {
    staticClass: ["controls"]
  }, [_c('text', [_vm._v("Time: ")]), _c('text', {
    staticClass: ["time"]
  }, [_vm._v(_vm._s(_vm.parsedCurrentTime) + " / " + _vm._s(_vm.parsedTotalTime))]), _c('text', [_vm._v("State: ")]), _c('text', {
    staticClass: ["time"]
  }, [_vm._v(_vm._s(_vm.state))])]), _c('div', {
    staticClass: ["controls"]
  }, [_c('button', {
    staticClass: ["controlButton"],
    on: {
      "click": _vm.changeMedia
    }
  }, [_c('text', {
    staticStyle: {
      color: "#ffffff"
    }
  }, [_vm._v("Change Video")])])], 1)], 1)
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ })
/******/ ]);