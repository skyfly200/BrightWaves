import Vue from 'vue'
import store from './store.js'
import App from './App.vue'
import vuetify from './plugins/vuetify'
import axios from 'axios'

Vue.prototype.$http = axios

Vue.config.productionTip = false

new Vue({
  store,
  vuetify,
  render: (h) => h(App),
}).$mount('#app')
