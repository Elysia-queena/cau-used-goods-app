<template>
  <view class="page publish-page">
    <view class="publish-intro">
      <text class="intro-title">发布你的闲置好物</text>
      <text class="muted">真实描述物品情况，更容易遇到合适的新主人</text>
    </view>

    <view class="form-card card">
      <view class="field-block">
        <view class="field-title">
          <text>商品图片</text>
          <text class="muted">{{ form.images.length }}/{{ MAX_PRODUCT_IMAGES }}</text>
        </view>
        <view class="image-grid">
          <view v-for="(image, index) in form.images" :key="`${image}-${index}`" class="image-item">
            <image :src="image" mode="aspectFill" />
            <text class="remove" @click="removeImage(index)">×</text>
          </view>
          <view v-if="form.images.length < MAX_PRODUCT_IMAGES" class="image-uploader" @click="chooseImages">
            <text class="plus">+</text>
            <text>添加图片</text>
          </view>
        </view>
        <text class="hint">最多上传 9 张图片，第一张将作为商品封面。</text>
      </view>

      <view class="field-block">
        <view class="field-title">
          <text>商品标题</text>
          <text class="ai-link" @click="optimizeTitle">AI 优化标题</text>
        </view>
        <input v-model.trim="form.title" maxlength="100" placeholder="例如：九成新小米台灯，宿舍自用" />
      </view>

      <view class="field-block inline-field">
        <text class="field-label">分类</text>
        <picker :range="selectableCategories" range-key="name" @change="changeCategory">
          <view class="picker-value">{{ selectedCategoryName || '请选择分类' }} ›</view>
        </picker>
      </view>

      <view class="field-block inline-field">
        <text class="field-label">成色</text>
        <picker :range="conditionOptions" @change="changeCondition">
          <view class="picker-value">{{ form.conditionLevel || '请选择成色' }} ›</view>
        </picker>
      </view>

      <view class="price-row">
        <view class="field-block price-field">
          <text class="field-label">原价</text>
          <view class="price-input"><text>¥</text><input v-model="form.originalPrice" type="digit" placeholder="选填" /></view>
        </view>
        <view class="field-block price-field">
          <text class="field-label">售价</text>
          <view class="price-input"><text>¥</text><input v-model="form.price" type="digit" placeholder="必填" /></view>
        </view>
      </view>

      <view class="field-block">
        <view class="field-title">
          <text>商品描述</text>
          <text class="ai-link" @click="generateDescription">AI 生成描述</text>
        </view>
        <textarea
          v-model.trim="form.description"
          maxlength="1000"
          placeholder="说明使用情况、外观瑕疵、配件等信息"
        />
      </view>

      <view class="field-block">
        <text class="field-label">建议面交地点</text>
        <input v-model.trim="form.meetLocation" maxlength="100" placeholder="例如：东区图书馆门口" />
      </view>
    </view>

    <view class="rules card">
      <text class="rules-title">发布提示</text>
      <text>请勿发布食品、危险品、盗版物或侵权物品。AI 内容仅作为建议，发布前请确认描述真实准确。</text>
    </view>

    <button class="submit-button" :loading="submitting" @click="submit">确认发布</button>
  </view>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import {
  publishProduct,
  requestGeneratedDescription,
  requestOptimizedTitles,
  uploadProductImage
} from '../../api/product.js'
import { MAX_IMAGE_SIZE, MAX_PRODUCT_IMAGES } from '../../config/index.js'
import { useProductStore } from '../../stores/product.js'
import { getCategoryName } from '../../utils/product.js'

const store = useProductStore()
const submitting = ref(false)
const conditionOptions = ['全新', '九成新', '八成新', '七成新', '有明显使用痕迹']

const form = reactive({
  images: [],
  title: '',
  categoryId: '',
  conditionLevel: '',
  originalPrice: '',
  price: '',
  description: '',
  meetLocation: ''
})

const selectableCategories = computed(() => store.categories.filter((item) => item.id !== 0))
const selectedCategoryName = computed(() => getCategoryName(store.categories, form.categoryId))

function showError(message) {
  uni.showToast({ title: message, icon: 'none' })
}

function changeCategory(event) {
  form.categoryId = selectableCategories.value[event.detail.value].id
}

function changeCondition(event) {
  form.conditionLevel = conditionOptions[event.detail.value]
}

async function chooseImages() {
  const remaining = MAX_PRODUCT_IMAGES - form.images.length
  try {
    const result = await uni.chooseImage({ count: remaining, sizeType: ['compressed'] })
    const validFiles = result.tempFiles.filter((file) => {
      if (file.size > MAX_IMAGE_SIZE) {
        showError('单张图片不能超过 5 MB')
        return false
      }
      return true
    })
    uni.showLoading({ title: '上传图片中' })
    for (const file of validFiles) {
      const uploaded = await uploadProductImage(file.path)
      form.images.push(uploaded.imageUrl)
    }
  } catch (error) {
    if (error?.errMsg && error.errMsg.includes('cancel')) return
    showError(error.message || '图片上传失败，请重新上传')
  } finally {
    uni.hideLoading()
  }
}

function removeImage(index) {
  form.images.splice(index, 1)
}

async function optimizeTitle() {
  if (!form.title) {
    showError('请先填写一个基础标题')
    return
  }
  try {
    uni.showLoading({ title: 'AI 正在优化' })
    const { titles } = await requestOptimizedTitles({
      title: form.title,
      categoryName: selectedCategoryName.value,
      conditionLevel: form.conditionLevel
    })
    uni.showActionSheet({
      itemList: titles,
      success: ({ tapIndex }) => {
        form.title = titles[tapIndex]
      }
    })
  } catch (error) {
    showError(error.message || 'AI 服务暂时不可用，你仍可手动填写')
  } finally {
    uni.hideLoading()
  }
}

async function generateDescription() {
  if (!form.title) {
    showError('请先填写标题，AI 才能生成合适的描述')
    return
  }
  try {
    uni.showLoading({ title: 'AI 正在生成' })
    const { description } = await requestGeneratedDescription({
      title: form.title,
      categoryName: selectedCategoryName.value,
      conditionLevel: form.conditionLevel,
      meetLocation: form.meetLocation
    })
    form.description = description
  } catch (error) {
    showError(error.message || 'AI 服务暂时不可用，你仍可手动填写')
  } finally {
    uni.hideLoading()
  }
}

function validate() {
  if (!form.images.length) return '请至少上传一张商品图片'
  if (!form.title) return '请填写商品标题'
  if (!form.categoryId) return '请选择商品分类'
  if (!form.conditionLevel) return '请选择商品成色'
  if (!form.price || Number(form.price) <= 0) return '请填写正确的商品售价'
  if (!form.description) return '请填写商品描述'
  return ''
}

async function submit() {
  const errorMessage = validate()
  if (errorMessage) {
    showError(errorMessage)
    return
  }

  submitting.value = true
  try {
    await publishProduct({ ...form })
    store.resetProducts()
    uni.showToast({ title: '发布成功', icon: 'success' })
    setTimeout(() => uni.switchTab({ url: '/pages/home/index' }), 700)
  } catch (error) {
    showError(error.message)
  } finally {
    submitting.value = false
  }
}

onLoad(() => store.loadCategories())
</script>

<style lang="scss" scoped>
.publish-intro {
  padding: 8rpx 4rpx 24rpx;
}

.intro-title,
.publish-intro .muted,
.hint,
.rules-title,
.rules text {
  display: block;
}

.intro-title {
  margin-bottom: 10rpx;
  color: #1f342c;
  font-size: 40rpx;
  font-weight: 700;
}

.form-card {
  padding: 6rpx 24rpx;
}

.field-block {
  padding: 24rpx 0;
  border-bottom: 2rpx solid #f0f3f1;
}

.field-block:last-child {
  border-bottom: 0;
}

.field-title,
.inline-field,
.price-input {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.field-title,
.field-label {
  color: #31423b;
  font-weight: 600;
}

.ai-link,
.picker-value {
  color: #23734f;
  font-size: 25rpx;
}

input {
  height: 72rpx;
  margin-top: 12rpx;
  font-size: 27rpx;
}

textarea {
  width: 100%;
  height: 210rpx;
  margin-top: 20rpx;
  padding: 18rpx;
  border-radius: 16rpx;
  background: #f6f8f5;
  font-size: 27rpx;
  line-height: 1.65;
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14rpx;
  margin-top: 18rpx;
}

.image-item,
.image-uploader {
  position: relative;
  height: 184rpx;
  overflow: hidden;
  border-radius: 18rpx;
}

.image-item image {
  width: 100%;
  height: 100%;
}

.remove {
  position: absolute;
  top: 8rpx;
  right: 8rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 38rpx;
  height: 38rpx;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.58);
  color: #ffffff;
  font-size: 32rpx;
  line-height: 1;
}

.image-uploader {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border: 2rpx dashed #aac4b8;
  color: #6b8b7e;
  font-size: 24rpx;
}

.plus {
  margin-bottom: 4rpx;
  font-size: 48rpx;
  line-height: 1;
}

.hint {
  margin-top: 14rpx;
  color: #9da7a3;
  font-size: 22rpx;
}

.price-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 28rpx;
}

.price-input {
  justify-content: flex-start;
  margin-top: 4rpx;
  color: #e36a3e;
}

.price-input input {
  width: 180rpx;
  margin: 0 0 0 8rpx;
}

.rules {
  margin-top: 20rpx;
  padding: 22rpx 24rpx;
  color: #8d714e;
  font-size: 23rpx;
  line-height: 1.7;
}

.rules-title {
  margin-bottom: 4rpx;
  color: #6f5535;
  font-weight: 700;
}

.submit-button {
  margin: 28rpx 0 12rpx;
  border-radius: 999rpx;
  background: #23734f;
  color: #ffffff;
  font-size: 30rpx;
  font-weight: 700;
}
</style>
