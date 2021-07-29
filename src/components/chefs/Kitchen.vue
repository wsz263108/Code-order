<template>
  <div>
    <!-- 头部 -->
    <van-nav-bar
      title="后厨订单"
      left-arrow
      :right-text="'厨师：'+user"
      @click-left="onClickLeft"
      fixed
    ></van-nav-bar>
    <!-- 所有订单内容 -->
    <div class="die">
    <div :style="{ height: windowHeight - 46 + 'px' }" class="main">
      <!-- 每个订单所展示的内容 -->
      <van-card
        class="vanc"
        num="1"
        :price="item.price.toFixed(1)"
        :title="item.footname"
        :thumb="item.imgurl"
        v-for="(item, i) of order"
        :key="i"
      >
        <!-- 接单状态标签 -->
        <template #tag>
          <van-tag plain type="danger">{{item.state===0?'未接单':'已接单'}}</van-tag>
        </template>
        <!-- 餐桌号标签 -->
        <template #tags>
          <van-tag plain type="danger" round>餐桌号:{{item.seatnum}}</van-tag>
        </template>
        <!-- taste标签 -->
        <template #tags>
          <van-tag class="mytag" v-for="tag in item.taste.split(';')" :key="tag" plain type="danger">{{tag}}</van-tag>
        </template>
        <!-- 接单和完成订单按钮 -->
        <template #footer>
          <span style="float: left; line-height: 24px"
            >接单人：{{ item.chefname===null?'无':item.chefname }}</span
          >
          <van-button class="mybtn" size="mini"  @click="accept(item)" :disabled="item.state!==0"
            >接单</van-button
          >
          <van-button class="mybtn" @click="finishOrder(item)" size="mini">完成订单</van-button>
        </template>
      </van-card>
    </div>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      // 获取的订单
      order:[],
      // 是否禁用按钮
      isdis: false,
      // 接单人
      people: "无",
      // 用户名
      user: "",
      windowWidth: document.documentElement.clientWidth, //实时屏幕宽度
      windowHeight: document.documentElement.clientHeight, //实时屏幕高度
      socket:io('ws://localhost:3030/')
    };
  },
  created() {
    this.user=this.$route.query.user
    this.getOrderList()
    // 监听用户端下单
    this.socket.on('chef',()=>{
      this.getOrderList()
    })
    this.socket.on('orderOrderAccomplish',()=>{
      this.getOrderList()
    })
  },
  methods: {
    // 左上角返回
    onClickLeft() {
      this.$router.push('/')
    },
    // 更改订单状态
    async accept(item) {
      item.state+=1
      item.chefname=this.user
      let obj=this.$par({id:item.id,state:item.state,chefname:this.user,foodname:item.footname})
      let{data:res}=await this.$http.put('/chef/changeState',obj)
      this.getOrderList()
      this.socket.emit('orderAccomplish')
      if(item.state===1) return this.$Toast.success('接单成功');
    },
    // 获取所有订单
    async getOrderList(){
      let {data:res}=await this.$http.get('/chef/allChef')
      this.order=res.data
    },
    // 完成订单
    finishOrder(item){
      if(item.state===0){
        return this.$Toast('请先接单')
      }
      if(item.chefname!==this.user){
        return this.$Toast.fail('不是同一个厨师')
      }
      if(item.state===1){
        this.$Toast.success('已完成订单' )
        this.accept(item)
        this.getOrderList()
      }
    },
    // 用户下单接收消息
    
  },
  mounted(){
  },
  watch: {
    // 实时监听屏幕宽高
    windowHeight(val) {
      let that = this;
    },
    windowWidth(val) {
      let that = this;
    },
  },
};
</script>
<style scoped>
.die{
  background-color: #f5f5f5;
}
.van-nav-bar {
  background-color: #ffdd4d;
}
.main {
  overflow: auto;
  margin-top:46px ;
  font-size: 18px;
}
.vanc{
    background-color: #fff;
    font-size: 16px;
}
.mytag{
  margin-top: 10px;
  margin-right: 5px;
}
.mybtn{
  font-size: 15px;
  background-color: #ffdd4d;
}
</style>
