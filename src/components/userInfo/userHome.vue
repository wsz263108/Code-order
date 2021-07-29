<template>
  <div>
    <keep-alive>
      <router-view></router-view>
    </keep-alive>
    <!-- 底部 -->
    <van-tabbar active-color="#ffdd4d" inactive-color="#000" v-model="active" fixed placeholder>
        <van-tabbar-item :to="'/UserHome/' + seat" name="home" icon="wap-home">首页</van-tabbar-item>
        <van-tabbar-item :to="'/UserHome/meal/' + seat" @click="toProductUrl" name="meal" icon="shopping-cart">干饭</van-tabbar-item>
        <van-tabbar-item :to="'/UserHome/order/'+seat" @click="toOrderUrl" name="search" icon="manager">我的订单</van-tabbar-item>
    </van-tabbar>
    
  </div>
</template>

<script>
export default {
 data(){
   return{
     seat:'',
     // 底部标签栏默认值
     active: 'home',
   }
 },
 created() {
     this.seat = this.$route.params.seat;
     this.getAllBacklogList()
 },
 methods: {
    toOrderUrl(){
      this.$store.commit('totalClear')
      this.$store.commit('totalPrice')
    },
    toProductUrl(){
      this.$store.commit('totalClear')
      // this.$store.commit('totalPrice')
    },
    // 进入后先查找当前座位有没有未完成订单
    async getAllBacklogList(){
      // 在页面打开时获取座位号信息，并传给seat
      let {data:res}=await this.$http.get('/isorder',{params:{seatnum:this.seat}})
      if(res.meta.status===200){
        res.data.forEach(async e => {
          let {data:res}=await this.$http.get('/foodname',{params:{id:e.id}})
          this.$store.commit('adduserOldList',res[0])
          return this.$dialog.alert({title:'温馨提示',message:'此座位还有未完成订单,可能是其他顾客离开一小会'})
        });
      }
    },
 },
}
</script>

<style lang='css' scoped>
</style>