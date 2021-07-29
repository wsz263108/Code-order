import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    userFoodList: [],
    userOldList: [],
    totalNum:0
  },
  mutations: {
    adduserFoodList(state, item) {
      state.userFoodList.push(item);
    },
    getUserOldList(state,obj){
      state.userOldList=obj
    },
    pushUserOldList(state){
      state.userFoodList.forEach(e => {
        state.userOldList.push(e);
      });
      state.userFoodList=[]
    },
    adduserOldList(state,item){
      state.userOldList.push(item)
    },
    totalPrice(state){
      state.userFoodList.forEach(e => {
        state.totalNum+=e.price
      });
    },
    totalClear(state){
      state.totalNum=0
    },
    spliceUserFoodList(state,i){
      state.userFoodList.splice(i,1)
    }
  },
  actions: {},
});
