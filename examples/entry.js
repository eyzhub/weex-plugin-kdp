import Vue from 'vue';

import weex from 'weex-vue-render';

import WeexKdp from '../src/index';

weex.init(Vue);

weex.install(WeexKdp)

const App = require('./index.vue');
App.el = '#root';
new Vue(App);
