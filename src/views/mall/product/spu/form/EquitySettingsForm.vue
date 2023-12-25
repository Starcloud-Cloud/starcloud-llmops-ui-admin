<template>
  <!-- 情况一：添加/修改 -->
  <el-form
    ref="equitySettingsFormRef"
    :model="formData"
    :rules="rules"
    label-width="150px"
  >
    <el-row>
      <el-col :span="8">
        <el-form-item prop="levelId" label="用户等级">
          <el-select v-model="formData.levelId">
    <el-option
      v-for="item in levelLists"
      :key="item.id"
      :label="item.name"
      :value="item.id"
    />
  </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item prop="giveMagicBean" label="魔法豆">
        <el-input-number
    v-model="formData.giveMagicBean"
    :min="0"
    controls-position="right"
  />
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item prop="giveImage" label="图片数量">
        <el-input-number
    v-model="formData.giveImage"
    :min="0"
    controls-position="right"
  />
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item prop="rightsTimeNums" label="权益生效时间">
          <el-input-number v-model="formData.rightsTimeNums" :min="1" controls-position="right"/>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item prop="rightsTimeRange" label="权益生效时间单位">
          <el-select v-model="formData.rightsTimeRange">
    <el-option
      v-for="item in timeList"
      :key="item.value"
      :label="item.label"
      :value="item.value"
    />
  </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="8"> <div></div></el-col>
      <el-col :span="8">
        <el-form-item prop="levelTimeNums" label="等级生效时间">
          <el-input-number v-model="formData.levelTimeNums" :min="1" controls-position="right"/>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item prop="levelTimeRange" label="等级生效时间单位">
          <el-select v-model="formData.levelTimeRange">
    <el-option
      v-for="item in timeList"
      :key="item.value"
      :label="item.label"
      :value="item.value"
    />
  </el-select>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>
<script lang="ts" setup>
import { PropType } from 'vue'
import { propTypes } from '@/utils/propTypes'
import { copyValueToTarget } from '@/utils'
import { otherSettingsSchema } from './spu.data'
import { DICT_TYPE, DictDataType } from '@/utils/dict'
import {levelList} from "@/api/mall/product/spu"

defineOptions({ name: 'EquitySettingsForm' })

const message = useMessage() // 消息弹窗

const levelLists = ref([])
levelList().then(res=>{
  levelLists.value = res
})
const timeList = [
  { label: '天', value: 1 },
  { label: '周', value: 7 },
  { label: '月', value: 30 },
  { label: '年', value: 365}]
const props = defineProps({
  propFormData: {
    type: Object as PropType<any>,
    default: () => {}
  },
  activeName: propTypes.string.def(''),
  isDetail: propTypes.bool.def(false) // 是否作为详情组件
})

// 活动优先级处理
const promotionTypes = ref<DictDataType[]>([
  {
    dictType: 'promotionTypes',
    label: '秒杀',
    value: 1,
    colorType: 'warning',
    cssClass: ''
  },
  {
    dictType: 'promotionTypes',
    label: '砍价',
    value: 2,
    colorType: 'warning',
    cssClass: ''
  },
  {
    dictType: 'promotionTypes',
    label: '拼团',
    value: 3,
    colorType: 'warning',
    cssClass: ''
  }
])

const equitySettingsFormRef = ref() // 表单Ref
// 表单数据
const formData = ref({
  levelId:'',
  giveMagicBean:1,
  giveImage:1,
  rightsTimeNums:1,
  rightsTimeRange:'',
  levelTimeNums:1,
  levelTimeRange:''
})
// 表单规则
const rules = reactive({
  levelId: [required],
  giveMagicBean:[required],
  giveImage:[required],
  rightsTimeNums:[required],
  rightsTimeRange:[required],
  levelTimeNums:[required],
  levelTimeRange:[required]
})

watch(
  () => props.propFormData,
  (data) => {
    if (!data) {
      return
    }
    copyValueToTarget(formData.value, data)
    console.log(formData.value);
    
  },
  {
    immediate: true
  }
)

const emit = defineEmits(['update:activeName'])
const validate = async () => {
  // 校验表单
  if (!equitySettingsFormRef) return
  return await unref(equitySettingsFormRef).validate((valid) => {
    if (!valid) {
      message.warning('商品其他设置未完善！！')
      emit('update:activeName', 'equitySettings')
      // 目的截断之后的校验
      throw new Error('商品其他设置未完善！！')
    } else {
      // 校验通过更新数据
      Object.assign(props.propFormData, formData.value)
    }
  })
}
defineExpose({ validate })
</script>
