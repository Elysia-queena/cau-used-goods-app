<template>
  <view class="product-card card" @click="openDetail">
    <view class="image-wrap">
      <image class="cover" :src="product.images[0]" mode="aspectFill" />
      <text v-if="product.status !== 'ON_SALE'" class="status">{{ statusMeta.text }}</text>
    </view>
    <view class="content">
      <text class="title">{{ product.title }}</text>
      <view class="meta-row">
        <text class="condition">{{ product.conditionLevel }}</text>
        <text class="muted">{{ product.createTime.slice(5, 10) }}</text>
      </view>
      <view class="price-row">
        <view>
          <text class="currency">¥</text>
          <text class="price">{{ product.price }}</text>
        </view>
        <text class="muted">{{ product.favoriteCount }} 人收藏</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue'
import { getStatusMeta } from '../utils/product.js'

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
})

const statusMeta = computed(() => getStatusMeta(props.product.status))

function openDetail() {
  uni.navigateTo({ url: `/pages/product-detail/index?id=${props.product.id}` })
}
</script>

<style lang="scss" scoped>
.product-card {
  overflow: hidden;
}

.image-wrap {
  position: relative;
  height: 260rpx;
  background: #e9efeb;
}

.cover {
  width: 100%;
  height: 100%;
}

.status {
  position: absolute;
  top: 14rpx;
  right: 14rpx;
  padding: 6rpx 14rpx;
  border-radius: 999rpx;
  background: rgba(31, 41, 37, 0.78);
  color: #ffffff;
  font-size: 22rpx;
}

.content {
  padding: 20rpx;
}

.title {
  display: -webkit-box;
  overflow: hidden;
  color: #24302b;
  font-size: 28rpx;
  font-weight: 600;
  line-height: 1.45;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.meta-row,
.price-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 14rpx;
  font-size: 22rpx;
}

.condition {
  padding: 4rpx 10rpx;
  border-radius: 8rpx;
  background: #eef7f1;
  color: #23734f;
}

.currency {
  color: #e36a3e;
  font-size: 24rpx;
}

.price {
  color: #e36a3e;
  font-size: 36rpx;
  font-weight: 700;
}
</style>
