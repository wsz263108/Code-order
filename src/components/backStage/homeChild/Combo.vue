<template>
  <div>
      <!-- 面包屑导航区域 -->
    <el-breadcrumb separator="/">
      <el-breadcrumb-item :to="{ path: '/BackStage' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>套餐管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 主体区域 -->
    <el-card class="comboContent">
        <!-- 头部添加食品区域 -->
      <el-row :gutter="20">
          <el-col :offset="7" :span="8">
            <h1>所有套餐信息</h1>
          </el-col>
          <el-col class="addButton" :span="5">
            <el-button
            type="primary"
            @click="AddDialogFormVisible=true"
            >添加套餐</el-button>
          </el-col>
      </el-row>
      <el-table
      max-height="380"
      :data="comboDataList"
      style="width: 100%">
        <el-table-column
          label="#"
          type="index">
        </el-table-column>
        <el-table-column
          prop="comboname"
          label="餐品名"
          width="180">
        </el-table-column>
        <el-table-column
          label="餐品内容"
          width="200">
          <template slot-scope="scoped">
              <el-tag
              class="columnContent"
              v-for="(item,i) in scoped.row.content"
              :key="i"
              effect="dark"
              size="mini"
              >{{item}}</el-tag>
          </template>
        </el-table-column>
        <el-table-column
          prop="price"
          label="价格"
          width="100">
        </el-table-column>
        <el-table-column
          label="是否可用"
          width="100">
          <template slot-scope="scoped">
              <el-switch
                v-model="scoped.row.selltype"
                @change="isComboType(scoped.row)"
                active-color="#13ce66"
                inactive-color="#ff4949">
              </el-switch>
          </template>
        </el-table-column>
        
        <el-table-column
        label="操作">
          <template slot-scope="scope">
            <el-button size="small" @click="editCombo(scope.row)" type="primary" icon="el-icon-edit" circle></el-button>
            <el-button size="small" @click="deleteCombo(scope.row.id)" type="danger" icon="el-icon-delete" circle></el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页器 -->
      <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="queryInfo.pageNum"
      :page-sizes="[3, 5, 10]"
      :page-size="queryInfo.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="queryInfo.total">
    </el-pagination>
    </el-card>
    <!-- 添加套餐弹框 -->
    <el-dialog @close="addClose" title="添加套餐" :visible.sync="AddDialogFormVisible">
        <el-form :model="addFrom" :rules='FromRules' ref="addFromRef" label-width="80px">
            <el-form-item prop="comboname" label="套餐名">
                <el-input v-model="addFrom.comboname"></el-input>
            </el-form-item>
            <el-form-item label="套餐内容">
                <el-tag
                    class="addTag"
                    :key="i"
                    v-for="(item,i) in addFrom.content"
                    closable
                    :disable-transitions="true"
                    @close="addHandleClose(i)">
                {{item}}
                </el-tag>
                <el-input
                    class="input-new-tag"
                    v-if="addInputVisible"
                    v-model="addInputValue"
                    size="small"
                    ref="addSaveTagInput"
                    @keyup.enter.native="addHandleInputConfirm"
                    @blur="addHandleInputConfirm"
                    >
                </el-input>
                <el-button v-else class="button-new-tag" size="small" @click="addShowInput">+ New Tag</el-button>
            </el-form-item>
            <el-form-item prop='price' label="套餐价格">
                <el-input v-model="addFrom.price"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button @click="AddDialogFormVisible = false">取 消</el-button>
            <el-button type="primary" @click="addComboDialog">确 定</el-button>
        </div>
    </el-dialog>
    <!-- 修改套餐弹框 -->
    <el-dialog @close="alterClose" title="修改套餐" :visible.sync="alterDialogFormVisible">
        <el-form :model="alterFrom" :rules='FromRules' ref="alterFromRef" label-width="80px">
            <el-form-item prop="comboname" label="套餐名">
                <el-input v-model="alterFrom.comboname"></el-input>
            </el-form-item>
             <el-form-item label="套餐内容">
                <el-tag
                    class="addTag"
                    :key="i"
                    v-for="(item,i) in alterFrom.content"
                    closable
                    :disable-transitions="true"
                    @close="alterHandleClose(i)">
                {{item}}
                </el-tag>
                <el-input
                    class="input-new-tag"
                    v-if="addInputVisible"
                    v-model="addInputValue"
                    size="small"
                    ref="addSaveTagInput"
                    @keyup.enter.native="alertHandleInputConfirm"
                    @blur="alertHandleInputConfirm"
                    >
                </el-input>
                <el-button v-else class="button-new-tag" size="small" @click="addShowInput">+ New Tag</el-button>
             </el-form-item>
             <el-form-item prop="price" label="套餐价格">
                <el-input v-model="alterFrom.price"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button @click="alterDialogFormVisible = false">取 消</el-button>
            <el-button type="primary" @click="alertComboDialog">确 定</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
 data(){
   return{
     comboDataList:[],//所有套餐
     foodDataList:[],//获取所有餐品名
     queryInfo:{
       pageSize:3,//每页显示多少条
       pageNum:1,//第几页
       total:0
     },//获取所有餐品数据携带的参数
     FromRules:{
         comboname:[
             {required:true,message:'请输入套餐名字',trigger:'blur'},
             {min:1,max:7,message:'套餐名在1-7个字符之间',trigger:'blur'}
         ],
         price:[
             {required:true,message:'请输入套餐价格',trigger:'blur'}
         ]
     },//规则
     AddDialogFormVisible:false,//控制添加弹框
     addFrom:{
         comboname:'',
         content:[],
         price:''
     },//保存将要添加的数据
     addInputValue:'',//添加弹出框的newtag标签的数据
     addInputVisible:false,//控制newtag是否显示
    //  修改弹框
    alterDialogFormVisible:false,//控制修改弹框显示隐藏
    alterFrom:{
        comboname:'',
        content:[],
        price:''
    },//要修改的数据
   }
 },
 created() {
     //获取所有套餐
     this.getComboList()
    //  获取所有餐品名
    this.getFoodDetails()
 },
 methods: {
    //  修改套餐是否可售
     async isComboType(s){
         let {data:res}=await this.$http.put('/backstage/comboType',this.$par(s))
         if(res.meta.status===200) return this.$message.success('修改成功')
         this.$message.error('修改失败')
     },
    //  获取所有套餐
     async getComboList(isMsg){
        let {data:res}=await this.$http.get('/backstage/combo',{params:this.queryInfo})
        if(res.meta.status!==200) return this.$message.error('获取失败')
        if(!isMsg){this.$message.success('获取成功')}
        this.comboDataList=res.data
        this.comboDataList.forEach(e => {
            e.selltype=e.selltype===1?true:false;
        });
        this.queryInfo.total=res.total
     },
    // 获取所有餐品
    async getFoodDetails(){
        let {data:res}=await this.$http.get('/backstage/foodName')
        this.foodDataList=res
    },
    //  点击删除按钮触发
     async deleteCombo(s){
         let confirm=await this.$confirm('此操作将永久删除该餐品，是否继续?','提示',{
            confirmButtonText:'确认',
            cancelButtonText:'取消',
            type:'warning'
         }).catch(err=>err)
         if(confirm==='cancel'){
            return this.$message.info('取消删除')
         }else{
            let {data:res}=await this.$http.delete('/backstage/delCombo',{params:{id:s}})
            if(res.meta.status!==200) return this.$message.error('删除失败')
            this.$message.success('删除成功')
            this.getComboList('111')
         }
     },
    //  监听切换每页显示多少条
    handleSizeChange(newpageSize){
        this.queryInfo.pageSize=newpageSize
        this.getComboList('111')
    },
    // 监听分页器改变页码数
    handleCurrentChange(newpageNum){
        this.queryInfo.pageNum=newpageNum
        this.getComboList('111')
    },
    //  监听添加弹出框 tag 标签关闭事件
    addHandleClose(i){
        this.addFrom.content.splice(i,1)
    },
    // 监听addinput的显示与隐藏
    addShowInput(){
        this.addInputVisible=true
        this.$nextTick(_ => {
            this.$refs.addSaveTagInput.$refs.input.focus();
        });
    },
    // 监听newInp的关闭事件
    addHandleInputConfirm(){
        if(this.addInputValue){
            this.addFrom.content.push(this.addInputValue)
        }
        this.addInputVisible=false
        this.addInputValue=''
    },
    // 监听添加弹框的关闭
    addClose(){
        this.addFrom={
            comboname:'',
            content:[],
            price:''
        }
        this.$refs.addFromRef.resetFields()
    },
    // 添加框确认事件
    addComboDialog(){
        let o=this.foodDataList
        let n=this.addFrom.content;
        let isAdd=false;
        for(let i=0;i<n.length;i++){
            for(let k=0;k<o.length;k++){
                if(n[i]===o[k]){
                    isAdd=true;
                    break;
                }else{
                    isAdd=false
                }
            }
        }
        if(!isAdd) return this.$message.error('请检查套餐内容是否存在')
        this.$refs.addFromRef.validate(async valid=>{
            if(!valid){
                return this.$message.error('请检查内容是否规范')
            }else{
                let add={}
                add.comboname=this.addFrom.comboname
                add.price=this.addFrom.price
                add.content=this.addFrom.content.join(';')
                let {data:res}=await this.$http.post('/backstage/addCombon',this.$par(add))
                if(res.meta.status===200){
                    this.AddDialogFormVisible=false
                    this.getComboList()
                    return this.$message.success('添加成功')
                }else{
                    this.AddDialogFormVisible=false
                    this.getComboList()
                    return this.$message.error('添加失败')
                }
                
            }
        })
    },
    //  点击修改按钮触发
    editCombo(s){
        this.alterFrom=s
        this.alterDialogFormVisible=true
    },
    // 监听修改弹框关闭事件
    alterClose(){
        this.getComboList('111')
        this.$refs.alterFromRef.resetFields()
    },
    // 监听修改弹框添加tag事件
    alertHandleInputConfirm(){
        if(this.addInputValue){
            this.alterFrom.content.push(this.addInputValue)
        }
        this.addInputVisible=false
        this.addInputValue=''
    },
    // 监听修改弹框删除tag事件
    alterHandleClose(i){
        this.alterFrom.content.splice(i,1)
    },
    // 监听修改弹框确认事件
    alertComboDialog(){
        let o=this.foodDataList
        let n=this.alterFrom.content;
        let isAdd=false;
        for(let i=0;i<n.length;i++){
            for(let k=0;k<o.length;k++){
                if(n[i]===o[k]){
                    isAdd=true;
                    break;
                }else{
                    isAdd=false
                }
            }
        }
        if(!isAdd) return this.$message.error('请检查套餐内容是否存在')
        this.$refs.alterFromRef.validate(async vali=>{
            if(!vali){
                return this.$message.error('请检查修改的内容')
            }else{
                let add={}
                add.id=this.alterFrom.id
                add.comboname=this.alterFrom.comboname
                add.price=this.alterFrom.price
                add.content=this.alterFrom.content.join(';')
                let {data:res}=await this.$http.put('/backstage/alterCombon',this.$par(add))
                if(res.meta.status===200){
                    this.alterDialogFormVisible=false
                    return this.$message.success('修改成功')
                }else{
                    this.alterDialogFormVisible=false
                    return this.$message.error('修改失败')
                }
            }
        })
    }
 },
}
</script>

<style lang='css' scoped>
.comboContent{
    margin: 30px;
}
.columnContent{
    font-size: 8px;
    margin: 1px;
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
.addTag{
    margin-right: 3px;
}
</style>