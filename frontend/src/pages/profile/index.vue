<template>
  <view class="page">
    <view class="profile card">
      <view class="avatar">我</view>
      <view>
        <text class="name">校园用户</text>
        <text class="verified">已认证学生</text>
      </view>
    </view>

    <view class="menu card">
      <view class="menu-item"><text>我的商品</text><text>›</text></view>
      <view class="menu-item"><text>我的订单</text><text>›</text></view>
      <view class="menu-item"><text>我的收藏</text><text>›</text></view>
      <view class="menu-item"><text>账号与安全</text><text>›</text></view>
    </view>
  </view>
</template>

<style lang="scss" scoped>
.profile {
  display: flex;
  align-items: center;
  padding: 32rpx;
}

.avatar {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100rpx;
  height: 100rpx;
  margin-right: 22rpx;
  border-radius: 50%;
  background: #eaf5ee;
  color: #23734f;
  font-size: 36rpx;
  font-weight: 700;
}

.name,
.verified {
  display: block;
}

.name {
  margin-bottom: 10rpx;
  color: #253a32;
  font-size: 34rpx;
  font-weight: 700;
}

.verified {
  color: #23734f;
  font-size: 24rpx;
}

.menu {
  margin-top: 22rpx;
  padding: 0 24rpx;
}

.menu-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 94rpx;
  border-bottom: 2rpx solid #f0f3f1;
  color: #3e4e48;
}

.menu-item:last-child {
  border-bottom: 0;
}
</style>
