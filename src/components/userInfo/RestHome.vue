<template>
<!-- 餐厅首页 -->
  <div>
    <div class="die">
    <van-notice-bar scrollable text="欢迎来到GFR餐厅" />
    <!-- 轮播图区域 -->
    <van-swipe class="my-swipe" :autoplay="3000" indicator-color="white">
      <van-swipe-item v-for="(item,i) in swipeImgList" :key="i">
        <img style="width:100%;height:200px" :src="item.imgurl" alt="">
      </van-swipe-item>
    </van-swipe>
    <!-- 套餐区域 -->
    <div class="recommBox">
      <div class="titleBox">
        <div offset="1" class="title" span="6">
          <div @click="aa"><span>---</span><van-icon size="25px" color="#ffdd4d" name="good-job" />优惠套餐<span>---</span></div>
        </div>
      </div>
<!-- <div  offset="12" class="checkCombo" span="5">查看套餐>></div> -->
      <van-swipe :loop="false" :width="140" :show-indicators='false'>
        <van-swipe-item :key="item.id" v-for="item in comboDataList" class="comboSwipeItem">
          <van-row>
            <van-col span="24">
              <img class="swipeColImg" :src="item.imgurl" alt="">
            </van-col>
             <van-col span="24">{{item.comboname}}</van-col>
             <van-col offset="" class="van-ellipsis" span="20">{{item.content.split(';').join('+')}}</van-col>
             <van-col offset="9" class="priceTextSize" span="15">￥:<b>{{item.price}}</b></van-col>
          </van-row>
        </van-swipe-item>
        <van-swipe-item></van-swipe-item>
      </van-swipe>
      
    </div>
     <div class="recommBox">
    <div class="titleBox">
      <div offset="1" class="title" span="6">
        <div><span>---</span><van-icon size="25px" color="#FF3B30" name="hot" />热销推荐<span>---</span></div>
      </div>
    </div>
     </div>
      <van-card
        :price='item.price.toFixed(1)'
        :desc="'销量：'+item.ordernum"
        :title="item.foodname"
        :thumb="item.imgurl"
        v-for="item in salesFoodList"
        :key="item.id+30"
      >
      <template #num>
        <van-stepper
          @plus="foodPlus(item)"
          @minus='foodMinus(item)'
          theme="round"
          button-size="25"
          disable-input
          default-value=0
          min="0"
        />
      </template>
    </van-card>
    <!-- 套餐详情 -->
    <van-popup
    closeable
    v-model="comboShow"
    round position="bottom"
    :style="{ height: '80%' }">
    <van-card
          :price='item.price.toFixed(1)'
          :title="item.comboname"
          desc="套餐内容:"
          :thumb="item.imgurl"
          v-for="item in comboDataList"
          :key="item.id"
        >
        <template #tags>
          <van-tag v-for="tag in item.content.split(';')" :key="tag" plain type="danger">{{tag}}</van-tag>
        </template>
        <template #num>
          <van-stepper
            @plus="foodPlus(item)"
            @minus='foodMinus(item)'
            theme="round"
            button-size="25"
            disable-input
            default-value=0
            min="0"
          />
        </template>
      </van-card>
    </van-popup>
    </div>
  </div>
</template>

<script>
export default {
 data(){
   return{
     swipeImgList:[],//轮播图img数组
    //用户所选的订单类型，关联至徽标展示
     logoarr: [],
     salesFoodList:[],//获取销量榜
     comboDataList:[],//获取所有套餐
     comboShow:false,//控制套餐弹框
   }
 },
 created() {
  //  获取轮播图图片
  this.getImgList()
  // 获取销量最高的五个餐品
  this.getSalesFood()
  //获取套餐
  this.getComboList()
 },
 methods: {
  //  获取轮播图的图片
  async getImgList(){
    let {data:res}=await this.$http.get('/imglist')
    this.swipeImgList=res.data
  },
  async getComboList(){
    let {data:res}=await this.$http.get('/comboMeal')
    this.comboDataList=res
  },
  // 加餐
  foodPlus(item) {
    item.comboname?item.foodname=item.comboname:item.foodname
    item.content?item.taste=item.content:item.taste
    this.$store.commit('adduserFoodList',item)
    this.$store.commit('totalPrice')
    // this.num=this.$store.state.totalNum
    // 点加号，将所选食物的类型添加到logoarr数组
    this.logoarr.push(item.type - 1);
  },
  // 减餐
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
  // 获取销量最高的五个餐品
  async getSalesFood(){
    let {data:res}=await this.$http.get('/salesFood')
    this.salesFoodList=res
  },
  // 
  aa(){
    this.comboShow=true
  }
 },
}
</script>

<style lang='css' scoped>
.die{
  background-color: #f5f5f5;
}
.van-notice-bar{
  color: black;
  background-color: #ffdd4d;
  /* opacity: 0.7; */
}
.recommBox{
  width: 98%;
  margin: 0 auto;
}
.swipeColImg{
  width: 100%;
  height: 100px;
}
.van-card{
  background-color: #fff;
}
.van-col{
  font-size: 13px;
  text-align: center;
}
.van-ellipsis{
  font-size: 1px;
  /* color: rgb(116, 116, 116); */
  background-color: #fff;
}
.priceTextSize{
  font-size: 8px;
  color: red;
}
.comboSwipeItem{
  margin-right: 10px;
  /* border: 1px solid rgba(90, 81, 81, 0.171); */
  border-radius: 5%;
  padding: 4px;
  background-color: #fff;
  /* background: #ffdd4d; */
  /* opacity: 0.8; */
}
.titleBox{
  display: flex;
  /* margin-top: 10px;
  border-bottom: 1px solid rgba(44, 44, 44, 0.521) ;
  margin-bottom: 5px */
}
.titleBox span{
  color: #c0c0c0;
  margin-right: 10px;
  margin-left: 10px;
}
.recommBox .title{
  margin: 0 auto;
  margin-top: 10px;
  margin-bottom: 10px;
  font-size: 20px;
  font-weight: 'blod';
  font-family: oblique
}
.checkCombo{
  font-size: 12px;
  background-color: "f5f5f5";
}
.recommBox .title .van-icon{
  margin-right: 5px;
}
</style>