<script lang="ts" name="Tooltip" setup>
import { propTypes } from '@/utils/propTypes'

defineProps({
  titel: propTypes.string.def(''),
  message: propTypes.string.def(''),
  icon: propTypes.string.def('ep:question-filled')
})
</script>
<template>
  <span>{{ titel }}</span>
  <ElTooltip :content="message" placement="top">
    <Icon :icon="icon" class="ml-1px relative top-1px" />
  </ElTooltip>
</template>
