<template>
  <div>
    <!-- 面包屑导航区域 -->
    <el-breadcrumb separator="/">
      <el-breadcrumb-item :to="{ path: '/BackStage' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>菜单管理</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card class="menuContent">
      <!-- 头部添加食品区域 -->
      <el-row :gutter="20">
          <el-col :offset="7" :span="8">
            <h1>所有餐品信息</h1>
          </el-col>
          <el-col class="addButton" :span="5">
            <el-button
            type="primary"
            @click="addDialogShow"
            >添加餐品</el-button>
          </el-col>
      </el-row>
      <!-- 主体区域 -->
      <el-table
      max-height="400"
      :data="allFoodDataList"
      style="width: 100%">
        <el-table-column
          type="index">
        </el-table-column>
        <el-table-column
          prop="foodname"
          label="餐品名"
          width="150">
        </el-table-column>
        <el-table-column
          prop="price"
          label="价格"
          width="100">
        </el-table-column>
        <el-table-column
          label="折扣"
          width="130">
          <template slot-scope="scoped">
            <el-select v-model="scoped.row.discount" placeholder="请选择" @change='editDiscount($event,scoped.row.id,scoped.row.price)'>
              <el-option
                v-for="item in [10,9,8,7,6,5,4,3,2,1]"
                :key="item"
                :label="item===10?'无折扣':item"
                :value="item">
              </el-option>
            </el-select>
          </template>
        </el-table-column>
        <el-table-column
          prop="discprice"
          label="折后价"
          width="100">
        </el-table-column>
        <el-table-column
          prop="type"
          label="类型"
          width="180">
           <template slot-scope="scope">
            <el-select v-model="scope.row.type" placeholder="请选择" @change='foodTypeSelect($event,scope.row.id)'>
                <el-option
                  v-for="item in allFoodClassList"
                  :key="item.id"
                  :label="item.foodclass"
                  :value="item.id"
                  >
                </el-option>
              </el-select>
          </template>
        </el-table-column>
        <el-table-column
        label="操作">
          <template slot-scope="scope">
            <el-button size="small" @click="editFood(scope.row)" type="primary" icon="el-icon-edit" circle></el-button>
            <el-button size="small" @click="deleteFood(scope.row.id)" type="danger" icon="el-icon-delete" circle></el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页器 -->
      <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="queryInfo.pageNum"
      :page-sizes="[5, 10, 15]"
      :page-size="queryInfo.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="queryInfo.total">
    </el-pagination>
    </el-card>
    <!-- 修改餐品弹出框 -->
    <el-dialog title="修改餐品" :visible.sync="editDialogVisible" @close='editDialogClosed'>
      <!-- 内容主题区域 -->
      <el-form :rules='editFromRules' ref="editFromRef" :model="editFrom" label-width="80px">
        <el-form-item prop="foodname" label="餐品名">
          <el-input v-model="editFrom.foodname"></el-input>
        </el-form-item>
        <el-form-item prop="price" label="价格">
          <el-input v-model="editFrom.price"></el-input>
        </el-form-item>
        <el-form-item label="餐品类型">
          <el-select v-model="editFrom.type" placeholder="请选择">
                <el-option
                  v-for="item in allFoodClassList"
                  :key="item.id"
                  :label="item.foodclass"
                  :value="item.id"
                  >
                </el-option>
              </el-select>
        </el-form-item>
        <el-form-item label="餐品备注">
          <el-tag
            :key="tag"
            v-for="tag in editFrom.taste"
            closable
            :disable-transitions="true"
            @close="editHandleClose(tag)">
            {{tag}}
          </el-tag>
          <el-input
            class="input-new-tag"
            v-if="editInputVisible"
            v-model="tagInputValue"
            size="small"
            ref="editSaveTagInput"
            @keyup.enter.native="editHandleInputConfirm"
            @blur="editHandleInputConfirm"
          >
          </el-input>
          <el-button v-else class="button-new-tag" size="small" @click="editShowInput">+ New Tag</el-button>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="editDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editDialogUser">确 定</el-button>
      </div>
    </el-dialog>
    <!-- 添加餐品弹出框-->
    <el-dialog title="添加餐品" :visible.sync="addDialogVisible" @close='addDialogClosed'>
      <!-- 内容主题区域 -->
      <el-form :rules='editFromRules' ref="addFromRef" :model="addFrom" label-width="80px">
        <el-form-item prop="foodname" label="餐品名">
          <el-input v-model="addFrom.foodname"></el-input>
        </el-form-item>
        <el-form-item prop="price" label="价格">
          <el-input v-model="addFrom.price"></el-input>
        </el-form-item>
        <el-form-item label="餐品类型">
          <el-select v-model="addFrom.type" placeholder="请选择">
                <el-option
                  v-for="item in allFoodClassList"
                  :key="item.id"
                  :label="item.foodclass"
                  :value="item.id"
                  >
                </el-option>
              </el-select>
        </el-form-item>
        <el-form-item label="餐品备注">
          <el-tag
            :key="tag"
            v-for="tag in addFrom.taste"
            closable
            :disable-transitions="true"
            @close="editHandleClose(tag)">
            {{tag}}
          </el-tag>
          <el-input
            class="input-new-tag"
            v-if="addInputVisible"
            v-model="addTagInputValue"
            size="small"
            ref="addSaveTagInput"
            @keyup.enter.native="addHandleInputConfirm"
            @blur="addHandleInputConfirm"
          >
          </el-input>
          <el-button v-else class="button-new-tag" size="small" @click="addShowInput">+ New Tag</el-button>
        </el-form-item>
         <el-form-item label="上传图片">
          <!-- 上传图片区域 -->
          <el-upload
            :http-request='uploadImg'
            :limit='1'
            :action="addUploadURL"
            :on-preview="addhandlePreview"
            :on-remove="addhandleRemove"
            list-type="picture">
            <el-button size="small" type="primary">点击上传</el-button>
          </el-upload>
        </el-form-item> 
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addDialogUser">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>  
export default {
 data(){
   return{
     imgaaa:'',
     allFoodDataList:[],//所有食品的详情
     allFoodClassList:[],//所有食品的类型
     queryInfo:{
       pageSize:5,//每页显示多少条
       pageNum:1,//第几页
       total:0
     },//获取所有餐品数据携带的参数
     editFrom:{},//修改某条餐品的详情
     editDialogVisible:false,//控制修改弹窗是否显示
     editFromRules:{
       foodname:[{required:true,message:'请输入餐品名',trigger:'blur'},
        {min:1,max:7,message:'餐品名长度在1-7个字符之间',trigger:'blur'}
       ],
       price:[{required:true,message:'请输入餐品价格',trigger:'blur'}
       ]
     },//表单验证规则
     tagInputValue:'',//修改新建的tag标签内容
     editInputVisible:false,//控制新建的tag标签是否显示
     addDialogVisible:false,//控制添加餐品弹出框显示
     addFrom:{
       foodname:'',
       price:'',
       type:1,
       taste:[],
       file:{}
     },//添加餐品需要携带的参数
     addTagInputValue:'',//添加餐品新建tag标签内容
     addInputVisible:false,//控制添加餐品tag标签里的inp标签是否显示
     addUploadURL:'http://localhost:3000/backstage/uploadImage',//上传图片的url地址
   }
 },
 created(){
   this.getMenuDataList()
   this.getFoodClassList()
 },
 methods:{
  //  获取所有食品详情
   async getMenuDataList(a){
     let {data:res}=await this.$http.get('/backstage/gainmenu',{params:this.queryInfo})
     if(res.meta.status===200){
       this.allFoodDataList=res.data
       this.queryInfo.total=res.total
       if(!a) return this.$message.success('获取成功')
     }else{
       this.$message.error('获取失败')
     }

   },
  //  获取所有食品类型
   async getFoodClassList(){
     let {data:res}=await this.$http.get('/foodclass')
     this.allFoodClassList=res.data
   },
  //  更改餐品类型
   async foodTypeSelect(type,id){
     let {data:res}=await this.$http.put('/backstage/changefoodtype',this.$par({type,id}))
     if(res.meta.status===200){
       return this.$message.success('修改成功')
     }else{
       return this.$message.error('修改失败')
     }
   },
   //修改餐品
   editFood(val){
     this.editDialogVisible=true
     this.editFrom=val
   },
  //  监听修改弹出框关闭事件
  editDialogClosed(){
    // this.$refs.editFromRef.resetFields()
    this.getMenuDataList(true)
  },
  //点击修改弹出框确认修改按钮
  editDialogUser(){
    this.$refs.editFromRef.validate(async valid=>{
      if(!valid){
        return this.$message.error('修改失败')
      }else{
        this.editFrom.tasteStr=this.editFrom.taste.join(';')
        let obj=this.$par(this.editFrom)
        let {data:res}=await this.$http.put('/backstage/editfood',obj)
        if(res.meta.status===200){
          this.$message.success('修改成功')
        }else{
          this.$message.danger('修改失败')
        }
        this.getMenuDataList(true)
      }
    })
    this.editDialogVisible=false
  },
  // 监听修改弹出框关闭tag标签关闭事件
  editHandleClose(tag){
    this.editFrom.taste.splice(this.editFrom.taste.indexOf(tag),1)
  },
  // 监听taginput关闭和失去焦点事件
  editHandleInputConfirm(){
    this.editInputVisible=false
    if(this.tagInputValue){
      this.editFrom.taste.push(this.tagInputValue)
    }
    this.tagInputValue=''
  },
  // 点击newtag 触发的事件
  editShowInput(){
    this.editInputVisible=true
    this.$nextTick(_ => {
      this.$refs.editSaveTagInput.$refs.input.focus();
    });
  },
  //  删除餐品
   async deleteFood(id){
     let confirm=await this.$confirm('此操作将永久删除该餐品，是否继续?','提示',{
       confirmButtonText:'确认',
       cancelButtonText:'取消',
       type:'warning'
     }).catch(err=>err)
     if(confirm==='cancel'){
       return this.$message.info('取消删除')
     }else{
       let {data:res}=await this.$http.delete('/backstage/deletefood',{params:{id}})
       if(res.meta.status===200){
         this.getMenuDataList()
         return this.$message.success('删除成功')
       }else{
         return this.$message.error('删除失败')
       }
     }
   },
    //监听分页器改变每页条数的函数
   handleSizeChange(newSize){
     this.queryInfo.pageSize=newSize
     this.getMenuDataList()
   },
   //  监听分页器改变页码的函数
   handleCurrentChange(newPage){
     this.queryInfo.pageNum=newPage
     this.getMenuDataList()
   },
  //  监听添加餐品弹出框关闭
  addDialogClosed(){
    console.log('关了');
  },
  // 监听点击newtag标签事件
  addShowInput(){
    this.addInputVisible=true
    this.$nextTick(_ => {
      this.$refs.addSaveTagInput.$refs.input.focus();
    });
  },
  // 点击添加按钮的事件
  addDialogShow(){
    this.addDialogVisible=true
    this.addFrom={
       foodname:'',
       price:'',
       type:1,
       taste:[],
       file:{}
     }
  },
  // 监听添加里面的 taginput 关闭事件
  addHandleInputConfirm(){
    this.addInputVisible=false
    if(this.addTagInputValue){
      this.addFrom.taste.push(this.addTagInputValue)
    }
    this.addTagInputValue=''
  },
  // 监听点击弹出框确认键后的事件
   addDialogUser(){
    this.$refs.addFromRef.validate(async valid=>{
      if(!valid){
        return this.$message.error('添加失败')
      }else{
        console.log(this.addFrom);
        function qs(obj) {
          let form = new FormData();
          for (let i in obj) {
            form.append(i, obj[i]);
          }
          return form;
        }
        // 文件对象
        let form=qs(this.addFrom)
        let {data:res}=await this.$http.post('/backstage/uploadImage',form)
        console.log(res);
      }
    })
    
    this.addDialogVisible=false
  },
   //  上传图片的回调
  uploadImg(param){
    this.addFrom.file=param.file
  },
  // 处理添加餐品图片预览效果
  addhandlePreview(){

  },
  // 处理添加餐品移除图片的操作
  addhandleRemove(){},
  // 监听修改折扣的回调函数
  async editDiscount(discount,id,p){
    let e=discount/10
    let discprice=p*e
    let {data:res}=await this.$http.put('/backstage/editDiscPrice',this.$par({id,discount,discprice}))
    if(res.meta.status!==200) return this.$message.error('修改失败')
    this.$message.success('修改成功')
    this.getMenuDataList('11')
  }
 }
}
</script>

<style lang='css' scoped>
.menuContent{
  margin: 30px;
}
.el-row .addButton{
  height: 60px;
  line-height: 60px;
}
.el-tag + .el-tag {
    margin-left: 10px;
  }
  .button-new-tag {
    margin-left: 10px;
    height: 32px;
    line-height: 30px;
    padding-top: 0;
    padding-bottom: 0;
  }
  .input-new-tag {
    width: 90px;
    margin-left: 10px;
    vertical-align: bottom;
  }
</style>