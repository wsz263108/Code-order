<template>
    <el-container class="HomeContent">
        <!-- 标题区域 -->
        <el-header class="HomeHeader">
            <div>
                <img class="login" src="../../assets/logo.png" alt="">
                <span class="title">扫码点餐后端管理系统</span>
            </div>
        </el-header>
        <el-container class="contentMain">
            <!-- 侧边栏区域 -->
            <el-aside
            width='200px'
            >
                <el-menu
                router
                text-color="#B5B5B5"
                active-text-color="#8EB15C"
                >
                    <el-menu-item index="/BackStage/user">
                        <i class="el-icon-user-solid"></i>
                        <span slot="title">账号管理</span>
                    </el-menu-item>
                    <el-menu-item index="/BackStage/menu">
                        <i class="el-icon-s-shop"></i>
                        <span slot="title">菜单管理</span>
                    </el-menu-item>
                    <el-menu-item index="/BackStage/combo">
                        <i class="el-icon-s-goods"></i>
                        <span slot="title">套餐管理</span>
                    </el-menu-item>
                </el-menu>
            </el-aside>
            <!-- 主体区域 -->
            <el-main>
                    
                <router-view>
                </router-view>
            </el-main>
        </el-container>
    </el-container>
</template>

<script>
export default {
 data(){
   return{
     
   }
 },
 created() {
 },
 methods:{

 }
}
</script>

<style lang='css' scoped>
.HomeContent{
    height: 100%;
}
.HomeContent .HomeHeader{
    background-color: gray;
}
.HomeContent .HomeHeader div{
    display: flex;
    justify-content: flex-start;
}
.HomeContent .HomeHeader .login{
    margin-top: 5px;
    width: 4%;
}
.HomeContent .HomeHeader .title{
    font-size: 30px;
    margin-left: 15%;
    line-height: 50px;
}
.el-menu{
    background-color: #282C34;
    height: 603px;
    /* width: 60%; */
}
.contentMain .el-main{
    margin: 0;
    padding: 0;
}
</style>