<template>
  <Dialog v-model="dialogVisible" :max-height="500" :scroll="true" title="详情">
    <el-descriptions :column="1" border>
      <el-descriptions-item label="编号" min-width="120">
        {{ detailData.id }}
      </el-descriptions-item>
      <el-descriptions-item label="用户类型">
        <dict-tag :type="DICT_TYPE.USER_TYPE" :value="detailData.userType" />
      </el-descriptions-item>
      <el-descriptions-item label="用户编号">
        {{ detailData.userId }}
      </el-descriptions-item>
      <el-descriptions-item label="模版编号">
        {{ detailData.templateId }}
      </el-descriptions-item>
      <el-descriptions-item label="模板编码">
        {{ detailData.templateCode }}
      </el-descriptions-item>
      <el-descriptions-item label="发送人名称">
        {{ detailData.templateNickname }}
      </el-descriptions-item>
      <el-descriptions-item label="模版内容">
        {{ detailData.templateContent }}
      </el-descriptions-item>
      <el-descriptions-item label="模版参数">
        {{ detailData.templateParams }}
      </el-descriptions-item>
      <el-descriptions-item label="模版类型">
        <dict-tag :type="DICT_TYPE.SYSTEM_NOTIFY_TEMPLATE_TYPE" :value="detailData.templateType" />
      </el-descriptions-item>
      <el-descriptions-item label="短信状态">
        <el-tag :type="getStatus(detailData.mediaTypes,1,detailData.smsSuccess,true)">{{getStatus(detailData.mediaTypes,1,detailData.smsSuccess)}}</el-tag>
      </el-descriptions-item>
      <el-descriptions-item label="微信公众号状态">
        <el-tag :type="getStatus(detailData.mediaTypes,2,detailData.mpSuccess,true)">{{getStatus(detailData.mediaTypes,2,detailData.mpSuccess)}}</el-tag>
      </el-descriptions-item>
      <el-descriptions-item label="模板消息状态">
        <el-tag :type="getStatus(detailData.mediaTypes,3,detailData.mpTempSuccess,true)">{{getStatus(detailData.mediaTypes,3,detailData.mpTempSuccess)}}</el-tag>
      </el-descriptions-item>
      <el-descriptions-item label="是否已读">
        <dict-tag :type="DICT_TYPE.INFRA_BOOLEAN_STRING" :value="detailData.readStatus" />
      </el-descriptions-item>
      <el-descriptions-item label="阅读时间">
        {{ formatDate(detailData.readTime) }}
      </el-descriptions-item>
      <el-descriptions-item label="创建时间">
        {{ formatDate(detailData.createTime) }}
      </el-descriptions-item>
    </el-descriptions>
  </Dialog>
</template>
<script lang="ts" setup>
import { DICT_TYPE } from '@/utils/dict'
import { formatDate } from '@/utils/formatTime'
import * as NotifyMessageApi from '@/api/system/notify/message'

defineOptions({ name: 'SystemNotifyMessageDetail' })

const dialogVisible = ref(false) // 弹窗的是否展示
const detailLoading = ref(false) // 表单的加载中
const detailData = ref() // 详情数据

/** 打开弹窗 */
const open = async (data: NotifyMessageApi.NotifyMessageVO) => {
  dialogVisible.value = true
  // 设置数据
  detailLoading.value = true
  try {
    detailData.value = data
  } finally {
    detailLoading.value = false
  }
}
const getStatus = (mediaTypes,num,status,flag) => {
  if(!flag){
    if(mediaTypes.includes(num)){
      if(num === 1){
        if(status === null){
        return '短信未发送'
      }else if(status){
        return '短信发送成功'
      }else{
        return '短信发送失败'
      }
      }else if(num === 2){
        if(status === null){
        return '公众号未发送'
      }else if(status){
        return '公众号发送成功'
      }else{
        return '公众号发送失败'
      }
      }else{
        if(status === null){
        return '微信模板消息未发送'
      }else if(status){
        return '微信模板消息发送成功'
      }else{
        return '微信模板消息发送失败'
      }
      }
    }else{
      return '不发送'
    }
  }else{
    if(mediaTypes.includes(num)){
      if(status === null){
        return ''
      }else if(status){
        return 'success'
      }else{
        return 'danger'
      }
    }else{
      return 'info'
    }
  }

}
defineExpose({ open }) // 提供 open 方法，用于打开弹窗
</script>
