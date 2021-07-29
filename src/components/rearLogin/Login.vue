<template>
  <div>
    <!-- 头部 -->
    <van-nav-bar title="登录页面">
      <template #right>
        <van-popover
          trigger="click"
          :actions="usertype"
          @select="onselect"
          v-model="showPopover"
        >
          <template #reference>
            <van-icon name="sort" size="18" color="gray"/>
            {{ switchtype }}
          </template>
        </van-popover>
      </template>
    </van-nav-bar>
    <!-- 登录表单 -->
    <van-form>
      <van-field
        v-model="queryInfo.username"
        name="用户名"
        label="用户名"
        :rules="[{ required: true, message: '请填写用户名' }]"
      />
      <van-field
        v-model="queryInfo.userpwd"
        type="password"
        name="密码"
        label="密码"
        :rules="[{ required: true, message: '请填写密码' }]"
      />
      <div style="margin: 16px">
        <van-button round block type="info" native-type="submit" @click="sub"
          >提交</van-button
        >
      </div>
    </van-form>
  </div>
</template>
<script>
export default {
  data() {
    return {
      queryInfo:{
        username:'',
        userpwd:''
      },
      showPopover: false,
      usertype: [{ text: "厨师" }, { text: "服务员" }],
      type: 1,
      switchtype: "服务员登录",
    };
  },
  methods: {
    onselect(usertype) {
      if (usertype.text == "厨师") {
        this.type = 2;
        this.switchtype = usertype.text + "登录";
      } else {
        this.type = 1;
        this.switchtype = usertype.text + "登录";
      }
    },
    async sub() {
      let par=this.$par(this.queryInfo)
      let {data:res}=await this.$http.post('/backstage/loginuser',par)
      if(res.meta.status!==200){
        return this.$Notify ({ type: 'danger', message: '登录失败,请检查账号密码' })
      }else{
        if(res.data[0].type===1){//1是厨师
          this.$Notify ({ type: 'success', message: '登录成功' })
          window.sessionStorage.setItem('chefToken',res.token)
          this.$router.push({path:'/chef?user='+res.data[0].username})
        }else{
          this.$dialog({title:'提示',message:'请在pc端登录'})
        }
      }
    },
  },
};
</script>

<style scoped>
</style>