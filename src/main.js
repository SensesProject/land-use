import Vue from 'vue'
import App from './App.vue'
import store from './store'
import { VueMasonryPlugin } from 'vue-masonry'

Vue.config.productionTip = false
Vue.use(VueMasonryPlugin)

new Vue({
  store,
  render: h => h(App)
}).$mount('#app')
