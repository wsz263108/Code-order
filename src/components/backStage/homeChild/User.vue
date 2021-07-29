<template>
  <div>
    <!-- 面包屑导航区域 -->
    <el-breadcrumb separator="/">
      <el-breadcrumb-item :to="{ path: '/BackStage' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>账号管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 卡片视图区域 -->
    <el-card class="userContent">
      <!-- 添加与搜索区域 -->
      <el-row :gutter="20">
          <el-col :offset="7" :span="8">
            <h1>所有内部账号信息</h1>
          </el-col>
          <el-col class="addButton" :span="5">
            <el-button
            type="primary"
            @click="addDialogVisible=true"
            >添加用户</el-button>
          </el-col>
      </el-row>
      <!-- table 表格区域 -->
      <el-table
    :data="userInfoDataList"
    style="width: 100%">
    <el-table-column
      type="index"
      >
    </el-table-column>
    <el-table-column
      prop="username"
      label="账号"
      width="180">
    </el-table-column>
    <el-table-column
      prop="userpwd"
      label="密码"
      width="180">
    </el-table-column>
    <el-table-column
      prop="type"
      label="类型">
      <template slot-scope="scope">
      <el-select v-model="scope.row.type" placeholder="请选择" @change='userTypeSelect($event,scope.row.id)'>
        <el-option
          v-for="item in [{id:0,name:'管理员'},{id:1,name:'厨师'}]"
          :key="item.id"
          :label="item.name"
          :value="item.id"
          >
        </el-option>
      </el-select>
  </template>
    </el-table-column>
    <el-table-column
      label="操作">
      <template slot-scope="scope">
        <el-button size="small" @click="editUser(scope.row)" type="primary" icon="el-icon-edit" circle></el-button>
        <el-button size="small" @click="deleteUser(scope.row.id)" type="danger" icon="el-icon-delete" circle></el-button>
      </template>
    </el-table-column>
      </el-table>
      <!-- 分页器 -->
      <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="queryInfo.pageNum"
      :page-sizes="[3, 5, 10, 15]"
      :page-size="queryInfo.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="queryInfo.total">
    </el-pagination>
    </el-card>
    <!-- 添加用户弹出框 -->
    <el-dialog title="添加用户" :visible.sync="addDialogVisible" @close='addDialogClosed'>
      <!-- 内容主题区域 -->
      <el-form :model="addFrom" ref="addFromRef" :rules='addFromRules' label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input type="text" v-model="addFrom.username"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="userpwd">
          <el-input type="text" v-model="addFrom.userpwd"></el-input>
        </el-form-item>
        <el-form-item label="账号类型">
          <el-select v-model="addFrom.type">
            <el-option
              v-for="item in [{id:0,name:'管理员'},{id:1,name:'厨师'}]"
              :key="item.id"
              :label="item.name"
              :value="item.id"
              >
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <!-- 底部区域 -->
      <div slot="footer" class="dialog-footer">
        <el-button @click="editDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addUser">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 修改用户账号弹出框 -->
    <el-dialog title="修改用户" :visible.sync="editDialogVisible" @close='editDialogClosed'>
      <!-- 内容主题区域 -->
      <el-form :rules='editFromRules' ref="editFromRef" :model="editFrom" label-width="80px">
        <el-form-item prop="username" label="用户账号">
          <el-input v-model="editFrom.username"></el-input>
        </el-form-item>
        <el-form-item prop="userpwd" label="用户密码">
          <el-input v-model="editFrom.userpwd"></el-input>
        </el-form-item>
        <el-form-item label="账号类型">
          <el-select v-model="editFrom.type">
            <el-option
              v-for="item in [{id:0,name:'管理员'},{id:1,name:'厨师'}]"
              :key="item.id"
              :label="item.name"
              :value="item.id"
              >
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="editDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editDialogUser">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
 data(){
  //  验证用户名的规则
   var checkUserName=(rule,value,cb)=>{
    //  rule 校验规则
    // value 待校验的值
    // cb 回调函数
    // 验证用户名的正则表达式
    let regUserName = /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{3,10}$/;
    if(regUserName.test(value)){
      // 合法的账号
      return cb()
    }
    cb(new Error('账号只能是3-10位的字母、数字'))
   }
   //验证用户密码的规则
   var checkUserPwd=(rule,value,cb)=>{
     let refUserPwd=/^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,15}$/
     if(refUserPwd.test(value)){
       return cb()
     }
     cb(new Error('密码只能是6-15位的数字、字母'))
   }
   return{
    //  获取所有账号数据携带的参数
     queryInfo:{
       pageSize:3,//每页显示多少条
       pageNum:1,//第几页
       total:0
     },
     userInfoDataList:[],//所有用户数据
     editFrom:{},//需要修改的用户信息
     editDialogVisible:false,//控制修改用户弹出框
     editFromRules:{
      username:[
        {required:true,message:'请输入用户名',trigger:'blur'},
        {validator:checkUserName,trigger:'blur'}
      ],
      userpwd:[
        {required:true,message:'请输入密码',trigger:'blur'},
        {validator:checkUserPwd,trigger:'blur'}
      ]
    },//修改用户表单验证规则
     addDialogVisible:false,//控制添加用户弹出框
     addFrom:{
       username:'',//用户名
       userpwd:'',//用户密码
       type:0,//用户账号类型
     },//添加的新的用户数据
    //  添加用户表单验证规则
    addFromRules:{
      username:[
        {required:true,message:'请输入用户名',trigger:'blur'},
        {validator:checkUserName,trigger:'blur'}
      ],
      userpwd:[
        {required:true,message:'请输入密码',trigger:'blur'},
        {validator:checkUserPwd,trigger:'blur'}
      ]
    },
   }
 },
 created(){
  //  获取所有用户数据
   this.getUserInfoDataList()
 },
 methods: {
  //  获取所有用户数据的方法
   async getUserInfoDataList(){
     let {data:res}=await this.$http.get('/backstage/alluser',{params:this.queryInfo})
     if(res.meta.status!==200) return this.$message.error('获取用户列表失败')
     this.$message.success('获取用户列表成功')
     this.userInfoDataList=res.data
     this.queryInfo.total=res.total
   },
  //  更改账号类型的回调
   async userTypeSelect(v,id){
     let obj={
       type:v,
       id
     }
     let {data:res}=await this.$http.put('/backstage/changeusertype',this.$par(obj))
     if(res.meta.status===200) return this.$message.success('修改成功')
     this.$message.error('修改失败')
   },
  //  点击修改账号的方法
   editUser(userInfo){
     this.editDialogVisible=true
     this.editFrom=userInfo
   },
  //  监听修改账号对话框关闭事件
  editDialogClosed(){
    this.getUserInfoDataList()
    this.$refs.editFromRef.resetFields()
  },
  // 确认修改用户对话框事件
  editDialogUser(){
    // 表单提交预校验
    this.$refs.editFromRef.validate(async valid=>{
      if(valid){
        let {data:res}=await this.$http.put('/backstage/changeuser',this.$par(this.editFrom))
        if(res.meta.status===200){
          this.$message.success('修改成功')
          return this.editDialogVisible=false
        }else{
          this.$message.error('修改失败')
          return this.editDialogVisible=false
        }
      }
    })
  },
  //  删除账号的方法
   async deleteUser(id){
     let confirm=await this.$confirm('此操作将永久删除该账号，是否继续?','提示',{
       confirmButtonText:'确认',
       cancelButtonText:'取消',
       type:'warning'
     }).catch(err=>err)
     if(confirm==='cancel'){
       return this.$message.info('取消删除')
     }else{
       let {data:res}=await this.$http.delete('/backstage/deleteuser?id='+id)
       if(res.meta.status!==200){
         return this.$message.danger('删除失败')
       }else{
         this.getUserInfoDataList()
         return this.$message.success('删除成功')
       }
     }
   },
   //监听分页器改变每页条数的函数
   handleSizeChange(newSize){
     this.queryInfo.pageSize=newSize
     this.getUserInfoDataList()
   },
  //  监听分页器改变页码的函数
   handleCurrentChange(newPage){
     this.queryInfo.pageNum=newPage
     this.getUserInfoDataList()
   },
  //  监听添加用户的弹出框的关闭事件
  addDialogClosed(){
    this.$refs.addFromRef.resetFields()
  },
  //点击按钮添加新用户
  addUser(){
    // 表单提交预检验
    this.$refs.addFromRef.validate(async valid=>{
      if(valid){
        let {data:res}=await this.$http.post('/backstage/adduser',this.$par(this.addFrom))
        if(res.meta.status===401){
          return this.$message.info('已有帐号')
        }else if(res.meta.status===200){
          this.$message.success('添加成功')
          this.getUserInfoDataList()
          return
        }
        this.$message.error('添加失败')
      }
    })
    this.addDialogVisible=false
  },
 },
}
</script>

<style lang='css' scoped>
.userContent{
  margin: 30px;
}
.el-row .addButton{
  height: 60px;
  line-height: 60px;
}
</style>