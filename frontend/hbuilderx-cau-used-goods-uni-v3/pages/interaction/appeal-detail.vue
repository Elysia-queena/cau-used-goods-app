<template>
  <view class="page">
    <view v-if="appeal" class="card">
      <view class="head">
        <text class="title">{{ appeal.reason }}</text>
        <StatusBadge :label="status(appeal.status).label" :tone="status(appeal.status).tone" />
      </view>

      <view class="row"><text>申诉对象</text><text>{{ appeal.targetTypeLabel || appeal.targetType }} · {{ appeal.targetId }}</text></view>
      <view class="row"><text>提交时间</text><text>{{ appeal.createdAt }}</text></view>
      <view v-if="appeal.handleTime" class="row"><text>处理时间</text><text>{{ appeal.handleTime }}</text></view>

      <view v-if="appeal.images && appeal.images.length" class="section">
        <text class="section-title">凭证图片</text>
        <view class="images">
          <image v-for="image in appeal.images" :key="image" :src="normalizeImage(image)" mode="aspectFill" @click="previewImage(image)" />
        </view>
      </view>

      <view v-if="appeal.result" class="result">处理结果：{{ appeal.result }}</view>

      <button v-if="appeal.status === 'PENDING'" class="close-button" @click="close">撤回申诉</button>
    </view>

    <view v-if="target" class="card">
      <text class="section-title">关联对象</text>
      <view v-if="appeal?.targetType === 'PRODUCT'" class="product" @click="openProduct">
        <image v-if="target.image" class="cover" :src="target.image" mode="aspectFill" />
        <view v-else class="cover placeholder">商品</view>
        <view class="product-body">
          <text class="product-title">{{ target.title }}</text>
          <text class="price">￥{{ target.price }}</text>
          <text class="meta">{{ target.meetLocation || '预约后协商' }}</text>
        </view>
      </view>
      <view v-else class="target-text">
        {{ appeal.targetTypeLabel || appeal.targetType }} #{{ appeal.targetId }}
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import StatusBadge from '../../components/StatusBadge.vue'
import { tradeService } from '../../services/trade'
import { APPEAL_STATUS } from '../../utils/constants'
import { BASE_URL } from '../../utils/request'
import { navigate, showError, showSuccess } from '../../utils/navigation'

const appeal = ref(null)
const target = ref(null)
let id = ''

onLoad((options) => {
  id = options.id
  load()
})

async function load() {
  try {
    appeal.value = await tradeService.getAppeal(id)
    await loadTarget()
  } catch (error) {
    showError(error)
  }
}

async function loadTarget() {
  target.value = null
  if (appeal.value?.targetType !== 'PRODUCT') return
  try {
    target.value = await tradeService.getProduct(appeal.value.targetId)
  } catch (error) {
    target.value = null
  }
}

function status(value) {
  return APPEAL_STATUS[value] || { label: value, tone: 'muted' }
}

function normalizeImage(url) {
  if (!url) return ''
  return /^https?:\/\//.test(url) ? url : `${BASE_URL}${url}`
}

function previewImage(image) {
  const urls = (appeal.value?.images || []).map(normalizeImage)
  uni.previewImage({ urls, current: normalizeImage(image) })
}

function openProduct() {
  navigate('/pages/detail/detail', { id: appeal.value.targetId })
}

function close() {
  uni.showModal({
    title: '撤回申诉',
    content: '确定撤回这条申诉吗？撤回后状态会变为已关闭。',
    success: async ({ confirm }) => {
      if (!confirm) return
      try {
        appeal.value = await tradeService.closeAppeal(id, '用户主动撤回申诉')
        showSuccess('已撤回')
      } catch (error) {
        showError(error)
      }
    }
  })
}
</script>

<style scoped>
.page { min-height: 100vh; padding: 24rpx; background: #f6f7f9; box-sizing: border-box; }
.card { margin-bottom: 18rpx; padding: 26rpx; border-radius: 22rpx; background: #fff; box-shadow: 0 8rpx 28rpx rgba(23, 33, 43, .04); }
.head { display: flex; justify-content: space-between; gap: 18rpx; align-items: flex-start; }
.title { flex: 1; color: #243129; font-size: 34rpx; font-weight: 800; line-height: 1.45; }
.row { display: flex; justify-content: space-between; gap: 24rpx; padding: 16rpx 0; border-bottom: 1rpx solid #edf1ee; color: #7a8580; font-size: 25rpx; }
.row text:last-child { flex: 1; color: #33413a; text-align: right; word-break: break-all; }
.section { margin-top: 18rpx; }
.section-title { display: block; margin-bottom: 14rpx; color: #243129; font-size: 29rpx; font-weight: 700; }
.images { display: flex; flex-wrap: wrap; gap: 14rpx; }
.images image { width: 150rpx; height: 150rpx; border-radius: 14rpx; background: #edf2ef; }
.result { margin-top: 20rpx; padding: 18rpx; border-radius: 14rpx; color: #2f6b4f; background: #edf6f1; font-size: 25rpx; line-height: 1.5; }
.close-button { margin-top: 24rpx; height: 76rpx; border-radius: 999rpx; background: #fff1ef; color: #d85c45; font-size: 27rpx; line-height: 76rpx; }
.product { display: flex; gap: 18rpx; align-items: center; }
.cover { width: 150rpx; height: 122rpx; flex: 0 0 150rpx; border-radius: 16rpx; background: #edf2ef; }
.placeholder { display: flex; align-items: center; justify-content: center; color: #9aa5a1; font-size: 23rpx; }
.product-body { flex: 1; min-width: 0; }
.product-title { display: block; overflow: hidden; color: #243129; font-size: 30rpx; font-weight: 700; text-overflow: ellipsis; white-space: nowrap; }
.price { display: block; margin-top: 8rpx; color: #e36a3e; font-size: 32rpx; font-weight: 800; }
.meta, .target-text { margin-top: 8rpx; color: #87918c; font-size: 24rpx; }
</style>
