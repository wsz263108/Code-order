import Vue from 'vue'
import VueRouter from 'vue-router'

// import BackStageHome from '../components/backStage/Home.vue'
const BackStageHome = () =>import(/*webpackChunkName:"backStage"*/ '../components/backStage/Home.vue')
// import BackStageLogin from '../components/backStage/Login.vue'
const BackStageLogin = () =>import(/*webpackChunkName:"backStage"*/ "../components/backStage/Login.vue");
// import BackStageUser from '../components/backStage/homeChild/User.vue'
const BackStageUser = () =>
  import(
    /*webpackChunkName:"backStage"*/ "../components/backStage/homeChild/User.vue"
  );
// import BackStageMenu from "../components/backStage/homeChild/User.vue";
const BackStageMenu = () =>
  import(
    /*webpackChunkName:"backStage"*/ "../components/backStage/homeChild/User.vue"
  );
// import BackStageWelcome from "../components/backStage/homeChild/Welcome.vue"
const BackStageWelcome = () =>
  import(
    /*webpackChunkName:"backStage"*/ "../components/backStage/homeChild/Welcome.vue"
  );
// import BackStageCombo from '../components/backStage/homeChild/Combo.vue'
const BackStageCombo = () =>
  import(
    /*webpackChunkName:"backStage"*/ "../components/backStage/homeChild/Combo.vue"
  );

// 用户点餐页面
// import UserHome from '../components/userInfo/userHome.vue'
const UserHome = () =>
  import(
    /*webpackChunkName:"userInfo"*/ "../components/userInfo/userHome.vue"
  );
// import UserInfo from '../components/userInfo/productsclass.vue'
const UserInfo = () =>
  import(
    /*webpackChunkName:"userInfo"*/ "../components/userInfo/productsclass.vue"
  );
// import Order from '../components/userInfo/Order.vue'
const Order = () =>
  import(/*webpackChunkName:"userInfo"*/ "../components/userInfo/Order.vue");
// import RestHome from '../components/userInfo/RestHome.vue'
const RestHome = () =>
  import(/*webpackChunkName:"userInfo"*/ "../components/userInfo/RestHome.vue");

// import Login from '../components/rearLogin/Login.vue'
const Login = () =>
  import(/*webpackChunkName:"chef"*/ "../components/rearLogin/Login.vue");
// import Chef from '../components/chefs/Kitchen.vue'
const Chef = () =>
  import(/*webpackChunkName:"chef"*/ "../components/chefs/Kitchen.vue");

Vue.use(VueRouter)

Vue.use(VueRouter)
const routes = [
  {
    path: "/BackStageLogin",
    component: BackStageLogin
  },
  {
    path: "/BackStage",
    component: BackStageHome,
    children: [
      { path: "/BackStage", component: BackStageWelcome },
      { path: "/BackStage/user", component: BackStageUser },
      { path: "/BackStage/menu", component: BackStageMenu },
      { path: "/BackStage/combo", component: BackStageCombo }
    ]
  },
  {
    path: "/UserHome",
    component: UserHome,
    children: [
      {path: "/UserHome/:seat",component: RestHome},
      {path: "/UserHome/meal/:seat",meta: { keepAlive: true },component: UserInfo},
      {
        path: "/UserHome/order/:seat",
        component: Order
      }
    ]
  },
  {
    path: "/",
    component: Login
  },
  {
    path: "/chef",
    component: Chef
  }
];

const router = new VueRouter({
  routes
})

router.beforeEach((to,from,next)=>{
  let path=to.path.split('/')[1]
    if (path === "BackStageLogin" || path === "" || path === "UserHome") {
      return next()
    }
    let backToken = window.sessionStorage.getItem("backToken");
    let chefToken = window.sessionStorage.getItem("chefToken");
    if(path==='chef'){
      if(!chefToken) return next('/');
    }else{
      if (!backToken) return next("/BackStageLogin");
    }
    next();
})

export default router
