<template>
  <Dialog v-model="dialogVisible" width="70%" title="测试发送" >
    <el-form
      ref="formRef"
      v-loading="formLoading"
      :model="formData"
      :rules="formRules"
      label-width="140px"
    >
      <el-form-item label="模板内容" prop="content">
        <el-input
          v-model="formData.content"
          placeholder="请输入模板内容"
          readonly
          type="textarea"
        />
      </el-form-item>
      <el-form-item label="用户类型" prop="userType">
        <el-radio-group v-model="formData.userType">
          <el-radio :label="2" v-if="formData.code">{{props.templateList.find(item=>item.value === formData.code).value+'（'+props.templateList.find(item=>item.value === formData.code).description+'）'}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <div class="mt-[20px]">
        <el-table @selection-change="handleSelectionChange" :data="tableData" maxHeight="250" border style="width: 100%">
        <el-table-column type="selection" width="55" />
    <el-table-column prop="receiverId" label="收件人 ID" width="90" />
    <el-table-column prop="receiverName" label="收件人名称" />
    <el-table-column prop="templateParams" label="收件人内容参数">
      <template #default="scope">
      <span v-if="scope.row.templateParams">{{JSON.stringify(scope.row.templateParams)}}</span>
      </template>
    </el-table-column>
    <el-table-column prop="content" label="通知内容" />
  </el-table>
      </div>
  <el-pagination class="mb-[20px]" layout="total,prev, pager, next" v-model:current-page="page.pageNo" :page-size="page.pageSize" :total="total" />
      <!-- <el-form-item v-show="formData.userType === 1" label="接收人ID" prop="userId">
        <el-input v-model="formData.userId" style="width: 160px" />
      </el-form-item> -->
      <!-- <el-form-item v-show="formData.userType === 2" label="接收人" prop="userId">
        <el-select v-model="formData.userId" placeholder="请选择接收人">
          <el-option
            v-for="item in userOption"
            :key="item.id"
            :label="item.nickname"
            :value="item.id"
          />
        </el-select>
      </el-form-item> -->
      <el-form-item
        v-for="param in formData.params"
        :key="param"
        :label="'参数 {' + param + '}'"
      >
        <el-input
        disabled
          v-model="formData.templateParams[param]"
          :placeholder="'请输入 ' + param + ' 参数'"
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button :disabled="formLoading" type="primary" @click="submitForm">确 定</el-button>
      <el-button @click="dialogVisible = false">取 消</el-button>
    </template>
  </Dialog>
</template>
<script lang="ts" setup>
import * as UserApi from '@/api/system/user'
import * as NotifyTemplateApi from '@/api/system/notify/template'
import { DICT_TYPE, getIntDictOptions } from '@/utils/dict'

defineOptions({ name: 'SystemNotifyTemplateSendForm' })
const props = defineProps({
  templateList:{
    type:Array,
    default:() =>[]
  }
})
const message = useMessage() // 消息弹窗

const dialogVisible = ref(false) // 弹窗的是否展示
const formLoading = ref(false) // 表单的加载中：1）修改时的数据加载；2）提交的按钮禁用
const formData = ref({
  content: '',
  code:'',
  params: {},
  userId: null,
  userType: 2,
  id:undefined,
  templateParams: new Map()
})
const formRules = reactive({
  userId: [{ required: true, message: '用户编号不能为空', trigger: 'change' }],
  templateParams: {}
})
const formRef = ref() // 表单 Ref
const userOption = ref<UserApi.UserVO[]>([])

const open = async (id: number) => {
  dialogVisible.value = true
  resetForm()
  // 设置数据
  formLoading.value = true
  try {
    const data = await NotifyTemplateApi.getNotifyTemplate(id)
    if(props.templateList.some((item:any)=>item.value === data.code)){
    getList(data.code)
  }
    // 设置动态表单
    formData.value.content = data.content
    formData.value.code = data.code
    formData.value.params = data.params
    formData.value.templateParams = data.params.reduce((obj, item) => {
      obj[item] = '' // 给每个动态属性赋值，避免无法读取
      return obj
    }, {})
    formRules.templateParams = data.params.reduce((obj, item) => {
      obj[item] = { required: true, message: '参数 ' + item + ' 不能为空', trigger: 'blur' }
      return obj
    }, {})
  } finally {
    formLoading.value = false
  }
  // 加载用户列表
  userOption.value = await UserApi.getSimpleUserList()
}

const page = ref({
  pageNo: 1,
  pageSize: 10
})
const total = ref(0)
const tableData = ref([{name:1,valu:1}])
defineExpose({ open }) // 提供 open 方法，用于打开弹窗

 
const getList = async (code:string) => {
  const result = await NotifyTemplateApi.notifyFilterUser({
    ...page.value,
    templateCode:code
  })
  tableData.value = result.list
  total.value = result.total
}
const handleSelectionChange = (rows) => {
  console.log(rows);
  
}
/** 提交表单 */
const submitForm = async () => {  
  // 校验表单
  if (!formRef) return
  const valid = await formRef.value.validate()
  if (!valid) return
  // 提交请求
  formLoading.value = true
  try {
    const data = formData.value
    const logId = await NotifyTemplateApi.notifyCreate({
      templateCode:data.code,
      receiverIds:tableData.value.map((item:any)=>item.receiverId)
    })
    if (logId) {
      message.success('提交发送成功')
    }
    dialogVisible.value = false
  } finally {
    formLoading.value = false
  }
}

/** 重置表单 */
const resetForm = () => {
  formData.value = {
    content: '',
    code:'',
    params: {},
    mobile: '',
    templateCode: '',
    templateParams: new Map(),
    userType: 2,
    id:undefined,
  } as any
  formRef.value?.resetFields()
}
</script>
