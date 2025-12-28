@Entry
@Component
export struct My_Page {
  @State message: string = 'my';
  @State currentIndex: number = 0;
  @State showSidebar: boolean = false; // 控制侧边栏显示状态

  // 使用 $r() 函数引用本地图片资源
  private imageList: Resource[] = [
    $r('app.media.slidshow1'),
    $r('app.media.slidshow2'),
    $r('app.media.slidshow3'),
    $r('app.media.slidshow4')
  ];

  // 关闭侧边栏的方法
  closeSidebar() {
    this.showSidebar = false;
  }

  build() {
    // 使用Stack作为根布局，允许侧边栏覆盖在主内容之上
    Stack() {
      // 主内容层
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
          .interval(5000) // 轮播间隔3秒
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

          // 轮播图右上角的菜单按钮
          Row() {
            Blank() // 左侧空白区域，让内容靠右
            Column() {
              // 菜单图标按钮
              Image($r('app.media.sanhengxian')) // 请确保项目中有此资源，或使用系统图标
                .width(40)
                .height(40)
                .objectFit(ImageFit.Contain)
                .padding(5)
                .backgroundColor('rgba(0, 0, 0, 0.3)')
                .borderRadius(30)
                .onClick(() => {
                  // 点击图标切换侧边栏显示状态
                  this.showSidebar = !this.showSidebar;
                })
            }
            .alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .height('100%')
          .alignItems(VerticalAlign.Top)
          .padding({ top: 28, right: 24 })
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

      // 侧边栏遮罩层（当侧边栏显示时出现）
      if (this.showSidebar) {
        Stack() {
          // 左侧空白区域（遮罩层），点击可以关闭侧边栏
          Column() {
            Blank()
          }
          .width('30%') // 左侧30%区域可点击关闭
          .height('100%')
          .onClick(() => {
            this.closeSidebar();
          })

          // 侧边栏内容区域
          Column() {
            // 侧边栏头部（可添加关闭按钮）
            Row() {

              // 关闭按钮
              Image($r('app.media.sanhengxian'))
                .width(35)
                .height(35)
                .onClick(() => {
                  this.closeSidebar();
                })

              Blank()

              Text('菜单')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)


            }
            .width('100%')
            .margin({ top: 50, bottom: 30 })
            .padding({ left: 20, right: 20 })

            // 示例菜单项
            MyMenuItem({ icon: $r('app.media.shouye'), text: '首页' })
            MyMenuItem({ icon: $r('app.media.geren'), text: '个人资料' })
            MyMenuItem({ icon: $r('app.media.lishi'), text: '历史记录' })
            MyMenuItem({ icon: $r('app.media.bangzhu'), text: '帮助与反馈' })
            MyMenuItem({ icon: $r('app.media.erweim'), text: '我的二维码' })
            MyMenuItem({ icon: $r('app.media.huancun'), text: '清理缓存' })
            MyMenuItem({ icon: $r('app.media.shezhi'), text: '设置' })
            MyMenuItem({ icon: $r('app.media.zhangh'), text: '切换账号' })
            MyMenuItem({ icon: $r('app.media.tuichu'), text: '退出登录' })
          }
          .width('70%') // 侧边栏宽度占屏幕70%
          .height('100%')
          .backgroundColor(Color.White)
          .position({ x: '30%' }) // 从左侧30%位置开始
          .shadow({ radius: 10, color: '#40000000', offsetX: -2 })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#60000000') // 半透明黑色遮罩
        .position({ x: 0, y: 0 })
        .onClick(() => {
          // 点击遮罩层任何位置（除侧边栏内容外）都可以关闭侧边栏
          // 注意：这个点击事件会被子组件的点击事件覆盖，所以实际上只会关闭侧边栏
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}

// 侧边栏菜单项组件
@Component
struct MyMenuItem {
  private icon: Resource = $r('app.media.startIcon'); // 图标资源，设置默认值
  private text: string = ''; // 菜单文本，设置默认值

  build() {
    Row() {
      // 菜单图标
      Image(this.icon)
        .width(24)
        .height(24)
        .margin({ right: 12 })
        .objectFit(ImageFit.Contain)

      // 菜单文本
      Text(this.text)
        .fontSize(16)
        .fontColor('#333')

      Blank()
    }
    .width('100%')
    .padding({ top: 15, bottom: 15, left: 20, right: 20 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      // 这里可以添加菜单项的点击事件
      console.log(`点击了菜单项: ${this.text}`);
    })
  }
}