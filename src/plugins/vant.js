import Vue from "vue";
import { Button, Card, Col, Dialog, Empty, Field, Form, Icon, NavBar, NoticeBar, Notify, Popover, Popup, Row, Search, Sidebar, SidebarItem, Skeleton, Stepper, Swipe, SwipeItem, Tabbar, TabbarItem, Tag, Toast } from 'vant'
Vue.use(Tabbar).use(TabbarItem).use(NoticeBar).use(Swipe).use(SwipeItem).use(Row).use(Col).use(Card).use(Stepper)
.use(Popup).use(Tag).use(Icon).use(Sidebar).use(SidebarItem).use(Search).use(Empty).use(Skeleton).use(NavBar)
.use(Popover).use(Form).use(Field).use(Button)
Vue.prototype.$dialog=Dialog;
Vue.prototype.$Toast=Toast;
Vue.prototype.$Notify =Notify
