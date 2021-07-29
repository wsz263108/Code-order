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
          :dot="item.logo"
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
            :desc="'销量：'+b.ordernum"
            :title="b.foodname"
            :thumb="b.imgurl"
            v-for="(b, c) of item.list"
            :key="c"
          >
            <template #num>
              <van-stepper
                @plus="foodPlus(b)"
                @minus='foodMinus(b)'
                theme="round"
                button-size="25"
                disable-input
                default-value=0
                min="0"
              />
            </template>
          </van-card>
        </div>
      </div>
    </div>
    
  </div>
</template>
<script>
export default {
  data() {
    return {
      // 经过分类处理的food数组
      food:[],
      foodnum: 0,
      // 座位号
      seat: 0,
      //用户点的食物列表
      foodname:[],
      //用户订单总价
      // sum:0,
      windowWidth: document.documentElement.clientWidth, //实时屏幕宽度
      windowHeight: document.documentElement.clientHeight, //实时屏幕高度
      // 左侧侧边栏默认值
      activeKey: 0,
      // 左侧侧边栏需要的值
      foodclass: [],
      // 搜索框默认值
      value: "",
      // 保存用户已点的餐品
      userFoodList:[],
      //用户所选的订单类型，关联至徽标展示
      logoarr: [],
    };
  },
  created() {
    this.seat = this.$route.params.seat;
  },
  methods: {
    foodPlus(item) {
      this.$store.commit('adduserFoodList',item)
      this.$store.commit('totalPrice')
      this.num=this.$store.state.totalNum
         // 点加号，将所选食物的类型添加到logoarr数组
      this.logoarr.push(item.type - 1);
    },
    foodMinus(item){
      let arr=[]
      this.$store.state.userFoodList.forEach((e,i) => {
        if(e===item){
          arr.push(i)
        }
      });
      this.$store.commit('spliceUserFoodList',arr[arr.length-1])
      // 点减号，将所选食物的类型从logoarr数组中删除
      this.logoarr.some((e, i) => {
        if (e == item.type - 1) {
          this.logoarr.splice(i, 1);
          return true;
        }
      });
    },
    
  },
  watch: {
     // 监听logoarr数组
    logoarr(val) {
      this.logoarr = val;
      if (this.logoarr == "") {
        this.foodclass.forEach((e) => {
          return (e.logo = false);
        });
        this.$forceUpdate();
      } else {
        this.foodclass.forEach((e) => {
          return (e.logo = false);
        });
        this.$forceUpdate();
        this.logoarr.forEach((c) => {
          this.foodclass[c].logo = true;
          this.$forceUpdate();
        });
      }
    },
    // 实时监听屏幕宽高
    windowHeight(val) {
      let that = this;
    },
    windowWidth(val) {
      let that = this;
    },
  },
  mounted() {
    // 获取侧边栏
    this.$http.get("/foodclass").then((result) => {
      this.foodclass = result.data.data;
      // 给foodclass数组新增控制徽标的属性
      this.foodclass.forEach((e) => {
        return (e["logo"] = false);
      });
    });

    this.$http.get(`/food?foodtype=0`).then((result) => {
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
  background-color: #ffdd4d;
  line-height: 40px;
  text-align: center;
  color: #fff;
  /* border-bottom: 1px solid rgb(214, 213, 213); */
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
