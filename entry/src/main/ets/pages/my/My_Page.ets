interface MoodItem {
  icon: Resource;
  text: string;
}

@Entry
@Component
export struct My_Page {
  @State message: string = 'my';
  @State currentIndex: number = 0;
  @State showSidebar: boolean = false; // 控制侧边栏显示状态
  @State currentTab: string = '心情'; // 控制标签栏选中状态

  // 使用 $r() 函数引用本地图片资源
  private imageList: Resource[] = [
    $r('app.media.slidshow1'),
    $r('app.media.slidshow2'),
    $r('app.media.slidshow3'),
    $r('app.media.slidshow4')
  ];

  // 心情选项数据
  private moodList: MoodItem[] = [
    { icon: $r('app.media.startIcon'), text: '开心' },
    { icon: $r('app.media.startIcon'), text: '愉悦' },
    { icon: $r('app.media.startIcon'), text: '给你两刀' },
    { icon: $r('app.media.startIcon'), text: '来两个大嘴巴子' }
  ];

  // 标签栏数据
  private tabList: string[] = ['心情', '近期', '创建', '收藏'];

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
          Row() {
            // 圆形头像
            Stack() {
              Image($r('app.media.avatar')) // 请替换为实际头像资源
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Cover)
                .clip(new Circle({ width: 60, height: 60 })) // 裁剪为圆形
            }
            .width(60)
            .height(60)
            .borderRadius(30) // 确保圆形
            .border({ width: 2, color: Color.White }) // 白色边框

            // 用户信息：用户名和账号（垂直排列）
            Column() {
              Text('用户名：xxx')
                .fontSize(18)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Start)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text('账 号：xxx')
                .fontSize(14)
                .fontColor('#f0f0f0')
                .textAlign(TextAlign.Start)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .margin({ left: 12 })
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)
          }
          .margin({ left: 24, bottom: 24 })
          .alignItems(VerticalAlign.Center)

          // 轮播图右上角的菜单按钮
          Row() {
            Blank()
            Column() {
              Image($r('app.media.sanhengxian')) // 菜单图标
                .width(40)
                .height(40)
                .objectFit(ImageFit.Contain)
                .padding(5)
                .backgroundColor('rgba(0, 0, 0, 0.3)')
                .borderRadius(30)
                .onClick(() => {
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
        .height('33.33%') // 顶部1/3区域

        // 底部占2/3的核心内容区域（完善部分）
        Column() {
          // 1. 个人资料卡片区域
          Column() {
            // 1.1 性别/日期/地区标签行（蓝色背景）
            Row() {
              Text('男')
                .fontSize(14)
                .fontColor(Color.White)
              Text('|')
                .fontSize(14)
                .fontColor(Color.White)
                .margin({ left: 4, right: 4 })
              Text('12月23日')
                .fontSize(14)
                .fontColor(Color.White)
              Text('|')
                .fontSize(14)
                .fontColor(Color.White)
                .margin({ left: 4, right: 4 })
              Text('冰岛')
                .fontSize(14)
                .fontColor(Color.White)
            }
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#4A90E2') // 蓝色背景匹配UI
            .borderRadius(4)
            .margin({ bottom: 8 })

            // 1.2 个性签名
            Text('个性签名：洗洗睡了！！！')
              .fontSize(14)
              .fontColor('#333333')
              .margin({ bottom: 12 })
              .textAlign(TextAlign.Start)
              .width('100%')

            // 1.3 编辑资料按钮
            Button('编辑资料')
              .width('100%')
              .height(40)
              .backgroundColor('#E5E5E5') // 灰色背景
              .fontSize(14)
              .fontColor('#666666')
              .borderRadius(4)
              .border({ width: 0 }) // 去掉默认边框
          }
          .width('90%')
          .padding({ top: 16, bottom: 16, left: 16, right: 16 })
          .backgroundColor(Color.White)
          .borderRadius(8)
          .margin({ top: 16, bottom: 16 })
          .alignItems(HorizontalAlign.Start)

          // 2. 标签栏（心情/近期/创建/收藏）
          Row() {
            ForEach(this.tabList, (tab: string) => {
              Column() {
                Text(tab)
                  .fontSize(16)
                  .fontColor(this.currentTab === tab ? '#4A90E2' : '#666666')
                  .fontWeight(this.currentTab === tab ? FontWeight.Bold : FontWeight.Normal)
                // 选中标签的下划线
                if (this.currentTab === tab) {
                  Divider()
                    .width(20)
                    .height(2)
                    .backgroundColor('#4A90E2')
                    .margin({ top: 4 })
                }
              }
              .onClick(() => {
                this.currentTab = tab;
              })
              .flexGrow(1)
              .alignItems(HorizontalAlign.Center)
            })
          }
          .width('90%')
          .height(44)
          .backgroundColor(Color.White)
          .borderRadius(4)
          .margin({ bottom: 12 })

          // 3. 标签内容区域（默认显示心情内容）
          Stack() {
            if (this.currentTab === '心情') {
              // 心情选项网格布局（2列）
              Grid() {
                ForEach(this.moodList, (item: MoodItem, index: number) => {
                  GridItem() {
                    Column() {
                      Image(item.icon)
                        .width(24)
                        .height(24)
                        .margin({ bottom: 8 })
                      Text(item.text)
                        .fontSize(14)
                        .fontColor('#333333')
                    }
                    .width('100%')
                    .height(80)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(HorizontalAlign.Center)
                    .backgroundColor(Color.White)
                    .border({ width: 1, color: '#EEEEEE' })
                  }
                })
              }
              .width('90%')
              .columnsTemplate('1fr 1fr') // 2列布局
              .columnsGap(1)
              .rowsGap(1)
              .backgroundColor('#EEEEEE')
            } else {
              // 其他标签占位内容
              Text(`暂无${this.currentTab}相关内容`)
                .fontSize(14)
                .fontColor('#999999')
                .padding(20)
            }
          }
        }
        .width('100%')
        .height('66.67%') // 底部2/3区域
        .backgroundColor('#F5F5F5')
        .justifyContent(FlexAlign.Start)
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
          .width('30%')
          .height('100%')
          .onClick(() => {
            this.closeSidebar();
          })

          // 侧边栏内容区域
          Column() {
            Row() {
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
          .width('70%')
          .height('100%')
          .backgroundColor(Color.White)
          .position({ x: '30%' })
          .shadow({ radius: 10, color: '#40000000', offsetX: -2 })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#60000000')
        .position({ x: 0, y: 0 })
      }
    }
    .height('100%')
    .width('100%')
  }
}

interface MenuItem {
  icon: Resource;
  text: string;
}

// 侧边栏菜单项组件
@Component
struct MyMenuItem {
  private icon: Resource = $r('app.media.startIcon');
  private text: string = '';

  build() {
    Row() {
      Image(this.icon)
        .width(24)
        .height(24)
        .margin({ right: 12 })
        .objectFit(ImageFit.Contain)

      Text(this.text)
        .fontSize(16)
        .fontColor('#333')

      Blank()
    }
    .width('100%')
    .padding({ top: 15, bottom: 15, left: 20, right: 20 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      console.log(`点击了菜单项: ${this.text}`);
    })
  }
}