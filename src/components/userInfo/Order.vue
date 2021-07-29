<template>
  <div>
    <!-- 头部 -->
    <div class="head">我的订单</div>
    <!-- 主体内容 -->
    <div class="main" :style="{ height: windowHeight - 91 + 'px' }">
      <van-empty
        v-if="this.$store.state.userFoodList.length===0&&this.$store.state.userOldList.length===0"
        description="暂没有订单"
        style="padding: 190px 0"
      />
      <div v-else>
        <!-- 座位号  人数  下单时间 -->
        <div class="seat">
          <span>座位号：{{ seat }}</span>
          <span>人数：</span>
          <span>下单时间：</span>
        </div>
        <!-- 付款区 -->
        <!-- <div class="pay">
          <h1>应付：{{this.$store.state.totalNum}}</h1>
        </div> -->
        <van-skeleton title title-width="100%" />
        <!-- 菜单菜品显示区 -->
        <div>
          <div style="padding: 15px 20px">
            <span style="color: gray">已点菜品</span>
            <a style="float: right; color: blue" @click="back">继续点菜 ></a>
          </div>
          <div style="overflow:auto" :style="{height:(windowHeight-255)+'px'}">
            <div>
              <van-card
              :price="i.price"
              :title="i.foodname"
              :thumb="i.imgurl"
              tag="未付款"
              centered
              v-for="(i,index) in this.$store.state.userFoodList"
              :key="index"
            >
              <template #tags>
                <van-tag v-for="tag in i.taste.split(';')" :key="tag" plain type="danger">{{tag}}</van-tag>
              </template>
            </van-card>
            </div>
              <van-card
              v-show="userOldList.length>0"
              :price="item.price"
              :title="item.footname"
              :thumb="item.imgurl"
              tag="已付款"
              centered
              v-for="(item,i) in this.$store.state.userOldList" :key="i"
            >
            <template #tags>
              <van-tag v-for="tag in item.content?item.content.split(';'):item.taste.split(';')" :key="tag" plain type="danger">{{tag}}</van-tag>
            </template>
            </van-card>
          </div>
          <!-- <van-button @click="payment" size="large" color="red" style="line-height:40px;height:40px;margin:0 20px" :style="{width:(windowWidth-40)+'px'}">在线买单</van-button> -->
          <!-- <van-icon @click="payment" color='#01FB01' name="passed" size='50px' class="footIcon"/> -->
          <div class="pay">
            <p>￥<span>{{this.$store.state.totalNum}}</span></p>
            <div class="paybtn">
              <button class="paybtnn" @click="payment">支付</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      // 座位号
      seat: 0,
      // 订单数量（为零显示无订单页面）
      order: 1,
      // 底部标签栏默认值
      active: 1,
      windowWidth: document.documentElement.clientWidth, //实时屏幕宽度
      windowHeight: document.documentElement.clientHeight, //实时屏幕高度
      // 获取用户所下的订单
      userFoodList:[],
      // socket 
      socket:io('ws://localhost:3030/'),
      // 获取已经付过款的订单
      userOldList:[],
      // num:this.$store.state.totalNum
    };
  },
  created() {
    this.seat = this.$route.params.seat;
    this.aa()
    // this.socket.on('userOrderAccomplish',()=>{
    //   this.getUserOrderList() b
  },
  methods: {
    // async getUserOrderList(){
    //   let {data:res}=await this.$http.get('/isorder',{params:{seatnum:this.seat}})
    //   if(res.meta.status===200){
    //     let arr=[]
    //     res.data.forEach(async e => {
    //       let {data:res}=await this.$http.get('/foodname',{params:{foodname:e.footname}})
    //       arr.push(res[0])
    //       // 
    //     });
    //     this.$store.commit('getUserOldList',arr)
    //   }
    //   this.aa()
    // },

    // btn(){
    //   this.axios.get('/food').then(result=>{
    //   })
    // }
    back(){
      // history.back()
      this.$router.push('/UserHome/' + this.seat)
    },
    addDate() {
      let nowDate = new Date();
      let date = {
          year: nowDate.getFullYear(),
          month: nowDate.getMonth() + 1,
          date: nowDate.getDate(),
      }
      if(date.date<10){
        date.date='0'+date.date
      }
      if(date.month<10){
        date.month='0'+date.month
      }
      return date.year + '-' +  date.month + '-'  + date.date;
    },
    async bb(){
      let {data:res}=await this.$http.get('/isorder',{params:{seatnum:this.seat}})
      this.$store.state.userOldList=res.data
    },
    aa(){
        this.userFoodList=this.$store.state.userFoodList
        this.userOldList=this.$store.state.userOldList
    },
    payment(){
      this.$dialog.confirm({
        title:'支付',
        message:`请支付${this.$store.state.totalNum}元`
      }).then(()=>{
        let obj=[]
        this.userFoodList.forEach(e => {
          let time=this.addDate()
            obj.push({seatnum:this.seat,footname:e.foodname,taste:e.taste,time,price:e.price,state:0,imgurl:e.imgurl})
        });
        this.socket.emit('userpayment',JSON.stringify(obj))
        this.$store.commit('pushUserOldList')
        this.aa()
        this.bb()
        this.$store.commit('totalClear')
        this.$Notify({ type: 'success', message: '支付成功' })
      }).catch((err)=>{
        console.log(err);
        return this.$Notify({ type: 'danger', message: '取消支付' })
      })
    },
  },
  watch: {
    //实时监听屏幕宽高
    windowHeight(val) {
      let that = this;
      console.log("实时屏幕高度：", val, that.windowHeight);
    },
    windowWidth(val) {
      let that = this;
      console.log("实时屏幕宽度：", val, that.windowHeight);
    },
  },
  mounted() {
    // 在页面打开时获取座位号信息，并传给seat
  },
};
</script>
<style scoped>
/* 头部样式 */
.head {
  height: 40px;
  background-color: #ffdd4d;
  line-height: 40px;
  text-align: center;
  /* border-bottom: 1px solid rgb(214, 213, 213); */
}
/* 主体内容 */
.main {
  width: 100%;
}
/* 座位号图标样式 */
.van-icon {
  line-height: 40px;
  margin-right: 5px;
}
/* 座位号块样式 */
.seat {
  padding-left: 20px;
  padding-right: 20px;
  height: 40px;
  line-height: 40px;
  border-bottom: 1px solid rgb(214, 213, 213);
}
.seat > span {
  display: inline-block;
  width: 111px;
  font-size: 10px;
  text-align: center;
}
/* 付款区样式 */
.pay {
  width: 95%;
  margin-left: 2%;
  position: fixed;
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 50px;
  border-radius: 40px;
  background-color: #222423;
  opacity:0.9;
}
.pay > p {
  font-size: 18px;
  color: #fff;
  margin-left: 10px;
}
.pay > p >span{
  font-size: 2rem;
}
.pay > .paybtn > .paybtnn{
  width: 100px;
  height: 52px;
  color: #222423;
  background-color: #ffdd4d;
  border-top-right-radius: 40px;
  border-bottom-right-radius: 40px;
  outline: none;
  border: none;
}
</style>
