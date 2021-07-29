import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './plugins/element'
// 引入全局样式
import global from './assets/css/global.css'


import './params'

import "element-ui/lib/theme-chalk/index.css";

import vant, { Dialog, Notify } from 'vant'
import 'vant/lib/index.css'
Vue.use(vant)
Vue.prototype.$dialog=Dialog
Vue.prototype.$Notify=Notify

Vue.use(global)
import axios from 'axios'
axios.defaults.headers.post["Content-Type"] =
  "application/x-www-form-urlencoded";
axios.defaults.baseURL='http://localhost:3000'
Vue.prototype.$http = axios;


Vue.config.productionTip = false

import vuex from 'vuex'
Vue.use(vuex);

new Vue({
  router,
  store,
  axios,
  render: h => h(App)
}).$mount('#app')
