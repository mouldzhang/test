@Entry
@Component
export struct My_Page {
  @State message: string = 'my';
  @State currentIndex: number = 0;

  // 使用 $r() 函数引用本地图片资源
  private imageList: Resource[] = [
    $r('app.media.slidshow1'),
    $r('app.media.slidshow2'),
    $r('app.media.slidshow3'),
    $r('app.media.slidshow4')
  ];

  build() {
    Column() {
      // 顶部占1/3的图片轮播区域 - 使用Stack布局包裹
      Stack({ alignContent: Alignment.BottomStart }) {
        // 轮播图部分
        Swiper() {
          ForEach(this.imageList, (imageRes: Resource, index: number) => {
            // 每张图片项使用Stack布局叠加蒙版
            Stack() {
              // 底层：图片
              Image(imageRes)
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Cover)

              // 上层：半透明蒙版
              Row() {
                // 蒙版区域，现在为空，后续可添加内容
              }
              .width('100%')
              .height('100%')
              .backgroundColor('rgba(0, 0, 0, 0.4)') // 半透明黑色蒙版
            }
          }, (imageRes: Resource, index: number) => index.toString())
        }
        .width('100%')
        .height('100%')
        .autoPlay(true) // 自动轮播
        .interval(3000) // 轮播间隔3秒
        .indicator(true) // 显示指示器
        .loop(true) // 循环轮播
        .duration(1000) // 切换动画时长1秒
        .onChange((index: number) => {
          // 轮播变化时更新当前索引
          this.currentIndex = index;
        })

        // 固定在轮播图左下角的头像和用户信息
        // 使用响应式设计，适应不同屏幕
        Row() {
          // 圆形头像
          Stack() {
            // 头像图片，这里使用示例资源，请替换为实际头像资源
            Image($r('app.media.avatar')) // 请确保项目中有此资源
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
              .clip(new Circle({ width: 60, height: 60 })) // 裁剪为圆形
          }
          .width(60)
          .height(60)
          .borderRadius(30) // 确保圆形
          .border({ width: 2, color: Color.White }) // 白色边框

          // 用户信息：用户名和账号（垂直排列，用户名在上，账号在下）
          Column() {
            // 用户名
            Text('用户名')
              .fontSize(18)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            // 账号
            Text('@user123')
              .fontSize(14)
              .fontColor('#f0f0f0')
              .textAlign(TextAlign.Start)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .margin({ left: 12 }) // 与头像的间距
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        }
        .margin({ left: 24, bottom: 24 }) // 固定在左下角，使用固定边距
        .alignItems(VerticalAlign.Center) // 垂直居中对齐
      }
      .width('100%')
      .height('33.33%') // 始终占屏幕高度的1/3

      // 底部占2/3的预留区域
      Column() {
        // 预留区域，后续可以添加内容
        Text('预留区域 (占屏幕2/3)')
          .fontSize(18)
          .fontColor('#333')

        // 显示当前轮播的索引（可选）
        Text(`当前轮播索引: ${this.currentIndex + 1}/${this.imageList.length}`)
          .fontSize(14)
          .fontColor('#666')
          .margin({ top: 10 })
      }
      .width('100%')
      .height('66.67%') // 始终占屏幕高度的2/3
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f3f3f3")
  }
}