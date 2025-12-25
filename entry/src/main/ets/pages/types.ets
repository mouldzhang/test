export interface XQZiYuan {
  image: Resource;
  imageName: string; // 用于路由传递的图片资源名
  label: string;
}

// 新增：路由传参专用接口（解决无类型字面量问题）
export interface MoodParams {
  imageName: string;
  label: string;
}

// 自定义标签弹窗参数接口
export interface ChangeLabelParams {
  XQlabel: string;
}