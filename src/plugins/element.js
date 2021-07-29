import Vue from "vue"
import {
  MessageBox,
  Message,
  Aside,
  Breadcrumb,
  BreadcrumbItem,
  Button,
  Card,
  Col,
  Container,
  Header,
  Input,
  Main,
  Menu,
  MenuItem,
  Row,
  Table,
  TableColumn,
  Select,
  Option,
  Dialog,
  Form,
  FormItem,
  Pagination,
  Tag,
  Upload,
  Submenu,
  Switch
} from "element-ui";
Vue.use(Button).use(Container).use(Menu).use(MenuItem).use(Header).use(Aside).use(Main).use(Breadcrumb)
.use(BreadcrumbItem).use(Card).use(Table).use(TableColumn).use(Row).use(Col).use(Input).use(Select).use(Option)
.use(Dialog).use(Form).use(FormItem).use(Pagination).use(Tag).use(Upload).use(Submenu).use(Switch)
Vue.prototype.$message=Message
Vue.prototype.$confirm = MessageBox.confirm;