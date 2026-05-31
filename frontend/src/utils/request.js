import { API_BASE_URL } from '../config/index.js'

const ERROR_MESSAGES = {
  40002: '图片上传失败，请重新上传',
  40100: '请先登录',
  40101: '请先完成学生认证',
  40300: '你没有权限执行此操作',
  40900: '商品状态已变化，请刷新后重试',
  42200: '内容包含敏感词，请修改后重试',
  50001: '服务暂时不可用，请稍后重试'
}

function getToken() {
  return uni.getStorageSync('token')
}

function handleBusinessError(code, message) {
  const error = new Error(ERROR_MESSAGES[code] || message || '请求失败')
  error.code = code
  throw error
}

export function request({ url, method = 'GET', data, showLoading = false }) {
  if (showLoading) uni.showLoading({ title: '加载中' })

  return new Promise((resolve, reject) => {
    uni.request({
      url: `${API_BASE_URL}${url}`,
      method,
      data,
      header: {
        Authorization: getToken() ? `Bearer ${getToken()}` : ''
      },
      success: ({ statusCode, data: response }) => {
        if (statusCode >= 200 && statusCode < 300 && response.code === 0) {
          resolve(response.data)
          return
        }
        try {
          handleBusinessError(response?.code, response?.message)
        } catch (error) {
          reject(error)
        }
      },
      fail: () => reject(new Error('网络连接失败，请检查网络后重试')),
      complete: () => {
        if (showLoading) uni.hideLoading()
      }
    })
  })
}

export function uploadFile(filePath) {
  return new Promise((resolve, reject) => {
    uni.uploadFile({
      url: `${API_BASE_URL}/upload/products`,
      filePath,
      name: 'file',
      header: {
        Authorization: getToken() ? `Bearer ${getToken()}` : ''
      },
      success: ({ data }) => {
        try {
          const response = JSON.parse(data)
          if (response.code !== 0) {
            handleBusinessError(response.code, response.message)
          }
          resolve(response.data)
        } catch (error) {
          reject(error)
        }
      },
      fail: () => reject(new Error('图片上传失败，请重新上传'))
    })
  })
}
