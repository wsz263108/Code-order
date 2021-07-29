<template>
  <div>
    <!-- 头部  餐厅名称 -->
    <div class="head">干饭人小餐馆</div>
    <!-- 座位号 -->
    <div class="seat">
      <van-icon
        name="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.51yuansu.com%2Fpic2%2Fcover%2F00%2F32%2F84%2F581109649d7fc_610.jpg&refer=http%3A%2F%2Fpic.51yuansu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1625623449&t=47ed54dd974330a262defe39378a0f52"
      />
      <span>座位号：{{ seat }}</span>
    </div>
    <!-- 主体内容 -->
    <div class="main" :style="{ height: windowHeight - 131 + 'px' }">
      <!-- 侧边栏 -->
      <van-sidebar v-model="activeKey">
        <van-sidebar-item
          :title="item.foodclass"
          v-for="(item, i) of foodclass"
          :key="i"
          :href="'#' + i"
        />
      </van-sidebar>
      <!-- 搜索框 -->
      <van-search
        v-model="value"
        shape="round"
        placeholder="搜索商品"
        input-align="center"
        style="padding-top: 0"
      />
      <!-- 食品区 -->
      <div
        class="food"
        :style="{
          height: windowHeight - 172 + 'px',
          width: windowWidth - 100 + 'px',
        }"
      >
        <div v-for="(item, a) of food" :key="a">
          <p
            style="
              height: 20px;
              line-height: 20px;
              border-left: 5px solid red;
              font-size: 10px;
              padding-left:10px
            "
            :id="a"
          >
            {{ foodclass[item.type-1].foodclass }}
          </p>
          <van-card
            style="margin-top: 0px"
            :price='b.price.toFixed(1)'
            desc="月销量：0"
            :title="b.foodname"
            :thumb="b.imgurl"
            v-for="(b, c) of item.list"
            :key="c"
          >
            <template #num>
              <van-stepper
                @change="aa"
                theme="round"
                button-size="25"
                disable-input
                min="0"
                :show-minus='minus'
                :show-input='num'
              />
            </template>
          </van-card>
        </div>
      </div>
    </div>
    <!-- 底部 -->
    <div fixed class="tabbar">
      <van-tabbar v-model="active" active-color="#000" route>
        <van-tabbar-item
          v-if="active == 1"
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
        <van-tabbar-item icon="manager" :to="'/order/'+seat">我的订单</van-tabbar-item>
      </van-tabbar>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      minus:false,
      num:false,
      // 经过分类处理的food数组
      food:[],
      foodnum: 0,
      // 底部标签栏默认值
      active: 0,
      // 座位号
      seat: 0,
      windowWidth: document.documentElement.clientWidth, //实时屏幕宽度
      windowHeight: document.documentElement.clientHeight, //实时屏幕高度
      // 左侧侧边栏默认值
      activeKey: 0,
      // 左侧侧边栏需要的值
      foodclass: [],
      // 搜索框默认值
      value: "",
    };
  },
  methods: {
    plusnum(e) {
      this.foodnum += 1;
      console.log(e * this.foodnum);
    },
    minusnum(e) {
      this.foodnum -= 1;
      console.log(e * this.foodnum);
    },
    aa(e) {
      this.foodnum = e;
    },
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
    this.axios.get("/foodclass").then((result) => {
      // console.log(result.data.data);
      this.foodclass = result.data.data;
    });

    this.axios.get(`/food?foodtype=0`).then((result) => {
      // console.log(result.data.data);
      // this.food = result.data.data;

      // 将food数组按照类别分类处理
      let f = result.data.data;
      let ff=[];
      f.map(mapItem=>{
        if(ff.length==0){
          ff.push({type:mapItem.type,list:[mapItem]})
        }else{
          let res=ff.some(item=>{
            if(item.type==mapItem.type){
              item.list.push(mapItem)
              return true
            }
          })
          if(!res){
            ff.push({type:mapItem.type,list:[mapItem]})
          }
        }
      })
      this.food=ff
      console.log(this.food)
    });
    var that = this;
    // <!--把window.onresize事件挂在到mounted函数上-->
    window.onresize = () => {
      return (() => {
        window.fullHeight = document.documentElement.clientHeight;
        window.fullWidth = document.documentElement.clientWidth;
        that.windowHeight = window.fullHeight; // 高
        that.windowWidth = window.fullWidth; // 宽
      })();
    };
    // 在页面打开时获取座位号信息，并传给seat
    this.seat = this.$route.params.seat;
    // this.seat = obseat;
    //将座位号存入vuex中
    // this.$store.commit("setseat", obseat);
  },
};
</script>
<style scoped>
/* 食品栏价格与按钮样式 */
.van-card__bottom {
  height: 25px;
}
/* 头部样式 */
.head {
  height: 40px;
  /* background-color: aqua; */
  line-height: 40px;
  text-align: center;
  border-bottom: 1px solid rgb(214, 213, 213);
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
}
/* 主体内容 */
.mian {
}
/* 侧边栏样式 */
.van-sidebar {
  width: 100px;
  float: left;
  height: 100%;
}
/* 搜索框样式 */
.van-search {
  border-bottom: 1px dashed rgb(214, 213, 213);
}
/* 食品区样式 */
.food {
  float: right;
  overflow: auto;
}
</style>
