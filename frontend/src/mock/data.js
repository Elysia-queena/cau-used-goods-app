export const categories = [
  { id: 0, name: '全部', icon: '全部' },
  { id: 1, name: '教材资料', icon: '书' },
  { id: 2, name: '电子产品', icon: '数码' },
  { id: 3, name: '生活用品', icon: '生活' },
  { id: 4, name: '服饰鞋包', icon: '服饰' },
  { id: 5, name: '运动娱乐', icon: '运动' },
  { id: 6, name: '其他闲置', icon: '其他' }
]

export const products = [
  {
    id: 101,
    sellerId: 11,
    categoryId: 2,
    title: '九成新 Kindle 青春版，附保护壳',
    description: '自用 Kindle 青春版，屏幕显示正常，续航良好。附赠保护壳和数据线，适合课余阅读。',
    originalPrice: 658,
    price: 320,
    conditionLevel: '九成新',
    meetLocation: '东区图书馆门口',
    status: 'ON_SALE',
    viewCount: 86,
    favoriteCount: 12,
    createTime: '2026-05-30 18:20',
    images: [
      'https://images.unsplash.com/photo-1592496001020-d31bd830651f?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=900&q=80'
    ],
    seller: { nickname: '小麦同学', college: '信息与电气工程学院', avatarUrl: '' }
  },
  {
    id: 102,
    sellerId: 12,
    categoryId: 1,
    title: '高等数学教材与习题册，一套出',
    description: '教材有少量笔记，习题册基本全新。适合大一课程预习和期末复习。',
    originalPrice: 86,
    price: 28,
    conditionLevel: '八成新',
    meetLocation: '西区操场南门',
    status: 'ON_SALE',
    viewCount: 44,
    favoriteCount: 5,
    createTime: '2026-05-30 15:10',
    images: [
      'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?auto=format&fit=crop&w=900&q=80'
    ],
    seller: { nickname: '晚风', college: '理学院', avatarUrl: '' }
  },
  {
    id: 103,
    sellerId: 13,
    categoryId: 3,
    title: '宿舍折叠小桌板，轻便好收纳',
    description: '桌板结构稳定，宿舍床上学习很方便。毕业清物品，价格可小刀。',
    originalPrice: 59,
    price: 20,
    conditionLevel: '七成新',
    meetLocation: '东区一号宿舍楼下',
    status: 'ON_SALE',
    viewCount: 38,
    favoriteCount: 4,
    createTime: '2026-05-29 21:30',
    images: [
      'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=900&q=80'
    ],
    seller: { nickname: '核桃', college: '食品科学与营养工程学院', avatarUrl: '' }
  },
  {
    id: 104,
    sellerId: 14,
    categoryId: 5,
    title: '羽毛球拍两支，送三个球',
    description: '两支入门拍，平时打球使用，拍框无变形。适合和室友一起运动。',
    originalPrice: 138,
    price: 55,
    conditionLevel: '八成新',
    meetLocation: '西区篮球场',
    status: 'LOCKED',
    viewCount: 72,
    favoriteCount: 9,
    createTime: '2026-05-29 19:00',
    images: [
      'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=900&q=80'
    ],
    seller: { nickname: '小满', college: '农学院', avatarUrl: '' }
  },
  {
    id: 105,
    sellerId: 15,
    categoryId: 2,
    title: '小米台灯 Pro，宿舍书桌适用',
    description: '使用半年，功能正常，灯光调节流畅。外壳没有明显划痕，搬宿舍所以转让。',
    originalPrice: 299,
    price: 150,
    conditionLevel: '九成新',
    meetLocation: '东区食堂入口',
    status: 'ON_SALE',
    viewCount: 63,
    favoriteCount: 8,
    createTime: '2026-05-28 13:40',
    images: [
      'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=900&q=80'
    ],
    seller: { nickname: '拾光', college: '工学院', avatarUrl: '' }
  },
  {
    id: 106,
    sellerId: 16,
    categoryId: 4,
    title: '帆布双肩包，容量大',
    description: '可以放下 14 寸电脑，通勤和上课都合适。肩带完好，清洗后闲置。',
    originalPrice: 129,
    price: 45,
    conditionLevel: '八成新',
    meetLocation: '图书馆北门',
    status: 'ON_SALE',
    viewCount: 31,
    favoriteCount: 3,
    createTime: '2026-05-27 17:15',
    images: [
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=900&q=80'
    ],
    seller: { nickname: '青禾', college: '经济管理学院', avatarUrl: '' }
  },
  {
    id: 107,
    sellerId: 17,
    categoryId: 3,
    title: '全新保温杯，未使用',
    description: '活动赠品，包装完整，容量 500ml。',
    originalPrice: 79,
    price: 35,
    conditionLevel: '全新',
    meetLocation: '西区食堂',
    status: 'ON_SALE',
    viewCount: 19,
    favoriteCount: 1,
    createTime: '2026-05-27 11:05',
    images: [
      'https://images.unsplash.com/photo-1602143407151-7111542de6e8?auto=format&fit=crop&w=900&q=80'
    ],
    seller: { nickname: '一川', college: '水利与土木工程学院', avatarUrl: '' }
  }
]
