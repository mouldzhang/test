import preferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';

interface MoodItem {
  icon: Resource;
  text: string;
}

interface StoreKey {
  GENDER: string;
  BIRTH_DATE: string;
  REGION: string;
  SIGNATURE: string;
}

// 定义一个常量用于存储键
const STORE_KEY: StoreKey = {
  GENDER: 'gender',
  BIRTH_DATE: 'birthDate',
  REGION: 'region',
  SIGNATURE: 'signature'
};

@Entry
@Component
export struct My_Page {
  @Prop context?: Context;
  @State message: string = 'my';
  @State currentIndex: number = 0;
  @State showSidebar: boolean = false; // 控制侧边栏显示状态
  @State currentTab: string = '心情'; // 控制标签栏选中状态
  @State showEditDialog: boolean = false; // 控制编辑对话框显示状态

  // 个人信息状态变量（带有默认值）
  @State gender: string = '男';
  @State birthDate: string = '12月23日';
  @State region: string = '冰岛';
  @State signature: string = '洗洗睡了！！！';

  // 编辑表单的临时变量
  @State editGender: string = '';
  @State editBirthDate: string = '';
  @State editRegion: string = '';
  @State editSignature: string = '';

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
  private tabList: string[] = ['心情', '收藏'];

  // Preferences实例
  private prefs: preferences.Preferences | null = null;

  // 在组件即将显示时加载数据
  aboutToAppear() {
    this.loadUserData();
  }

  // 加载用户数据
  async loadUserData() {
    try {
      // 创建或获取Preferences实例
      if (this.context) {
        this.prefs = await preferences.getPreferences(this.context, 'userProfile');

        // 从Preferences中读取数据，如果没有则使用默认值
        const savedGender = await this.prefs.get(STORE_KEY.GENDER, '男');
        const savedBirthDate = await this.prefs.get(STORE_KEY.BIRTH_DATE, '12月23日');
        const savedRegion = await this.prefs.get(STORE_KEY.REGION, '冰岛');
        const savedSignature = await this.prefs.get(STORE_KEY.SIGNATURE, '洗洗睡了！！！');

        // 更新状态变量
        this.gender = savedGender as string;
        this.birthDate = savedBirthDate as string;
        this.region = savedRegion as string;
        this.signature = savedSignature as string;

        console.log('用户数据加载成功:', {
          gender: this.gender,
          birthDate: this.birthDate,
          region: this.region,
          signature: this.signature
        });
      }
    } catch (error) {
      console.error('加载用户数据失败:', error);
    }
  }

  // 保存用户数据到Preferences
  async saveUserData() {
    try {
      if (!this.prefs && this.context) {
        this.prefs = await preferences.getPreferences(this.context, 'userProfile');
      }

      if (this.prefs) {
        // 保存数据到Preferences
        await this.prefs.put(STORE_KEY.GENDER, this.gender);
        await this.prefs.put(STORE_KEY.BIRTH_DATE, this.birthDate);
        await this.prefs.put(STORE_KEY.REGION, this.region);
        await this.prefs.put(STORE_KEY.SIGNATURE, this.signature);

        // 提交更改
        await this.prefs.flush();

        console.log('用户数据保存成功:', {
          gender: this.gender,
          birthDate: this.birthDate,
          region: this.region,
          signature: this.signature
        });
      }
    } catch (error) {
      console.error('保存用户数据失败:', error);
    }
  }

  // 关闭侧边栏的方法
  closeSidebar() {
    this.showSidebar = false;
  }

  // 打开编辑资料对话框
  openEditDialog() {
    // 将当前值赋给临时编辑变量
    this.editGender = this.gender;
    this.editBirthDate = this.birthDate;
    this.editRegion = this.region;
    this.editSignature = this.signature;
    this.showEditDialog = true;
  }

  // 保存编辑的资料
  async saveProfile() {
    // 更新主状态变量
    this.gender = this.editGender;
    this.birthDate = this.editBirthDate;
    this.region = this.editRegion;
    this.signature = this.editSignature;
    this.showEditDialog = false;

    // 保存到本地存储
    await this.saveUserData();

    // 显示保存成功的提示
    this.showToast('资料保存成功！');
  }

  // 取消编辑
  cancelEdit() {
    this.showEditDialog = false;
  }

  // 显示提示消息（模拟Toast）
  @Builder showToast(message: string) {
    Text(message)
      .fontSize(14)
      .fontColor(Color.White)
      .backgroundColor('rgba(0, 0, 0, 0.7)')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .borderRadius(4)
      .margin({ bottom: 50 })
  }

  build() {
    // 使用Stack作为根布局，允许侧边栏和编辑对话框覆盖在主内容之上
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
          .interval(5000) // 轮播间隔5秒
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

        // 底部占2/3的核心内容区域
        Column() {
          // 1. 个人资料卡片区域
          Column() {
            // 1.1 性别/日期/地区标签行（蓝色背景）
            Row() {
              Text(this.gender)
                .fontSize(14)
                .fontColor(Color.White)
              Text('|')
                .fontSize(14)
                .fontColor(Color.White)
                .margin({ left: 4, right: 4 })
              Text(this.birthDate)
                .fontSize(14)
                .fontColor(Color.White)
              Text('|')
                .fontSize(14)
                .fontColor(Color.White)
                .margin({ left: 4, right: 4 })
              Text(this.region)
                .fontSize(14)
                .fontColor(Color.White)
            }
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#4A90E2') // 蓝色背景匹配UI
            .borderRadius(4)
            .margin({ bottom: 8 })

            // 1.2 个性签名
            Text(`个性签名：${this.signature}`)
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
              .onClick(() => {
                this.openEditDialog();
              })
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

      // 编辑资料对话框（覆盖层）
      if (this.showEditDialog) {
        Stack() {
          // 半透明背景遮罩层
          Column() {
            Blank()
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#60000000')
          .onClick(() => {
            this.cancelEdit();
          })

          // 编辑表单弹窗
          Column() {
            // 标题栏
            Row() {
              Text('编辑资料')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
              Blank()
              Image($r('app.media.startIcon')) // 关闭图标
                .width(20)
                .height(20)
                .onClick(() => {
                  this.cancelEdit();
                })
            }
            .width('100%')
            .padding({ bottom: 16 })

            // 表单内容
            Column({ space: 16 }) {
              // 性别输入
              Column() {
                Text('性别')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')
                TextInput({ text: this.editGender })
                  .width('100%')
                  .height(40)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.editGender = value;
                  })
              }

              // 出生日期输入
              Column() {
                Text('出生日期')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')
                TextInput({ text: this.editBirthDate })
                  .width('100%')
                  .height(40)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.editBirthDate = value;
                  })
              }

              // 地区输入
              Column() {
                Text('所在地区')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')
                TextInput({ text: this.editRegion })
                  .width('100%')
                  .height(40)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.editRegion = value;
                  })
              }

              // 个性签名输入
              Column() {
                Text('个性签名')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')
                TextInput({ text: this.editSignature })
                  .width('100%')
                  .height(80)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.editSignature = value;
                  })
              }
            }
            .width('100%')

            // 按钮区域
            Row({ space: 12 }) {
              Button('取消')
                .flexGrow(1)
                .height(44)
                .backgroundColor('#E5E5E5')
                .fontSize(14)
                .fontColor('#666666')
                .borderRadius(4)
                .border({ width: 0 })
                .onClick(() => {
                  this.cancelEdit();
                })

              Button('保存')
                .flexGrow(1)
                .height(44)
                .backgroundColor('#4A90E2')
                .fontSize(14)
                .fontColor(Color.White)
                .borderRadius(4)
                .border({ width: 0 })
                .onClick(() => {
                  this.saveProfile();
                })
            }
            .width('100%')
            .margin({ top: 24 })
          }
          .width('80%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .shadow({ radius: 10, color: '#40000000', offsetX: 0, offsetY: 2 })
        }
        .width('100%')
        .height('100%')
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