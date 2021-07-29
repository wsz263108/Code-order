<template>
  <div>
    <!-- 头部 -->
    <div class="head">我的订单</div>
    <!-- 主体内容 -->
    <div class="main" :style="{ height: windowHeight - 91 + 'px' }">
      <van-empty
        v-if="order == 0"
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
        <div class="pay">
          <p>应付：</p>
          <p>已付：</p>
          <h1>还需支付：</h1>
        </div>
        <van-skeleton title title-width="100%" />
        <!-- 菜单菜品显示区 -->
        <div>
          <div style="padding: 15px 20px">
            <span style="color: gray">已点菜品</span>
            <a style="float: right; color: blue" href="#">继续点菜 ></a>
          </div>
          <div style="overflow:auto" :style="{height:(windowHeight-354)+'px'}">
            <van-card
              price="2.0"
              title="商品标题"
              thumb="https://img01.yzcdn.cn/vant/ipad.jpeg"
              centered
              v-for="i of 10" :key="i"
            >
            </van-card>
          </div>
          <van-button size="large" color="red" style="line-height:40px;height:40px;margin:0 20px" :style="{width:(windowWidth-40)+'px'}">在线买单</van-button>
        </div>
      </div>
    </div>
    <!-- 底部标签栏 -->
    <div class="tabbar">
      <van-tabbar v-model="active" active-color="#000" route>
        <van-tabbar-item
          v-if="active"
          icon="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F01%2F55%2F21%2F73574758f9c9668.jpg&refer=http%3A%2F%2Fbpic.588ku.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1625658934&t=d629ae6764ad8af5a06101fde66f03b6"
          :to="'/home/' + seat"
          >干饭</van-tabbar-item
        >
        <van-tabbar-item
          v-else
          icon="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F01%2F35%2F22%2F60573bd88e87a6a.jpg&refer=http%3A%2F%2Fbpic.588ku.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1625658934&t=c01d5974f84258c593d9937762307210"
          :to="'/home/' + seat"
          >干饭</van-tabbar-item
        >
        <van-tabbar-item icon="manager" :to="'/order/' + seat"
          >我的订单</van-tabbar-item
        >
      </van-tabbar>
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
    };
  },
  methods: {
    // btn(){
    //   this.axios.get('/food').then(result=>{
    //     console.log(result.data)
    //   })
    // }
  },
  watch: {
    // 实时监听屏幕宽高
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
    this.seat = this.$route.params.seat;
  },
};
</script>
<style scoped>
/* 头部样式 */
.head {
  height: 40px;
  /* background-color: aqua; */
  line-height: 40px;
  text-align: center;
  border-bottom: 1px solid rgb(214, 213, 213);
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
  height: 90px;
  padding: 15px 20px;
  line-height: 30px;
}
.pay > p {
  font-size: 18px;
}
.pay > h1 {
  font-size: 20px;
}
</style>
