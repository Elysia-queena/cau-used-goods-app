<template>
  <view v-if="product" class="detail-page">
    <swiper class="gallery" indicator-dots circular>
      <swiper-item v-for="image in product.images" :key="image">
        <image class="gallery-image" :src="image" mode="aspectFill" />
      </swiper-item>
    </swiper>

    <view class="content">
      <view class="card info-card">
        <view class="price-line">
          <view>
            <text class="currency">¥</text>
            <text class="price">{{ product.price }}</text>
            <text v-if="product.originalPrice" class="original-price">¥{{ product.originalPrice }}</text>
          </view>
          <text class="status" :class="statusMeta.className">{{ statusMeta.text }}</text>
        </view>
        <text class="title">{{ product.title }}</text>
        <view class="meta-line muted">
          <text>{{ product.conditionLevel }}</text>
          <text>{{ product.viewCount }} 次浏览</text>
          <text>{{ product.createTime }}</text>
        </view>
      </view>

      <view class="card section-card">
        <text class="section-title">商品描述</text>
        <text class="description">{{ product.description }}</text>
      </view>

      <view class="card section-card">
        <text class="section-title">面交信息</text>
        <view class="location">建议地点：{{ product.meetLocation || '预约后协商' }}</view>
        <text class="privacy-note">为保护隐私，联系方式仅在订单进入待面交后向交易双方展示。</text>
      </view>

      <view class="card seller-card">
        <view class="avatar">{{ product.seller.nickname.slice(0, 1) }}</view>
        <view>
          <text class="seller-name">{{ product.seller.nickname }}</text>
          <text class="muted seller-college">{{ product.seller.college }}</text>
        </view>
      </view>
    </view>

    <view class="bottom-bar">
      <view class="action-link" @click="favorite">
        <text>♡</text>
        <text>收藏</text>
      </view>
      <view class="action-link" @click="report">
        <text>!</text>
        <text>举报</text>
      </view>
      <button class="reserve-button" :disabled="product.status !== 'ON_SALE'" @click="reserve">
        {{ product.status === 'ON_SALE' ? '提交预约' : statusMeta.text }}
      </button>
    </view>
  </view>
</template>

<script setup>
import { computed, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { fetchProductDetail } from '../../api/product.js'
import { getStatusMeta } from '../../utils/product.js'

const product = ref(null)
const statusMeta = computed(() => getStatusMeta(product.value?.status))

function favorite() {
  uni.showToast({ title: '已加入收藏', icon: 'success' })
}

function report() {
  uni.showToast({ title: '举报功能由其他成员接入', icon: 'none' })
}

function reserve() {
  uni.showToast({ title: '预约页面由订单模块接入', icon: 'none' })
}

onLoad(async ({ id }) => {
  try {
    product.value = await fetchProductDetail(id)
  } catch (error) {
    uni.showToast({ title: error.message, icon: 'none' })
  }
})
</script>

<style lang="scss" scoped>
.detail-page {
  padding-bottom: 140rpx;
}

.gallery,
.gallery-image {
  width: 100%;
  height: 620rpx;
  background: #e9efeb;
}

.content {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  padding: 22rpx;
}

.info-card,
.section-card,
.seller-card {
  padding: 24rpx;
}

.price-line,
.meta-line,
.seller-card {
  display: flex;
  align-items: center;
}

.price-line {
  justify-content: space-between;
}

.currency,
.price {
  color: #e36a3e;
}

.currency {
  font-size: 28rpx;
}

.price {
  font-size: 48rpx;
  font-weight: 700;
}

.original-price {
  margin-left: 16rpx;
  color: #a1aaa7;
  font-size: 24rpx;
  text-decoration: line-through;
}

.status {
  padding: 8rpx 16rpx;
  border-radius: 999rpx;
  background: #eaf5ee;
  color: #23734f;
  font-size: 23rpx;
}

.status.locked {
  background: #fff0df;
  color: #c56b22;
}

.title {
  display: block;
  margin-top: 18rpx;
  color: #1e2b26;
  font-size: 36rpx;
  font-weight: 700;
}

.meta-line {
  gap: 20rpx;
  margin-top: 18rpx;
  font-size: 23rpx;
}

.description,
.location,
.privacy-note,
.seller-name,
.seller-college {
  display: block;
}

.description {
  margin-top: 18rpx;
  color: #56625e;
  line-height: 1.8;
}

.location {
  margin-top: 18rpx;
  color: #34433d;
}

.privacy-note {
  margin-top: 18rpx;
  color: #9a7745;
  font-size: 23rpx;
  line-height: 1.6;
}

.avatar {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 82rpx;
  height: 82rpx;
  margin-right: 18rpx;
  border-radius: 50%;
  background: #eaf5ee;
  color: #23734f;
  font-weight: 700;
}

.seller-name {
  margin-bottom: 8rpx;
  font-weight: 700;
}

.seller-college {
  font-size: 23rpx;
}

.bottom-bar {
  position: fixed;
  right: 0;
  bottom: 0;
  left: 0;
  display: flex;
  align-items: center;
  gap: 24rpx;
  padding: 18rpx 24rpx calc(18rpx + env(safe-area-inset-bottom));
  background: #ffffff;
  box-shadow: 0 -6rpx 20rpx rgba(26, 64, 50, 0.08);
}

.action-link {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #65716c;
  font-size: 22rpx;
}

.action-link text:first-child {
  font-size: 34rpx;
  line-height: 1;
}

.reserve-button {
  flex: 1;
  border-radius: 999rpx;
  background: #23734f;
  color: #ffffff;
  font-size: 29rpx;
}

.reserve-button[disabled] {
  background: #aeb8b4;
  color: #ffffff;
}
</style>
