function qs(obj) {
  let par = new URLSearchParams();
  for (let i in obj) {
    par.append(i, obj[i]);
  }
  return par;
}
import Vue from 'vue'
Vue.prototype.$par=qs